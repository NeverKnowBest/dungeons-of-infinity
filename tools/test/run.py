"""Builds the game with Igor (GameMaker's command line compiler) and runs a test scenario, with nobody at the keyboard.

    python tools/test/run.py tools/test/scenarios/smoke.json
    python tools/test/run.py --sheet Castle --seeds 4        # contact sheet: 4 Castle levels, every room in one PNG
    python tools/test/run.py boot --no-build                 # reuse the last build (no GML change since)

Finds the GameMaker runtime and user folder by itself. The scenario goes to %LOCALAPPDATA%\\Zelda\\test\\scenario.json
and the game reads it in test mode (scripts/__Test). Results (log.txt and the PNGs) are copied to tools/test/out/.
Prints compile errors and the test log; exit code 0 when the test ends with "end ok" and no FAIL line.
Standard library only.
"""
import argparse
import glob
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import scenario as scn

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = scn.REPO
PROJECT = os.path.join(REPO, 'game', 'Zelda.yyp')
OUT = os.path.join(HERE, 'out')
GM_NAME = 'GameMakerStudio2-LTS2026'
GM_DATA = os.path.join(os.environ.get('PROGRAMDATA', r'C:\ProgramData'), GM_NAME)
SAVE = os.path.join(os.environ.get('LOCALAPPDATA', ''), 'Zelda')
BUILD = os.path.join(tempfile.gettempdir(), 'doi-test')
SCENARIO_IN_GAME = 'test/scenario.json'   # relative to the save folder, as the game sees it

# Lines of the run output worth showing besides [Test] (compile and runtime errors)
ERROR_WORDS = ('error', 'exception', 'failed', 'fatal')
KNOWN_NOISE = ('Index did not map to an existing sound instance', 'existing audio asset', 'Errors.txt')


def fail(msg):
    print('ERROR: ' + msg)
    sys.exit(2)


def find_runtime():
    path = os.path.join(GM_DATA, 'runtime.json')
    if not os.path.exists(path):
        fail('GameMaker runtime list not found: ' + path)
    info = json.load(open(path))
    runtime = info[info['active']].split('&')[0]
    if not os.path.isdir(runtime):
        fail('active runtime folder not found: ' + runtime)
    return os.path.normpath(runtime)


def find_user():
    base = os.path.join(os.environ.get('APPDATA', ''), GM_NAME)
    users = [d for d in glob.glob(os.path.join(base, '*_*')) if os.path.isdir(d)]
    if not users:
        fail('no GameMaker user folder in ' + base + ' (open the IDE once)')
    # a signed in user first, then unknownUser_unknownUserID
    users.sort(key=lambda d: os.path.basename(d).startswith('unknownUser'))
    return users[0]


def find_last_build():
    """Runner.exe and the game data of the last Igor build (for --no-build)."""
    wins = sorted(glob.glob(os.path.join(BUILD, '**', '*.win'), recursive=True), key=os.path.getmtime)
    if not wins:
        fail('no previous build in ' + BUILD + '; run once without --no-build')
    return wins[-1]


def sheet_scenario(level, seeds):
    if seeds.isdigit():
        seeds = list(range(1, int(seeds) + 1))
    else:
        seeds = [int(s) for s in seeds.split(',')]
    return {'name': 'sheet', 'level': level, 'cheats': ['Cheat_Inf_Health'], 'max_frames': 100000,
            'steps': [{'do': 'sheet', 'level': level, 'seeds': seeds}]}


def kill_game():
    subprocess.run(['taskkill', '/IM', 'Runner.exe', '/F'], capture_output=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('scenario', nargs='?', help='scenario file, or a name in tools/test/scenarios')
    ap.add_argument('--sheet', metavar='LEVEL', help='contact sheet of a level (name such as Castle)')
    ap.add_argument('--seeds', default='4', help='for --sheet: a count (1..N) or a list like 7,8,9 (default 4)')
    ap.add_argument('--no-build', action='store_true', help='run the last build again instead of compiling')
    ap.add_argument('--timeout', type=int, default=600, help='seconds before the run is stopped (default 600)')
    ap.add_argument('--full', action='store_true', help='print the whole log (default: no "step" lines)')
    args = ap.parse_args()

    if args.sheet:
        data, errors = scn.resolve(sheet_scenario(args.sheet, args.seeds))
    elif args.scenario:
        path = args.scenario
        if not os.path.exists(path):
            path = os.path.join(HERE, 'scenarios', args.scenario + ('' if path.endswith('.json') else '.json'))
        data, errors = scn.load(path)
    else:
        ap.error('give a scenario or --sheet')
    if errors:
        fail('scenario: ' + '; '.join(errors))

    # Scenario into the save folder, old results out of the way
    test_dir = os.path.join(SAVE, 'test')
    shutil.rmtree(os.path.join(test_dir, 'out'), ignore_errors=True)
    os.makedirs(os.path.join(test_dir, 'out'), exist_ok=True)
    json.dump(data, open(os.path.join(test_dir, 'scenario.json'), 'w'), indent=1)

    runtime = find_runtime()
    env = dict(os.environ, DOI_TEST=SCENARIO_IN_GAME)
    os.makedirs(BUILD, exist_ok=True)
    out_path = os.path.join(BUILD, 'run_output.txt')
    if args.no_build:
        win = find_last_build()
        cmd = [os.path.join(runtime, 'windows', 'x64', 'Runner.exe'), '-game', win]
        print('Running the last build: ' + win)
    else:
        igor = os.path.join(runtime, 'bin', 'igor', 'windows', 'x64', 'Igor.exe')
        cmd = [igor, '-j=8', '--project=' + PROJECT, '--user=' + find_user(), '--runtimePath=' + runtime,
               '--runtime=VM', '--prefabs=' + os.path.join(GM_DATA, 'Prefabs'),
               '--cache=' + os.path.join(BUILD, 'cache'), '--temp=' + os.path.join(BUILD, 'temp'), '--', 'Windows', 'Run']
        print('Compiling and running (about a minute to compile)...')
    kill_game()
    start = time.time()
    with open(out_path, 'w', encoding='utf-8', errors='replace') as out:
        proc = subprocess.Popen(cmd, cwd=BUILD, env=env, stdout=out, stderr=subprocess.STDOUT)
        try:
            proc.wait(timeout=args.timeout)
            timed_out = False
        except subprocess.TimeoutExpired:
            timed_out = True
            kill_game()
            proc.kill()
            proc.wait()
    print('Finished in %d s' % (time.time() - start))

    # Errors from the compiler and the runtime
    lines = open(out_path, encoding='utf-8', errors='replace').read().splitlines()
    problems = [l for l in lines if any(w in l.lower() for w in ERROR_WORDS)
                and not any(n in l for n in KNOWN_NOISE) and '[Test]' not in l]
    if problems:
        print('\n--- errors in the run output (%s) ---' % out_path)
        for l in problems[:40]:
            print(l)
        if len(problems) > 40:
            print('... %d more' % (len(problems) - 40))

    # Results
    shutil.rmtree(OUT, ignore_errors=True)
    shutil.copytree(os.path.join(test_dir, 'out'), OUT)
    log_path = os.path.join(OUT, 'log.txt')
    log = open(log_path, encoding='utf-8').read().splitlines() if os.path.exists(log_path) else []
    print('\n--- test log (%s) ---' % log_path)
    for l in log:
        if args.full or ' step ' not in l:
            print(l)
    if not log:
        print('(empty: the game did not reach test mode; look at the errors above or ' + out_path + ')')
    pngs = sorted(f for f in os.listdir(OUT) if f.endswith('.png'))
    if pngs:
        print('\nImages in %s: %s' % (OUT, ', '.join(pngs)))

    ended_ok = any(' end ok ' in l + ' ' for l in log[-1:]) and not any(' FAIL ' in l for l in log)
    if timed_out:
        print('\nRESULT: timeout after %d s (game stopped)' % args.timeout)
    else:
        print('\nRESULT: ' + ('ok' if ended_ok else 'FAILED'))
    sys.exit(0 if ended_ok and not timed_out else 1)


if __name__ == '__main__':
    main()
