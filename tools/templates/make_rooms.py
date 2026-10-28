"""Room template helper (roadmap F11): writes the Tiled maps of a room set from a short description.

The Main_Upper and Main_Lower templates are half rooms with walls, doors, sections, zones and SplitConnections,
which convert.py joins into whole rooms. Drawing them takes the Tiled editor; this script writes them from
data/room-templates/sets/<Set>/rooms.json instead, so a region can get its own rooms without Tiled:

    python tools/templates/make_rooms.py Example            # writes the set's maps, converts and checks them
    python tools/templates/make_rooms.py Example --dry-run  # checks only, writes nothing
    python tools/templates/make_rooms.py --list             # sets and what each description makes
    python tools/templates/make_rooms.py --selftest         # the outline model against shared templates

Then python tools/templates/convert.py writes the game files (the script says so). A map the script did not write
(a set drawn in Tiled) is never overwritten. Description format: tools/README.md ("templates/") and the example
set data/room-templates/sets/Example/rooms.json. Everything is in pixels of the half room, on an 8 px grid.

Each half gets, from its outline: the walls (corner, inner corner and side pieces traced around the outline,
24 px thick; in Main_Lower the outline is the lower floor and the upper walls go around it 24 px out),
OutOfBounds over the cut corners, the doors on the wall pieces, the SplitConnections at the side
walls on the cut line and, unless "furnish" is false, the objects the generator needs to place special objects
(torches in the top corners, treasure and crystal spots, pot rows along the top wall, two monuments, an enemy
area), kept off the door lanes, water and spikes. Each section it can host (1 corner, 2 middle, 9 wide,
17 strip; their mirrors come from the game's transforms) gets its area, its rails and the same objects with
the rails in the way, plus a treasure and a crystal spot inside the section.

Standard library only.
"""
import argparse
import copy
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import convert  # noqa: E402

G = convert.GIDS
GRID = 8
WALL = 24
GENERATOR = 'tools/templates/make_rooms.py'

# Half heights and the room size index whose door coordinates they use
SIZES = {'1x1': (128, 0), '1x2': (256, 1)}
# Door slots of a top half, in the joined room's numbering (Data_InitDoorCoordinates): top, left, right
SLOTS = {'Main_Upper': [11, 12, 1, 10, 9, 2, 3], 'Main_Lower': [23, 24, 13, 22, 21, 14, 15]}
DOOR_GID = {'Top': G['DoorT'], 'Left': G['DoorL'], 'Right': G['DoorR']}
# outline origin: Main_Upper walls start at 16; Main_Lower lower walls at 40 (its upper walls go around them)
ORIGIN = {'Main_Upper': 16, 'Main_Lower': 40}
PIECES = {
    'Main_Upper': {'TL': 'WallCornerTL', 'TR': 'WallCornerTR', 'BL': 'WallCornerBL', 'BR': 'WallCornerBR',
                   'iTL': 'WallInnerTL', 'iTR': 'WallInnerTR', 'iBL': 'WallInnerBL', 'iBR': 'WallInnerBR',
                   'T': 'WallSideT', 'B': 'WallSideB', 'L': 'WallSideL', 'R': 'WallSideR'},
    'Main_Lower': {'TL': 'WallLowerCornerTL', 'TR': 'WallLowerCornerTR', 'BL': 'WallLowerCornerBL', 'BR': 'WallLowerCornerBR',
                   'iTL': 'WallLowerInnerTL', 'iTR': 'WallLowerInnerTR', 'iBL': 'WallLowerInnerBL', 'iBR': 'WallLowerInnerBR',
                   'T': 'WallLowerSideT', 'B': 'WallLowerSideB', 'L': 'WallLowerSideL', 'R': 'WallLowerSideR'},
}
WALL_LAYER = {'Main_Upper': 'WallsUpper', 'Main_Lower': 'WallsLower'}
# Section groups of Main_Upper, in Split_MainSectionIDs order, and the section of each group a half can host.
# Geometry from the shared templates (663 and the most common 256 px halves): area, rails (x, y, w, h, SB), doors.
GROUPS = ['1-3-6-8', '2-4-5-7', '9-10-11-12-13-14-15-16', '17-18-19-20']
GROUP_OF = {1: 0, 2: 1, 9: 2, 17: 3}
SECTIONS = {
    128: {1: ((16, 16, 80, 80), [(48, 96, 56, 8, 'RD'), (96, 48, 8, 56, 'RD')], [11, 10]),
          2: ((104, 16, 48, 80), [(96, 48, 8, 56, 'LD'), (96, 96, 64, 8, 'LDR'), (152, 48, 8, 56, 'RD')], [12]),
          9: ((16, 16, 128, 80), [(48, 96, 104, 8, 'RD'), (144, 48, 8, 56, 'RD')], [11, 12, 10]),
          17: ((16, 16, 224, 80), [(48, 96, 160, 8, 'D')], [11, 12, 1, 10, 2])},
    256: {1: ((16, 16, 80, 144), [(48, 160, 56, 8, 'RD'), (96, 48, 8, 120, 'RD')], [11, 10]),
          2: ((104, 16, 48, 80), [(96, 48, 8, 56, 'LD'), (96, 96, 64, 8, 'LDR'), (152, 48, 8, 56, 'RD')], [12]),
          9: ((16, 16, 128, 136), [(48, 152, 104, 8, 'RD'), (144, 48, 8, 112, 'RD')], [11, 12, 10]),
          17: ((16, 16, 224, 144), [(48, 152, 160, 8, 'D')], [11, 12, 1, 10, 2])},
}
HALF_KEYS = {'name', 'class', 'size', 'cut', 'doors', 'sections', 'water', 'spikes', 'zones', 'objects', 'furnish',
             'props', 'comment'}
LAYER_GID = {'Torches': 'Torch', 'Treasures': 'Treasure', 'Crystals': 'Crystal', 'Pots': 'Pot',
             'PotTreasures': 'PotOrTreasure', 'Monuments': 'Monument', 'Kinstones': 'Kinstone', 'Altars': 'Altar',
             'GuruBars': 'GuruBar', 'Water': 'Water', 'Spikes': 'SpikeFloor'}


class RoomError(Exception):
    pass


# ---------------------------------------------------------------- rectangles

def overlap(a, b):
    """Two (x, y, w, h) boxes share some area."""
    return a[0] < b[0] + b[2] and b[0] < a[0] + a[2] and a[1] < b[1] + b[3] and b[1] < a[1] + a[3]


def inside(a, b):
    """Box a is within box b."""
    return a[0] >= b[0] and a[1] >= b[1] and a[0] + a[2] <= b[0] + b[2] and a[1] + a[3] <= b[1] + b[3]


def mirror(r):
    return (256 - r[0] - r[2],) + tuple(r[1:])


def rect(v, where):
    if not (isinstance(v, (list, tuple)) and len(v) == 4 and all(isinstance(x, int) for x in v)):
        raise RoomError('%s: %r should be [x, y, w, h] in whole pixels' % (where, v))
    if any(x % GRID for x in v) or v[2] <= 0 or v[3] <= 0:
        raise RoomError('%s: %r is not on the %d px grid' % (where, v, GRID))
    return tuple(v)


class Mask:
    """Cells of GRID px over the half, x 0..256 and y 0..h."""

    def __init__(self, h, value=False):
        self.w, self.h = 256 // GRID, h // GRID
        self.c = [[value] * self.w for _ in range(self.h)]

    def set(self, r, value=True):
        for y in range(max(0, r[1] // GRID), min(self.h, (r[1] + r[3]) // GRID)):
            for x in range(max(0, r[0] // GRID), min(self.w, (r[0] + r[2]) // GRID)):
                self.c[y][x] = value

    def get(self, cx, cy):
        return 0 <= cx < self.w and 0 <= cy < self.h and self.c[cy][cx]

    def all(self, r):
        """Every cell of the box is set (boxes past the bottom edge are checked up to it)."""
        if r[0] < 0 or r[1] < 0 or r[0] + r[2] > 256:
            return False
        for y in range(r[1] // GRID, min(self.h, (r[1] + r[3]) // GRID)):
            for x in range(r[0] // GRID, (r[0] + r[2]) // GRID):
                if not self.c[y][x]:
                    return False
        return True

    def any(self, r):
        for y in range(max(0, r[1] // GRID), min(self.h, (r[1] + r[3]) // GRID)):
            for x in range(max(0, r[0] // GRID), min(self.w, (r[0] + r[2]) // GRID)):
                if self.c[y][x]:
                    return True
        return False

    def minus(self, other):
        out = Mask(self.h * GRID)
        out.c = [[a and not b for a, b in zip(ra, rb)] for ra, rb in zip(self.c, other.c)]
        return out

    def rows(self):
        """The set cells as rectangles: runs of each row, merged with equal runs below."""
        runs = []
        for y in range(self.h):
            x = 0
            while x < self.w:
                if self.c[y][x]:
                    x0 = x
                    while x < self.w and self.c[y][x]:
                        x += 1
                    runs.append([x0, y, x - x0, 1])
                else:
                    x += 1
        merged = []
        for r in runs:
            for m in merged:
                if m[0] == r[0] and m[2] == r[2] and m[1] + m[3] == r[1]:
                    m[3] += 1
                    break
            else:
                merged.append(r)
        return [(m[0] * GRID, m[1] * GRID, m[2] * GRID, m[3] * GRID) for m in merged]

    def largest(self):
        """Largest box of set cells (x, y, w, h), or None."""
        best, best_area = None, 0
        heights = [0] * self.w
        for y in range(self.h):
            for x in range(self.w):
                heights[x] = heights[x] + 1 if self.c[y][x] else 0
            for x0 in range(self.w):
                hmin = 1 << 30
                for x1 in range(x0, self.w):
                    hmin = min(hmin, heights[x1])
                    if hmin == 0:
                        break
                    area = hmin * (x1 - x0 + 1)
                    if area > best_area:
                        best_area, best = area, (x0, y - hmin + 1, x1 - x0 + 1, hmin)
        if best is None:
            return None
        return tuple(v * GRID for v in best)


# ---------------------------------------------------------------- walls from the outline

def trace_walls(region, x0, h, names):
    """Wall pieces (gid name, box) around the region cells, 24 px thick inside it. The region continues straight
    down past the cut line (h), which gets no wall. Corners on every outline vertex, sides between them."""
    def cell(cx, cy):
        if cy >= region.h:
            cy = region.h - 1
        return region.get(cx, cy)

    pieces = []
    corner = {}   # lattice point -> 'convex' or 'concave'
    for py in range(region.h + 1):
        for px in range(region.w + 1):
            if py == region.h:
                continue    # the cut line: walls go straight through it
            q = (cell(px - 1, py - 1), cell(px, py - 1), cell(px - 1, py), cell(px, py))   # TL TR BL BR
            n = sum(q)
            x, y = px * GRID, py * GRID
            if n == 1:
                k = ('TL', 'TR', 'BL', 'BR')[q.index(True)]
                kind = {'BR': 'TL', 'BL': 'TR', 'TR': 'BL', 'TL': 'BR'}[k]
                bx = x if kind in ('TL', 'BL') else x - WALL
                by = y if kind in ('TL', 'TR') else y - WALL
                pieces.append((names[kind], (bx, by, WALL, WALL)))
                corner[(x, y)] = 'convex'
            elif n == 3:
                k = ('TL', 'TR', 'BL', 'BR')[q.index(False)]
                bx = x if k in ('TL', 'BL') else x - WALL
                by = y if k in ('TL', 'TR') else y - WALL
                pieces.append((names['i' + k], (bx, by, WALL, WALL)))
                corner[(x, y)] = 'concave'
            elif n == 2 and q[0] == q[3]:
                raise RoomError('the outline touches itself diagonally at %d,%d' % (x, y))

    def ends(a, b, at):
        """Side piece of an edge run from a to b: convex ends leave the corner piece inside the run."""
        s = a + (WALL if corner.get(at(a)) == 'convex' else 0)
        e = b - (WALL if corner.get(at(b)) == 'convex' else 0)
        if e < s:
            raise RoomError('the outline has an edge of %d px between corners at %s; it needs %d'
                            % (b - a, at(a), 2 * WALL))
        return s, e

    # horizontal edges: top walls (outside above) and bottom walls (outside below)
    for py in range(region.h):
        for side in ('T', 'B'):
            px = 0
            while px < region.w:
                def edge(cx):
                    above, below = cell(cx, py - 1), cell(cx, py)
                    return (below and not above) if side == 'T' else (above and not below)
                if edge(px):
                    a = px
                    while px < region.w and edge(px):
                        px += 1
                    y = py * GRID
                    s, e = ends(a * GRID, px * GRID, lambda v: (v, y))
                    if e > s:
                        pieces.append((names[side], (s, y if side == 'T' else y - WALL, e - s, WALL)))
                else:
                    px += 1
    # vertical edges: left walls (outside left) and right walls (outside right); they run to the cut line
    for px in range(region.w + 1):
        for side in ('L', 'R'):
            py = 0
            while py < region.h:
                def edge(cy):
                    left, right = cell(px - 1, cy), cell(px, cy)
                    return (right and not left) if side == 'L' else (left and not right)
                if edge(py):
                    a = py
                    while py < region.h and edge(py):
                        py += 1
                    x = px * GRID
                    s, e = ends(a * GRID, py * GRID, lambda v: (x, v))
                    if e > s:
                        pieces.append((names[side], (x if side == 'L' else x - WALL, s, WALL, e - s)))
                else:
                    py += 1

    for i, (n1, r1) in enumerate(pieces):
        for n2, r2 in pieces[i + 1:]:
            if overlap(r1, r2):
                raise RoomError('wall pieces %s %s and %s %s overlap: parts of the outline are closer than %d px'
                                % (n1, r1, n2, r2, 2 * WALL))
    # the cut line: one opening, with a side wall at each end
    last = [cx for cx in range(region.w) if region.get(cx, region.h - 1)]
    if not last or last != list(range(last[0], last[-1] + 1)):
        raise RoomError('the outline must meet the cut line (y=%d) in one opening' % h)
    split = [(last[0] * GRID, h - 16, WALL, 32), ((last[-1] + 1) * GRID - WALL, h - 16, WALL, 32)]
    return pieces, split


# ---------------------------------------------------------------- one half

class Half:
    def __init__(self, d, where):
        self.d = d
        self.where = where
        for k in d:
            if k not in HALF_KEYS:
                raise RoomError('%s: unknown key "%s" (keys: %s)' % (where, k, ', '.join(sorted(HALF_KEYS))))
        self.name = d.get('name')
        if not self.name:
            raise RoomError('%s: needs a "name"' % where)
        self.cls = d.get('class', 'Main_Upper')
        if self.cls not in SLOTS:
            raise RoomError('%s: class must be Main_Upper or Main_Lower' % where)
        if d.get('size', '1x1') not in SIZES:
            raise RoomError('%s: size must be 1x1 (256x128 half) or 1x2 (256x256 half)' % where)
        self.h, self.size_index = SIZES[d.get('size', '1x1')]
        self.layers = {}        # layer -> [(gid name or None, box, props)]
        self.groups = {}        # section group index -> {layer: [...]}
        self.split_ids = [0, 0, 0, 0]
        self.build()

    def add(self, layer, gid, box, props=None, group=None, obj_type=''):
        dst = self.layers if group is None else self.groups.setdefault(group, {})
        dst.setdefault(layer, []).append((gid, tuple(box), dict(props or {}), obj_type))

    def build(self):
        d, h, cls, where = self.d, self.h, self.cls, self.where
        o = ORIGIN[cls]
        bounds = (o, o, 256 - 2 * o, h - o)
        region = Mask(h)
        region.set(bounds)
        cuts = [rect(c, where + ' cut') for c in d.get('cut', [])]
        for c in cuts:
            if not inside(c, bounds):
                raise RoomError('%s: cut %s is outside the outline %s' % (where, c, bounds))
            region.set(c, False)
        self.cuts = cuts

        whole = Mask(h)
        whole.set((16, 16, 224, h - 16))
        if cls == 'Main_Lower':
            # the outline is the lower floor (and its walls); the upper walls go right around it, 24 px out
            # (the outline grown by 24 px on every side), like in the shared templates (40406, 33044, 42882)
            upper = Mask(h)
            for cy in range(region.h):
                for cx in range(region.w):
                    if region.c[cy][cx]:
                        upper.set((cx * GRID - WALL, cy * GRID - WALL, GRID + 2 * WALL, GRID + 2 * WALL))
            upper = upper.minus(upper.minus(whole))
            try:
                upper_pieces, _ = trace_walls(upper, 16, h, PIECES['Main_Upper'])
            except RoomError as e:
                raise RoomError('%s: upper walls: %s' % (where, e))
            for gid, box in upper_pieces:
                self.add('WallsUpper', gid, box)
            for box in whole.minus(upper).rows():
                self.add('OutOfBounds', None, box)
            for box in region.rows():
                self.add('LowerFloor', None, box)
        else:
            for box in whole.minus(region).rows():
                self.add('OutOfBounds', None, box)
        try:
            pieces, split = trace_walls(region, o, h, {k: v for k, v in PIECES[cls].items()})
        except RoomError as e:
            raise RoomError('%s: %s' % (where, e))
        for gid, box in pieces:
            self.add(WALL_LAYER[cls], gid, box)
        for box in split:
            self.add('SplitConnections', None, box)

        # doors on straight wall pieces
        coords = convert.DOOR_XY[self.size_index]
        sides = {'Top': 'WallLowerSideT' if cls == 'Main_Lower' else 'WallSideT',
                 'Left': 'WallLowerSideL' if cls == 'Main_Lower' else 'WallSideL',
                 'Right': 'WallLowerSideR' if cls == 'Main_Lower' else 'WallSideR'}
        slots = SLOTS[cls]
        want = d.get('doors', 'all')
        if want != 'all':
            if not isinstance(want, list) or any(p not in slots for p in want):
                raise RoomError('%s: doors is "all" or a list of %s (positions of the joined room, top half)'
                                % (where, slots))
        self.doors = {}
        for p in slots:
            loc = convert.door_location(p)
            x, y = coords[(p - 1) * 2], coords[(p - 1) * 2 + 1]
            box = (x, y, 32, 24) if loc == 'Top' else (x, y, 24, 32)
            part = (box[0], box[1], box[2], min(box[3], h - box[1]))     # seam doors: the part in this half
            fits = any(n == sides[loc] and inside(part, r) for n, r in pieces)
            if want == 'all':
                if fits:
                    self.doors[p] = (loc, box)
            elif p in want:
                if not fits:
                    raise RoomError('%s: door %d (%s wall at %d,%d) is not on a straight wall' % (where, p, loc, x, y))
                self.doors[p] = (loc, box)
        if not self.doors:
            raise RoomError('%s: no door fits the outline' % where)
        for p, (loc, box) in sorted(self.doors.items()):
            self.add('Doors', DOOR_GID[loc], box, obj_type='Lower' if cls == 'Main_Lower' else '')

        # the floor: inside the walls
        walls = Mask(h)
        for _, box in pieces:
            walls.set(box)
        self.floor = region.minus(walls)
        if not any(any(r) for r in self.floor.c):
            raise RoomError('%s: the walls leave no floor' % where)

        self.blocked = Mask(h)
        for key, layer in (('water', 'Water'), ('spikes', 'Spikes')):
            for r in d.get(key, []):
                r = rect(r, '%s %s' % (where, key))
                if not self.floor.all(r):
                    raise RoomError('%s: %s %s is not all floor' % (where, key, r))
                self.add(layer, LAYER_GID[layer], r)
                self.blocked.set(r)
        self.lanes = Mask(h)
        for loc, box in self.doors.values():
            x, y, w, hh = box
            lane = {'Top': (x, y + 24, 32, 32), 'Left': (x + 24, y, 32, 32), 'Right': (x - 32, y, 32, 32)}[loc]
            self.lanes.set(lane)
        self.zones = [rect(z, where + ' zones') for z in d.get('zones', [])]
        if not self.zones:
            self.check_connected(where)
        for z in self.zones:
            self.add('Zones', None, z, group='main')
        for layer, items in (d.get('objects') or {}).items():
            if layer not in LAYER_GID and layer != 'Enemies':
                raise RoomError('%s: objects layer "%s" is not one of %s' % (where, layer, sorted(LAYER_GID) + ['Enemies']))
            for it in items:
                props = it[4] if len(it) > 4 else {}
                self.add(layer, LAYER_GID.get(layer), rect(it[:4], '%s objects %s' % (where, layer)), props, group='main')

        if d.get('furnish', True):
            self.furnish('main', Mask(h))
        sections = d.get('sections', [])
        if sections and cls != 'Main_Upper':
            raise RoomError('%s: only Main_Upper halves have sections' % where)
        for s in sections:
            self.section(s)

        self.symmetric = self.is_symmetric()

    def check_connected(self, where):
        """Without zones, every door must reach every bit of floor (water in the way needs zones)."""
        walk = self.floor.minus(self.blocked)
        seen, todo = set(), []
        for loc, box in self.doors.values():
            x, y, w, hh = box
            probe = {'Top': (x, y + 24), 'Left': (x + 24, y), 'Right': (x - 8, y)}[loc]
            c = (probe[0] // GRID, probe[1] // GRID)
            if walk.get(*c):
                todo.append(c)
        while todo:
            c = todo.pop()
            if c in seen or not walk.get(*c):
                continue
            seen.add(c)
            todo += [(c[0] + 1, c[1]), (c[0] - 1, c[1]), (c[0], c[1] + 1), (c[0], c[1] - 1)]
        cells = sum(sum(r) for r in walk.c)
        if len(seen) != cells:
            raise RoomError('%s: water splits the floor (%d of %d cells reached from the doors); '
                            'give "zones" for the parts' % (where, len(seen), cells))

    def spot_ok(self, box, extra, margin=0):
        grown = (box[0] - margin, box[1] - margin, box[2] + 2 * margin, box[3] + 2 * margin)
        return (self.floor.all(grown) and not self.blocked.any(box) and not self.lanes.any(box)
                and not extra.any(grown))

    def furnish(self, group, extra):
        """The objects the generator places things on, off the door lanes, water, spikes and the boxes in extra."""
        fl = self.floor
        cells = [(x, y) for y in range(fl.h) for x in range(fl.w) if fl.c[y][x]]
        fx0 = min(c[0] for c in cells) * GRID
        fy0 = min(c[1] for c in cells) * GRID
        fx1 = (max(c[0] for c in cells) + 1) * GRID
        mid = 128

        for x in (fx0, fx1 - 16):                         # torches in the top corners
            if self.spot_ok((x, fy0, 16, 16), extra):
                self.add('Torches', 'Torch', (x, fy0, 16, 16), group=group)
        spots = []                                         # treasure and crystal spots
        for y in range(fy0 + 8, self.h - 15, 24):
            for k in range(0, 5):
                for x in sorted({mid - 8 - 32 * k, mid - 8 + 32 * k}):
                    if self.spot_ok((x, y, 16, 16), extra, 8):
                        spots.append((x, y, 16, 16))
        spots = spots[:14]
        for s in spots:
            self.add('Treasures', 'Treasure', s, group=group)
            self.add('Crystals', 'Crystal', s, group=group)
        self.spots = spots
        x = fx0                                            # pot rows along the top wall
        while x < fx1:
            if self.spot_ok((x, fy0, 16, 16), extra):
                x0 = x
                while x < fx1 and self.spot_ok((x, fy0, 16, 16), extra) and x - x0 < 64:
                    x += 16
                w = x - x0
                if w >= 16:
                    sd = 'R' if x0 == fx0 else ('L' if x == fx1 else 'Full')
                    self.add('Pots', 'Pot', (x0, fy0, w, 16), {'SpawnDir': sd}, group=group)
                    self.add('PotTreasures', 'PotOrTreasure', (x0, fy0, w, 16), group=group)
            else:
                x += 8
        ym = fy0 + ((self.h - fy0) // 2 // GRID) * GRID - 16   # two monuments, mirrored
        for x in (mid - 16 - 48, mid - 16 + 48):
            for y in (ym, ym + 16, ym - 16):
                if self.spot_ok((x, y, 32, 32), extra, 8):
                    self.add('Monuments', 'Monument', (x, y, 32, 32), group=group)
                    break
        walk = self.floor.minus(self.blocked).minus(extra)  # enemy area: the largest free box, 16 px in
        big = walk.largest()
        if big:
            # 16 px in from every side, but it keeps going to the cut line (the other half continues it)
            area = (big[0] + 16, big[1] + 16, big[2] - 32, big[3] - (16 if big[1] + big[3] >= self.h else 32))
            if area[2] > 0 and area[3] > 0:
                self.add('Enemies', None, area, group=group)

    def section(self, s):
        where = '%s section %s' % (self.where, s)
        if s not in SECTIONS[self.h]:
            raise RoomError('%s: sections are %s (their mirrors come from the transforms)' % (where, sorted(GROUP_OF)))
        area, rails, doors = SECTIONS[self.h][s]
        if any(overlap(c, area) for c in self.cuts):
            raise RoomError('%s: a cut is inside the section area %s' % (where, area))
        missing = [p for p in doors if p not in self.doors]
        if missing:
            raise RoomError('%s: the section needs doors %s' % (where, missing))
        g = GROUP_OF[s]
        self.split_ids[g] = s
        self.add('SectionArea', None, area, group=g)
        blocked = Mask(self.h)
        for x, y, w, h, sb in rails:
            if self.blocked.any((x, y, w, h)):
                raise RoomError('%s: the rail at %d,%d %dx%d crosses water or spikes' % (where, x, y, w, h))
            self.add('SectionWalls', 'Rail', (x, y, w, h), {'SB': sb}, group=g)
            blocked.set((x - 8, y - 8, w + 16, h + 16))
        for z in self.zones:
            if not overlap(z, area):
                self.add('Zones', None, z, group=g)
        for layer, items in (self.d.get('objects') or {}).items():
            for it in items:
                box = tuple(it[:4])
                if not blocked.any(box):
                    self.add(layer, LAYER_GID.get(layer), box, it[4] if len(it) > 4 else {}, group=g)
        if self.d.get('furnish', True):
            enemies = Mask(self.h)
            enemies.set(area)
            self.furnish(g, blocked)
            # the enemy area is the largest free box outside the section, recomputed
            self.groups[g]['Enemies'] = []
            walk = self.floor.minus(self.blocked).minus(blocked).minus(enemies)
            big = walk.largest()
            if big:
                self.add('Enemies', None, (big[0] + 8, big[1] + 8, max(8, big[2] - 16), max(8, big[3] - 16)), group=g)
            if not any(inside(sp, area) for sp in self.spots):
                inner = self.floor.minus(blocked)
                cx, cy = area[0] + area[2] // 2 - 8, area[1] + area[3] // 2 - 8
                cands = sorted(((x, y) for y in range(area[1], area[1] + area[3] - 15, GRID)
                                for x in range(area[0], area[0] + area[2] - 15, GRID)
                                if inner.all((x, y, 16, 16)) and not self.lanes.any((x, y, 16, 16))),
                               key=lambda p: abs(p[0] - cx) + abs(p[1] - cy))
                if not cands:
                    raise RoomError('%s: no room for a treasure inside the section' % where)
                sp = cands[0] + (16, 16)
                self.add('Treasures', 'Treasure', sp, group=g)
                self.add('Crystals', 'Crystal', sp, group=g)

    def is_symmetric(self):
        def norm(boxes):
            return sorted(tuple(b) for b in boxes)
        d = self.d
        for key in ('cut', 'water', 'spikes', 'zones'):
            boxes = d.get(key, [])
            if norm(boxes) != norm(mirror(b) for b in boxes):
                return False
        for layer, items in (d.get('objects') or {}).items():
            boxes = [it[:4] for it in items]
            if norm(boxes) != norm(mirror(b) for b in boxes):
                return False
        boxes = [b for _, b in self.doors.values()]
        return norm(boxes) == norm(mirror(b) for b in boxes)


# ---------------------------------------------------------------- the Tiled map

def layer_names(cls):
    return convert.OBJ_TYPES[cls], convert.SECTION_OBJ_TYPES[cls]


def build_map(cls, halves):
    """A Tiled map like data/room-templates/Room Templates <Class>.json, with the halves side by side."""
    obj_types, sec_types = layer_names(cls)
    ids = {'obj': 1, 'layer': 1}

    def next_id(kind):
        ids[kind] += 1
        return ids[kind] - 1

    def obj(gid, box, props, room_id, obj_type='', ox=0):
        o = {'height': box[3], 'id': next_id('obj'), 'name': '', 'properties': [], 'rotation': 0, 'type': obj_type,
             'visible': True, 'width': box[2], 'x': box[0] + ox, 'y': box[1]}
        if gid is not None:
            o['gid'] = G[gid] if isinstance(gid, str) else gid
        for k, v in sorted(props.items()):
            o['properties'].append({'name': k, 'type': 'string' if isinstance(v, str) else 'int', 'value': v})
        o['properties'].append({'name': 'Room', 'type': 'object', 'value': room_id})
        o['properties'].sort(key=lambda p: p['name'])
        return o

    def objgroup(name, objects):
        return {'draworder': 'topdown', 'id': next_id('layer'), 'name': name, 'objects': objects, 'opacity': 1,
                'type': 'objectgroup', 'visible': True, 'x': 0, 'y': 0}

    rooms, layers = [], {n: [] for n in obj_types}
    group_names = ['Main'] + (GROUPS if cls == 'Main_Upper' else [])
    sec_layers = {g: {n: [] for n in sec_types} for g in group_names}
    width = 0
    for i, half in enumerate(halves):
        ox = i * 288
        rid = next_id('obj')
        props = [{'name': 'Split_MainSectionIDs', 'type': 'string', 'value': ','.join(str(s) for s in half.split_ids)},
                 {'name': 'Symetry', 'type': 'int', 'value': 1 if half.symmetric else 0}]
        for k, v in sorted((half.d.get('props') or {}).items()):
            props.append({'name': k, 'type': 'string' if isinstance(v, str) else 'int', 'value': v})
        props.sort(key=lambda p: p['name'])
        rooms.append({'height': half.h, 'id': rid, 'name': half.name, 'properties': props, 'rotation': 0, 'type': '',
                      'visible': True, 'width': 256, 'x': ox, 'y': 0})
        for layer, items in half.layers.items():
            for gid, box, p, ot in items:
                layers[layer].append(obj(gid, box, p, rid, ot, ox))
        for g, content in [('main', half.groups.get('main', {}))] + sorted(
                (k, v) for k, v in half.groups.items() if k != 'main'):
            gname = 'Main' if g == 'main' else GROUPS[g]
            for layer, items in content.items():
                if layer not in sec_layers[gname]:
                    raise RoomError('%s: %s has no layer %s in a section' % (half.where, cls, layer))
                for gid, box, p, ot in items:
                    sec_layers[gname][layer].append(obj(gid, box, p, rid, ot, ox))
        width = ox + 256
    for layer in layers:
        layers[layer].sort(key=lambda o: o['id'])
    out = [objgroup('Rooms', rooms)] + [objgroup(n, layers[n]) for n in obj_types]
    groups = []
    for g in group_names:
        groups.append({'id': next_id('layer'), 'layers': [objgroup(n, sec_layers[g][n]) for n in sec_types],
                       'name': g, 'opacity': 1, 'type': 'group', 'visible': True, 'x': 0, 'y': 0})
    out.append({'id': next_id('layer'), 'layers': groups, 'name': 'Sections', 'opacity': 1, 'type': 'group',
                'visible': True, 'x': 0, 'y': 0})
    height = max(h.h for h in halves)
    return {'compressionlevel': -1, 'editorsettings': {'export': {'format': 'json'}}, 'height': height // GRID,
            'infinite': False, 'layers': out, 'nextlayerid': ids['layer'], 'nextobjectid': ids['obj'],
            'orientation': 'orthogonal', 'properties': [{'name': 'Generator', 'type': 'string', 'value': GENERATOR}],
            'renderorder': 'right-down', 'tiledversion': '1.10.1', 'tileheight': GRID,
            'tilesets': [{'firstgid': 1, 'source': '../../RoomTemplateTileset.json'}], 'tilewidth': GRID,
            'type': 'map', 'version': '1.10', 'width': width // GRID}


def generated(path):
    try:
        m = json.load(open(path, encoding='utf-8'))
    except (OSError, ValueError):
        return False
    return any(p.get('name') == 'Generator' and p.get('value') == GENERATOR for p in m.get('properties', []))


# ---------------------------------------------------------------- a set

def load_set(name):
    path = os.path.join(convert.SETS_DIR, name, 'rooms.json')
    if not os.path.exists(path):
        raise RoomError('%s not found' % os.path.relpath(path, convert.REPO))
    try:
        d = json.load(open(path, encoding='utf-8'))
    except ValueError as e:
        raise RoomError('%s: %s' % (os.path.relpath(path, convert.REPO), e))
    halves = []
    names = set()
    for i, h in enumerate(d.get('halves', [])):
        where = '%s half %d (%s)' % (name, i, h.get('name', '?'))
        if h.get('name') in names:
            raise RoomError('%s: the name is used twice' % where)
        names.add(h.get('name'))
        halves.append(Half(h, where))
    if not halves:
        raise RoomError('%s: rooms.json has no "halves"' % name)
    return halves


def check_converted(name, by_class, warnings):
    """Converts the set's maps like convert.py and returns lines that describe the rooms they make."""
    lines = []
    ci_of = {c[0]: i for i, c in enumerate(convert.CLASSES)}
    for cls in sorted(by_class):
        subclasses = convert.parse_class(ci_of[cls], warnings, name)
        for si, sub in enumerate(subclasses):
            if not sub:
                continue
            union = 0
            for t in sub:
                union |= int(t['DoorCode'][0])
            doors = [p + 1 for p in range(24) if union & (1 << p)]
            sections = sorted({int(s) for t in sub for s in t['Split_MainSectionIDs'] if s})
            lines.append('  %s %s: %d rooms from %d halves; doors %s; sections %s'
                         % (cls, ['1x1', '1x2'][si], len(sub), len([h for h in by_class[cls] if h.size_index == si]),
                            ','.join(map(str, doors)), ','.join(map(str, sections)) or 'none'))
    return lines


def make(name, dry_run=False):
    halves = load_set(name)
    by_class = {}
    for h in halves:
        by_class.setdefault(h.cls, []).append(h)
    folder = os.path.join(convert.SETS_DIR, name)
    ci_of = {c[0]: i for i, c in enumerate(convert.CLASSES)}
    written = []
    for cls, hs in sorted(by_class.items()):
        path = convert.map_path(ci_of[cls], name)
        if os.path.exists(path) and not generated(path):
            raise RoomError('%s was not written by this script (drawn in Tiled?); not overwriting it'
                            % os.path.relpath(path, convert.REPO))
        text = json.dumps(build_map(cls, hs), indent=1) + '\n'
        if not dry_run:
            old = open(path, encoding='utf-8').read() if os.path.exists(path) else None
            if old != text:
                with open(path, 'w', encoding='utf-8', newline='\n') as f:
                    f.write(text)
                written.append(os.path.relpath(path, convert.REPO).replace(os.sep, '/'))
    # maps of classes the description no longer has
    for ci, (cls, _, _, _) in enumerate(convert.CLASSES):
        path = convert.map_path(ci, name)
        if cls not in by_class and os.path.exists(path) and generated(path) and not dry_run:
            os.remove(path)
            written.append('removed ' + os.path.relpath(path, convert.REPO).replace(os.sep, '/'))
    if dry_run:
        return halves, written, [], []
    warnings = []
    lines = check_converted(name, by_class, warnings)
    return halves, written, lines, warnings


# Shared templates the outline model is checked against (--selftest): Tiled room id, class, the description that
# should give the same walls, OutOfBounds, LowerFloor (by cells) and SplitConnections
SELFTEST = [
    (663, 'Main_Upper', {}),
    (11139, 'Main_Upper', {'cut': [[16, 16, 48, 48], [192, 16, 48, 48]]}),
    (11113, 'Main_Upper', {'cut': [[192, 16, 48, 56]]}),
    (32618, 'Main_Upper', {'cut': [[16, 16, 224, 40]]}),
    (11102, 'Main_Lower', {}),
    (40406, 'Main_Lower', {'cut': [[40, 40, 176, 32]]}),
    (33044, 'Main_Lower', {'cut': [[160, 40, 56, 24]]}),
    (40419, 'Main_Lower', {'cut': [[40, 40, 32, 32], [184, 40, 32, 32]]}),
    (42882, 'Main_Lower', {'size': '1x2', 'cut': [[40, 40, 176, 32], [40, 184, 32, 72], [184, 184, 32, 72]]}),
    (40295, 'Main_Lower', {'size': '1x2'}),
]


def selftest():
    """Builds the SELFTEST halves and compares them with the shared Tiled maps. Returns the differences."""
    names = {v: k for k, v in G.items()}
    layers = ['WallsUpper', 'WallsLower', 'SplitConnections', 'OutOfBounds', 'LowerFloor', 'Doors']
    maps, out = {}, []

    def cells(boxes):
        return {(x, y) for b in boxes for x in range(b[1], b[1] + b[3], GRID) for y in range(b[2], b[2] + b[4], GRID)}
    for rid, cls, d in SELFTEST:
        ci = [c[0] for c in convert.CLASSES].index(cls)
        if cls not in maps:
            maps[cls] = json.load(open(convert.map_path(ci), encoding='utf-8'))
        m = maps[cls]
        room = [o for o in m['layers'][0]['objects'] if o['id'] == rid][0]
        real = {n: set() for n in layers}
        for layer in m['layers']:
            if layer['name'] in real:
                for o in layer['objects']:
                    if any(p['name'] == 'Room' and p['value'] == rid for p in o['properties']):
                        real[layer['name']].add((names.get(o.get('gid')), o['x'] - room['x'], o['y'] - room['y'],
                                                 o['width'], o['height']))
        half = Half(dict(d, name=str(rid), **{'class': cls}), 'selftest %d' % rid)
        mine = {n: set() for n in layers}
        for layer, items in half.layers.items():
            if layer in mine:
                for gid, box, _, _ in items:
                    mine[layer].add(((names.get(gid) if isinstance(gid, int) else gid),) + box)
        for n in layers:
            same = cells(real[n]) == cells(mine[n]) if n == 'LowerFloor' else real[n] == mine[n]
            if not same:
                out.append('%d %s: shared only %s, helper only %s'
                           % (rid, n, sorted(real[n] - mine[n]), sorted(mine[n] - real[n])))
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('set', nargs='?', help='room set: data/room-templates/sets/<set>/rooms.json')
    ap.add_argument('--dry-run', action='store_true', help='check the description, write nothing')
    ap.add_argument('--list', action='store_true', help='list the sets that have a description')
    ap.add_argument('--selftest', action='store_true', help='compare the outline model with shared templates')
    a = ap.parse_args()
    if a.selftest:
        diffs = selftest()
        for line in diffs:
            print(line)
        print('selftest: %d shared templates, %s' % (len(SELFTEST), 'SAME' if not diffs else '%d differences' % len(diffs)))
        return 1 if diffs else 0
    if a.list or not a.set:
        if os.path.isdir(convert.SETS_DIR):
            for n in sorted(os.listdir(convert.SETS_DIR)):
                if os.path.exists(os.path.join(convert.SETS_DIR, n, 'rooms.json')):
                    try:
                        hs = load_set(n)
                        print('%s: %s' % (n, ', '.join('%s (%s %s%s)' % (h.name, h.cls, ['1x1', '1x2'][h.size_index],
                              ', sections ' + ','.join(str(s) for s in h.split_ids if s) if any(h.split_ids) else '')
                              for h in hs)))
                    except RoomError as e:
                        print('%s: error: %s' % (n, e))
        return 0
    try:
        halves, written, lines, warnings = make(a.set, a.dry_run)
        if a.dry_run:
            print('%s: %d halves ok (dry run, nothing written)' % (a.set, len(halves)))
            return 0
    except (RoomError, convert.ConvertError) as e:
        print('error:', e)
        return 1
    for w in warnings:
        print('warning:', w)
    for f in written:
        print('wrote' if not f.startswith('removed') else '', f)
    print('%s: %d halves' % (a.set, len(halves)))
    for line in lines:
        print(line)
    print('next: python tools/templates/convert.py (writes game/datafiles/data/rooms/sets/%s)' % a.set)
    return 0


if __name__ == '__main__':
    sys.exit(main())
