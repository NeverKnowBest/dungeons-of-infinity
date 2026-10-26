"""Compares two data_r files by content.

    python tools/templates/compare.py OLD NEW [--max 40]

Key order inside objects and int versus float (16 and 16.0) are ignored, since the game reads
both the same way. The order of the templates inside each subclass does count: the dungeon
generator picks templates by index, so a different order changes what a seed builds.
Prints the template counts per class, then the first differences with their path.
Exit code 0 when the files match.
"""
import argparse
import json
import sys


def load(path):
    raw = open(path, 'rb').read()
    if raw.startswith(b'version https://git-lfs'):
        sys.exit('%s is a Git LFS pointer; run "git lfs pull" first' % path)
    return json.loads(raw.rstrip(b'\0').decode('utf-8'))


def label(t):
    if isinstance(t, dict):
        return 'id %s %s' % (num(t.get('id')), t.get('name') or t.get('type') or '')
    return ''


def num(v):
    if isinstance(v, float) and v.is_integer():
        return int(v)
    return v


def diff(a, b, path, out, limit):
    if len(out) >= limit:
        return
    if isinstance(a, bool) or isinstance(b, bool):
        if a is not b and a != b:
            out.append('%s: %r != %r' % (path, a, b))
        return
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        if float(a) != float(b):
            out.append('%s: %s != %s' % (path, num(a), num(b)))
        return
    if type(a) is not type(b):
        out.append('%s: type %s != %s (%s / %s)' % (path, type(a).__name__, type(b).__name__,
                                                    str(a)[:60], str(b)[:60]))
        return
    if isinstance(a, dict):
        for k in a:
            if k not in b:
                out.append('%s.%s: only in the first file' % (path, k))
        for k in b:
            if k not in a:
                out.append('%s.%s: only in the second file' % (path, k))
        for k in a:
            if k in b:
                diff(a[k], b[k], '%s.%s' % (path, k), out, limit)
    elif isinstance(a, list):
        if len(a) != len(b):
            out.append('%s: length %d != %d' % (path, len(a), len(b)))
        for i in range(min(len(a), len(b))):
            lab = label(a[i])
            diff(a[i], b[i], '%s[%d]%s' % (path, i, ' (%s)' % lab if lab else ''), out, limit)
    elif a != b:
        out.append('%s: %r != %r' % (path, a, b))


def main():
    ap = argparse.ArgumentParser(description='Compare two data_r files by content.')
    ap.add_argument('old')
    ap.add_argument('new')
    ap.add_argument('--max', type=int, default=40, help='how many differences to print (default 40)')
    a = ap.parse_args()
    old, new = load(a.old), load(a.new)

    classes = ['Main_Upper', 'Main_Lower', 'Stairs', 'Jails', 'Village', 'Mines', 'Obstacles',
               'Sections', 'Special', 'Other']
    print('templates per class and subclass (first file / second file):')
    for ci in range(max(len(old), len(new))):
        o = [len(s) for s in old[ci]] if ci < len(old) else []
        n = [len(s) for s in new[ci]] if ci < len(new) else []
        name = classes[ci] if ci < len(classes) else str(ci)
        print('  %-11s %s / %s%s' % (name, o, n, '' if o == n else '  <- differs'))

    out = []
    diff(old, new, 'data_r', out, a.max)
    if not out:
        print('same content')
        return 0
    print('differences (first %d):' % a.max)
    for line in out:
        print('  ' + line)
    return 1


if __name__ == '__main__':
    sys.exit(main())
