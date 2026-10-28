"""Builds the game with Igor (GameMaker's command line compiler) and runs test scenarios, with nobody at the keyboard.

    python tools/test/run.py smoke                           # one scenario (a name in tools/test/scenarios or a path)
    python tools/test/run.py boot smoke arch_trace           # several, one build for all of them
    python tools/test/run.py --all                           # every scenario in tools/test/scenarios
    python tools/test/run.py --all --only ref_               # the ones whose name contains "ref_"
    python tools/test/run.py --all --save after              # also keep them as a baseline (baseline.py compare)
    python tools/test/run.py --sheet Castle --seeds 4        # contact sheet: 4 Castle levels, every room in one PNG
    python tools/test/run.py boot --no-build                 # reuse the last build (no GML change since)
    python tools/test/run.py smoke --show                    # on the screen, to watch it

Finds the GameMaker runtime and user folder by itself. Igor only compiles ("Compile"); this script starts the game
itself, a new game for each scenario so each one starts from scratch, as before (one game for several scenarios would
carry the generator's state, the instance and ds numbers and the globals from one to the next).
Out of sight: the game runs on a hidden Windows desktop of its own (CreateDesktop), so it never shows on the screen nor
takes the focus or the keyboard, from a copy of the build with the "start fullscreen" option off (the real build is not
touched). --show runs the real build on the screen instead.
Each scenario goes to %LOCALAPPDATA%\\Zelda\\test\\scenario.json and the game reads it in test mode (scripts/__Test).
Results (log.txt and the PNGs) are copied to tools/test/out/ (one scenario) or tools/test/out/<scenario>/ (several).
Prints compile errors, the test log (one scenario) or one line per scenario, and RESULT; exit code 0 when every
scenario ends with "end ok" and no FAIL line.
Standard library only.
"""
import argparse
import ctypes
import glob
import json
import msvcrt
import os
import shutil
import struct
import subprocess
import sys
import tempfile
import time
from ctypes import wintypes

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
TEST_WIN = 'Zelda_test.win'               # the build's copy that starts windowed (next to the real one: same data files)

# Lines of the run output worth showing besides [Test] (compile and runtime errors)
ERROR_WORDS = ('error', 'exception', 'failed', 'fatal')
KNOWN_NOISE = ('Index did not map to an existing sound instance', 'existing audio asset', 'Errors.txt')

GENERIC_ALL, STARTF_USESTDHANDLES, CREATE_UNICODE_ENVIRONMENT = 0x10000000, 0x100, 0x400


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
    """Game data of the last Igor build (for --no-build)."""
    wins = sorted((w for w in glob.glob(os.path.join(BUILD, '**', '*.win'), recursive=True)
                   if os.path.basename(w) != TEST_WIN), key=os.path.getmtime)
    if not wins:
        fail('no previous build in ' + BUILD + '; run once without --no-build')
    return wins[-1]


def problems_in(lines):
    return [l for l in lines if any(w in l.lower() for w in ERROR_WORDS)
            and not any(n in l for n in KNOWN_NOISE) and '[Test]' not in l]


def show_problems(lines, path):
    problems = problems_in(lines)
    if problems:
        print('\n--- errors in %s ---' % path)
        for l in problems[:40]:
            print(l)
        if len(problems) > 40:
            print('... %d more' % (len(problems) - 40))
    return problems


def build(runtime):
    """Igor "Compile": builds the game without starting it. Returns the .win file."""
    igor = os.path.join(runtime, 'bin', 'igor', 'windows', 'x64', 'Igor.exe')
    cmd = [igor, '-j=8', '--project=' + PROJECT, '--user=' + find_user(), '--runtimePath=' + runtime,
           '--runtime=VM', '--prefabs=' + os.path.join(GM_DATA, 'Prefabs'),
           '--cache=' + os.path.join(BUILD, 'cache'), '--temp=' + os.path.join(BUILD, 'temp'), '--', 'Windows', 'Compile']
    print('Compiling (about a minute)...')
    start = time.time()
    out_path = os.path.join(BUILD, 'build_output.txt')
    with open(out_path, 'w', encoding='utf-8', errors='replace') as out:
        code = subprocess.run(cmd, cwd=BUILD, stdout=out, stderr=subprocess.STDOUT).returncode
    lines = open(out_path, encoding='utf-8', errors='replace').read().splitlines()
    problems = show_problems(lines, out_path)
    win = os.path.join(BUILD, 'output', 'Zelda', 'Zelda.win')
    if code != 0 or not os.path.exists(win) or os.path.getmtime(win) < start:
        fail('the build failed (Igor exit code %d); see %s' % (code, out_path))
    print('Compiled in %d s%s' % (time.time() - start, ' (with the errors above)' if problems else ''))
    return win


def windowed_copy(win):
    """Copy of the build with the "start fullscreen" option off (bit 0 of the GEN8 info flags). The game starts in
    fullscreen and goes windowed a few frames later (oInit): that first fullscreen is what flashed and took the focus."""
    data = bytearray(open(win, 'rb').read())
    if data[:4] != b'FORM' or data[8:12] != b'GEN8':
        fail('unexpected build format (no GEN8 chunk first): ' + win)
    flags = 16 + 68    # GEN8 data starts at 16; the info flags follow the default window width and height
    width, height, info = struct.unpack_from('<III', data, flags - 8)
    if not (0 < width < 10000 and 0 < height < 10000):
        fail('unexpected GEN8 layout (window %dx%d): %s' % (width, height, win))
    struct.pack_into('<I', data, flags, info & ~1)
    path = os.path.join(os.path.dirname(win), TEST_WIN)
    open(path, 'wb').write(data)
    return path


class STARTUPINFOW(ctypes.Structure):
    _fields_ = [('cb', wintypes.DWORD), ('lpReserved', wintypes.LPWSTR), ('lpDesktop', wintypes.LPWSTR),
                ('lpTitle', wintypes.LPWSTR), ('dwX', wintypes.DWORD), ('dwY', wintypes.DWORD),
                ('dwXSize', wintypes.DWORD), ('dwYSize', wintypes.DWORD), ('dwXCountChars', wintypes.DWORD),
                ('dwYCountChars', wintypes.DWORD), ('dwFillAttribute', wintypes.DWORD), ('dwFlags', wintypes.DWORD),
                ('wShowWindow', wintypes.WORD), ('cbReserved2', wintypes.WORD), ('lpReserved2', ctypes.c_void_p),
                ('hStdInput', wintypes.HANDLE), ('hStdOutput', wintypes.HANDLE), ('hStdError', wintypes.HANDLE)]


class PROCESS_INFORMATION(ctypes.Structure):
    _fields_ = [('hProcess', wintypes.HANDLE), ('hThread', wintypes.HANDLE), ('dwProcessId', wintypes.DWORD),
                ('dwThreadId', wintypes.DWORD)]


class HiddenDesktop:
    """A Windows desktop of its own (CreateDesktop), never shown: windows on it cannot reach the screen, the
    foreground or the keyboard of the desktop in use. Programs run on it with CreateProcess(lpDesktop).
    The desktop goes away with its handle once the programs on it have closed."""
    def __init__(self):
        self.user32 = ctypes.WinDLL('user32', use_last_error=True)
        self.kernel32 = ctypes.WinDLL('kernel32', use_last_error=True)
        self.user32.CreateDesktopW.restype = wintypes.HANDLE
        self.user32.CreateDesktopW.argtypes = [wintypes.LPCWSTR, wintypes.LPCWSTR, ctypes.c_void_p, wintypes.DWORD,
                                               wintypes.DWORD, ctypes.c_void_p]
        self.user32.CloseDesktop.argtypes = [wintypes.HANDLE]
        self.kernel32.WaitForSingleObject.argtypes = [wintypes.HANDLE, wintypes.DWORD]
        self.kernel32.TerminateProcess.argtypes = [wintypes.HANDLE, ctypes.c_uint]
        self.kernel32.CloseHandle.argtypes = [wintypes.HANDLE]
        self.name = 'doi-test-%d' % os.getpid()
        self.handle = self.user32.CreateDesktopW(self.name, None, None, 0, GENERIC_ALL, None)
        if not self.handle:
            fail('could not create the test desktop (error %d); try --show' % ctypes.get_last_error())

    def run(self, cmd, cwd, env, out, timeout):
        """Runs cmd on the desktop with stdout and stderr into the open file out. Returns True when it timed out."""
        handle = msvcrt.get_osfhandle(out.fileno())
        os.set_handle_inheritable(handle, True)
        info = STARTUPINFOW()
        info.cb = ctypes.sizeof(info)
        info.lpDesktop = self.name
        info.dwFlags = STARTF_USESTDHANDLES
        info.hStdOutput = info.hStdError = handle
        proc = PROCESS_INFORMATION()
        block = ''.join('%s=%s\0' % kv for kv in sorted(env.items(), key=lambda kv: kv[0].upper())) + '\0'
        if not self.kernel32.CreateProcessW(None, ctypes.create_unicode_buffer(subprocess.list2cmdline(cmd)), None,
                                            None, True, CREATE_UNICODE_ENVIRONMENT, ctypes.c_wchar_p(block), cwd,
                                            ctypes.byref(info), ctypes.byref(proc)):
            fail('could not start %s (error %d)' % (cmd[0], ctypes.get_last_error()))
        end = time.time() + timeout
        ended = False
        try:
            # short waits, so Ctrl+C still stops the script (and, below, the game nobody could see or close)
            while not ended and time.time() < end:
                ended = self.kernel32.WaitForSingleObject(proc.hProcess, 200) == 0
        finally:
            if not ended:
                self.kernel32.TerminateProcess(proc.hProcess, 1)
                self.kernel32.WaitForSingleObject(proc.hProcess, 10000)
            self.kernel32.CloseHandle(proc.hThread)
            self.kernel32.CloseHandle(proc.hProcess)
        return not ended

    def close(self):
        self.user32.CloseDesktop(self.handle)


def run_game(runtime, win, data, timeout, desktop):
    """One scenario in a new game process, on the hidden desktop (or on the screen when desktop is None).
    Returns (log lines, problems in the run output, timed out)."""
    test_dir = os.path.join(SAVE, 'test')
    shutil.rmtree(os.path.join(test_dir, 'out'), ignore_errors=True)
    os.makedirs(os.path.join(test_dir, 'out'), exist_ok=True)
    json.dump(data, open(os.path.join(test_dir, 'scenario.json'), 'w'), indent=1)

    cmd = [os.path.join(runtime, 'windows', 'x64', 'Runner.exe'), '-game', win]
    env = dict(os.environ, DOI_TEST=SCENARIO_IN_GAME)
    out_path = os.path.join(BUILD, 'run_output.txt')
    with open(out_path, 'w', encoding='utf-8', errors='replace') as out:
        if desktop:
            timed_out = desktop.run(cmd, BUILD, env, out, timeout)
        else:
            proc = subprocess.Popen(cmd, cwd=BUILD, env=env, stdout=out, stderr=subprocess.STDOUT)
            try:
                proc.wait(timeout=timeout)
                timed_out = False
            except subprocess.TimeoutExpired:
                timed_out = True
                proc.kill()
                proc.wait()
    problems = problems_in(open(out_path, encoding='utf-8', errors='replace').read().splitlines())
    log_path = os.path.join(test_dir, 'out', 'log.txt')
    log = open(log_path, encoding='utf-8').read().splitlines() if os.path.exists(log_path) else []
    return log, problems, timed_out


def sheet_scenario(level, seeds):
    if seeds.isdigit():
        seeds = list(range(1, int(seeds) + 1))
    else:
        seeds = [int(s) for s in seeds.split(',')]
    return {'name': 'sheet', 'level': level, 'cheats': ['Cheat_Inf_Health'], 'max_frames': 100000,
            'steps': [{'do': 'sheet', 'level': level, 'seeds': seeds}]}


def scenario_path(name):
    if os.path.exists(name):
        return name
    return os.path.join(HERE, 'scenarios', name + ('' if name.endswith('.json') else '.json'))


def all_scenarios(only=None):
    names = sorted(os.path.splitext(os.path.basename(p))[0] for p in glob.glob(os.path.join(HERE, 'scenarios', '*.json')))
    return [n for n in names if not only or only.lower() in n.lower()]


def ended_ok(log):
    return any(' end ok ' in l + ' ' for l in log[-1:]) and not any(' FAIL ' in l for l in log)


def run_batch(jobs, no_build=False, timeout=600, out=OUT, full=False, show=False):
    """Runs [(name, scenario data), ...] after one build, each in a new game on the hidden desktop (show: on the
    screen, as the IDE does). One job: results in out/ and the whole log printed; several: out/<name>/ and one line
    each. Returns {name: (ok, result text)}."""
    runtime = find_runtime()
    os.makedirs(BUILD, exist_ok=True)
    if no_build:
        win = find_last_build()
        print('Running the last build: ' + win)
    else:
        win = build(runtime)
    desktop = None
    if not show:
        win = windowed_copy(win)
        desktop = HiddenDesktop()
    single = len(jobs) == 1
    shutil.rmtree(out, ignore_errors=True)
    results = {}
    try:
        for name, data in jobs:
            dest = out if single else os.path.join(out, name)
            results[name] = run_job(runtime, win, name, data, timeout, desktop, dest, single, full)
    finally:
        if desktop:
            desktop.close()
    if not single:
        failed = [n for n, (ok, _) in results.items() if not ok]
        print('\nResults in %s' % out)
        print('RESULT: ' + ('ok (%d scenarios)' % len(results) if not failed else
                            'FAILED %d of %d: %s' % (len(failed), len(results), ', '.join(failed))))
    return results


def run_job(runtime, win, name, data, timeout, desktop, dest, single, full):
    """One scenario of run_batch: runs it, copies its results to dest and prints them. Returns (ok, result text)."""
    start = time.time()
    log, problems, timed_out = run_game(runtime, win, data, timeout, desktop)
    shutil.copytree(os.path.join(SAVE, 'test', 'out'), dest)
    ok = ended_ok(log) and not timed_out
    result = ('timeout after %d s (game stopped)' % timeout) if timed_out else ('ok' if ok else 'FAILED')
    if not single:
        print('%-26s %-8s %4d s' % (name, 'timeout' if timed_out else result, time.time() - start), flush=True)
        if not ok:
            tail = [l for l in log if ' crash ' in l or ' FAIL ' in l or '  at ' in l] + problems
            for l in (tail or log[-3:] or ['(empty log: the game did not reach test mode)'])[:8]:
                print('    ' + l[:200])
        return ok, result
    print('Finished in %d s' % (time.time() - start))
    if problems:
        print('\n--- errors in the run output (%s) ---' % os.path.join(BUILD, 'run_output.txt'))
        print('\n'.join(problems[:40]))
    print('\n--- test log (%s) ---' % os.path.join(dest, 'log.txt'))
    for l in log:
        if full or ' step ' not in l:
            print(l)
    if not log:
        print('(empty: the game did not reach test mode; look at the errors above or %s)'
              % os.path.join(BUILD, 'run_output.txt'))
    pngs = sorted(f for f in os.listdir(dest) if f.endswith('.png'))
    if pngs:
        print('\nImages in %s: %s' % (dest, ', '.join(pngs)))
    print('\nRESULT: ' + result)
    return ok, result


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('scenario', nargs='*', help='scenario files, or names in tools/test/scenarios')
    ap.add_argument('--all', action='store_true', help='every scenario in tools/test/scenarios')
    ap.add_argument('--only', help='with --all: only the scenarios whose name contains this text')
    ap.add_argument('--sheet', metavar='LEVEL', help='contact sheet of a level (name such as Castle)')
    ap.add_argument('--seeds', default='4', help='for --sheet: a count (1..N) or a list like 7,8,9 (default 4)')
    ap.add_argument('--no-build', action='store_true', help='run the last build again instead of compiling')
    ap.add_argument('--timeout', type=int, default=600, help='seconds before a run is stopped (default 600)')
    ap.add_argument('--full', action='store_true', help='print the whole log (default: no "step" lines)')
    ap.add_argument('--show', action='store_true', help='run the game on the screen, as the IDE does (it takes the '
                    'focus), instead of on the hidden desktop')
    ap.add_argument('--save', metavar='LABEL', help='also keep the results under tools/test/baseline/LABEL/<scenario>/, '
                    'as baseline.py save does (so one --all run is also the baseline to compare)')
    args = ap.parse_args()

    names = list(dict.fromkeys(args.scenario))
    if args.all:
        names += [n for n in all_scenarios(args.only) if n not in names]
    jobs = []
    if args.sheet:
        data, errors = scn.resolve(sheet_scenario(args.sheet, args.seeds))
        if errors:
            fail('sheet: ' + '; '.join(errors))
        jobs.append(('sheet', data))
    for name in names:
        data, errors = scn.load(scenario_path(name))
        if errors:
            fail('scenario %s: %s' % (name, '; '.join(errors)))
        jobs.append((os.path.splitext(os.path.basename(name))[0], data))
    if not jobs:
        ap.error('give a scenario, --all or --sheet')

    results = run_batch(jobs, args.no_build, args.timeout, full=args.full, show=args.show)
    if args.save:
        for name in results:
            dest = os.path.join(HERE, 'baseline', args.save, name)
            shutil.rmtree(dest, ignore_errors=True)
            shutil.copytree(OUT if len(results) == 1 else os.path.join(OUT, name), dest)
        print('Saved to %s' % os.path.join(HERE, 'baseline', args.save))
    sys.exit(0 if all(ok for ok, _ in results.values()) else 1)


if __name__ == '__main__':
    main()
