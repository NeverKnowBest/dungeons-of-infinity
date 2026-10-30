"""Automatic painting of rooms (roadmap F12b-2): zones in, blocks of a region tileset out, under the fitting rules.

A room is described by zones on its grid of 16x16 blocks (floor, wall, grass, water, a passage...). The painter picks
a block for every cell so that every pair and every 2x2 window of blocks was seen on a real map (tile_rules.py), by an
overlapping wave function collapse: each cell keeps the set of blocks it may still take, the windows prune the sets
around each choice, and the cell with the fewest choices is decided next (weighted by how often the ROM uses each
block), backtracking on a dead end.

What the zones decide (docs/dev/engine-notes.md, "Automatic painting"):
* hard: the collision. Every 8x8 tile is a wall or walkable as its zone says, except within 16 px of the border
  between two zones (where the ROM's own wall edges go); a passage ("lane") is walkable in every tile.
* hard: no material of another zone (a wall zone takes no grass). A tile's material comes from its colors, compared
  with the seed blocks the kit names per material; tiles like no seed are "other" and fit any zone of their kind.
* soft: the zone's own material, and how common the block is on the ROM.
Pieces of decoration (a crest, a tower) are cells fixed beforehand; the painter fits the rest around them.

Neighbouring rooms join because every room of a set shares one border (the ring), cut from a room painted on a torus
(its right edge next to its own left edge, its bottom next to its own top): any two rooms side by side meet exactly as
the torus room meets itself. Standard library only (the tiles' colors are read by a small PNG reader).
"""
import json
import os
import random
import struct
import zlib

import tile_rules

TOL = 2            # tiles of free collision on each side of a zone border (16 px)
OWN_WEIGHT = 0.05  # weight factor per tile not of the zone's own material


class PaintError(Exception):
    pass


def read_png(path):
    """(w, h, rows of (r, g, b, a)) of an 8-bit RGB or RGBA PNG without interlace."""
    data = open(path, 'rb').read()
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise PaintError('%s is not a PNG' % path)
    pos, idat, w = 8, b'', 0
    while pos < len(data):
        n, kind = struct.unpack('>I4s', data[pos:pos + 8])
        body = data[pos + 8:pos + 8 + n]
        if kind == b'IHDR':
            w, h, depth, ctype, _, _, inter = struct.unpack('>IIBBBBB', body)
            if depth != 8 or ctype not in (2, 6) or inter:
                raise PaintError('%s: only 8-bit RGB or RGBA PNGs without interlace are read' % path)
        elif kind == b'IDAT':
            idat += body
        pos += n + 12
    bpp = 4 if ctype == 6 else 3
    raw = zlib.decompress(idat)
    stride = w * bpp
    rows, prev, i = [], bytearray(stride), 0
    for _ in range(h):
        f = raw[i]
        line = bytearray(raw[i + 1:i + 1 + stride])
        i += 1 + stride
        for x in range(stride):
            a = line[x - bpp] if x >= bpp else 0
            b = prev[x]
            c = prev[x - bpp] if x >= bpp else 0
            if f == 1:
                line[x] = (line[x] + a) & 255
            elif f == 2:
                line[x] = (line[x] + b) & 255
            elif f == 3:
                line[x] = (line[x] + (a + b) // 2) & 255
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        rows.append([tuple(line[x:x + 3]) + ((line[x + 3],) if bpp == 4 else (255,)) for x in range(0, stride, bpp)])
        prev = line
    return w, h, rows


class Region:
    """A region tileset with its fitting rules and the material of every tile, from the kit's seeds."""

    def __init__(self, region, seeds, where='kit', mirror=False, folder=None):
        self.rules = R = tile_rules.Rules(region, folder=folder, mirror=mirror)
        self.where = where
        w, h, px = read_png(os.path.join(R.folder, 'tiles.png'))
        cols = w // 8
        hist = []
        for t in range(len(R.tile_class)):
            hh = {}
            if t:
                for y in range(8):
                    for x in range(8):
                        p = px[(t // cols) * 8 + y][(t % cols) * 8 + x]
                        if p[3]:
                            hh[p[:3]] = hh.get(p[:3], 0) + 1
            hist.append(hh)
        self.walk_tile = [R.tile_class[t] in tile_rules.WALKABLE for t in range(len(R.tile_class))]
        area = list(R.areas.values())
        seedc, seedw = {}, {}
        for mat, cells in seeds.items():
            colors, nw = set(), 0
            for cell in cells:
                c, r = cell[0], cell[1]
                a = R.areas[cell[2]] if len(cell) > 2 else area[0]
                for t, _ in R.blocks[a[r][c]]:
                    nw += 1 if self.walk_tile[t] else -1
                    colors |= set(hist[t])
            seedc[mat], seedw[mat] = colors, nw > 0
        self.solid_mats = {m for m in seeds if not seedw[m]} | {'other_solid'}
        self.mats = list(seeds)

        def material(t):
            wk, hh = self.walk_tile[t], hist[t]
            tot = sum(hh.values()) or 1
            best, bm = 0.6, 'other' if wk else 'other_solid'
            for m in self.mats:
                if seedw[m] != wk:
                    continue
                s = sum(v for k, v in hh.items() if k in seedc[m]) / tot
                if s > best:
                    best, bm = s, m
            return bm
        self.tile_mat = [material(t) for t in range(len(R.tile_class))]
        self.used = sorted(R.count)                   # blocks seen on the maps: the painter's alphabet
        self.index = {b: i for i, b in enumerate(self.used)}
        self.n = len(self.used)
        self.mat = [tuple(self.tile_mat[t] for t, _ in R.blocks[b]) for b in self.used]
        self.walk = [tuple(self.walk_tile[t] for t, _ in R.blocks[b]) for b in self.used]
        self.freq = [R.count[b] for b in self.used]
        self.joins = []
        self.set_joins([])
        # loose windows: any 2x2 whose four pairs are on the maps (for a first painting that a search then polishes)
        right = {self.index[a]: {self.index[b] for b in v} for a, v in R.right.items()}
        down = {self.index[a]: {self.index[b] for b in v} for a, v in R.down.items()}
        self.by_a_loose = {}
        for a in range(self.n):
            for b in right.get(a, ()):
                for c in down.get(a, ()):
                    for d in right.get(c, ()):
                        if d in down.get(b, ()):
                            self.by_a_loose.setdefault(a, []).append((1 << b, 1 << c, 1 << d))
        self.ALL = (1 << self.n) - 1

    def set_joins(self, joins):
        """The windows the painter may use: those of the maps plus the joins (approved 2x2 windows, block numbers)."""
        self.joins = [tuple(j) for j in joins]
        self.windows = set(self.rules.windows) | set(self.joins)
        self.by_a = {}
        for a, b, c, d in self.windows:
            if all(v in self.index for v in (a, b, c, d)):
                a, b, c, d = (self.index[v] for v in (a, b, c, d))
                self.by_a.setdefault(a, []).append((1 << b, 1 << c, 1 << d))

    def misfits(self, grid, wrap=False):
        """The 2x2 windows of a grid that are neither on the maps nor joins: {(x, y): window}. With wrap, also those
        across the right and bottom edges (where the grid meets itself), except where four copies meet."""
        H, W = len(grid), len(grid[0])
        out = {}
        for y in range(H if wrap else H - 1):
            for x in range(W if wrap else W - 1):
                if wrap and x == W - 1 and y == H - 1:
                    continue
                w = (grid[y][x], grid[y][(x + 1) % W], grid[(y + 1) % H][x], grid[(y + 1) % H][(x + 1) % W])
                if w not in self.windows:
                    out[(x, y)] = w
        return out

    def is_walk_zone(self, z):
        return z not in self.solid_mats

    # ---------------------------------------------------------------- zones

    def domains(self, zones, lane_mat, edge_solid=False):
        """The blocks each cell may take (bit masks) and their weights, from a grid of zone names (material names,
        "lane" for a passage of material lane_mat, "*" for anything). edge_solid: the outermost 8x8 tiles of the
        grid are walls except in a lane (a room's edge, where Link may only leave through a door)."""
        H, W = len(zones), len(zones[0])

        def zone_at(x, y):
            if 0 <= x < W and 0 <= y < H:
                z = zones[y][x]
                return None if z == '*' else (lane_mat if z == 'lane' else z)
            return None

        def walk_at(tx, ty):
            z = zone_at(tx // 2, ty // 2) if 0 <= tx < 2 * W and 0 <= ty < 2 * H else None
            return None if z is None else self.is_walk_zone(z)
        need = {}
        rng = range(-TOL, TOL + 1)
        for ty in range(2 * H):
            for tx in range(2 * W):
                if zones[ty // 2][tx // 2] == 'lane':
                    need[(tx, ty)] = True
                    continue
                if edge_solid is True:
                    edge_solid = 'LRTB'
                if edge_solid and ((tx == 0 and 'L' in edge_solid) or (tx == 2 * W - 1 and 'R' in edge_solid) or
                                   (ty == 0 and 'T' in edge_solid) or (ty == 2 * H - 1 and 'B' in edge_solid)):
                    need[(tx, ty)] = False
                    continue
                v = walk_at(tx, ty)
                if v is not None and all(walk_at(tx + dx, ty + dy) in (v, None) for dx in rng for dy in rng):
                    need[(tx, ty)] = v
        masks, weights = [], []
        for y in range(H):
            for x in range(W):
                z = zone_at(x, y)
                near = {zone_at(x + dx, y + dy) for dx in (-2, -1, 0, 1, 2) for dy in (-2, -1, 0, 1, 2)} - {None}
                nd = [need.get((2 * x + k % 2, 2 * y + k // 2)) for k in range(4)]
                m, ws = 0, {}
                for i in range(self.n):
                    if any(v is not None and v != w for v, w in zip(nd, self.walk[i])):
                        continue
                    if z is not None and any(t not in near and t not in ('other', 'other_solid') for t in self.mat[i]):
                        continue
                    own = 4 if z is None else sum(1 for t in self.mat[i] if t == z)
                    m |= 1 << i
                    ws[i] = self.freq[i] * OWN_WEIGHT ** (4 - own)
                masks.append(m)
                weights.append(ws)
        return masks, weights

    # ---------------------------------------------------------------- solver

    def solve(self, W, H, masks, weights, fixed=None, wrap=False, seed=0, max_back=3000, loose=False):
        """A grid of block numbers (rows), or raises PaintError. fixed: {(x, y): block}. loose: windows need only
        their four pairs on the maps, and each choice avoids windows off the maps (a start for anneal)."""
        dom = list(masks)
        for (x, y), b in (fixed or {}).items():
            if b not in self.index:
                raise PaintError('block %d at %d,%d is not on the maps' % (b, x, y))
            dom[y * W + x] &= 1 << self.index[b]
        empty = [(i % W, i // W) for i, d in enumerate(dom) if not d]
        if empty:
            raise PaintError('no block fits the cells %s' % ', '.join('%d,%d' % c for c in empty[:6]))
        AW, AH = (W, H) if wrap else (W - 1, H - 1)
        by_a = self.by_a_loose if loose else self.by_a

        def cells(ax, ay):
            x1, y1 = (ax + 1) % W, (ay + 1) % H
            return ay * W + ax, ay * W + x1, y1 * W + ax, y1 * W + x1

        def anchors_of(i):
            cx, cy = i % W, i // W
            out = []
            for ax in (cx - 1, cx):
                for ay in (cy - 1, cy):
                    if wrap:
                        out.append((ax % W, ay % H))
                    elif 0 <= ax < AW and 0 <= ay < AH:
                        out.append((ax, ay))
            return out

        def propagate(dom, queue):
            inq = set(queue)
            while queue:
                a_ = queue.pop()
                inq.discard(a_)
                if wrap and a_ == (W - 1, H - 1):
                    continue        # where four copies meet: its pairs are in the windows beside it
                i0, i1, i2, i3 = cells(*a_)
                A, B, C, D = dom[i0], dom[i1], dom[i2], dom[i3]
                na = nb = nc = nd = 0
                rest = A
                while rest:
                    low = rest & -rest
                    rest ^= low
                    for mb, mc, md in by_a.get(low.bit_length() - 1, ()):
                        if B & mb and C & mc and D & md:
                            na |= low
                            nb |= mb
                            nc |= mc
                            nd |= md
                if not na:
                    self.dead_end = a_
                    return False
                for i, old, new in ((i0, A, na), (i1, B, nb), (i2, C, nc), (i3, D, nd)):
                    if new != old:
                        dom[i] = new
                        for an in anchors_of(i):
                            if an not in inq:
                                inq.add(an)
                                queue.append(an)
            return True

        if not propagate(dom, [(x, y) for y in range(AH) for x in range(AW)]):
            raise PaintError('the zones and the fixed cells have no fitting (first dead end at the 2x2 from %d,%d)' % self.dead_end)
        rnd = random.Random(seed)
        stack, backs = [], 0
        while True:
            best, bi = None, -1
            for i, d in enumerate(dom):
                if d & (d - 1):
                    k = bin(d).count('1') + rnd.random() * 0.5
                    if best is None or k < best:
                        best, bi = k, i
            if bi < 0:
                break
            d = dom[bi]
            opts = [b for b in range(self.n) if (d >> b) & 1]
            ws = [weights[bi].get(b, self.freq[b] * OWN_WEIGHT ** 4) for b in opts]
            if loose:
                ws = [wt * 0.0001 ** self.novel_at(dom, W, H, wrap, bi, b) for wt, b in zip(ws, opts)]
            pick = rnd.choices(opts, ws)[0]
            stack.append((list(dom), bi, pick))
            dom[bi] = 1 << pick
            ok = propagate(dom, anchors_of(bi))
            while not ok:
                backs += 1
                if backs > max_back or not stack:
                    raise PaintError('no fitting found (gave up after %d backtracks)' % backs)
                dom, bi, pick = stack.pop()
                dom[bi] &= ~(1 << pick)
                ok = bool(dom[bi]) and propagate(dom, anchors_of(bi))
        return [[self.used[dom[y * W + x].bit_length() - 1] for x in range(W)] for y in range(H)]

    def novel_at(self, dom, W, H, wrap, i, b):
        """How many decided 2x2 windows around cell i would be off the maps with block b (index) there."""
        cx, cy = i % W, i // W
        n = 0
        for ax in (cx - 1, cx):
            for ay in (cy - 1, cy):
                if wrap:
                    ax, ay = ax % W, ay % H
                    if (ax, ay) == (W - 1, H - 1):
                        continue
                elif not (0 <= ax < W - 1 and 0 <= ay < H - 1):
                    continue
                q = []
                for x, y in ((ax, ay), ((ax + 1) % W, ay), (ax, (ay + 1) % H), ((ax + 1) % W, (ay + 1) % H)):
                    j = y * W + x
                    if j == i:
                        q.append(b)
                    else:
                        d = dom[j]
                        if d & (d - 1):
                            break
                        q.append(d.bit_length() - 1)
                else:
                    if tuple(self.used[v] for v in q) not in self.windows:
                        n += 1
        return n

    # ---------------------------------------------------------------- checks

    def reach(self, grid, start, wrap=False):
        """8x8 tiles walkable from start (tx, ty)."""
        H, W = len(grid) * 2, len(grid[0]) * 2
        R = self.rules

        def walk(tx, ty):
            return self.walk_tile[R.blocks[grid[ty // 2][tx // 2]][(ty % 2) * 2 + tx % 2][0]]
        if not walk(*start):
            return set()
        seen, todo = {start}, [start]
        while todo:
            x, y = todo.pop()
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if wrap:
                    n = (n[0] % W, n[1] % H)
                if 0 <= n[0] < W and 0 <= n[1] < H and n not in seen and walk(*n):
                    seen.add(n)
                    todo.append(n)
        return seen


def zone_grid(W, H, rects, base='*'):
    """Rows of zone names: base everywhere, then each (zone, x0, y0, x1, y1) rectangle of cells over it."""
    z = [[base] * W for _ in range(H)]
    for name, x0, y0, x1, y1 in rects:
        for y in range(max(0, y0), min(H, y1)):
            for x in range(max(0, x0), min(W, x1)):
                z[y][x] = name
    return z


def cache_key(*parts):
    import hashlib
    return hashlib.sha1(json.dumps(parts, sort_keys=True).encode()).hexdigest()[:20]


def anneal(region, W, H, masks, fixed=None, wrap=False, seed=0, steps=200000, type_cost=6.0, start=None, forbid=(),
           pairs_only=True):
    """A grid that keeps the zones (masks, hard) with as few 2x2 windows off the maps as it can find: simulated
    annealing over single cells, each window off the maps costing 1 and each new kind of window type_cost more.
    Returns (grid, {window: count}) of the windows it still needs (the joins to propose). forbid: windows refused
    before (they cost as much as fifty new ones). pairs_only: a window off the maps whose four pairs are not all on the
    maps costs as much too (a join may only be a new corner of pieces that already meet two by two: a wall cut
    straight against the floor is a pair the maps never show)."""
    rg = region
    rnd = random.Random(seed)
    allowed = rg.windows
    doms = []
    for i, m in enumerate(masks):
        x, y = i % W, i // W
        if fixed and (x, y) in fixed:
            doms.append([fixed[(x, y)]])
        else:
            doms.append([rg.used[b] for b in range(rg.n) if (m >> b) & 1])
    if any(not d for d in doms):
        raise PaintError('no block fits the cells %s' % [(i % W, i // W) for i, d in enumerate(doms) if not d][:6])
    if start:
        g = [start[i // W][i % W] if start[i // W][i % W] in doms[i] else doms[i][0] for i in range(W * H)]
    else:
        g = [rnd.choice(d) for d in doms]
    AW, AH = (W, H) if wrap else (W - 1, H - 1)

    def win(ax, ay):
        x1, y1 = (ax + 1) % W, (ay + 1) % H
        return (g[ay * W + ax], g[ay * W + x1], g[y1 * W + ax], g[y1 * W + x1])

    def anchors(i):
        cx, cy = i % W, i // W
        out = []
        for ax in (cx - 1, cx):
            for ay in (cy - 1, cy):
                if wrap:
                    a = (ax % W, ay % H)
                    if a != (W - 1, H - 1):
                        out.append(a)
                elif 0 <= ax < AW and 0 <= ay < AH:
                    out.append((ax, ay))
        return out
    kinds = {}
    bad = set()
    for ay in range(AH):
        for ax in range(AW):
            if wrap and (ax, ay) == (W - 1, H - 1):
                continue
            w = win(ax, ay)
            if w not in allowed:
                bad.add((ax, ay))
                kinds[w] = kinds.get(w, 0) + 1
    free = [i for i in range(W * H) if len(doms[i]) > 1]
    if not free:
        return [[g[y * W + x] for x in range(W)] for y in range(H)], dict(kinds)

    forbid = set(map(tuple, forbid))

    right, down = rg.rules.right, rg.rules.down

    def pairs_ok(w):
        a, b, c, d = w
        return b in right.get(a, ()) and d in right.get(c, ()) and c in down.get(a, ()) and d in down.get(b, ())

    def cost_of(ws):
        c = 0.0
        for w in ws:
            if w not in allowed:
                c += 1 + (50 * type_cost if w in forbid or (pairs_only and not pairs_ok(w)) else 0)
        return c
    best = (len(bad) + type_cost * len(kinds), list(g), dict(kinds))
    T0, T1 = 2.0, 0.02
    for step in range(steps):
        if not bad:
            break
        T = T0 * (T1 / T0) ** (step / steps)
        if rnd.random() < 0.85:
            ax, ay = rnd.choice(tuple(bad))
            cand = [i for i in ((ay * W + ax), (ay * W + (ax + 1) % W), (((ay + 1) % H) * W + ax),
                                (((ay + 1) % H) * W + (ax + 1) % W)) if len(doms[i]) > 1]
            if not cand:
                continue
            i = rnd.choice(cand)
        else:
            i = rnd.choice(free)
        old = g[i]
        new = rnd.choice(doms[i])
        if new == old:
            continue
        ans = anchors(i)
        before = [win(*a) for a in ans]
        g[i] = new
        after = [win(*a) for a in ans]
        delta = cost_of(after) - cost_of(before)
        dk = {}
        for w in before:
            if w not in allowed:
                dk[w] = dk.get(w, 0) - 1
        for w in after:
            if w not in allowed:
                dk[w] = dk.get(w, 0) + 1
        for w, d in dk.items():
            n0 = kinds.get(w, 0)
            if n0 == 0 and d > 0:
                delta += type_cost
            elif n0 > 0 and n0 + d == 0:
                delta -= type_cost
        if delta <= 0 or rnd.random() < pow(2.718281828, -delta / T):
            for w, d in dk.items():
                n = kinds.get(w, 0) + d
                if n:
                    kinds[w] = n
                else:
                    kinds.pop(w, None)
            for a, w in zip(ans, after):
                if w in allowed:
                    bad.discard(a)
                else:
                    bad.add(a)
            score = len(bad) + type_cost * len(kinds)
            if score < best[0]:
                best = (score, list(g), dict(kinds))
        else:
            g[i] = old
    _, g, kinds = best
    return [[g[y * W + x] for x in range(W)] for y in range(H)], kinds
