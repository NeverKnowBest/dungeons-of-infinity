"""Painted rooms (roadmap F12b): whole rooms painted tile by tile with a region tileset, for make_rooms.py.

A room set's rooms.json may have, beside its "halves", a "kit" and a list of "painted" rooms:

    "kit": {
      "tiles": "CastleTop",                     # region tileset (data/room-templates/tilesets/<Name>.json, imported)
      "area": "1B",                             # ALttP area the pieces are cut from (tiles/areas.json of the region)
      "pieces": {                               # cells of that area, 16x16 blocks: [col, row, w, h] or rows of [col, row]
        "floor": [15, 7, 1, 1],                 #   ([col, row, "m"] is that cell mirrored)
        "bottom_left": [[[11, 6], [12, 6], [17, 8]], ...]},
      "frame": {"top": ["top_left", "top_mid", "top_right"],          # the walls: left and right pieces at the corners,
                "middle": ["side_left", "floor", "side_right"],       #   the mid piece repeated across; the middle row
                "bottom": ["bottom_left", "bottom_mid", "bottom_right"]},   # repeated down between top and bottom
      "openings": {"Top": "open_top", "Bottom": "open_bottom"}        # painted on RegionOpen over a door in use,
    },                                                                #   16 px left of the door cell, at the wall
    "painted": [
      {"name": "Terrace", "size": "1x1", "doors": [12, 6],           # 1x1, 1x2 or 2x1; door positions of the room (DOOR_XY)
       "decor": [{"piece": "tower", "at": [48, 16], "pair": true},    # px on the 8 px grid; pair: mirrored copy too
                 {"piece": "crest", "at": [112, 112]}],
       "transforms": "None,FlipH",                                    # optional; that is the default
       "props": {...}}
    ]

The room becomes a Whole Main_Upper template with the tile layers Region (the room, every door closed) and
RegionOpen (the passage of each door), its Doors, an enemy area and a treasure and crystal spot on the floor. The
game paints it with the transform it picks and makes the walls from the tile classes (RegionRoom_Paint). Pieces are
cells of a real ALttP area, so the walls, their ends and the decoration keep the original light and perspective.
"""
import json
import os

import convert

GRID = 8
SIZES = {'1x1': (256, 256, 0), '1x2': (256, 512, 1), '2x1': (512, 256, 2)}    # w, h, RoomSize
ROOM_KEYS = {'name', 'size', 'doors', 'decor', 'transforms', 'props', 'comment'}
KIT_KEYS = {'tiles', 'area', 'pieces', 'frame', 'openings', 'comment'}
DECOR_KEYS = {'piece', 'at', 'pair', 'mirror'}
TILESETS_DIR = os.path.join(convert.TEMPLATE_DIR, 'tilesets')
TILED_H, TILED_V = 0x80000000, 0x40000000


class PaintError(Exception):
    pass


class Kit:
    """The pieces of a region tileset a set paints with, resolved to 16x16 blocks."""

    def __init__(self, d, where):
        for k in d:
            if k not in KIT_KEYS:
                raise PaintError('%s: unknown key "%s" (keys: %s)' % (where, k, ', '.join(sorted(KIT_KEYS))))
        self.name = d.get('tiles')
        ts = os.path.join(TILESETS_DIR, '%s.json' % self.name)
        if not os.path.exists(ts):
            raise PaintError('%s: no Tiled tileset %s (tools/import/import_region.py writes it)'
                             % (where, os.path.relpath(ts, convert.REPO)))
        self.tileset_path = ts
        tsj = json.load(open(ts, encoding='utf-8'))
        folder = os.path.dirname(os.path.normpath(os.path.join(TILESETS_DIR, tsj['image'])))
        tiles = json.load(open(os.path.join(folder, 'tiles.json'), encoding='utf-8'))
        self.blocks = [b['tiles'] for b in tiles['blocks']]
        data = os.path.join(convert.REPO, 'game', 'datafiles', 'data', 'tiles', self.name + '.json')
        self.solid = json.load(open(data, encoding='utf-8'))['solid']
        areas = json.load(open(os.path.join(folder, 'areas.json'), encoding='utf-8'))
        if d.get('area') not in areas:
            raise PaintError('%s: area "%s" not in %s/areas.json (areas: %s)'
                             % (where, d.get('area'), os.path.relpath(folder, convert.REPO), ', '.join(areas)))
        self.area = areas[d['area']]
        self.pieces = {n: self.piece(v, '%s piece %s' % (where, n)) for n, v in (d.get('pieces') or {}).items()}
        self.frame = d.get('frame') or {}
        for row in ('top', 'middle', 'bottom'):
            names = self.frame.get(row)
            if not (isinstance(names, list) and len(names) == 3):
                raise PaintError('%s: frame "%s" needs three pieces (left, middle, right)' % (where, row))
            for n in names:
                self.get(n, where)
        self.openings = d.get('openings') or {}
        for loc, n in self.openings.items():
            if loc not in ('Top', 'Bottom', 'Left', 'Right'):
                raise PaintError('%s: openings are Top, Bottom, Left or Right, not %s' % (where, loc))
            self.get(n, where)

    def piece(self, v, where):
        """Rows of (block, mirrored)."""
        try:
            if len(v) == 4 and all(isinstance(x, int) for x in v):
                c, r, w, h = v
                cells = [[[c + i, r + j] for i in range(w)] for j in range(h)]
            else:
                cells = v
            out = []
            for row in cells:
                line = []
                for cell in row:
                    c, r = cell[0], cell[1]
                    line.append((self.area[r][c], len(cell) > 2 and cell[2] == 'm'))
                out.append(line)
        except (TypeError, IndexError, ValueError):
            raise PaintError('%s: a piece is [col, row, w, h] or rows of [col, row] (cells of the area)' % where)
        if not out or any(len(r) != len(out[0]) for r in out):
            raise PaintError('%s: the rows of a piece must have the same length' % where)
        return out

    def get(self, name, where):
        if name not in self.pieces:
            raise PaintError('%s: no piece "%s" in the kit' % (where, name))
        return self.pieces[name]


class Painted:
    """A whole painted room, laid out like a Half for build_map (layers, groups, split ids) plus its tile layers."""
    painted = True
    symmetric = True
    split_ids = [0]

    def __init__(self, d, kit, where):
        self.d, self.kit, self.where = d, kit, where
        for k in d:
            if k not in ROOM_KEYS:
                raise PaintError('%s: unknown key "%s" (keys: %s)' % (where, k, ', '.join(sorted(ROOM_KEYS))))
        self.name = d.get('name')
        if not self.name:
            raise PaintError('%s: needs a "name"' % where)
        self.cls = 'Main_Upper'
        if d.get('size', '1x1') not in SIZES:
            raise PaintError('%s: size must be 1x1, 1x2 or 2x1' % where)
        self.w, self.h, self.size_index = SIZES[d.get('size', '1x1')]
        self.cw, self.ch = self.w // 16, self.h // 16       # 16x16 cells
        self.layers, self.groups = {}, {}
        self.base = [[None] * (self.cw * 2) for _ in range(self.ch * 2)]     # 8x8 tiles: (tile, flags) or None
        self.open = [[None] * (self.cw * 2) for _ in range(self.ch * 2)]
        self.build()

    # ---------------------------------------------------------------- painting

    def stamp(self, grid, piece, x, y, mirror=False, where=''):
        """Paints a piece with its top left corner at x, y (px, 8 px grid); mirror turns the whole piece."""
        if x % GRID or y % GRID:
            raise PaintError('%s: %s,%s is off the 8 px grid' % (where, x, y))
        w = len(piece[0])
        for j, row in enumerate(piece):
            for i in range(w):
                block, m = row[w - 1 - i] if mirror else row[i]
                m = m != mirror
                for k, (tile, fl) in enumerate(self.kit.blocks[block]):
                    tx, ty = k % 2, k // 2
                    if m:
                        tx, fl = 1 - tx, fl ^ 1
                    gx, gy = x // GRID + i * 2 + tx, y // GRID + j * 2 + ty
                    if 0 <= gy < len(grid) and 0 <= gx < len(grid[0]):
                        grid[gy][gx] = (tile, fl) if tile else None

    def fill(self, grid, piece, x0, y0, x1, y1):
        """Repeats a piece over the box x0..x1, y0..y1 (px), cut at its right and bottom edges."""
        pw, ph = len(piece[0]) * 16, len(piece) * 16
        for y in range(y0, y1, ph):
            for x in range(x0, x1, pw):
                tmp = [[None] * len(grid[0]) for _ in grid]
                self.stamp(tmp, piece, x, y)
                for gy in range(y // GRID, min(y1, y + ph) // GRID):
                    for gx in range(x // GRID, min(x1, x + pw) // GRID):
                        if tmp[gy][gx] is not None or grid[gy][gx] is not None:
                            grid[gy][gx] = tmp[gy][gx]

    def build(self):
        k, d, where = self.kit, self.d, self.where
        W, H = self.w, self.h
        top, mid, bot = ([k.get(n, where) for n in k.frame[r]] for r in ('top', 'middle', 'bottom'))
        th, bh = len(top[0]) * 16, len(bot[0]) * 16
        lw, rw = len(mid[0][0]) * 16, len(mid[2][0]) * 16
        self.inner = (lw, th, W - rw, H - bh)          # the floor between the walls
        for row, y0, y1 in ((top, 0, th), (mid, th, H - bh), (bot, H - bh, H)):
            left, centre, right = row
            self.fill(self.base, left, 0, y0, len(left[0]) * 16, y1)
            self.fill(self.base, centre, len(left[0]) * 16, y0, W - len(right[0]) * 16, y1)
            self.fill(self.base, right, W - len(right[0]) * 16, y0, W, y1)

        # doors: the Doors objects and the passages painted on RegionOpen
        coords = convert.DOOR_XY[self.size_index]
        doors = d.get('doors')
        if not isinstance(doors, list) or not doors:
            raise PaintError('%s: "doors" lists the door positions of the room (1 to 12)' % where)
        self.doors = {}
        boxes = []
        for p in doors:
            if not isinstance(p, int) or not 1 <= p <= 12:
                raise PaintError('%s: door %s is not a position 1 to 12' % (where, p))
            loc = convert.door_location(p)
            if loc not in k.openings:
                raise PaintError('%s: door %d is on the %s wall and the kit has no opening there' % (where, p, loc))
            x, y = coords[(p - 1) * 2], coords[(p - 1) * 2 + 1]
            box = {'Top': (x, y, 32, 24), 'Bottom': (x, y, 32, 24), 'Left': (x, y, 24, 32), 'Right': (x, y, 24, 32)}[loc]
            gid = {'Top': 'DoorT', 'Bottom': 'DoorB', 'Left': 'DoorL', 'Right': 'DoorR'}[loc]
            self.doors[p] = (loc, box)
            self.add('Doors', gid, box)
            piece = k.get(k.openings[loc], where)
            pw, ph = len(piece[0]) * 16, len(piece) * 16
            ox = {'Top': (x - 16, 0), 'Bottom': (x - 16, H - ph), 'Left': (0, y - 16), 'Right': (W - pw, y - 16)}[loc]
            self.stamp(self.open, piece, ox[0], ox[1], where=where)
            boxes.append((p, (ox[0], ox[1], pw, ph)))
        for i, (p, a) in enumerate(boxes):
            for q, b in boxes[i + 1:]:
                if convert.rect_overlap((a[0], a[1], a[0] + a[2], a[1] + a[3]), (b[0], b[1], b[0] + b[2], b[1] + b[3])):
                    raise PaintError('%s: the passages of doors %d and %d touch' % (where, p, q))

        for dd in d.get('decor', []):
            if not isinstance(dd, dict) or any(key not in DECOR_KEYS for key in dd):
                raise PaintError('%s: decor is {"piece", "at": [x, y], "pair", "mirror"}' % where)
            piece = k.get(dd.get('piece'), where)
            x, y = dd.get('at', [0, 0])
            pw, ph = len(piece[0]) * 16, len(piece) * 16
            spots = [(x, y, dd.get('mirror', False))]
            if dd.get('pair'):
                spots.append((W - x - pw, y, not dd.get('mirror', False)))
            for sx, sy, m in spots:
                for p, b in boxes:
                    if convert.rect_overlap((sx, sy, sx + pw - 1, sy + ph - 1), (b[0], b[1], b[0] + b[2] - 1, b[1] + b[3] - 1)):
                        raise PaintError('%s: decor %s at %d,%d covers the passage of door %d' % (where, dd['piece'], sx, sy, p))
                self.stamp(self.base, piece, sx, sy, m, where)

        self.check_passages()
        self.furnish()

    def solid_at(self, grid, gx, gy):
        t = grid[gy][gx]
        return t is not None and self.kit.solid[t[0]] == 1

    def floor_cells(self):
        """8x8 cells nothing blocks with every door open."""
        out = set()
        for gy in range(len(self.base)):
            for gx in range(len(self.base[0])):
                g = self.open if self.open[gy][gx] is not None else self.base
                if not self.solid_at(g, gx, gy):
                    out.add((gx, gy))
        return out

    def check_passages(self):
        """Each door's passage is walkable from the room's inner floor to the edge, and closed without it."""
        floor = self.floor_cells()
        x0, y0, x1, y1 = self.inner
        cx, cy = (x0 + x1) // 2 // GRID, (y0 + y1) // 2 // GRID
        if (cx, cy) not in floor:
            raise PaintError('%s: the middle of the room is not floor' % self.where)
        seen, todo = {(cx, cy)}, [(cx, cy)]
        while todo:
            x, y = todo.pop()
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if n in floor and n not in seen:
                    seen.add(n)
                    todo.append(n)
        gw, gh = len(self.base[0]), len(self.base)
        for p, (loc, (x, y, w, h)) in sorted(self.doors.items()):
            # Link (16 px wide) goes through the middle of the door cell to the room's edge
            if loc in ('Top', 'Bottom'):
                cells = [(gx, gy) for gx in (x // GRID + 1, x // GRID + 2)
                         for gy in (range(0, y0 // GRID) if loc == 'Top' else range(y1 // GRID, gh))]
            else:
                cells = [(gx, gy) for gy in (y // GRID + 1, y // GRID + 2)
                         for gx in (range(0, x0 // GRID) if loc == 'Left' else range(x1 // GRID, gw))]
            if not all(c in seen for c in cells):
                raise PaintError('%s: the passage of door %d is not open floor from the room to the edge' % (self.where, p))
        self.reach = seen

    def furnish(self):
        """An enemy area over the inner floor and a treasure and a crystal spot in its middle (special objects)."""
        x0, y0, x1, y1 = self.inner
        self.add('Enemies', None, (x0 + 8, y0 + 8, x1 - x0 - 16, y1 - y0 - 16), group='main', obj_type='Area')
        cx, cy = (x0 + x1) // 2 - 8, (y0 + y1) // 2 - 8
        for gx in range(cx // GRID, cx // GRID + 2):
            for gy in range(cy // GRID, cy // GRID + 2):
                if (gx, gy) not in self.reach:
                    raise PaintError('%s: the middle of the room (treasure spot) is not open floor' % self.where)
        self.add('Treasures', 'Treasure', (cx, cy, 16, 16), group='main')
        self.add('Crystals', 'Crystal', (cx, cy, 16, 16), group='main')

    def add(self, layer, gid, box, props=None, group=None, obj_type=''):
        dst = self.layers if group is None else self.groups.setdefault(group, {})
        dst.setdefault(layer, []).append((gid, tuple(box), dict(props or {}), obj_type))

    def room_props(self):
        p = {'Whole': 1, 'Transforms': self.d.get('transforms', ','.join(convert.DEFAULT_PAINTED_TRANSFORMS))}
        p.update(self.d.get('props') or {})
        return p

    def gids(self, grid, firstgid):
        """The 8x8 tiles as Tiled gids (mirror and flip bits)."""
        out = []
        for row in grid:
            line = []
            for t in row:
                if t is None:
                    line.append(0)
                else:
                    tile, fl = t
                    line.append((firstgid + tile) | (TILED_H if fl & 1 else 0) | (TILED_V if fl & 2 else 0))
            out.append(line)
        return out


def load(d, where):
    """(kit, [Painted]) of a rooms.json, or (None, [])."""
    rooms = d.get('painted', [])
    if not rooms:
        return None, []
    if 'kit' not in d:
        raise PaintError('%s: painted rooms need a "kit"' % where)
    kit = Kit(d['kit'], where + ' kit')
    names = set()
    out = []
    for i, r in enumerate(rooms):
        w = '%s painted %d (%s)' % (where, i, r.get('name', '?'))
        if r.get('name') in names:
            raise PaintError('%s: the name is used twice' % w)
        names.add(r.get('name'))
        out.append(Painted(r, kit, w))
    return kit, out


def render(rooms, path, scale=2):
    """Preview without the game: each room twice, every door closed and every door open (with its door cells
    outlined), side by side, one row per room. Needs Pillow (python -m pip install --user pillow)."""
    from PIL import Image, ImageDraw
    if not rooms:
        return
    kit = rooms[0].kit
    tsj = json.load(open(kit.tileset_path, encoding='utf-8'))
    sheet = Image.open(os.path.normpath(os.path.join(TILESETS_DIR, tsj['image']))).convert('RGBA')
    cols = tsj['columns']

    def tile(t, fl):
        im = sheet.crop(((t % cols) * GRID, (t // cols) * GRID, (t % cols + 1) * GRID, (t // cols + 1) * GRID))
        if fl & 1:
            im = im.transpose(Image.FLIP_LEFT_RIGHT)
        if fl & 2:
            im = im.transpose(Image.FLIP_TOP_BOTTOM)
        return im

    def paint(room, with_open):
        im = Image.new('RGBA', (room.w, room.h), (0, 0, 0, 255))
        for gy in range(len(room.base)):
            for gx in range(len(room.base[0])):
                t = room.open[gy][gx] if with_open and room.open[gy][gx] is not None else room.base[gy][gx]
                if t is not None:
                    im.paste(tile(*t), (gx * GRID, gy * GRID))
        if with_open:
            d = ImageDraw.Draw(im)
            for p, (loc, (x, y, w, h)) in room.doors.items():
                d.rectangle((x, y, x + w - 1, y + h - 1), outline=(255, 0, 255, 255))
        return im

    W, H = max(r.w for r in rooms) * 2 + 16, sum(r.h + 16 for r in rooms)
    out = Image.new('RGBA', (W, H), (40, 40, 40, 255))
    y = 0
    for r in rooms:
        out.paste(paint(r, False), (0, y))
        out.paste(paint(r, True), (r.w + 16, y))
        ImageDraw.Draw(out).text((2, y + r.h + 2), '%s %s doors %s' % (r.name, r.d.get('size', '1x1'), r.d.get('doors')),
                                 fill=(255, 255, 255, 255))
        y += r.h + 16
    out = out.resize((W * scale, H * scale), Image.NEAREST)
    out.save(path)


def text_map(room):
    """The room as text, 8 px a character: # wall, . floor, o a passage (RegionOpen), D a door cell."""
    rows = []
    for gy in range(len(room.base)):
        line = ''
        for gx in range(len(room.base[0])):
            if room.open[gy][gx] is not None:
                line += 'o' if not room.solid_at(room.open, gx, gy) else 'O'
            else:
                line += '#' if room.solid_at(room.base, gx, gy) else '.'
        rows.append(line)
    for p, (loc, (x, y, w, h)) in room.doors.items():
        for gy in range(y // GRID, (y + h) // GRID):
            r = rows[gy]
            rows[gy] = r[:x // GRID] + 'D' * (w // GRID) + r[(x + w) // GRID:]
    return '\n'.join(rows)
