"""Fitting rules of a region tileset (roadmap F12b-2): which 16x16 blocks may sit next to which.

The rules are learned from real maps: every area of the region's tiles/areas.json (a grid of block numbers per area;
for ALttP, tools/alttp/owdump.py tiles cuts it from the ROM) is read, and every pair of neighbouring blocks (left and
right, above and below) and every 2x2 window of blocks seen there becomes allowed. Nothing else is: a painted room
fits when each of its pairs and windows was seen on a real map. The window rule is what catches a corner with an empty
edge or a wall that does not join: each pair alone may exist and the four together not.

Generic: it only needs tiles.json (the blocks, four 8x8 tiles each, and the tile classes) and areas.json (the maps
in block numbers), so any area of ALttP, and later of another game, gives its rules the same way.

    python tools/templates/tile_rules.py <region>            # writes incoming/<region>/tiles/rules.json, prints stats
    python tools/templates/tile_rules.py <region> --check    # exit 1 when rules.json is missing or out of date

rules.json: {"source": hash of areas.json and tiles.json, "areas": [...], "blocks": N, "right": {"a": [b, ...]},
"down": {"a": [b, ...]}, "windows": [[tl, tr, bl, br], ...], "count": {"a": times seen}, "solid": {"a": mask}}
(mask: bit 0 top left, 1 top right, 2 bottom left, 3 bottom right 8x8 tile is a wall).
"""
import argparse
import hashlib
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
INCOMING = os.path.join(REPO, 'incoming')
# the walkable tile classes (the same list as tools/import/import_region.py TILE_WALKABLE)
WALKABLE = {'floor', 'shallow_water', 'tall_grass', 'stairs', 'entrance', 'dig', 'warp'}


def tiles_dir(region):
    return os.path.join(INCOMING, region, 'tiles')


def source_hash(folder):
    h = hashlib.sha1()
    for f in ('areas.json', 'tiles.json'):
        h.update(open(os.path.join(folder, f), 'rb').read().replace(b'\r\n', b'\n'))
    return h.hexdigest()[:16]


class Rules:
    """The fitting rules of a region, learned from its areas (or loaded from rules.json)."""

    def __init__(self, region=None, folder=None, mirror=False, joins=False):
        self.folder = folder or tiles_dir(region)
        tiles = json.load(open(os.path.join(self.folder, 'tiles.json'), encoding='utf-8'))
        self.areas = json.load(open(os.path.join(self.folder, 'areas.json'), encoding='utf-8'))
        self.blocks = [b['tiles'] for b in tiles['blocks']]
        self.mirror_of = {}
        if mirror:
            # the areas mirrored left to right too (painted rooms already take the horizontal mirror, F12b-1):
            # block i mirrored is the block with the same tiles mirrored, or a new block numbered after tiles.json's
            index = {tuple(map(tuple, b)): i for i, b in enumerate(self.blocks)}
            for i in range(len(self.blocks)):
                b = self.blocks[i]
                m = tuple((t, f ^ 1) for t, f in (b[1], b[0], b[3], b[2]))
                if m not in index:
                    index[m] = len(self.blocks)
                    self.blocks.append([list(t) for t in m])
                self.mirror_of[i] = index[m]
            self.areas = dict(self.areas)
            for name, grid in list(self.areas.items()):
                self.areas[name + 'm'] = [[self.mirror_of[b] for b in reversed(row)] for row in grid]
        classes = tiles['classes']
        attrs = tiles['attributes']
        self.tile_class = ['none'] + [classes.get(a, 'floor') for a in attrs[1:]]
        self.solid = [sum((self.tile_class[t[0]] not in WALKABLE) << k for k, t in enumerate(b)) for b in self.blocks]
        # blocks with the same four tiles are one block for the rules (the ROM has the same picture under several
        # map16 numbers; a painted room's tiles cannot tell them apart): each counts as the lowest of its numbers
        first = {}
        self.canon = [first.setdefault(tuple(map(tuple, b)), i) for i, b in enumerate(self.blocks)]
        self.areas = {n: [[self.canon[b] for b in row] for row in grid] for n, grid in self.areas.items()}
        self.mirror_of = {self.canon[a]: self.canon[b] for a, b in self.mirror_of.items()}
        self.right, self.down, self.windows, self.count = {}, {}, set(), {}
        for grid in self.areas.values():
            self.learn(grid)
        # joins: 2x2 windows the maps never show that Guilherme approved (tiles/joins.json "approved"); with them their
        # pairs fit too
        self.joins = set()
        jp = os.path.join(self.folder, 'joins.json')
        if joins and os.path.exists(jp):
            self.joins = {tuple(self.canon[b] for b in w) for w in json.load(open(jp, encoding='utf-8')).get('approved', [])}
        self.fit = self.windows | self.joins
        self.fit_right = {a: set(v) for a, v in self.right.items()}
        self.fit_down = {a: set(v) for a, v in self.down.items()}
        for a, b, c, d in self.joins:
            for x, y in ((a, b), (c, d)):
                self.fit_right.setdefault(x, set()).add(y)
            for x, y in ((a, c), (b, d)):
                self.fit_down.setdefault(x, set()).add(y)

    def learn(self, grid):
        h, w = len(grid), len(grid[0])
        for y in range(h):
            for x in range(w):
                a = grid[y][x]
                self.count[a] = self.count.get(a, 0) + 1
                if x + 1 < w:
                    self.right.setdefault(a, set()).add(grid[y][x + 1])
                if y + 1 < h:
                    self.down.setdefault(a, set()).add(grid[y + 1][x])
                if x + 1 < w and y + 1 < h:
                    self.windows.add((a, grid[y][x + 1], grid[y + 1][x], grid[y + 1][x + 1]))

    def fits_h(self, a, b):
        return b in self.fit_right.get(a, ())

    def fits_v(self, a, b):
        return b in self.fit_down.get(a, ())

    def check(self, grid, fixed=None):
        """Every misfit of a grid of blocks (None = unknown, skipped): [(x, y, what)], what "right", "down" or
        "window" at the cell (x, y) the pair or window starts from. The approved joins fit (when loaded)."""
        bad = []
        grid = [[None if b is None else self.canon[b] for b in row] for row in grid]
        h, w = len(grid), len(grid[0])
        for y in range(h):
            for x in range(w):
                a = grid[y][x]
                if a is None:
                    continue
                b = grid[y][x + 1] if x + 1 < w else None
                c = grid[y + 1][x] if y + 1 < h else None
                if b is not None and not self.fits_h(a, b):
                    bad.append((x, y, 'right'))
                if c is not None and not self.fits_v(a, c):
                    bad.append((x, y, 'down'))
                if b is not None and c is not None and y + 1 < h and x + 1 < w:
                    d = grid[y + 1][x + 1]
                    if d is not None and (a, b, c, d) not in self.fit:
                        bad.append((x, y, 'window'))
        return bad

    def to_json(self):
        return {'comment': 'Fitting rules of the region tileset, learned from tiles/areas.json by '
                           'tools/templates/tile_rules.py (roadmap F12b-2). Do not edit.',
                'source': source_hash(self.folder), 'areas': sorted(self.areas), 'blocks': len(self.blocks),
                'right': {str(a): sorted(v) for a, v in sorted(self.right.items())},
                'down': {str(a): sorted(v) for a, v in sorted(self.down.items())},
                'windows': sorted(self.windows),
                'count': {str(a): n for a, n in sorted(self.count.items())},
                'solid': {str(a): self.solid[a] for a in sorted(self.count)}}


_LOADED = {}


def load(region, mirror=False, joins=False):
    """Rules(region, mirror, joins), made once per run (they take a second or two with the mirror)."""
    key = (region, mirror, joins)
    if key not in _LOADED:
        _LOADED[key] = Rules(region, mirror=mirror, joins=joins)
    return _LOADED[key]


def write(region):
    r = Rules(region)
    path = os.path.join(r.folder, 'rules.json')
    d = r.to_json()
    text = '{\n' + ',\n'.join('"%s": %s' % (k, json.dumps(v, separators=(',', ':'))) for k, v in d.items()) + '\n}\n'
    open(path, 'w', encoding='utf-8', newline='\n').write(text)
    return r, path


def up_to_date(region):
    folder = tiles_dir(region)
    path = os.path.join(folder, 'rules.json')
    if not os.path.exists(path):
        return False
    return json.load(open(path, encoding='utf-8')).get('source') == source_hash(folder)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('region', help='folder in incoming/ (e.g. topo-do-castelo)')
    ap.add_argument('--check', action='store_true', help='exit 1 when rules.json is missing or out of date')
    a = ap.parse_args()
    if a.check:
        ok = up_to_date(a.region)
        print('rules.json %s' % ('up to date' if ok else 'missing or out of date (run tile_rules.py %s)' % a.region))
        sys.exit(0 if ok else 1)
    r, path = write(a.region)
    used = len(r.count)
    print('%s: %d areas, %d blocks used of %d, %d right pairs, %d down pairs, %d windows'
          % (os.path.relpath(path, REPO), len(r.areas), used, len(r.blocks),
             sum(map(len, r.right.values())), sum(map(len, r.down.values())), len(r.windows)))


if __name__ == '__main__':
    main()


def template_blocks(rules, cells, w, h):
    """The block grid of a painted template's tile layer (Region base/open/gate: 8x8 tiles, index | flags << 16, 0 for
    none): each 2x2 of tiles as the block that has those tiles, None where no block has them."""
    quad = getattr(rules, '_quad', None)
    if quad is None:
        quad = rules._quad = {tuple(tuple(t) for t in b): rules.canon[i] for i, b in enumerate(rules.blocks)}
    out = []
    for by in range(h // 2):
        row = []
        for bx in range(w // 2):
            q = []
            for dy, dx in ((0, 0), (0, 1), (1, 0), (1, 1)):
                v = int(cells[(by * 2 + dy) * w + bx * 2 + dx])
                q.append((v & 0xFFFF, v >> 16) if v else (0, 0))
            row.append(quad.get(tuple(q)))
        out.append(row)
    return out


def check_set(set_dir, rooms_dir):
    """Problems of a set painted from a frame (paint_auto.py): every painted template of its game data (rooms_dir,
    one template per line) must fit the rules and the approved joins closed, with its doors open and with its gate,
    and its border must be the frame's (so any two rooms meet as the frame meets itself). Returns [message]."""
    d = json.load(open(os.path.join(set_dir, 'rooms.json'), encoding='utf-8'))
    auto = (d.get('kit') or {}).get('auto')
    if auto is None:
        return []
    frame = json.load(open(os.path.join(set_dir, auto.get('frame', 'frame.json')), encoding='utf-8'))
    rules = load(frame['region'], mirror=frame.get('mirror', False), joins=True)
    import paint_auto
    kit = paint_auto.AutoKit({'frame': auto.get('frame', 'frame.json')}, rules.folder, set_dir, set_dir)
    G = frame['ring']
    out = []
    for fn in sorted(os.listdir(rooms_dir)):
        if fn == 'Fit.json':
            continue
        for line in open(os.path.join(rooms_dir, fn), encoding='utf-8'):
            line = line.strip().rstrip(',')
            if not line.startswith('{'):
                continue
            t = json.loads(line)
            reg = t.get('Region')
            if not reg:
                continue
            w, h = int(reg['w']), int(reg['h'])
            name = '%s %s' % (fn, t.get('name'))
            base = template_blocks(rules, reg['base'], w, h)
            if any(b is None for row in base for b in row):
                out.append('%s: tiles that make no block of the region' % name)
                continue
            cw, ch = w // 2, h // 2
            border = [(x, y) for y in range(ch) for x in range(cw) if x in (0, cw - 1) or y in (0, ch - 1)]
            for x, y in border:
                want = G[0 if y == 0 else 15][x % 16] if y in (0, ch - 1) else G[y % 16][0 if x == 0 else 15]
                if base[y][x] != rules.canon[want]:
                    out.append('%s: block %d,%d of its border is not the frame\'s (neighbouring rooms would not meet)'
                               % (name, x, y))
                    break
            for layer in ('open', 'gate'):
                if not reg.get(layer):
                    if layer == 'open':
                        bad = rules.check(base)
                        if bad:
                            out.append('%s: %d misfits closed, the first at block %d,%d (%s)' % ((name, len(bad)) + bad[0]))
                    continue
                cells = [o if o else b for o, b in zip(reg[layer], reg['base'])]
                grid = template_blocks(rules, cells, w, h)
                if any(b is None for row in grid for b in row):
                    out.append('%s: %s tiles that make no block of the region' % (name, layer))
                    continue
                for what, g in (('closed', base), ('with its %s' % layer, grid)):
                    bad = rules.check(g)
                    if bad:
                        out.append('%s: %d misfits %s, the first at block %d,%d (%s)' % ((name, len(bad), what) + bad[0]))
                if layer == 'open':
                    # an open door's border is the frame's passage, block for block, so the room on the other side
                    # (which opens the same passage) meets it
                    want = {}
                    for dr in t.get('Doors', []):
                        loc = dr['Location']
                        off = int(dr['x'] if loc in ('Top', 'Bottom') else dr['y'])
                        for c, b in kit.passage(loc, off, cw, ch).items():
                            if c in border:
                                want[c] = rules.canon[b]
                    for x, y in border:
                        if grid[y][x] != want.get((x, y), base[y][x]):
                            out.append('%s: block %d,%d of its border with the doors open is not the frame\'s passage '
                                       '(the neighbouring room would not meet it)' % (name, x, y))
                            break
    return out


def fit_text(set_dir):
    """sets/<Set>/Fit.json of the game data, for a set painted from a frame (roadmap F12b-2), or None: "quads", the
    block of each four tiles ("tile:flags" top left, top right, bottom left, bottom right), and "fit", every 2x2 window
    of blocks that fits ("a,b,c,d": on the maps or an approved join). The test step "seams" checks with it the seams
    between neighbouring painted rooms of a level."""
    rp = os.path.join(set_dir, 'rooms.json')
    auto = (json.load(open(rp, encoding='utf-8')).get('kit') or {}).get('auto') if os.path.exists(rp) else None
    if auto is None:
        return None
    frame = json.load(open(os.path.join(set_dir, auto.get('frame', 'frame.json')), encoding='utf-8'))
    rules = load(frame['region'], mirror=frame.get('mirror', False), joins=True)
    quads = {}
    for i, b in enumerate(rules.blocks):
        quads.setdefault(','.join('%d:%d' % (t, f) for t, f in b), rules.canon[i])
    fit = sorted('%d,%d,%d,%d' % w for w in rules.fit)
    return ('{"comment":"Fitting rules of the room set (tools/templates/tile_rules.py fit_text, roadmap F12b-2), read by the '
            'test step seams.",\n"quads":' + json.dumps(quads, separators=(',', ':'), sort_keys=True) +
            ',\n"fit":' + json.dumps(fit, separators=(',', ':')) + '}\n')
