"""Painted rooms built from a frame under the fitting rules (roadmap F12b-2), for paint_rooms.py.

A set whose kit has "auto" paints its rooms from data/room-templates/sets/<Set>/frame.json instead of hand-cut pieces:

    "kit": {"tiles": "CastleTop",
            "auto": {"frame": "frame.json",                   # the set's frame (below)
                     "seeds": {"floor": [[15, 7]], ...},      # blocks of each material (cells of the area), for the solver
                     "pieces": {"crest": [31, 8, 2, 3]}}}     # decoration: [col, row, w, h] cells of the area

frame.json (made with tools/templates/autopaint.py and approved join by join, incoming/<region>/tiles/joins.json):
"ring", the reference room (16x16 blocks) whose border every room repeats every 16 blocks: it meets itself on all
four sides, so any two rooms of the set meet as it meets itself; "passages", per door offset along an edge ("h56",
"v240"...: h for top and bottom walls, v for the sides, the offset in px within a 256 px unit or 240 for the middle of
a 2x1 or 1x2 room) the reference room with that passage open on both sides of its seam (a room copies the cells that
differ from the ring on its own side); "gates", the level's entrance or exit in a top or bottom door ({"door": offset,
"grid": the reference room with it}), and "gate_dy", how far below the door cell the top gate's doorway is.

A room is the ring around the reference room's inside and its decoration (pieces of the area). In a room larger than
the reference (1x2, 2x1) the border's corner pieces fall in the middle of its long sides, so autopaint's solver paints
the inside around the fixed border (a terrace in each half, anything the rules allow between them), and a door whose
passage does not fit what it painted gets a box around it painted again. Every 2x2 window of the result is checked
against the rules and the approved joins (closed, each door open, each gate), so a room that does not fit is refused
here, never in the game.
"""
import hashlib
import json
import os

import autopaint
import tile_rules

AUTO_KEYS = {'frame', 'pieces', 'seeds', 'comment'}
SAVE_CACHE = False      # make_rooms.py turns it on: the solver's paintings are kept in the set's solver_cache.json
CACHE = 'solver_cache.json'


class AutoError(Exception):
    pass


class AutoKit:
    def __init__(self, d, folder, set_dir, where):
        for k in d:
            if k not in AUTO_KEYS:
                raise AutoError('%s: unknown key "%s" in auto (keys: %s)' % (where, k, ', '.join(sorted(AUTO_KEYS))))
        fp = os.path.join(set_dir, d.get('frame', 'frame.json'))
        if not os.path.exists(fp):
            raise AutoError('%s: no frame %s (made with tools/templates/autopaint.py)' % (where, fp))
        self.frame = json.load(open(fp, encoding='utf-8'))
        self.rules = tile_rules.Rules(folder=folder, mirror=self.frame.get('mirror', False), joins=True)
        area = list(self.rules.areas.values())[0]
        self.pieces = {}
        for n, (c, r, w, h) in (d.get('pieces') or {}).items():
            self.pieces[n] = [[area[r + j][c + i] for i in range(w)] for j in range(h)]
        self.gate_dy = self.frame.get('gate_dy', 16)
        self.folder = folder
        self.seeds = d.get('seeds') or {}
        self._solver = None
        # the solver's paintings, by what they were asked (the rules' sources, the joins, the cells and zones): the
        # same question gives the same room, so make_rooms.py and the validator do not paint again
        self.cache_path = os.path.join(set_dir, CACHE)
        self.cache = json.load(open(self.cache_path, encoding='utf-8')) if os.path.exists(self.cache_path) else {}
        self.cache_used = set()
        self.salt = [tile_rules.source_hash(folder), sorted(self.rules.joins), self.seeds]
        G = self.ring = self.frame['ring']
        self.inside = [[G[y][x] for x in range(1, 15)] for y in range(1, 15)]

    # ---------------------------------------------------------------- the room

    def room(self, cw, ch):
        """Blocks of a cw x ch room: the ring's border repeated every 16 blocks, the reference room's inside within
        (its first two and last two rows and columns, the middle repeated)."""
        G = self.ring

        def one(v, n):
            if v < 2:
                return v
            if v >= n - 2:
                return 16 - (n - v)
            return v % 16 if 2 <= v % 16 <= 13 else 7

        def at(x, y):
            if y in (0, ch - 1):
                return G[0 if y == 0 else 15][x % 16]
            if x in (0, cw - 1):
                return G[y % 16][0 if x == 0 else 15]
            return G[one(y, ch)][one(x, cw)]
        return [[at(x, y) for x in range(cw)] for y in range(ch)]

    def passage(self, loc, off, cw, ch):
        """{(x, y): block} a door at px offset off along its wall changes in a cw x ch room."""
        if off == 240:
            key, unit = ('h' if loc in ('Top', 'Bottom') else 'v') + '240', 0
        else:
            key, unit = ('h' if loc in ('Top', 'Bottom') else 'v') + str(off % 256), off // 256
        P = self.frame['passages'].get(key)
        if P is None:
            raise AutoError('the frame has no passage %s' % key)
        PH, PW = len(P), len(P[0])
        ref = self.reference(PW, PH)
        out = {}
        for y in range(PH):
            for x in range(PW):
                if P[y][x] == ref[y][x]:
                    continue
                if loc == 'Top' and y < PH // 2:
                    out[(x + unit * 16, y)] = P[y][x]
                elif loc == 'Bottom' and y >= PH // 2:
                    out[(x + unit * 16, ch - PH + y)] = P[y][x]
                elif loc == 'Left' and x < PW // 2:
                    out[(x, y + unit * 16)] = P[y][x]
                elif loc == 'Right' and x >= PW // 2:
                    out[(cw - PW + x, y + unit * 16)] = P[y][x]
        return out

    def reference(self, W, H):
        return self.room(W, H)

    def gate(self, loc, off, cw, ch):
        """{(x, y): block} of the level's entrance or exit in that door, or None where the frame has none."""
        g = (self.frame.get('gates') or {}).get(loc.lower())
        if not g or off % 256 != g['door'] or (loc == 'Top' and cw != 16):
            return None
        P = g['grid']
        ref = self.room(16, 16)
        unit = off // 256
        out = {}
        for y in range(16):
            for x in range(16):
                if P[y][x] != ref[y][x]:
                    out[(x + unit * 16, y if loc == 'Top' else ch - 16 + y)] = P[y][x]
        return out

    # ---------------------------------------------------------------- the solver

    def solver(self):
        if self._solver is None:
            if not self.seeds:
                raise AutoError('a room larger than the frame needs "seeds" in the kit auto (materials of the area)')
            self._solver = autopaint.Region(None, self.seeds, mirror=self.frame.get('mirror', False), folder=self.folder)
            self._solver.set_joins(sorted(self.rules.joins))
        return self._solver

    def floor_zones(self, cw, ch):
        """The inside a big room's solver keeps as terrace: each 16x16 half's middle, and the middle of the room."""
        rects = []
        for ux in range(cw // 16):
            for uy in range(ch // 16):
                rects.append(('floor', ux * 16 + 2, uy * 16 + 2, ux * 16 + 14, uy * 16 + 14))
        if cw > 16:
            rects.append(('floor', 13, 5, cw - 13, ch - 5))
        if ch > 16:
            rects.append(('floor', 5, 13, cw - 5, ch - 13))
        return autopaint.zone_grid(cw, ch, rects)

    def paint(self, g, fixed, cw, ch, zones=None, lanes=(), what='the room'):
        """g with every cell not in fixed painted by the solver under the rules (zones: the big room's terraces;
        lanes: cells that must be walkable)."""
        z = [row[:] for row in (zones or self.floor_zones(cw, ch))]
        for x, y in lanes:
            z[y][x] = 'lane'
        key = hashlib.sha1(json.dumps([self.salt, cw, ch, z, sorted([x, y, g[y][x]] for x, y in fixed)]).encode()).hexdigest()
        if key in self.cache:
            self.cache_used.add(key)
            return self.cache[key]
        rg = self.solver()
        m, w = rg.domains(z, 'floor')
        fx = {}
        for (x, y) in fixed:
            b = rg.rules.canon[g[y][x]]         # blocks of the same tiles are one for the rules
            fx[(x, y)] = b
            m[y * cw + x] |= 1 << rg.index[b]
        last = None
        for seed in range(6):
            try:
                out = rg.solve(cw, ch, m, w, fixed=fx, seed=seed, max_back=2000)
            except autopaint.PaintError as e:
                last = e
                continue
            self.cache[key] = out
            self.cache_used.add(key)
            return out
        raise AutoError('the solver finds no painting for %s (%s)' % (what, last))

    # ---------------------------------------------------------------- checks

    def misfits(self, grid):
        """The windows and pairs of a block grid that are neither on the maps nor approved joins."""
        return self.rules.check(grid)

    def tiles(self, b):
        """The four 8x8 tiles of block b as (tile, flags): top left, top right, bottom left, bottom right."""
        return [tuple(t) for t in self.rules.blocks[b]]

    def save_cache(self):
        """Writes the paintings this build used (only those: a stale one goes away)."""
        keep = {k: self.cache[k] for k in sorted(self.cache_used)}
        text = '{\n' + ',\n'.join('%s: %s' % (json.dumps(k), json.dumps(v, separators=(',', ':')))
                                  for k, v in keep.items()) + '\n}\n'
        open(self.cache_path, 'w', encoding='utf-8', newline='\n').write(text)
