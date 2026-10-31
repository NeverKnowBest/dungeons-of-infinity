"""Screens of an area (roadmap F18): an ALttP overworld area cut into rooms with open edges, as ALttP shows it.

    python tools/templates/paint_screens.py CastleTopArea            # writes the set's map and screens.json
    python tools/templates/paint_screens.py CastleTopArea --png out.png   # and a picture of the screens (Pillow)
    python tools/templates/paint_screens.py CastleTopArea --check    # only checks that the written files are current

The set's data/room-templates/sets/<Set>/area.json says how the area is cut:

    {
      "tiles": "CastleTop",                  # region tileset (data/room-templates/tilesets/<Name>.json, imported)
      "area": "1B",                          # the area in the region's tiles/areas.json (16x16 blocks)
      "rooms": [                             # the rooms, in cells of 256x256 px (16x16 blocks) of the area: a room
        {"name": "CastleFront", "at": [1, 0], "size": [2, 2]},   # is 1 or 2 cells wide and tall, and the rooms cover
        ...],                                                    # the area's grid with no gap and no overlap
      "optional": {"NorthWest": 0.5},        # rooms the game may leave out (chance to keep), never the entrance's,
                                             #   the exit's, the lock's nor one that would cut the way through
      "entrance": {"room": "SouthRoad", "door": [800, 992], "location": "Bottom"},   # door cells (32x32, px of the
      "exit": {"room": "CastleFront", "door": [496, 256], "location": "Top"},        #   area): where Link comes in,
      "lock": {"room": "Gatehouse", "door": [496, 624], "location": "Top",           #   leaves, and the lock (a key
               "open": [30, 39, 4, 2], "from": [30, 41]},                            #   opens it: blocks [col, row, w,
                                                                                     #   h] take the blocks of the
      "mirror": true                         # the game may mirror the whole area     #   rows from [col, row] down)
    }

It writes the set's Tiled map (Room Templates Main Upper.json: each room a Whole painted room with the area's tiles on
the layer Region and the lock's open tiles on RegionOpen, an enemy area over each stretch of floor Link reaches and
treasure and pot spots) and data/room-templates/sets/<Set>/screens.json, which convert.py copies into the game: the
grid, the rooms, the open edges (where reachable floor crosses from a room into the next), the entrance, the exit,
the lock and which rooms come before it. The game builds the level from it (LevelLayout.Screens). Collision is the
tiles' own (data/tiles/<Name>.json "solid"): nothing is cut nor invented, the screens are the area itself.
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import convert          # noqa: E402
import make_rooms       # noqa: E402

GRID = 8
CELL = 256
GENERATOR = 'tools/templates/paint_screens.py'
AREA_KEYS = {'comment', 'tiles', 'area', 'rooms', 'optional', 'entrance', 'exit', 'lock', 'mirror'}
TILESETS_DIR = os.path.join(convert.TEMPLATE_DIR, 'tilesets')
LOCATIONS = ('Top', 'Bottom', 'Left', 'Right')
EDGE_BAND = 16          # enemy areas and spots keep this far from a room's edge (open edges let Link cross there)
MAX_AREAS = 6           # enemy areas per room (the largest stretches of reachable floor)
MIN_AREA = 32           # an enemy area is at least this wide and tall
CHEST_BOX = (-16, 0, 32, 32)       # a chest wants this box (px from its spot) clear of walls (SpawnObj: 16 px each side and below)


class ScreenError(Exception):
    pass


class Area:
    """The area's blocks and tiles, and which 8x8 tiles are walls."""

    def __init__(self, tiles_name, area_name, where):
        ts = os.path.join(TILESETS_DIR, '%s.json' % tiles_name)
        if not os.path.exists(ts):
            raise ScreenError('%s: no Tiled tileset %s (tools/import/import_region.py writes it)'
                              % (where, os.path.relpath(ts, convert.REPO)))
        tsj = json.load(open(ts, encoding='utf-8'))
        folder = os.path.dirname(os.path.normpath(os.path.join(TILESETS_DIR, tsj['image'])))
        self.folder = folder
        self.name = tiles_name
        self.tileset_path = ts
        tiles = json.load(open(os.path.join(folder, 'tiles.json'), encoding='utf-8'))
        self.blocks = [b['tiles'] for b in tiles['blocks']]
        areas = json.load(open(os.path.join(folder, 'areas.json'), encoding='utf-8'))
        if area_name not in areas:
            raise ScreenError('%s: area "%s" not in %s/areas.json (areas: %s)'
                              % (where, area_name, os.path.relpath(folder, convert.REPO), ', '.join(areas)))
        self.map = areas[area_name]                     # rows of block numbers
        self.bh, self.bw = len(self.map), len(self.map[0])
        data = os.path.join(convert.REPO, 'game', 'datafiles', 'data', 'tiles', tiles_name + '.json')
        self.solid = json.load(open(data, encoding='utf-8'))['solid']
        self.tw, self.th = self.bw * 2, self.bh * 2      # in 8x8 tiles
        self.tiles = [[None] * self.tw for _ in range(self.th)]
        for by in range(self.bh):
            for bx in range(self.bw):
                for q, t in enumerate(self.blocks[self.map[by][bx]]):
                    self.tiles[by * 2 + q // 2][bx * 2 + q % 2] = (t[0], t[1])

    def wall(self, tx, ty, opened=None):
        t = (opened or {}).get((tx, ty)) or self.tiles[ty][tx]
        return self.solid[t[0]] == 1


class Room:
    def __init__(self, d, i, area, where):
        self.name, self.index = d.get('name'), i
        if not self.name or not convert.SET_NAME.match(self.name):
            raise ScreenError('%s: room %d needs a name (letters, digits, _)' % (where, i))
        self.where = '%s room %s' % (where, self.name)
        try:
            self.cx, self.cy = (int(v) for v in d['at'])
            self.cw, self.ch = (int(v) for v in d.get('size', [1, 1]))
        except (KeyError, TypeError, ValueError):
            raise ScreenError('%s: "at" is [col, row] and "size" [w, h], in cells' % self.where)
        if (self.cw, self.ch) not in convert.ROOM_SIZE:
            raise ScreenError('%s: a room is 1 or 2 cells wide and tall' % self.where)
        if self.cx < 0 or self.cy < 0 or (self.cx + self.cw) * CELL > area.bw * 16 or (self.cy + self.ch) * CELL > area.bh * 16:
            raise ScreenError('%s: outside the area' % self.where)
        self.x, self.y, self.w, self.h = self.cx * CELL, self.cy * CELL, self.cw * CELL, self.ch * CELL
        self.size_index = convert.ROOM_SIZE[(self.cw, self.ch)]

    def has(self, px, py):
        return self.x <= px < self.x + self.w and self.y <= py < self.y + self.h


class Door:
    def __init__(self, d, rooms, area, kind, where):
        where = '%s %s' % (where, kind)
        if not isinstance(d, dict) or d.get('room') not in rooms:
            raise ScreenError('%s: {"room": <a room name>, "door": [x, y], "location": ...}' % where)
        self.room = rooms[d['room']]
        try:
            self.x, self.y = (int(v) for v in d['door'])
        except (KeyError, TypeError, ValueError):
            raise ScreenError('%s: "door" is [x, y], px of the area' % where)
        self.location = d.get('location')
        if self.location not in LOCATIONS:
            raise ScreenError('%s: location is one of %s' % (where, ', '.join(LOCATIONS)))
        if self.x % GRID or self.y % GRID or not (self.room.has(self.x, self.y) and self.room.has(self.x + 31, self.y + 31)):
            raise ScreenError('%s: the 32x32 door cell at %d,%d is not on the 8 px grid inside room %s'
                              % (where, self.x, self.y, self.room.name))
        self.kind = kind

    def local(self):
        return [float(self.x - self.room.x), float(self.y - self.room.y)]


class Screens:
    def __init__(self, set_name):
        self.set = set_name
        self.dir = os.path.join(convert.SETS_DIR, set_name)
        path = os.path.join(self.dir, 'area.json')
        where = os.path.relpath(path, convert.REPO).replace(os.sep, '/')
        if not os.path.exists(path):
            raise ScreenError('%s not found' % where)
        try:
            d = json.load(open(path, encoding='utf-8'))
        except ValueError as e:
            raise ScreenError('%s: %s' % (where, e))
        for k in d:
            if k not in AREA_KEYS:
                raise ScreenError('%s: unknown key "%s" (keys: %s)' % (where, k, ', '.join(sorted(AREA_KEYS))))
        self.d, self.where = d, where
        self.area = Area(d.get('tiles'), d.get('area'), where)
        self.rooms = [Room(r, i, self.area, where) for i, r in enumerate(d.get('rooms') or [])]
        if not self.rooms:
            raise ScreenError('%s: no rooms' % where)
        self.by_name = {}
        for r in self.rooms:
            if r.name in self.by_name:
                raise ScreenError('%s: the name %s is used twice' % (where, r.name))
            self.by_name[r.name] = r
        self.gw, self.gh = self.area.bw * 16 // CELL, self.area.bh * 16 // CELL
        self.grid = [[None] * self.gw for _ in range(self.gh)]
        for r in self.rooms:
            for cy in range(r.cy, r.cy + r.ch):
                for cx in range(r.cx, r.cx + r.cw):
                    if self.grid[cy][cx] is not None:
                        raise ScreenError('%s: rooms %s and %s overlap' % (where, self.grid[cy][cx].name, r.name))
                    self.grid[cy][cx] = r
        for cy in range(self.gh):
            for cx in range(self.gw):
                if self.grid[cy][cx] is None:
                    raise ScreenError('%s: no room covers cell %d,%d' % (where, cx, cy))
        self.entrance = Door(d.get('entrance'), self.by_name, self.area, 'entrance', where)
        self.exit = Door(d.get('exit'), self.by_name, self.area, 'exit', where)
        self.lock = Door(d['lock'], self.by_name, self.area, 'lock', where) if d.get('lock') else None
        self.opened = {}
        if self.lock:
            self.open_lock(d['lock'], where)
        self.optional = d.get('optional') or {}
        for n, p in self.optional.items():
            if n not in self.by_name or not isinstance(p, (int, float)) or not 0 < p < 1:
                raise ScreenError('%s: optional is {room name: chance to keep it (0 to 1)}' % where)
            if n in (self.entrance.room.name, self.exit.room.name) or (self.lock and n == self.lock.room.name):
                raise ScreenError('%s: room %s has the entrance, the exit or the lock: it cannot be left out' % (where, n))
        self.mirror = bool(d.get('mirror'))
        self.reach_all = self.flood(self.opened)
        self.reach_before = self.flood({}) if self.lock else self.reach_all
        ex = self.door_tiles(self.exit)
        if not any(t in self.reach_all for t in ex):
            raise ScreenError('%s: the exit is not reached from the entrance' % where)
        if self.lock:
            if any(t in self.reach_before for t in ex):
                raise ScreenError('%s: the exit is reached without opening the lock' % where)
            if not any(t in self.reach_before for t in self.ring(self.lock)):
                raise ScreenError('%s: the lock is not reached from the entrance' % where)
        # leaving rooms out only takes floor away, so the way that survives all of them out survives any of them
        if self.optional and not self.keeps_way({self.by_name[n] for n in self.optional}):
            raise ScreenError('%s: leaving out the optional rooms %s cuts the way from the entrance to the exit'
                              % (where, ', '.join(sorted(self.optional))))
        for r in self.rooms:
            self.furnish(r)

    # ---------------------------------------------------------------- reach

    def open_lock(self, d, where):
        """The lock's open picture: the wall tiles of its box taken from the blocks below "from" (the path that runs
        through); the tiles of the box Link already walks on (the arch over the bars) stay."""
        try:
            c0, r0, w, h = (int(v) for v in d['open'])
            fc, fr = (int(v) for v in d['from'])
        except (KeyError, TypeError, ValueError):
            raise ScreenError('%s lock: "open" is [col, row, w, h] and "from" [col, row], blocks of the area' % where)
        for j in range(h):
            for i in range(w):
                b = self.area.map[fr + j % max(1, self.area.bh - fr)][fc + i]
                for q, t in enumerate(self.area.blocks[b]):
                    tx, ty = (c0 + i) * 2 + q % 2, (r0 + j) * 2 + q // 2
                    if self.area.wall(tx, ty):      # only the bars: the arch over them (walkable on the map) stays
                        self.opened[(tx, ty)] = (t[0], t[1])
        for (tx, ty) in self.opened:
            if not self.lock.room.has(tx * GRID, ty * GRID):
                raise ScreenError('%s lock: its open blocks leave room %s' % (where, self.lock.room.name))

    def door_tiles(self, door):
        return [(door.x // GRID + i, door.y // GRID + j) for j in range(4) for i in range(4)]

    def ring(self, door):
        """The tiles around a door cell (Link stands there to use it)."""
        x0, y0 = door.x // GRID - 1, door.y // GRID - 1
        return [(x0 + i, y0 + j) for j in range(6) for i in range(6)]

    def flood(self, opened, skip=None):
        """Walkable tiles Link reaches from the entrance (the rooms in skip are left out of the level)."""
        a = self.area
        start = [t for t in self.door_tiles(self.entrance) if not a.wall(*t, opened)]
        seen, todo = set(start), list(start)
        while todo:
            x, y = todo.pop()
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if not (0 <= nx < a.tw and 0 <= ny < a.th) or (nx, ny) in seen or a.wall(nx, ny, opened):
                    continue
                if skip and self.grid[ny * GRID // CELL][nx * GRID // CELL] in skip:
                    continue
                seen.add((nx, ny))
                todo.append((nx, ny))
        return seen

    def keeps_way(self, rooms):
        reach = self.flood(self.opened, skip=rooms)
        return any(t in reach for t in self.door_tiles(self.exit))

    def edges(self, r):
        """Open edges of room r: per side, [neighbour, [start, length]...] in px along the side (reachable floor on
        both sides of the boundary)."""
        out = {}
        reach = self.reach_all
        x0, y0, x1, y1 = r.x // GRID, r.y // GRID, (r.x + r.w) // GRID, (r.y + r.h) // GRID
        sides = {'Top': [((x, y0), (x, y0 - 1)) for x in range(x0, x1)],
                 'Bottom': [((x, y1 - 1), (x, y1)) for x in range(x0, x1)],
                 'Left': [((x0, y), (x0 - 1, y)) for y in range(y0, y1)],
                 'Right': [((x1 - 1, y), (x1, y)) for y in range(y0, y1)]}
        for side, pairs in sides.items():
            runs = []
            for k, (a_, b_) in enumerate(pairs):
                if a_ in reach and b_ in reach:
                    nb = self.grid[b_[1] * GRID // CELL][b_[0] * GRID // CELL]
                    if runs and runs[-1][0] == nb.name and runs[-1][1] + runs[-1][2] == k * GRID:
                        runs[-1][2] += GRID
                    else:
                        runs.append([nb.name, k * GRID, GRID])
            if runs:
                out[side] = [[n, float(s), float(l)] for n, s, l in runs]
        return out

    # ---------------------------------------------------------------- objects

    def floor_ok(self, r, tx, ty, reach):
        """Tile tx, ty (of the area) is floor Link reaches inside room r, away from its edges."""
        b = EDGE_BAND // GRID
        return (r.x // GRID + b <= tx < (r.x + r.w) // GRID - b and r.y // GRID + b <= ty < (r.y + r.h) // GRID - b
                and (tx, ty) in reach)

    def furnish(self, r):
        """Enemy areas over the reachable floor of room r (largest rectangles first) and treasure and pot spots."""
        reach = self.reach_all
        keep = set()
        for door in (self.entrance, self.exit) + ((self.lock,) if self.lock else ()):
            if door.room is r:     # nothing in front of a door: 32 px around its cell stay free
                keep |= {(door.x // GRID + i, door.y // GRID + j) for j in range(-4, 8) for i in range(-4, 8)}
        free = {(tx, ty) for ty in range(r.y // GRID, (r.y + r.h) // GRID) for tx in range(r.x // GRID, (r.x + r.w) // GRID)
                if self.floor_ok(r, tx, ty, reach) and (tx, ty) not in keep}
        r.areas = []
        left = set(free)
        n = MIN_AREA // GRID
        while len(r.areas) < MAX_AREAS:
            best = largest_rect(left, r)
            if best is None or best[2] < n or best[3] < n:
                break
            x, y, w, h = best
            r.areas.append((x * GRID - r.x, y * GRID - r.y, w * GRID, h * GRID))
            left -= {(x + i, y + j) for j in range(h) for i in range(w)}
        # one treasure spot (the key or a bonus chest): never loose on the grass, but at the foot of a wall, fence or
        # hedge ("Composição das salas", the motif "parede de cima"), as near the middle of the largest area as it goes
        r.treasures, r.pots = [], []
        if r.areas:
            ax, ay, aw, ah = r.areas[0]
            spot = self.spot_against_wall(r, free, ax + aw // 2, ay + ah // 2)
            if spot is not None:
                r.treasures.append(spot)

    def spot_against_wall(self, r, free, cx, cy):
        """A 16x16 spot (px in room r) whose chest box is reachable floor and that has a wall right above its box."""
        bx, by, bw, bh = CHEST_BOX
        a = self.area
        best = None
        for y in range(EDGE_BAND - by, r.h - EDGE_BAND - bh, 8):
            for x in range(EDGE_BAND - bx, r.w - EDGE_BAND - bw, 8):
                tx0, ty0 = (r.x + x + bx) // GRID, (r.y + y + by) // GRID
                box = [(tx0 + i, ty0 + j) for j in range((bh - by) // GRID) for i in range((bw - bx) // GRID)]
                if not all(t in free for t in box):
                    continue
                above = [(tx0 + i, ty0 - 1) for i in range((bw - bx) // GRID)]
                if not all(0 <= ty < a.th and a.wall(tx, ty) for tx, ty in above):
                    continue
                d = (x + 8 - cx) ** 2 + (y + 8 - cy) ** 2
                if best is None or d < best[0]:
                    best = (d, (x, y))
        return None if best is None else best[1]

    # ---------------------------------------------------------------- output

    def grid_of(self, r, opened=None):
        x0, y0 = r.x // GRID, r.y // GRID
        return [[(opened or {}).get((x0 + i, y0 + j), self.area.tiles[y0 + j][x0 + i]) if opened is None
                 or (x0 + i, y0 + j) in opened else None
                 for i in range(r.w // GRID)] for j in range(r.h // GRID)]

    def map(self):
        halves = [ScreenRoom(self, r) for r in self.rooms]
        m = make_rooms.build_map('Main_Upper', halves)
        for p in m['properties']:
            if p['name'] == 'Generator':
                p['value'] = GENERATOR
        return m

    def screens_json(self):
        def door(dr):
            return {'room': float(dr.room.index), 'x': dr.local()[0], 'y': dr.local()[1], 'location': dr.location}
        rooms = []
        for r in self.rooms:
            cells = {(tx * GRID // CELL, ty * GRID // CELL) for (tx, ty) in self.reach_before}
            before = any((cx, cy) in cells for cy in range(r.cy, r.cy + r.ch) for cx in range(r.cx, r.cx + r.cw)
                         if any(self.floor_ok(r, tx, ty, self.reach_before)
                                for ty in range(cy * CELL // GRID, (cy + 1) * CELL // GRID)
                                for tx in range(cx * CELL // GRID, (cx + 1) * CELL // GRID)))
            # the key of the lock may go in this room: every spot and enemy area (an enemy may carry it) before the lock
            key = bool(self.lock and r.treasures and all(
                (r.x // GRID + x // GRID + i, r.y // GRID + y // GRID + j) in self.reach_before
                for (x, y) in r.treasures for j in range(2) for i in range(2)) and all(
                (r.x // GRID + ax // GRID + i, r.y // GRID + ay // GRID + j) in self.reach_before
                for (ax, ay, aw, ah) in r.areas for j in range(ah // GRID) for i in range(aw // GRID)))
            rooms.append({'name': r.name, 'x': float(r.cx), 'y': float(r.cy), 'w': float(r.cw), 'h': float(r.ch),
                          'keep': float(self.optional.get(r.name, 1)), 'before_lock': before, 'key': key,
                          'treasures': float(len(r.treasures)), 'edges': self.edges(r)})
        out = {'comment': 'Written by %s from area.json; convert.py copies it into the game (LevelLayout.Screens).'
                          % GENERATOR,
               'tiles': self.area.name, 'w': float(self.gw), 'h': float(self.gh), 'mirror': self.mirror,
               'rooms': rooms, 'entrance': door(self.entrance), 'exit': door(self.exit)}
        if self.lock:
            out['lock'] = door(self.lock)
        return out

    def png(self, path, scale=1):
        from PIL import Image, ImageDraw
        tsj = json.load(open(self.area.tileset_path, encoding='utf-8'))
        sheet = Image.open(os.path.normpath(os.path.join(TILESETS_DIR, tsj['image']))).convert('RGBA')
        cols = tsj['columns']
        a = self.area
        im = Image.new('RGBA', (a.tw * GRID, a.th * GRID), (0, 0, 0, 255))
        for ty in range(a.th):
            for tx in range(a.tw):
                t, fl = a.tiles[ty][tx]
                tile = sheet.crop(((t % cols) * GRID, (t // cols) * GRID, (t % cols + 1) * GRID, (t // cols + 1) * GRID))
                if fl & 1:
                    tile = tile.transpose(Image.FLIP_LEFT_RIGHT)
                if fl & 2:
                    tile = tile.transpose(Image.FLIP_TOP_BOTTOM)
                im.paste(tile, (tx * GRID, ty * GRID))
        ov = Image.new('RGBA', im.size, (0, 0, 0, 0))
        d = ImageDraw.Draw(ov)
        for ty in range(a.th):
            for tx in range(a.tw):
                if (tx, ty) not in self.reach_all:
                    d.rectangle((tx * GRID, ty * GRID, tx * GRID + 7, ty * GRID + 7), fill=(0, 0, 0, 110))
                elif (tx, ty) not in self.reach_before:
                    d.rectangle((tx * GRID, ty * GRID, tx * GRID + 7, ty * GRID + 7), fill=(255, 200, 0, 40))
        for r in self.rooms:
            d.rectangle((r.x, r.y, r.x + r.w - 1, r.y + r.h - 1), outline=(255, 0, 255, 255), width=2)
            d.text((r.x + 4, r.y + 4), r.name, fill=(255, 255, 255, 255))
            for (x, y, w, h) in r.areas:
                d.rectangle((r.x + x, r.y + y, r.x + x + w - 1, r.y + y + h - 1), outline=(255, 64, 64, 200))
            for (x, y) in r.treasures:
                d.rectangle((r.x + x, r.y + y, r.x + x + 15, r.y + y + 15), outline=(255, 255, 0, 255), width=2)
            for (x, y) in r.pots:
                d.ellipse((r.x + x, r.y + y, r.x + x + 15, r.y + y + 15), outline=(0, 255, 255, 255), width=2)
        for dr, c in ((self.entrance, (0, 255, 0, 255)), (self.exit, (0, 128, 255, 255)), (self.lock, (255, 128, 0, 255))):
            if dr:
                d.rectangle((dr.x, dr.y, dr.x + 31, dr.y + 31), outline=c, width=3)
        out = Image.alpha_composite(im, ov)
        if scale != 1:
            out = out.resize((out.width * scale, out.height * scale), Image.NEAREST)
        out.save(path)


def largest_rect(cells, r):
    """Largest rectangle (x, y, w, h in tiles of the area) of cells inside room r (histogram method)."""
    x0, y0, w, h = r.x // GRID, r.y // GRID, r.w // GRID, r.h // GRID
    heights = [0] * w
    best = None
    for j in range(h):
        for i in range(w):
            heights[i] = heights[i] + 1 if (x0 + i, y0 + j) in cells else 0
        stack = []
        for i in range(w + 1):
            hh = heights[i] if i < w else 0
            start = i
            while stack and stack[-1][1] >= hh:
                s, sh = stack.pop()
                area = sh * (i - s)
                if sh and (best is None or area > best[0]):
                    best = (area, (x0 + s, y0 + j - sh + 1, i - s, sh))
                start = s
            stack.append((start, hh))
    return None if best is None else best[1]


class ScreenRoom:
    """A screen laid out like make_rooms' Painted for build_map: a Whole Main_Upper room with its tiles."""
    painted = True
    symmetric = True
    split_ids = [0]
    room_type = ''
    section_grids = None

    def __init__(self, s, r):
        self.name, self.w, self.h, self.where = r.name, r.w, r.h, r.where
        self.size_index = r.size_index
        self.kit = s.area
        self.base = s.grid_of(r)
        self.open = s.grid_of(r, s.opened)
        self.gate = [[None] * (r.w // GRID) for _ in range(r.h // GRID)]
        self.layers = {}
        self.groups = {'main': {'Enemies': [], 'Treasures': [], 'Pots': []}}
        for box in r.areas:
            self.groups['main']['Enemies'].append((None, box, {}, 'Area'))
        for (x, y) in r.treasures:
            self.groups['main']['Treasures'].append((make_rooms.G['Treasure'], (x, y, 16, 16), {}, ''))
        for (x, y) in r.pots:
            self.groups['main']['Pots'].append((make_rooms.G['Pot'], (x, y, 16, 16), {}, ''))

    def room_props(self):
        return {'Whole': 1, 'Transforms': 'None,FlipH', 'Screen': 1}

    def gids(self, grid, firstgid):
        out = []
        for row in grid:
            out.append([0 if t is None else (firstgid + t[0]) | (convert_flag(t[1])) for t in row])
        return out


def convert_flag(fl):
    return (0x80000000 if fl & 1 else 0) | (0x40000000 if fl & 2 else 0)


def write(s):
    """Writes the set's map and screens.json. Returns the paths that changed."""
    written = []
    path = convert.map_path(0, s.set)
    if os.path.exists(path):
        old = json.load(open(path, encoding='utf-8'))
        if not any(p.get('name') == 'Generator' and p.get('value') == GENERATOR for p in old.get('properties', [])):
            raise ScreenError('%s was not written by this script; not overwriting it' % os.path.relpath(path, convert.REPO))
    for p, text in ((path, json.dumps(s.map(), indent=1) + '\n'),
                    (os.path.join(s.dir, 'screens.json'), json.dumps(s.screens_json(), indent=1) + '\n')):
        old = open(p, encoding='utf-8').read() if os.path.exists(p) else None
        if old != text:
            with open(p, 'w', encoding='utf-8', newline='\n') as f:
                f.write(text)
            written.append(os.path.relpath(p, convert.REPO).replace(os.sep, '/'))
    return written


def check(s):
    """Lines saying which written files differ from what the script writes now (empty when current)."""
    out = []
    for p, text in ((convert.map_path(0, s.set), json.dumps(s.map(), indent=1) + '\n'),
                    (os.path.join(s.dir, 'screens.json'), json.dumps(s.screens_json(), indent=1) + '\n')):
        old = open(p, encoding='utf-8').read() if os.path.exists(p) else None
        if old != text:
            out.append('%s is not what %s writes: run python %s %s'
                       % (os.path.relpath(p, convert.REPO).replace(os.sep, '/'), GENERATOR, GENERATOR, s.set))
    return out


def summary(s):
    lines = ['%s: area %s, %dx%d cells, %d rooms, entrance in %s, exit in %s%s'
             % (s.set, s.d['area'], s.gw, s.gh, len(s.rooms), s.entrance.room.name, s.exit.room.name,
                ', lock in %s' % s.lock.room.name if s.lock else '')]
    sj = s.screens_json()
    for r, rj in zip(s.rooms, sj['rooms']):
        edges = ', '.join('%s %s' % (side, '+'.join('%s:%d' % (n, l) for n, _, l in runs)) for side, runs in rj['edges'].items())
        lines.append('  %-12s %dx%d at %d,%d  %s%s  areas %d, chests %d  open: %s'
                     % (r.name, r.cw, r.ch, r.cx, r.cy, 'before lock' if rj['before_lock'] else 'after lock ',
                        ', key' if rj['key'] else '', len(r.areas), len(r.treasures), edges or 'none'))
    return lines


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('set', help='room set (data/room-templates/sets/<Set>/area.json)')
    ap.add_argument('--png', help='also draw the screens (reach, enemy areas, spots, doors) to this PNG')
    ap.add_argument('--check', action='store_true', help='only check that the written files are current')
    a = ap.parse_args()
    try:
        s = Screens(a.set)
        if a.check:
            bad = check(s)
            for line in bad:
                print(line)
            sys.exit(1 if bad else 0)
        for line in summary(s):
            print(line)
        for p in write(s):
            print('wrote', p)
        if a.png:
            s.png(a.png)
            print('wrote', a.png)
    except ScreenError as e:
        sys.exit('error: %s' % e)


if __name__ == '__main__':
    main()
