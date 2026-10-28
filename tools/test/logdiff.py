# Compares two test logs (tools/test/out/log.txt of two versions of the code) line by line, ignoring what changes
# between builds and runs without being a change in behaviour: the frame at the start of each line (f152), the "step"
# lines (they echo the scenario) and the numbers of ds_lists, instances, surfaces and sprites (ref ds_list 63).
#
#   python tools/test/logdiff.py before_log.txt after_log.txt [--frames]   SAME, or the first lines that differ
#
# --frames also compares the frame numbers (a step that took longer). Used for scenarios/arch_trace.json (roadmap F7).
import re, sys

REF = re.compile(r'ref (ds_list|ds_map|ds_grid|instance|surface|sprite) \d+')
FRAME = re.compile(r'^f\d+ ')


def lines(path, frames):
    out = []
    for l in open(path, encoding='utf-8', errors='replace').read().splitlines():
        if re.match(r'^f\d+ step ', l):
            continue
        l = REF.sub(lambda m: 'ref %s N' % m.group(1), l)
        out.append(l if frames else FRAME.sub('', l))
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if len(args) != 2:
        print(open(__file__).read().split('\nimport')[0])
        return 2
    a, b = (lines(p, '--frames' in sys.argv) for p in args)
    diff = [(i, x, y) for i, (x, y) in enumerate(zip(a, b)) if x != y]
    if not diff and len(a) == len(b):
        print('SAME (%d lines)' % len(a))
        return 0
    print('%d lines differ (%d and %d lines)' % (len(diff) + abs(len(a) - len(b)), len(a), len(b)))
    for i, x, y in diff[:10]:
        print('line %d\n  - %s\n  + %s' % (i + 1, x[:300], y[:300]))
    return 1


if __name__ == '__main__':
    sys.exit(main())
