"""Room template helper (roadmap F11): writes the Tiled maps of a room set from a short description.

The Main_Upper and Main_Lower templates are half rooms with walls, doors, sections, zones and SplitConnections,
which convert.py joins into whole rooms. Drawing them takes the Tiled editor; this script writes them from
data/room-templates/sets/<Set>/rooms.json instead, so a region can get its own rooms without Tiled:

    python tools/templates/make_rooms.py Example            # writes the set's maps, converts and checks them
    python tools/templates/make_rooms.py Example --dry-run  # checks only, writes nothing
    python tools/templates/make_rooms.py --list             # sets and what each description makes
    python tools/templates/make_rooms.py Example --map      # each half as text: walls, door lanes, the composed motifs
    python tools/templates/make_rooms.py CastleTop --png out.png   # painted rooms drawn, closed and open (Pillow)
    python tools/templates/make_rooms.py --selftest         # outlines against shared templates, loose compositions refused

Then python tools/templates/convert.py writes the game files (the script says so). A map the script did not write
(a set drawn in Tiled) is never overwritten. Description format: tools/README.md ("templates/") and the example
set data/room-templates/sets/Example/rooms.json. Everything is in pixels of the half room, on an 8 px grid.

Each half gets, from its outline: the walls (corner, inner corner and side pieces traced around the outline,
24 px thick; in Main_Lower the outline is the lower floor and the upper walls go around it 24 px out),
OutOfBounds over the cut corners, the doors on the wall pieces, the SplitConnections at the side
walls on the cut line and, unless "furnish" is false, its composition (roadmap F11b): the decoration and the spots
the generator places special objects on come from the motifs of data/room-templates/motifs.json (motifs.py
measures them in the shared templates). The half names the motifs that make its function ("motifs"); every other
layer of DEFAULT_LAYERS takes its most used motif. Each motif is placed by its anchor (top corners, top wall,
middle axis, side walls, a lattice, an area) at the catalog's sizes, insets and steps, in mirrored pairs, off the
door lanes where the game does not check them; furniture first, then water and spikes around it, then the spots and
areas. Each section it can host (1 corner, 2 middle, 9 wide, 17 strip; their mirrors come from the game's
transforms) gets its area, its rails and the same composition with the rails in the way, plus a treasure and a
crystal spot inside the section. Then motifs.check_half refuses a loose composition: a piece no motif explains, a
mirrored layer without its pair, pieces that never touch touching, a piece on a lane it must keep off, solid pieces
cutting two doors apart.

Standard library only.
"""
import argparse
import collections
import copy
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import convert  # noqa: E402
import motifs as mt  # noqa: E402
import paint_rooms  # noqa: E402

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
             'motifs', 'props', 'comment'}
MOTIF_KEYS = {'motif', 'size', 'inset', 'step', 'within'}
# Composition (F11b): the layers every half gets unless "furnish" is false (each with the catalog's most used motif,
# replaced by the description's own "motifs" for that layer), and the order they are placed in: furniture first,
# then water and spikes around it, then the spots and the areas
DEFAULT_LAYERS = ['Torches', 'Monuments', 'Pots', 'PotTreasures', 'Treasures', 'Crystals', 'CarpetsFull', 'Enemies']
ORDER = ['Torches', 'Monuments', 'Altars', 'Kinstones', 'Pots', 'PotTreasures', 'GuruBars', 'MovingSpikeBlocks',
         'Water', 'Spikes', 'Treasures', 'Crystals', 'CarpetsFull', 'Enemies']
TOP_LEVEL = {'Water', 'Spikes', 'CarpetsFull'}
FURNITURE = {'Torches', 'Monuments', 'Altars', 'Kinstones', 'Pots', 'PotTreasures'}   # what water and spikes avoid      # layers of the map's top level (not of a section group)
LAYER_GID = {'Torches': 'Torch', 'Treasures': 'Treasure', 'Crystals': 'Crystal', 'Pots': 'Pot',
             'PotTreasures': 'PotOrTreasure', 'Monuments': 'Monument', 'Kinstones': 'Kinstone', 'Altars': 'Altar',
             'GuruBars': 'GuruBar', 'Water': 'Water', 'Spikes': 'SpikeFloor', 'CarpetsFull': 'Carpet_Full',
             'MovingSpikeBlocks': 'SpikeBlock'}


class RoomError(Exception):
    pass


_CATALOG = []


def catalog():
    """The composition motifs (data/room-templates/motifs.json, written by motifs.py)."""
    if not _CATALOG:
        cat = mt.load_catalog()
        if cat is None:
            raise RoomError('%s is missing: run python %s' % (os.path.relpath(mt.CATALOG, convert.REPO), mt.GENERATOR))
        _CATALOG.append(cat)
    return _CATALOG[0]


def lane_box(loc, box):
    """The 32x32 square inside a door that stays free."""
    x, y = box[0], box[1]
    return {'Top': (x, y + 24, 32, 32), 'Left': (x + 24, y, 32, 32), 'Right': (x - 32, y, 32, 32)}[loc]


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
            self.lanes.set(lane_box(loc, box))
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

        # composition (F11b): the motifs of the catalog, placed by their anchors
        self.fl = mt.Floor(h, [(x, y) for y in range(self.floor.h) for x in range(self.floor.w) if self.floor.c[y][x]],
                           [box for _, box in self.doors.values()])
        self.specs = self.motif_specs() if d.get('furnish', True) else []
        sections = d.get('sections', [])
        if sections and cls != 'Main_Upper':
            raise RoomError('%s: only Main_Upper halves have sections' % where)
        rails = Mask(h)
        for s in sections:
            if s in SECTIONS[self.h]:
                for x, y, w, hh, _ in SECTIONS[self.h][s][1]:
                    rails.set((x - 8, y - 8, w + 16, hh + 16))
        self.compose('main', Mask(h), FURNITURE)          # furniture, then water and spikes around it, then the rest
        self.compose(None, rails)
        if not self.zones:
            self.check_connected(where)
        self.compose('main', Mask(h), set(ORDER) - FURNITURE)
        for s in sections:
            self.section(s)
        self.check_composition()

        self.symmetric = self.is_symmetric()

    def check_connected(self, where):
        """Without zones, every door must reach every bit of floor (water in the way needs zones)."""
        if not self.connected(self.blocked):
            walk = self.floor.minus(self.blocked)
            raise RoomError('%s: water splits the floor (%d cells cannot be reached from the doors); '
                            'give "zones" for the parts' % (where, sum(sum(r) for r in walk.c)))

    def connected(self, blocked):
        """Every bit of floor outside the blocked cells is reached from the doors."""
        walk = self.floor.minus(blocked)
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
        return len(seen) == sum(sum(r) for r in walk.c)

    # ------------------------------------------------------------ composition (F11b)

    def motif_specs(self):
        """The motifs of the half: the catalog's most used motif of each DEFAULT_LAYERS layer, with the layers the
        description's "motifs" names replaced by its own entries. Returns [(layer, anchor, spec, where)] in ORDER."""
        motifs = catalog()['classes'][self.cls]['layers']
        own = []
        for i, spec in enumerate(self.d.get('motifs', [])):
            where = '%s motifs[%d]' % (self.where, i)
            if isinstance(spec, str):
                spec = {'motif': spec}
            if not isinstance(spec, dict) or set(spec) - MOTIF_KEYS or 'motif' not in spec:
                raise RoomError('%s: %r should be "Layer/anchor" or {"motif": "Layer/anchor", %s}'
                                % (where, spec, ', '.join('"%s": ...' % k for k in sorted(MOTIF_KEYS - {'motif'}))))
            layer, _, anchor = str(spec['motif']).partition('/')
            if layer not in motifs or anchor not in motifs[layer]['motifs']:
                known = ['%s/%s' % (n, a) for n, e in sorted(motifs.items()) for a in sorted(e['motifs'])
                         if n in LAYER_GID or n == 'Enemies']
                raise RoomError('%s: "%s" is not a motif of %s; the catalog has %s'
                                % (where, spec['motif'], self.cls, ', '.join(known)))
            if layer not in LAYER_GID and layer != 'Enemies':
                raise RoomError('%s: the helper does not write the layer %s' % (where, layer))
            own.append((layer, anchor, spec, where))
        named = {layer for layer, _, _, _ in own}
        out = []
        for layer in DEFAULT_LAYERS:
            e = motifs.get(layer)
            if layer in named or not e or not e['motifs']:
                continue
            anchor = max(sorted(e['motifs']), key=lambda a: e['motifs'][a]['halves'])
            out.append((layer, anchor, {'motif': layer + '/' + anchor, 'default': True},
                        '%s default %s' % (self.where, layer)))
        out += own
        out.sort(key=lambda s: ORDER.index(s[0]))
        return out

    def options(self, layer, anchor, spec, where):
        """Size, inset, steps and props of a motif entry, checked against the catalog."""
        m = catalog()['classes'][self.cls]['layers'][layer]['motifs'][anchor]
        if m.get('rotation'):
            raise RoomError('%s: %s/%s pieces are rotated in the shared templates; the helper does not write '
                            'rotated pieces' % (where, layer, anchor))
        if anchor == 'area':
            return None, None, None
        sizes = [tuple(s[:2]) for s in m['sizes']]
        size = tuple(spec.get('size', sizes[0]))
        if size not in sizes:
            raise RoomError('%s: %s/%s sizes are %s' % (where, layer, anchor, ', '.join('%dx%d' % s for s in sizes)))
        insets = [tuple(i[:2]) for i in m['insets']]
        inset = tuple(spec.get('inset', insets[0]))
        if inset not in insets:
            raise RoomError('%s: %s/%s insets [side, top] are %s' % (where, layer, anchor, [list(i) for i in insets]))
        steps = [(s[1], s[2]) for s in m.get('steps', []) if tuple(s[0]) == size]
        step = tuple(spec.get('step', steps[0] if steps else (size[0], size[1])))
        if 'step' in spec and step not in steps + [size]:
            raise RoomError('%s: %s/%s %dx%d steps [x, y] are %s' % (where, layer, anchor, size[0], size[1],
                                                                       [list(s) for s in steps + [size]]))
        return size, inset, step

    def candidates(self, layer, anchor, spec, where):
        """Boxes of one motif entry: every position whose anchor and insets are the motif's, in lines and lattices
        stepped like the shared templates."""
        size, inset, step = self.options(layer, anchor, spec, where)
        w, hh = size
        sx, sy = step[0] or w, step[1] or hh
        within = rect(spec['within'], where + ' within') if 'within' in spec else None
        fl = self.fl
        found = []
        for y in range(0, self.h - hh + 1, GRID):
            for x in range(0, 256 - w + 1, GRID):
                b = (x, y, w, hh)
                if not fl.all(b) or (within and not inside(b, within)):
                    continue
                a, ins = mt.classify(fl, b)
                if a == anchor:
                    found.append((b, ins))
        out = []
        if anchor in ('corner', 'top', 'top_center'):
            out = [b for b, ins in found if ins == inset or (anchor == 'top_center' and ins[1] == inset[1])]
        elif anchor in ('side', 'axis'):
            # a line down the wall or the axis: from the inset (or the topmost far spot) every sy px
            cols = {}
            for b, ins in found:
                if ins[0] == inset[0] or anchor == 'axis':
                    cols.setdefault(b[0], []).append((b, ins))
            for x, col in sorted(cols.items()):
                # from the inset (a far inset, or any inset in a within box: the first spot at least that far)
                start = [b for b, ins in col if (ins[1] == inset[1] if inset[1] < mt.FAR and not within
                                                 else ins[1] >= inset[1])]
                if not start:
                    continue
                y0 = start[0][1]
                out += [b for b, ins in col if b[1] >= y0 and (b[1] - y0) % sy == 0
                        and (anchor == 'axis' or 'step' in spec or b[1] == y0 or inset[1] >= mt.FAR)]
        elif anchor == 'field':
            margin = min(inset)
            top = within[1] if within else fl.box[1] + margin     # rows from the floor top, or the within box
            off = 0 if mt.phase((128 - w // 2, 0, w, hh), sx) == 'center' else sx // 2
            phases = [p[2] for p in catalog()['classes'][self.cls]['layers'][layer]['motifs'][anchor].get('phase', [])
                      if tuple(p[0]) == size and p[1] == sx]
            if phases and phases[0] == 'straddle':
                off = sx // 2
            elif phases and phases[0] == 'center':
                off = 0
            for b, ins in found:
                cx = b[0] + w // 2 - 128
                if min(ins) >= margin and (cx - off) % sx == 0 and (b[1] - top) % sy == 0:
                    out.append(b)
        return out

    def compose(self, group, extra, only=None):
        """Places the motifs of one section group (group None: the top level layers, water, spikes and carpets).
        extra: cells nothing may cover (a section's rails); only: the layers to place (default all)."""
        top = group is None
        avoid = Mask(self.h)                      # what furniture and spots keep off: water and spikes
        furniture = Mask(self.h)                  # what water and spikes keep off
        for layer, items in self.layers.items():
            if layer in ('Water', 'Spikes'):
                for _, b, _, _ in items:
                    avoid.set(b)
        if top:                                   # the main group's furniture is placed already
            for layer, items in self.groups.get('main', {}).items():
                if layer in FURNITURE:
                    for _, b, _, _ in items:
                        furniture.set(b)
        for layer, anchor, spec, where in self.specs:
            if (layer in TOP_LEVEL) != top or (only is not None and layer not in only):
                continue
            if anchor == 'area':
                self.area(layer, group, extra, avoid)
                continue
            motifs = catalog()['classes'][self.cls]['layers'][layer]['motifs']
            # a default layer falls back on its next most used motif when this one finds no place
            tries = [anchor] if not spec.get('default') else sorted(
                (a for a in motifs if a != 'area' and not motifs[a].get('rotation')), key=lambda a: -motifs[a]['halves'])
            for a in tries:
                spec = dict(spec, motif=layer + '/' + a)
                if self.place(layer, a, spec, where, group, extra, avoid, furniture):
                    break
            else:
                if group in (None, 'main') and not (spec.get('default') and layer != 'Treasures'):
                    raise RoomError('%s: %s/%s finds no place in this half' % (where, layer, anchor))

    def place(self, layer, anchor, spec, where, group, extra, avoid, furniture):
        """Places one motif entry; returns how many pieces it placed."""
        motifs, _, lane_free, apart = mt.rules(catalog(), self.cls, layer)
        m = motifs[anchor]
        props_of = {tuple(p[0]): p[1] for p in reversed(m.get('props', []))}
        keep = []
        try:
            cands = self.candidates(layer, anchor, {k: v for k, v in spec.items() if k != 'default'}, where)
        except RoomError:
            if spec.get('default'):
                return 0
            raise
        for b in cands:
            if extra.any(b) or (lane_free and self.lanes.any(b)):
                continue
            if layer in ('Water', 'Spikes'):
                if furniture.any(b) or self.blocked.any(b):
                    continue
            elif avoid.any(b):
                continue
            keep.append(b)
        kept = set(keep)
        # a piece whose mirror spot is floor goes only with its mirror (in every layer: the check only asks it of
        # the layers the shared templates mirror, but a composed room is kept symmetric)
        keep = [b for b in keep if 2 * b[0] + b[2] == 256 or mirror(b) in kept
                or not self.fl.all(mt.clip(self.fl, mirror(b))) or extra.any(mirror(b))]
        have = [b for _, b, _, _ in (self.layers if group is None else self.groups.get(group, {})).get(layer, [])]
        placed = []
        for b in keep:
            if b in placed:
                continue
            pair = [b] if 2 * b[0] + b[2] == 256 or mirror(b) not in kept else [b, mirror(b)]
            if apart and mt.touching(have + placed + pair)[0]:
                continue
            if layer == 'Water' and not self.zones:     # water must not split the floor (no zones)
                test = Mask(self.h)
                test.c = [row[:] for row in self.blocked.c]
                for p in pair:
                    test.set(p)
                if not self.connected(test):
                    continue
            for p in pair:
                placed.append(p)
                props = props_of.get(p[2:], {})
                if 2 * p[0] + p[2] > 256:
                    props = mt.mirror_props(props)
                self.add(layer, LAYER_GID[layer], p, props, group=group)
                if layer in ('Water', 'Spikes'):
                    avoid.set(p)
                    if layer == 'Water':
                        self.blocked.set(p)
                else:
                    furniture.set(p)
        return len(placed)

    def area(self, layer, group, extra, avoid):
        """Enemy area (largest free box) or full carpet (the floor box), inset like the shared templates."""
        insets = catalog()['classes'][self.cls]['layers'][layer]['motifs']['area']['insets']
        left = collections.Counter()
        topc = collections.Counter()
        for i in insets:
            left[min(i[0], i[2])] += i[-1]
            topc[i[1]] += i[-1]
        side = left.most_common(1)[0][0]
        top = min(t for t in topc if t <= side) if any(t <= side for t in topc) else topc.most_common(1)[0][0]
        # a full carpet is drawn only in a room without a section (Dungeon_Draw_CarpetsFull): rails do not matter
        walk = self.floor if layer == 'CarpetsFull' else self.floor.minus(self.blocked).minus(extra).minus(avoid)
        big = walk.largest()
        if not big:
            return
        # the catalog's inset, or 8 px when that leaves nothing (a section's rails can leave a narrow free box, and
        # every section group of the shared templates has an enemy area)
        for side, top in ((side, top), (8, 8)):
            bottom = 0 if big[1] + big[3] >= self.h else top
            box = (big[0] + side, big[1] + top, big[2] - 2 * side, big[3] - top - bottom)
            if box[2] > 0 and box[3] > 0:
                self.add(layer, LAYER_GID.get(layer), box, group=group)
                return

    def check_composition(self):
        """The composition check of motifs.py on every section group, with the top level layers in each."""
        top = {layer: [b for _, b, _, _ in items] for layer, items in self.layers.items() if layer in mt.PIECES}
        problems = []
        for g, content in sorted(self.groups.items(), key=lambda kv: str(kv[0])):
            layers = dict(top)
            for layer, items in content.items():
                layers[layer] = layers.get(layer, []) + [b for _, b, _, _ in items]
            rails = [(b[0] - 8, b[1] - 8, b[2] + 16, b[3] + 16) for _, b, _, _ in content.get('SectionWalls', [])]
            where = '%s (%s)' % (self.where, 'main' if g == 'main' else 'section ' + GROUPS[g])
            problems += mt.check_half(catalog(), self.cls, self.fl, layers, where, rails)
        if problems:
            raise RoomError('loose composition:\n  ' + '\n  '.join(problems))

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
        if self.specs:
            self.compose(g, blocked)
            # the enemy area is the largest free box outside the section, and the section holds a treasure spot
            layers = [layer for layer, _, _, _ in self.specs]
            self.groups[g]['Enemies'] = []
            if 'Enemies' in layers:
                outside = Mask(self.h)
                outside.c = [row[:] for row in blocked.c]
                outside.set(area)
                self.area('Enemies', g, outside, Mask(self.h))
            for layer in ('Treasures', 'Crystals'):
                if layer in layers and not any(inside(b, area) for _, b, _, _ in self.groups[g].get(layer, [])):
                    self.spot_in(layer, g, area, blocked, where)

    def spot_in(self, layer, g, area, blocked, where):
        """A spot of a layer inside a section area (and its mirror), from the layer's motifs, nearest the middle."""
        m = catalog()['classes'][self.cls]['layers'][layer]['motifs']
        cx, cy = area[0] + area[2] // 2, area[1] + area[3] // 2
        best = None
        for anchor in sorted(m):
            for ins in m[anchor].get('insets', []):
                for st in [None] + [s[1:3] for s in m[anchor].get('steps', []) if s[0] == [16, 16]]:
                    spec = {'motif': layer + '/' + anchor, 'inset': ins[:2], 'within': list(area), 'size': [16, 16]}
                    if st:
                        spec['step'] = st
                    try:
                        cands = self.candidates(layer, anchor, spec, where)
                    except RoomError:
                        continue
                    for b in cands:
                        if blocked.any(b) or self.blocked.any(b):
                            continue
                        dist = abs(b[0] + 8 - cx) + abs(b[1] + 8 - cy)
                        if best is None or dist < best[0]:
                            best = (dist, b)
        if not best:
            raise RoomError('%s: no room for a %s spot inside the section' % (where, layer))
        b = best[1]
        self.add(layer, LAYER_GID[layer], b, group=g)
        mb = mirror(b)
        have = {x for _, x, _, _ in self.groups[g].get(layer, [])}
        if mt.rules(catalog(), self.cls, layer)[1] and mb not in have and self.fl.all(mb) and not blocked.any(mb):
            self.add(layer, LAYER_GID[layer], mb, group=g)

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
    offsets = []                        # x of each half in the map: side by side, 32 px apart
    for i, half in enumerate(halves):
        ox = width + 32 if i else 0
        offsets.append(ox)
        rid = next_id('obj')
        props = [{'name': 'Split_MainSectionIDs', 'type': 'string', 'value': ','.join(str(s) for s in half.split_ids)},
                 {'name': 'Symetry', 'type': 'int', 'value': 1 if half.symmetric else 0}]
        extra = half.room_props() if getattr(half, 'painted', False) else (half.d.get('props') or {})
        for k, v in sorted(extra.items()):
            props.append({'name': k, 'type': 'string' if isinstance(v, str) else 'int', 'value': v})
        props.sort(key=lambda p: p['name'])
        rooms.append({'height': half.h, 'id': rid, 'name': half.name, 'properties': props, 'rotation': 0,
                      'type': getattr(half, 'room_type', ''),
                      'visible': True, 'width': getattr(half, 'w', 256), 'x': ox, 'y': 0})
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
        width = ox + getattr(half, 'w', 256)
    for layer in layers:
        layers[layer].sort(key=lambda o: o['id'])
    out = [objgroup('Rooms', rooms)] + [objgroup(n, layers[n]) for n in obj_types]
    groups = []
    for g in group_names:
        groups.append({'id': next_id('layer'), 'layers': [objgroup(n, sec_layers[g][n]) for n in sec_types],
                       'name': g, 'opacity': 1, 'type': 'group', 'visible': True, 'x': 0, 'y': 0})
    if sec_types:                       # classes without sections (Special) have no Sections group
        out.append({'id': next_id('layer'), 'layers': groups, 'name': 'Sections', 'opacity': 1, 'type': 'group',
                    'visible': True, 'x': 0, 'y': 0})
    height = max(h.h for h in halves)
    tilesets = [{'firstgid': 1, 'source': '../../RoomTemplateTileset.json'}]
    painted = [(i, h) for i, h in enumerate(halves) if getattr(h, 'painted', False)]
    if painted:
        # the painted rooms' tiles (roadmap F12b): tile layers over the region tileset, after the object layers
        # (the converter reads the first layer as Rooms)
        kit = painted[0][1].kit
        firstgid = 1 + json.load(open(os.path.join(convert.TEMPLATE_DIR, 'RoomTemplateTileset.json'),
                                      encoding='utf-8'))['tilecount']
        firstgid = (firstgid + 999) // 1000 * 1000 + 1
        tilesets.append({'firstgid': firstgid, 'source': '../../tilesets/%s.json' % kit.name})
        mw, mh = width // GRID, height // GRID
        for name, attr in (('Region', 'base'), ('RegionOpen', 'open'), ('RegionGate', 'gate')):
            data = [0] * (mw * mh)
            for i, h in painted:
                for gy, row in enumerate(h.gids(getattr(h, attr), firstgid)):
                    for gx, v in enumerate(row):
                        data[gy * mw + offsets[i] // GRID + gx] = v
            out.append({'data': data, 'height': mh, 'id': next_id('layer'), 'name': name, 'opacity': 1,
                        'type': 'tilelayer', 'visible': True, 'width': mw, 'x': 0, 'y': 0})
    return {'compressionlevel': -1, 'editorsettings': {'export': {'format': 'json'}}, 'height': height // GRID,
            'infinite': False, 'layers': out, 'nextlayerid': ids['layer'], 'nextobjectid': ids['obj'],
            'orientation': 'orthogonal', 'properties': [{'name': 'Generator', 'type': 'string', 'value': GENERATOR}],
            'renderorder': 'right-down', 'tiledversion': '1.10.1', 'tileheight': GRID,
            'tilesets': tilesets, 'tilewidth': GRID,
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
    try:
        _, painted = paint_rooms.load(d, name)
    except paint_rooms.PaintError as e:
        raise RoomError(str(e))
    for p in painted:
        if p.name in names:
            raise RoomError('%s: the name %s is used twice' % (name, p.name))
        names.add(p.name)
    if not halves and not painted:
        raise RoomError('%s: rooms.json has no "halves" nor "painted" rooms' % name)
    return halves + painted


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
            names = convert.CLASSES[ci_of[cls]][3]
            if names:                   # classes picked by subclass (Special): the subclass, not the size
                lines.append('  %s %s: %d rooms; doors %s' % (cls, names[si], len(sub), ','.join(map(str, doors))))
                continue
            lines.append('  %s %s: %d rooms from %d halves and painted rooms; doors %s; sections %s'
                         % (cls, ['1x1', '1x2 and 2x1'][si], len(sub), len([h for h in by_class[cls] if min(h.size_index, 1) == si]),
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
    return out + selftest_composition()


# Loose compositions the check must refuse (F11b): the description and a bit of the message it must give. The
# first two are the F11 Example set's own pool and gallery statues.
NOTCHES = [[16, 16, 48, 48], [192, 16, 48, 48]]
SELFTEST_LOOSE = [
    ('pool of the old Notched half', {'cut': NOTCHES, 'water': [[104, 88, 48, 40]]}, 'loose piece'),
    ('statues in the middle of the old Gallery half',
     {'size': '1x2', 'objects': {'Monuments': [[64, 168, 32, 32], [160, 168, 32, 32]]}}, 'loose piece'),
    ('a lamp without its mirror', {'furnish': False, 'objects': {'Torches': [[40, 40, 16, 16]]}}, 'has no mirror'),
    ('water on a door lane', {'water': [[40, 112, 32, 32]]}, 'on a door lane'),
    ('statues touching', {'furnish': False, 'objects': {'Monuments': [[48, 48, 32, 32], [176, 48, 32, 32],
                                                                       [48, 80, 32, 32], [176, 80, 32, 32]]}},
     'touch each other'),
    ('water across the room', {'water': [[40, 64, 176, 32]]}, 'cut the door'),
]
COVERAGE_MIN = 0.9      # the motifs must explain this share of the shared templates' pieces


def selftest_composition():
    """The catalog is what the templates give, explains most of their pieces, and loose compositions are refused."""
    out = []
    cat = mt.build_catalog()
    if mt.load_catalog() != json.loads(mt.catalog_text(cat)):
        out.append('%s is out of date: run python %s' % (os.path.relpath(mt.CATALOG, convert.REPO).replace(os.sep, '/'),
                                                        mt.GENERATOR))
        return out
    for cls in mt.CLASSES:
        ok, total, _ = mt.coverage(cat, cls)
        if ok < COVERAGE_MIN * total:
            out.append('motifs of %s explain only %d of %d shared pieces' % (cls, ok, total))
    for what, d, expect in SELFTEST_LOOSE:
        try:
            Half(dict(d, name='loose'), 'selftest ' + what)
            out.append('composition check: %s was not refused' % what)
        except RoomError as e:
            if expect not in str(e):
                out.append('composition check: %s gave "%s" (expected "%s")' % (what, e, expect))
    return out


# --map: one character per 8 px cell, later layers over earlier ones
MAP_CHARS = [('CarpetsFull', ','), ('Water', '~'), ('Spikes', '^'), ('Treasures', 't'), ('Crystals', 'c'),
             ('PotTreasures', 'q'), ('Pots', 'p'), ('Monuments', 'M'), ('Torches', 'T')]


def text_map(half):
    """The half's main composition as text: # wall or outside, . floor, o door lane, then MAP_CHARS."""
    g = [['.' if half.floor.get(x, y) else '#' for x in range(32)] for y in range(half.h // GRID)]
    for x, y in half.fl.lanes:
        if 0 <= y < len(g) and g[y][x] == '.':
            g[y][x] = 'o'
    items = dict(half.layers)
    for layer, it in half.groups.get('main', {}).items():
        items[layer] = items.get(layer, []) + it
    for layer, ch in MAP_CHARS:
        for _, b, _, _ in items.get(layer, []):
            for y in range(b[1] // GRID, min(len(g), (b[1] + b[3]) // GRID)):
                for x in range(b[0] // GRID, (b[0] + b[2]) // GRID):
                    if g[y][x] != '#':
                        g[y][x] = ch
    rows = [''.join(r) for r in g]
    while rows and set(rows[0]) == {'#'}:
        rows.pop(0)
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('set', nargs='?', help='room set: data/room-templates/sets/<set>/rooms.json')
    ap.add_argument('--dry-run', action='store_true', help='check the description, write nothing')
    ap.add_argument('--list', action='store_true', help='list the sets that have a description')
    ap.add_argument('--map', action='store_true', help='print each half as text (walls, lanes, motifs), write nothing')
    ap.add_argument('--png', metavar='FILE', help='draw the painted rooms of the set (closed and open) into FILE, write nothing')
    ap.add_argument('--selftest', action='store_true', help='compare the outline model with shared templates')
    a = ap.parse_args()
    if a.selftest:
        diffs = selftest()
        for line in diffs:
            print(line)
        print('selftest: %d shared templates and %d loose compositions, %s'
              % (len(SELFTEST), len(SELFTEST_LOOSE), 'SAME' if not diffs else '%d differences' % len(diffs)))
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
    if a.png:
        try:
            rooms = [h for h in load_set(a.set) if getattr(h, 'painted', False)]
        except RoomError as e:
            print('error:', e)
            return 1
        paint_rooms.render(rooms, a.png)
        print('%s: %d painted rooms drawn in %s' % (a.set, len(rooms), a.png))
        return 0
    if a.map:
        try:
            halves = load_set(a.set)
        except RoomError as e:
            print('error:', e)
            return 1
        for h in halves:
            print('%s (%s %s%s)' % (h.name, h.cls, ['1x1', '1x2'][h.size_index], ', painted' if getattr(h, 'painted', False) else ''))
            if getattr(h, 'painted', False):
                for row in paint_rooms.text_map(h).splitlines():
                    print('  ' + row)
                continue
            for row in text_map(h):
                print('  ' + row)
        print('# wall or outside, . floor, o door lane, ' + ', '.join('%s %s' % (c, n) for n, c in MAP_CHARS))
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
