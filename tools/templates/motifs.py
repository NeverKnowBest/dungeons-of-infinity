"""Room composition motifs (roadmap F11b): how the shared templates place decoration, measured from the data.

The Main_Upper and Main_Lower templates of the original DoI do not hold loose coordinates: each piece sits on an
anchor of the floor (a top corner, the top wall, the middle axis, a side wall, a lattice over the floor) at a few
fixed insets, and almost always with its mirror. This script measures that in data/room-templates/ and writes the
catalog data/room-templates/motifs.json, which make_rooms.py composes the halves of a room set from and checks them
against:

    python tools/templates/motifs.py            # writes the catalog (only when it changed) and a short summary
    python tools/templates/motifs.py --report   # every layer: anchors, sizes, insets, steps, mirror and lane shares
    python tools/templates/motifs.py --check    # exit 1 when the catalog is not what the templates give (validator)

Anchors (classify): corner (against the top wall and a side wall), top_center (against the top wall, on the axis),
top (against the top wall), side (against a side wall), axis (on the middle axis), field (anywhere else; measured
as a lattice: step, phase against the axis, margin from the walls) and area (the layers that hold one big box:
enemy areas, full carpets). A motif enters the catalog when MIN_HALVES halves of the class use it; its sizes,
insets and properties are the ones MIN_HALVES halves use, most frequent first. Per layer the catalog also keeps the
mirror share (pieces whose mirror spot is free floor and that have their mirror there) and the lane share (pieces
on a door lane); the composition check (check_half) turns them into rules: a layer that is mirrored in the shared
templates must be mirrored in a set, and a layer that never sits on a lane must not sit on one.

Standard library only.
"""
import argparse
import collections
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import convert  # noqa: E402

CATALOG = os.path.join(convert.TEMPLATE_DIR, 'motifs.json')
GENERATOR = 'tools/templates/motifs.py'
GRID = 8
CLASSES = ['Main_Upper', 'Main_Lower']
MIN_HALVES = 3          # a motif, size, inset or property value needs this many halves of the class
MIRROR_RULE = 0.75      # a layer whose mirror share is at least this must be mirrored
LANE_RULE = 0.05        # a layer whose lane share is at most this must keep off the lanes
APART_RULE = 0.01       # a layer whose pieces touch (or overlap) in at most this share of pairs keeps them apart
FAR = 64                # distances from 64 px on count as "far" (the piece is not held by that wall)
# Layers that hold pieces (placed by motifs) and layers that hold one area each
PIECES = ['Torches', 'Monuments', 'Pots', 'PotTreasures', 'Treasures', 'Crystals', 'Water', 'Spikes', 'Kinstones',
          'Altars', 'GuruBars', 'MovingSpikeBlocks']
AREAS = ['Enemies', 'CarpetsFull']
# Layers whose pieces stop Link: they must leave the doors connected (pots can be lifted, spikes walked over)
SOLID = ['Torches', 'Monuments', 'Water', 'Altars', 'Kinstones']
# Layers the game itself keeps off the doors in use (__Dungeon_Draw_SpecialObjs: SpawnObj, SpawnMonuments,
# SpawnSpikes, the kinstone, jail and altar spawns skip a piece next to an oDoor); the templates put them on every
# door slot's lane on purpose, so the lane rule only holds for the other layers
DOOR_CHECKED = ['Torches', 'Monuments', 'Pots', 'PotTreasures', 'Treasures', 'Crystals', 'Spikes', 'Kinstones',
                'Altars']
# how far from a door in use the game drops them (SpawnObj 16 px, monuments, spikes and altars 24, kinstones 32)
NEAR_DOOR = {'Monuments': 24, 'Spikes': 24, 'Altars': 24, 'Kinstones': 32}
MIRROR_PROP = {'SpawnDir': {'L': 'R', 'R': 'L'}}


# ---------------------------------------------------------------- geometry

class Floor:
    """Floor cells of a half (GRID px), with the doors (x, y, w, h) and their lanes."""

    def __init__(self, h, cells, doors=()):
        self.h = h
        self.cells = set(cells)
        self.doors = list(doors)
        self.lanes = set()
        for b in lane_boxes(self.doors):
            self.lanes |= box_cells(b)
        xs = [c[0] for c in self.cells] or [0]
        ys = [c[1] for c in self.cells] or [0]
        self.box = (min(xs) * GRID, min(ys) * GRID, (max(xs) + 1 - min(xs)) * GRID, (max(ys) + 1 - min(ys)) * GRID)

    def has(self, cx, cy):
        return (cx, cy) in self.cells

    def all(self, b):
        return box_cells(b) <= self.cells

    def run(self, b, dx, dy):
        """Free floor between the box and the nearest non-floor cell in a direction (min over the box's edge)."""
        x, y, w, h = b
        if dx:
            edge = [((x if dx < 0 else x + w - GRID) // GRID, cy) for cy in range(y // GRID, (y + h) // GRID)]
        else:
            edge = [(cx, (y if dy < 0 else y + h - GRID) // GRID) for cx in range(x // GRID, (x + w) // GRID)]
        best = FAR
        for cx, cy in edge:
            n = 0
            while n * GRID < FAR:
                cx, cy = cx + dx, cy + dy
                if cy * GRID >= self.h or not self.has(cx, cy):
                    break
                n += 1
            if dy > 0 and cy * GRID >= self.h:
                n = FAR // GRID     # the cut line is not a wall: the other half goes on
            best = min(best, n * GRID)
        return best


def box_cells(b):
    return {(cx, cy) for cy in range(b[1] // GRID, (b[1] + b[3] + GRID - 1) // GRID)
            for cx in range(b[0] // GRID, (b[0] + b[2] + GRID - 1) // GRID)}


def mirror(b):
    return (256 - b[0] - b[2],) + tuple(b[1:])


def mirror_props(props):
    out = dict(props)
    for k, table in MIRROR_PROP.items():
        if k in out:
            out[k] = table.get(out[k], out[k])
    return out


def lane_boxes(doors):
    """The 32x32 square inside each door that must stay free (doors as (x, y, w, h) boxes of the half)."""
    out = []
    for x, y, w, h in doors:
        if w == 32:                         # top door
            out.append((x, y + 24, 32, 32))
        elif x < 128:                       # left door
            out.append((x + 24, y, 32, 32))
        else:                               # right door
            out.append((x - 32, y, 32, 32))
    return out


def clip(floor, b):
    """The part of a box in the half (pieces may cross the cut line into the other half)."""
    return (b[0], b[1], b[2], min(b[3], floor.h - b[1]))


def classify(floor, b):
    """Anchor and insets of a piece: (anchor, (side inset, top inset))."""
    b = clip(floor, b)
    x, y, w, h = b
    d_top = floor.run(b, 0, -1)
    d_side = min(floor.run(b, -1, 0), floor.run(b, 1, 0))
    centered = 2 * x + w == 256
    top, side = d_top <= GRID, d_side <= GRID
    if top and side:
        anchor = 'corner'
    elif top and centered:
        anchor = 'top_center'
    elif top:
        anchor = 'top'
    elif side:
        anchor = 'side'
    elif centered:
        anchor = 'axis'
    else:
        anchor = 'field'
    return anchor, (d_side, d_top)


def area_inset(floor, b):
    """Insets of an area from the floor box: left, top, right, bottom ('cut' when it reaches the cut line)."""
    fx, fy, fw, fh = floor.box
    bottom = 'cut' if b[1] + b[3] >= floor.h else fy + fh - b[1] - b[3]
    return (b[0] - fx, b[1] - fy, fx + fw - b[0] - b[2], bottom)


# ---------------------------------------------------------------- shared templates

def walk(layers, prefix=''):
    for L in layers:
        if L['type'] == 'group':
            yield from walk(L['layers'], prefix + L['name'] + '/')
        else:
            yield prefix + L['name'], L


def shared_halves(cls):
    """Every half of a shared class: (id, height, Floor, {layer: [(box, props, rotation)]}, symmetry)."""
    ci = [c[0] for c in convert.CLASSES].index(cls)
    m = json.load(open(convert.map_path(ci), encoding='utf-8'))
    rooms, objs = {}, collections.defaultdict(lambda: collections.defaultdict(list))
    for name, L in walk(m['layers']):
        if name.startswith('Sections/') and not name.startswith('Sections/Main/'):
            continue
        name = name.split('/')[-1]
        for o in L.get('objects', []):
            if name == 'Rooms':
                rooms[o['id']] = o
                continue
            rid = convert.get_prop(o.get('properties'), 'Room')
            o = dict(o)
            rot = o.get('rotation', 0)
            convert.fix_obj_rotation(o)
            props = {p['name']: p['value'] for p in o.get('properties', []) if p['name'] != 'Room'}
            objs[rid][name].append(((int(o['x']), int(o['y']), int(o['width']), int(o['height'])), props, rot))
    out = []
    for rid, r in rooms.items():
        h = int(r['height'])
        rel = {n: [((b[0] - int(r['x']), b[1] - int(r['y']), b[2], b[3]), p, rot) for b, p, rot in L]
               for n, L in objs[rid].items()}
        if cls == 'Main_Upper':
            cells = box_cells((16, 16, 224, h - 16))
            for n in ('OutOfBounds', 'WallsUpper'):
                for b, _, _ in rel.get(n, []):
                    cells -= box_cells(b)
        else:
            cells = set()
            for b, _, _ in rel.get('LowerFloor', []):
                cells |= box_cells(b)
            for b, _, _ in rel.get('WallsLower', []):
                cells -= box_cells(b)
        cells = {c for c in cells if 0 <= c[1] * GRID < h}
        doors = [b for b, _, _ in rel.get('Doors', [])]
        sym = convert.get_prop(r.get('properties'), 'Symetry')
        out.append((rid, h, Floor(h, cells, doors), rel, sym))
    return out


# ---------------------------------------------------------------- the catalog

def lattice(boxes):
    """Step (x, y) and phase of same-size pieces: the smallest gap between neighbours in a row and in a column."""
    sx = sy = None
    rows, cols = collections.defaultdict(list), collections.defaultdict(list)
    for x, y, w, h in boxes:
        rows[y].append(x)
        cols[x].append(y)
    for line, best in ((rows, 'x'), (cols, 'y')):
        for vals in line.values():
            vals = sorted(set(vals))
            for a, b in zip(vals, vals[1:]):
                if best == 'x':
                    sx = b - a if sx is None else min(sx, b - a)
                else:
                    sy = b - a if sy is None else min(sy, b - a)
    return sx, sy


def phase(b, step):
    off = (2 * b[0] + b[2] - 256) // 2 % step
    return 'center' if off == 0 else ('straddle' if 2 * off == step else 'free')


def ranked(counter_of_halves, keyfn=lambda k: k):
    """Values used by MIN_HALVES halves, most used first: [[value..., halves]]."""
    out = [(k, len(v)) for k, v in counter_of_halves.items() if len(v) >= MIN_HALVES]
    out.sort(key=lambda kv: (-kv[1], str(kv[0])))
    return [list(keyfn(k)) + [n] for k, n in out]


def touching(boxes):
    """Pairs of pieces and the pairs that touch or overlap."""
    bs = sorted(set(boxes))
    pairs = touch = 0
    for i, a in enumerate(bs):
        for b in bs[i + 1:]:
            pairs += 1
            if a[0] <= b[0] + b[2] and b[0] <= a[0] + a[2] and a[1] <= b[1] + b[3] and b[1] <= a[1] + a[3]:
                touch += 1
    return touch, pairs


def measure(cls):
    halves = shared_halves(cls)
    layers = {}
    for layer in PIECES + AREAS:
        obs = collections.defaultdict(lambda: {'halves': set(), 'pieces': 0, 'sizes': collections.defaultdict(set),
                                               'insets': collections.defaultdict(set), 'props': collections.defaultdict(set),
                                               'rot': collections.defaultdict(set), 'steps': collections.defaultdict(set),
                                               'phase': collections.defaultdict(set), 'margin': collections.defaultdict(set),
                                               'examples': []})
        pieces = mirrored = mirror_free = on_lane = touch = pairs = 0
        used = 0
        for rid, h, floor, rel, sym in halves:
            items = rel.get(layer, [])
            if not items:
                continue
            used += 1
            boxes = {b for b, _, _ in items}
            if layer in AREAS:
                for b, _, _ in items:
                    o = obs['area']
                    o['halves'].add(rid)
                    o['pieces'] += 1
                    o['insets'][area_inset(floor, b)].add(rid)
                    if rid not in o['examples']:
                        o['examples'].append(rid)
                continue
            t, n = touching(boxes)
            touch += t
            pairs += n
            field = collections.defaultdict(list)
            for b, props, rot in items:
                pieces += 1
                anchor, inset = classify(floor, b)
                o = obs[anchor]
                o['halves'].add(rid)
                o['pieces'] += 1
                o['sizes'][b[2:]].add(rid)
                o['insets'][inset].add(rid)
                o['rot'][rot].add(rid)
                if rid not in o['examples']:
                    o['examples'].append(rid)
                if props and 2 * b[0] + b[2] <= 256:
                    o['props'][(b[2:], tuple(sorted(props.items())))].add(rid)
                if anchor in ('field', 'axis'):
                    field[(anchor, b[2:])].append(b)
                    o['margin'][min(inset)].add(rid)
                if box_cells(b) & floor.lanes:
                    on_lane += 1
                centered = 2 * b[0] + b[2] == 256
                if sym != 0 and not centered and floor.all(clip(floor, mirror(b))):
                    mirror_free += 1
                    if mirror(b) in boxes:
                        mirrored += 1
            for (anchor, size), bs in field.items():
                sx, sy = lattice(bs)
                o = obs[anchor]
                if anchor == 'field' and sx:
                    o['phase'][(size, sx, phase(bs[0], sx))].add(rid)
                if sx or sy:
                    o['steps'][(size, sx or 0, sy or 0)].add(rid)
        motifs = {}
        for anchor, o in sorted(obs.items()):
            if len(o['halves']) < MIN_HALVES:
                continue
            m = {'halves': len(o['halves']), 'pieces': o['pieces']}
            if anchor == 'area':
                m['insets'] = ranked(o['insets'])
            else:
                m['sizes'] = ranked(o['sizes'])
                m['insets'] = ranked(o['insets'])
                if not m['sizes'] or not m['insets']:
                    continue
                rot = ranked(o['rot'], lambda k: [k])
                if rot and rot[0][0] != 0:
                    m['rotation'] = rot[0][0]
                props = ranked(o['props'], lambda k: [list(k[0]), dict(k[1])])
                if props:
                    m['props'] = props
                if o['steps']:
                    m['steps'] = ranked(o['steps'], lambda k: [list(k[0]), k[1], k[2]])
                if o['phase']:
                    m['phase'] = ranked(o['phase'], lambda k: [list(k[0]), k[1], k[2]])
                if o['margin']:
                    m['margin'] = ranked(o['margin'], lambda k: [k])
            m['examples'] = sorted(o['examples'])[:6]
            motifs[anchor] = m
        entry = {'halves': used, 'motifs': motifs}
        if layer in PIECES:
            entry['pieces'] = pieces
            entry['mirror'] = [mirrored, mirror_free]
            entry['lane'] = [on_lane, pieces]
            entry['touch'] = [touch, pairs]
        layers[layer] = entry
    return {'halves': len(halves), 'layers': layers}


def build_catalog():
    cat = {'comment': 'Composition motifs measured from the shared Main_Upper and Main_Lower templates by %s '
                      '(roadmap F11b). Do not edit: run the script. Each layer lists its motifs by anchor; sizes, '
                      'insets [side, top] (areas: [left, top, right, bottom]), steps [size, x, y], phases and '
                      'properties end with the number of halves that use them.' % GENERATOR,
           'generator': GENERATOR, 'min_halves': MIN_HALVES, 'mirror_rule': MIRROR_RULE, 'lane_rule': LANE_RULE,
           'apart_rule': APART_RULE,
           'solid': SOLID, 'classes': {}}
    for cls in CLASSES:
        cat['classes'][cls] = measure(cls)
    return cat


def catalog_text(cat):
    return json.dumps(cat, indent=1, sort_keys=True) + '\n'


def load_catalog():
    try:
        return json.load(open(CATALOG, encoding='utf-8'))
    except (OSError, ValueError):
        return None


# ---------------------------------------------------------------- rules

def rules(cat, cls, layer):
    """What the catalog asks of a layer: (motifs, must be mirrored, must keep off the lanes, pieces kept apart)."""
    e = cat['classes'][cls]['layers'].get(layer)
    if not e:
        return {}, False, False, False
    mir = e.get('mirror', [0, 0])
    lane = e.get('lane', [0, 1])
    touch = e.get('touch', [1, 1])
    return (e['motifs'], bool(mir[1]) and mir[0] >= MIRROR_RULE * mir[1],
            layer not in DOOR_CHECKED or lane[0] <= LANE_RULE * max(1, lane[1]),
            bool(touch[1]) and touch[0] <= APART_RULE * touch[1])


def explain(motifs, floor, b):
    """The motif that explains a piece, or None."""
    anchor, inset = classify(floor, b)
    m = motifs.get(anchor)
    if not m:
        return None
    if list(b[2:]) not in [s[:2] for s in m['sizes']]:
        return None
    if anchor == 'field':
        steps = [s for s in m.get('phase', []) if s[0] == list(b[2:])]
        margin = min([v[0] for v in m.get('margin', [[0]])])
        if min(inset) < margin:
            return None
        if steps and all(phase(b, s[1]) != s[2] for s in steps):
            return None
        return anchor
    insets = [tuple(i[:2]) for i in m['insets']]
    if anchor in ('axis',):
        return anchor if inset[1] >= min(i[1] for i in insets) else None
    if anchor in ('top', 'top_center'):
        return anchor if inset[1] in [i[1] for i in insets] else None
    if anchor == 'side':
        return anchor if inset[0] in [i[0] for i in insets] else None
    return anchor if inset in insets else None


def check_half(cat, cls, floor, layers, where, blocked=()):
    """Problems of a composed half: loose pieces, a missing mirror, a piece on a door lane, doors cut apart.

    layers: {layer: [box]} of one section group (the main one or a section), blocked: boxes nothing may cover
    (section rails). Returns a list of messages (empty when the composition is sound)."""
    out = []
    solid = []
    blocked_cells = set()
    for b in blocked:
        blocked_cells |= box_cells(b)
    for layer, boxes in sorted(layers.items()):
        if layer not in PIECES:
            continue
        motifs, mirrored, lane_free, apart = rules(cat, cls, layer)
        bs = set(boxes)
        if apart and touching(boxes)[0]:
            out.append('%s: %s pieces touch each other (they never do in the shared templates)' % (where, layer))
        for b in boxes:
            if not floor.all(clip(floor, b)):
                out.append('%s: %s %s is not on the floor' % (where, layer, list(b)))
                continue
            if not explain(motifs, floor, b):
                anchor, inset = classify(floor, b)
                out.append('%s: %s %s is a loose piece (%s, inset %s): no motif of the shared templates puts it there'
                           % (where, layer, list(b), anchor, list(inset)))
            if lane_free and box_cells(b) & floor.lanes:
                out.append('%s: %s %s is on a door lane' % (where, layer, list(b)))
            mb = mirror(b)
            if (mirrored and 2 * b[0] + b[2] != 256 and mb not in bs and floor.all(clip(floor, mb))
                    and not box_cells(mb) & blocked_cells):
                out.append('%s: %s %s has no mirror at %s (the shared templates mirror this layer)'
                           % (where, layer, list(b), list(mb)))
            if layer in SOLID:
                solid.append((layer, b))
    # two doors in use that reach each other over the floor (rails count as walls) still do with every solid
    # piece drawn, but those the game drops next to a door in use
    before = components(floor.cells - blocked_cells)
    lanes = [box_cells(lb) & floor.cells - blocked_cells for lb in lane_boxes(floor.doors)]
    for i in range(len(floor.doors)):
        for j in range(i + 1, len(floor.doors)):
            if not lanes[i] or not lanes[j] or before.get(min(lanes[i])) != before.get(min(lanes[j])):
                continue
            cells = set()
            for layer, b in solid:
                near = NEAR_DOOR.get(layer, 16)
                grown = (b[0] - near, b[1] - near, b[2] + 2 * near, b[3] + 2 * near)
                if layer in DOOR_CHECKED and any(overlaps(grown, floor.doors[k]) for k in (i, j)):
                    continue
                cells |= box_cells(b)
            after = components(floor.cells - blocked_cells - cells)
            pa = {after[c] for c in lanes[i] if c in after}
            pb = {after[c] for c in lanes[j] if c in after}
            if not pa & pb:
                out.append('%s: the solid pieces (%s) cut the door at %d,%d off from the one at %d,%d'
                           % (where, ', '.join(SOLID), floor.doors[i][0], floor.doors[i][1],
                              floor.doors[j][0], floor.doors[j][1]))
                return out
    return out


def overlaps(a, b):
    return a[0] < b[0] + b[2] and b[0] < a[0] + a[2] and a[1] < b[1] + b[3] and b[1] < a[1] + a[3]


def components(cells):
    """Connected parts of a set of cells: {cell: part number}."""
    part = {}
    for start in sorted(cells):
        if start in part:
            continue
        todo = [start]
        while todo:
            c = todo.pop()
            if c in part or c not in cells:
                continue
            part[c] = start
            todo += [(c[0] + 1, c[1]), (c[0] - 1, c[1]), (c[0], c[1] + 1), (c[0], c[1] - 1)]
    return part


def coverage(cat, cls):
    """How many pieces of the shared halves the catalog explains: (explained, pieces, loose by layer)."""
    total = ok = 0
    loose = collections.Counter()
    for rid, h, floor, rel, sym in shared_halves(cls):
        for layer in PIECES:
            motifs = rules(cat, cls, layer)[0]
            for b, _, _ in rel.get(layer, []):
                total += 1
                if explain(motifs, floor, b):
                    ok += 1
                else:
                    loose[layer] += 1
    return ok, total, loose


# ---------------------------------------------------------------- report

def report(cat):
    for cls in CLASSES:
        c = cat['classes'][cls]
        ok, total, loose = coverage(cat, cls)
        print('== %s: %d halves; the motifs explain %d of %d pieces (%.0f%%)'
              % (cls, c['halves'], ok, total, 100.0 * ok / max(1, total)))
        for layer, e in sorted(c['layers'].items()):
            line = '%-18s in %2d halves' % (layer, e['halves'])
            if 'mirror' in e:
                mir, lane, touch = e['mirror'], e['lane'], e['touch']
                line += '; mirrored %d/%d%s; on lanes %d/%d%s' % (
                    mir[0], mir[1], ' (rule)' if mir[1] and mir[0] >= MIRROR_RULE * mir[1] else '',
                    lane[0], lane[1], ' (rule: off)' if rules(cat, cls, layer)[2] else ' (the game checks)')
                line += '; touching %d/%d%s' % (touch[0], touch[1],
                                                ' (rule: apart)' if rules(cat, cls, layer)[3] else '')
                if loose[layer]:
                    line += '; loose %d' % loose[layer]
            print(line)
            for anchor, m in sorted(e['motifs'].items(), key=lambda kv: -kv[1]['halves']):
                parts = ['%-10s %2d halves' % (anchor, m['halves'])]
                if 'sizes' in m:
                    parts.append('sizes ' + ' '.join('%dx%d' % tuple(s[:2]) for s in m['sizes'][:4]))
                parts.append('insets ' + ' '.join(','.join(str(v) for v in i[:-1]) for i in m['insets'][:4]))
                if 'steps' in m:
                    parts.append('steps ' + ' '.join('%dx%d:%d,%d' % (s[0][0], s[0][1], s[1], s[2]) for s in m['steps'][:3]))
                if 'phase' in m:
                    parts.append('phase ' + ' '.join('%s/%d' % (s[2], s[1]) for s in m['phase'][:2]))
                print('    ' + '; '.join(parts))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--report', action='store_true', help='print the catalog layer by layer')
    ap.add_argument('--check', action='store_true', help='exit 1 when motifs.json is not what the templates give')
    a = ap.parse_args()
    cat = build_catalog()
    text = catalog_text(cat)
    rel = os.path.relpath(CATALOG, convert.REPO).replace(os.sep, '/')
    old = open(CATALOG, encoding='utf-8').read() if os.path.exists(CATALOG) else None
    if a.check:
        if old != text:
            print('%s is out of date: run python %s' % (rel, GENERATOR))
            return 1
        print('%s: up to date' % rel)
        return 0
    if old != text:
        with open(CATALOG, 'w', encoding='utf-8', newline='\n') as f:
            f.write(text)
        print('wrote', rel)
    if a.report:
        report(cat)
    else:
        for cls in CLASSES:
            ok, total, _ = coverage(cat, cls)
            n = sum(len(e['motifs']) for e in cat['classes'][cls]['layers'].values())
            print('%s: %d motifs from %d halves; they explain %d of %d pieces'
                  % (cls, n, cat['classes'][cls]['halves'], ok, total))
    return 0


if __name__ == '__main__':
    sys.exit(main())
