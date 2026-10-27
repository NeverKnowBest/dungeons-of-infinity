"""Reference runs of every level (roadmap F4): run all the ref_* scenarios, keep the results, compare two versions.

    python tools/test/baseline.py save before                # compiles once, runs every ref_* scenario
    python tools/test/baseline.py save after --only Mines    # only the scenarios whose name contains "Mines"
    python tools/test/baseline.py save after --no-build      # reuse the last build
    python tools/test/baseline.py compare before after       # what changed between two saved runs

Each scenario's results (log.txt, the level dumps dump_<n>_<level>_s<seed>.txt and the PNGs) are copied to
tools/test/baseline/<label>/<scenario>/ (ignored by git). The same code gives the same files, so "compare" lists every
text line that differs and every image that is not the same byte for byte (with Pillow installed, also how many
pixels differ). A baseline of an older commit can be made again at any time: check it out, save, come back.
Standard library only (Pillow optional).
"""
import argparse
import difflib
import glob
import os
import re
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'out')
BASE = os.path.join(HERE, 'baseline')
STEP_RE = re.compile(r'f\d+ step ')


def scenarios(only):
    names = sorted(os.path.splitext(os.path.basename(p))[0] for p in glob.glob(os.path.join(HERE, 'scenarios', 'ref_*.json')))
    return [n for n in names if not only or only.lower() in n.lower()]


def save(label, only, no_build):
    dest = os.path.join(BASE, label)
    names = scenarios(only)
    if not names:
        sys.exit('no ref_* scenario matches')
    failed = []
    for i, name in enumerate(names):
        cmd = [sys.executable, os.path.join(HERE, 'run.py'), name]
        if no_build or i > 0:
            cmd.append('--no-build')
        proc = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8', errors='replace')
        result = [l for l in proc.stdout.splitlines() if l.startswith('RESULT')]
        print('%-28s %s' % (name, result[-1] if result else 'no result'))
        if proc.returncode != 0:
            failed.append(name)
            tail = [l for l in proc.stdout.splitlines() if ' crash ' in l or ' FAIL ' in l or '  at ' in l or 'rror' in l]
            for l in tail[:8]:
                print('    ' + l[:200])
        shutil.rmtree(os.path.join(dest, name), ignore_errors=True)
        if os.path.isdir(OUT):
            shutil.copytree(OUT, os.path.join(dest, name))
    print('\nSaved to %s (%d scenarios, %d failed%s)' % (dest, len(names), len(failed), ': ' + ', '.join(failed) if failed else ''))
    return 1 if failed else 0


def pixels_differ(a, b):
    try:
        from PIL import Image, ImageChops
    except ImportError:
        return None
    ia, ib = Image.open(a).convert('RGB'), Image.open(b).convert('RGB')
    if ia.size != ib.size:
        return 'size %s vs %s' % (ia.size, ib.size)
    diff = ImageChops.difference(ia, ib).convert('L').point(lambda v: 255 if v else 0)
    return '%d pixels' % (sum(diff.histogram()[255:]))


def compare(a, b, lines):
    da, db = os.path.join(BASE, a), os.path.join(BASE, b)
    for d in (da, db):
        if not os.path.isdir(d):
            sys.exit('no baseline ' + d)
    changed = 0
    for name in sorted(set(os.listdir(da)) | set(os.listdir(db))):
        fa, fb = os.path.join(da, name), os.path.join(db, name)
        if not (os.path.isdir(fa) and os.path.isdir(fb)):
            print('%s: only in %s' % (name, a if os.path.isdir(fa) else b))
            changed += 1
            continue
        files = sorted(set(os.listdir(fa)) | set(os.listdir(fb)))
        notes = []
        for f in files:
            pa, pb = os.path.join(fa, f), os.path.join(fb, f)
            if not os.path.exists(pa) or not os.path.exists(pb):
                notes.append('  %s: only in %s' % (f, a if os.path.exists(pa) else b))
                continue
            if open(pa, 'rb').read() == open(pb, 'rb').read():
                continue
            if f.endswith('.png'):
                px = pixels_differ(pa, pb)
                notes.append('  %s: image differs%s' % (f, ' (%s)' % px if px else ''))
                continue
            la = open(pa, encoding='utf-8', errors='replace').read().splitlines()
            lb = open(pb, encoding='utf-8', errors='replace').read().splitlines()
            if f == 'log.txt':	# "step" lines echo the scenario as GML writes it; key order changes between builds
                la, lb = [l for l in la if not STEP_RE.match(l)], [l for l in lb if not STEP_RE.match(l)]
            diff = [l for l in difflib.unified_diff(la, lb, a, b, n=0, lineterm='') if l[:1] in '+-' and l[:3] not in ('---', '+++')]
            if not diff:
                continue
            notes.append('  %s: %d lines differ' % (f, len(diff)))
            for l in diff[:lines]:
                notes.append('    ' + l[:240])
            if len(diff) > lines:
                notes.append('    ... %d more' % (len(diff) - lines))
        if notes:
            changed += 1
            print(name)
            print('\n'.join(notes))
    print('\n%s: %s' % ('SAME' if not changed else 'DIFFERENT', 'every scenario gives the same files' if not changed else '%d scenarios differ' % changed))
    return 1 if changed else 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    s = sub.add_parser('save', help='run the ref_* scenarios and keep the results under a label')
    s.add_argument('label')
    s.add_argument('--only', help='only scenarios whose name contains this text')
    s.add_argument('--no-build', action='store_true', help='reuse the last build for the first scenario too')
    c = sub.add_parser('compare', help='compare two saved labels')
    c.add_argument('a')
    c.add_argument('b')
    c.add_argument('--lines', type=int, default=12, help='differing lines shown per file (default 12)')
    args = ap.parse_args()
    if args.cmd == 'save':
        sys.exit(save(args.label, args.only, args.no_build))
    sys.exit(compare(args.a, args.b, args.lines))


if __name__ == '__main__':
    main()
