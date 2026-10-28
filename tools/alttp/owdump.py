"""Reads the ALttP overworld straight from the ROM (roadmap F12a).

No compiler needed: the ROM addresses and name tables come from zelda3's own
asset scripts (`assets/util.py`, `assets/tables.py`, `assets/extract_resources.py`),
and the logic mirrors zelda3's `src/overworld.c`, `src/load_gfx.c` and
`src/tile_detect.c`. Usage:

  python tools/alttp/owdump.py areas                  # one line per area
  python tools/alttp/owdump.py area 0x1b              # header, entrances, secrets, sprites, attribute map
  python tools/alttp/owdump.py edges                  # openings between neighbouring areas
  python tools/alttp/owdump.py stats [--world light]  # composition: attributes, ledges, bushes, map16/map32 counts
  python tools/alttp/owdump.py png 0x1b [0x2c ...]    # render areas (needs Pillow)
  python tools/alttp/owdump.py world [--world dark] [--scale 0.25]
  python tools/alttp/owdump.py vocab [--world light] [--top 64]   # most used map32 blocks, rendered
  python tools/alttp/owdump.py tiles 0x1b --region topo-do-castelo  # cut the blocks into a region tileset (F6b)

Options: --zelda3 <dir> (default: $ZELDA3_DIR, else the zelda3 folder next to the
repository), --rom <file> (default: <zelda3>/zelda3.sfc), --out <dir> (default
tools/alttp/out). Area numbers: 0x00-0x3f light world, 0x40-0x7f dark world,
0x80-0x9f special areas (Master Sword grove, Zora's waterfall...).
"""
import argparse
import os
import re
import sys
from collections import Counter

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(REPO, 'tools', 'alttp', 'out')

# --- zelda3 -----------------------------------------------------------------

def load_zelda3(zdir, rom):
    zdir = zdir or os.environ.get('ZELDA3_DIR') or os.path.join(os.path.dirname(REPO), 'zelda3')
    assets = os.path.join(zdir, 'assets')
    if not os.path.isfile(os.path.join(assets, 'util.py')):
        sys.exit('zelda3 not found at %s (use --zelda3 or ZELDA3_DIR)' % zdir)
    sys.path.insert(0, assets)
    global util, tables, SRC
    import util, tables  # noqa: E402  (zelda3's own scripts)
    rom = rom or os.path.join(zdir, 'zelda3.sfc')
    if not os.path.isfile(rom):
        sys.exit('ROM not found at %s (use --rom)' % rom)
    util.load_rom(rom)
    SRC = os.path.join(zdir, 'src')


def c_array(fname, name):
    """Numbers of a C array initializer in zelda3's source."""
    text = open(os.path.join(SRC, fname), encoding='utf8').read()
    m = re.search(r'\b%s\[[^\]]*\](?:\[[^\]]*\])?\s*=\s*\{(.*?)\};' % re.escape(name), text, re.S)
    return [int(v, 0) for v in re.findall(r'-?(?:0x[0-9a-fA-F]+|\d+)', m.group(1))]

# --- ROM tables (addresses from zelda3 assets/extract_resources.py) --------

def b(ea): return util.get_byte(ea)
def w(ea): return util.get_word(ea)
def s8(ea): return util.get_int8(ea)


def area_heads(): return util.get_bytes(0x82A5EC, 64)
def is_small(a): return util.get_bytes(0x82F88D, 192)[a & 0x3f] != 0


def heads():
    h = area_heads()
    return [a for a in range(160) if a >= 128 or h[a & 63] == (a & 63)]


def area_name(a):
    return tables.kAreaNames[a].split(':', 1)[1].strip() if ':' in tables.kAreaNames[a] else tables.kAreaNames[a]


def music(a):
    def fn(x, amb):
        return tables.kAmbientSoundName.get(x >> 4, x >> 4) if amb else tables.kMusicNames.get(x & 0xf, x & 0xf)
    if a < 64:
        stages = [b(0x82C303 + a + 64 * i) for i in range(4)]
        return [(fn(x, False), fn(x, True)) for x in stages]
    if a < 160:
        x = b(0x82C403 + a - 64)
        return [(fn(x, False), fn(x, True))]
    return []


def entrances():
    r = {}
    for i in range(129):
        pos = w(0x9BBA71 + i * 2)
        r.setdefault(w(0x9BB96F + i * 2), []).append(((pos >> 1) & 0x3f, (pos >> 7) & 0x3f, b(0x9BBB73 + i)))
    return r


def holes():
    r = {}
    for i in range(19):
        pos = w(0x9BB800 + i * 2) + 0x400
        r.setdefault(w(0x9BB826 + i * 2), []).append(((pos >> 1) & 0x3f, (pos >> 7) & 0x3f, b(0x9BB84C + i)))
    return r


def exits():
    """Where Link comes out when leaving a room (to the overworld): screen, room, position."""
    r = {}
    for i in range(79):
        room, screen = w(0x82DD8A + i * 2), b(0x82DE28 + i)
        x = w(0x82E0EF + i * 2) - ((screen & 7) << 9)
        y = w(0x82E051 + i * 2) - ((screen & 56) << 6)
        ndoor, fdoor = w(0x82E367 + i * 2), w(0x82E405 + i * 2)
        door = ''
        if ndoor: door = 'bombable' if ndoor & 0x8000 else 'wooden'
        if fdoor: door = 'palace' if fdoor & 0x8000 else 'sanctuary'
        r.setdefault(screen, []).append((room, x, y, door))
    return r


def secrets(a):
    if a >= 128: return []
    ea = 0x9B0000 | w(0x9BC2F9 + a * 2)
    out = []
    while w(ea) != 0xffff:
        pos = w(ea) // 2
        out.append((pos % 64, pos // 64, tables.kSecretNames[b(ea + 2)][3:]))
        ea += 3
    return out


SPRITE_STAGES = [('beginning', 0x89C881), ('first part', 0x89C901), ('second part', 0x89CA21)]


def sprites(a):
    """{stage: [(x16, y16, name)]}; dark world and special areas have one list."""
    def dec(base):
        ea = 0x890000 + w(base + a * 2)
        out = []
        while b(ea) != 0xff:
            y, x, t = b(ea), b(ea + 1), b(ea + 2)
            out.append((x, y, tables.kSpriteNames[t][3:] or tables.kSpriteNames[t]))
            ea += 3
        return out
    if a < 64: return {n: dec(base) for n, base in SPRITE_STAGES}
    if a < 144: return {'all': dec(0x89CA21)}
    return {}


NPC_WORDS = ('Person', 'Man', 'Boy', 'Girl', 'Woman', 'Priest', 'Zelda', 'Smith', 'Sign', 'Kid', 'Teller', 'Witch',
             'Lumberjack', 'Brother', 'Kiki', 'Chicken', 'Fairy', 'Item', 'Heart', 'Rupee', 'Waterfall', 'Bully',
             'Squirrel', 'Bird', 'Animal', 'Rabbit', 'MasterSwd', 'Tablet', 'Door', 'Pipe', 'Whirlpool', 'Inscription',
             'Ostrich', 'Flute', 'Thief', 'ScaredGirl', 'Uncle', 'DashItem', 'Pond', 'Apples', 'Shop', 'Blind',
             'Mushroom', 'Bunny', 'Mantle', 'OldMan', 'Dust', 'Tent', 'Farm', 'Hedge', 'Fortune', 'Runner', 'Bottle',
             'Digging', 'Kodondo', 'Good-Bee', 'Lighting', 'Agah', 'Statue', 'Telep', 'PullFor', 'Useless', 'Hylia',
             'SickBoy', 'BombShop', 'Viterous', 'Arrow', 'Bomb', 'Magic', 'Key', 'Zora', 'Fish', 'Mouldrum')


def is_enemy(name):
    return not any(k.lower() in name.lower() for k in NPC_WORDS) and not name.startswith('1')  # 1xx: overlords

# --- map32 / map16 / map8 ---------------------------------------------------

_m32 = None
def map32_to_map16():
    global _m32
    if _m32 is None:
        tabs = []
        for base in (0x838000, 0x83B400, 0x848000, 0x84B400):
            t = []
            for i in range(2218):
                ov = util.get_bytes(base + i * 6, 6)
                t += [ov[0] | (ov[4] >> 4) << 8, ov[1] | (ov[4] & 0xf) << 8,
                      ov[2] | (ov[5] >> 4) << 8, ov[3] | (ov[5] & 0xf) << 8]
            tabs.append(t)
        _m32 = tabs  # [TL, TR, BL, BR][map32]
    return _m32


_m16 = None
def map16_to_map8():
    global _m16
    if _m16 is None:
        _m16 = util.get_words(0x8F8000, 3752 * 4)  # 4 words per map16: TL, TR, BL, BR
    return _m16


_attr = None
def map8_attr():
    global _attr
    if _attr is None:
        _attr = util.get_bytes(0x8E9459, 512)
    return _attr


def screen_map32(screen):
    """16x16 map32 indices of one 512x512 screen (zelda3 Overworld_DecompressAndDrawOneQuadrant)."""
    hi = util.decomp(util.ROM.get_24(0x82F94D + screen * 3), util.get_byte, True)
    lo = util.decomp(util.ROM.get_24(0x82FB2D + screen * 3), util.get_byte, True)
    return [lo[i] | hi[i] << 8 for i in range(256)]


def area_map16(a):
    """Map16 grid of an area: 32x32 (small) or 64x64 (big), as a list of rows."""
    big = a < 128 and not is_small(a)
    n = 2 if big else 1
    t = map32_to_map16()
    grid = [[0] * (32 * n) for _ in range(32 * n)]
    for qy in range(n):
        for qx in range(n):
            m = screen_map32(a + qx + qy * 8)
            for j in range(16):
                for i in range(16):
                    v = m[j * 16 + i]
                    x, y = qx * 32 + i * 2, qy * 32 + j * 2
                    grid[y][x], grid[y][x + 1] = t[0][v], t[1][v]
                    grid[y + 1][x], grid[y + 1][x + 1] = t[2][v], t[3][v]
    return grid


def area_map32(a):
    big = a < 128 and not is_small(a)
    n = 2 if big else 1
    out = []
    for qy in range(n):
        for qx in range(n):
            out += screen_map32(a + qx + qy * 8)
    return out


def attr_grid(m16):
    """8x8 tile attributes (zelda3 Overworld_GetTileAttributeAtLocation)."""
    t, at = map16_to_map8(), map8_attr()
    h, wd = len(m16) * 2, len(m16[0]) * 2
    g = [[0] * wd for _ in range(h)]
    for y, row in enumerate(m16):
        for x, v in enumerate(row):
            for k in range(4):
                m8 = t[v * 4 + k]
                a = at[m8 & 0x1ff]
                if 0x10 <= a < 0x1c: a |= (m8 >> 14) & 1
                g[y * 2 + k // 2][x * 2 + k % 2] = a
    return g

# --- attribute classes (zelda3 TileDetect_ExecuteInner) ----------------------

WALK = {0x00, 0x05, 0x06, 0x07, 0x14, 0x15, 0x16, 0x17, 0x21, 0x23, 0x24, 0x25, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x41,
        0x45, 0x47, 0x49, 0x5e, 0x5f, 0x61, 0x62, 0x64, 0x65, 0x66, 0xa6, 0xa7, 0xbe, 0xbf, 0x0a, 0x0c, 0x6c, 0x6d,
        0x6e, 0x6f} | set(range(0xd0, 0xf0))

CLASSES = [  # (char, name, attributes)
    ('.', 'floor (path, dirt, plain ground)', WALK),
    ('#', 'solid', {0x01, 0x02, 0x03, 0x26, 0x43, 0x27}),
    ('z', 'slope (diagonal wall)', set(range(0x10, 0x1c))),
    ('~', 'deep water', {0x08, 0x0b}),
    (',', 'shallow water', {0x09}),
    ('"', 'thick grass', {0x40, 0x04}),
    ('^', 'ledge, jump north', {0x28}),
    ('v', 'ledge, jump south', {0x29}),
    ('<', 'ledge, jump west', {0x2a}),
    ('>', 'ledge, jump east', {0x2b}),
    ('/', 'ledge, diagonal (2c, 2e north; 2d, 2f south)', {0x2c, 0x2d, 0x2e, 0x2f}),
    ('b', 'bush (liftable 50, 51)', {0x50, 0x51}),
    ('r', 'rock (liftable 52, 53)', {0x52, 0x53}),
    ('s', 'liftable 54 (sign)', {0x54}),
    ('R', 'big rock (liftable 55, 56)', {0x55, 0x56}),
    ('B', 'bonk rocks (dash)', {0x57}),
    ('O', 'pit / hole', {0x20} | set(range(0xb0, 0xbe))),
    ('H', 'stairs', {0x22} | set(range(0x30, 0x38)) | {0x1d, 0x1e, 0x1f, 0x3d, 0x3e, 0x3f}),
    ('E', 'entrance', {0x8e, 0x8f}),
    ('d', 'grass (diggable ground)', {0x48, 0x4a}),
    ('W', 'warp', {0x4b}),
    ('x', 'spike / cactus', {0x44, 0x0d}),
    ('T', 'gravestone', {0x42}),
    ('P', 'plaque', {0x46}),
    ('c', 'chest', set(range(0x58, 0x5e)) | {0x63}),
    ('+', 'other', set()),
]
CHAR = {}
for ch, _, s in CLASSES:
    for v in s: CHAR.setdefault(v, ch)
def cls(a): return CHAR.get(a, '+')
NAME = {ch: n for ch, n, _ in CLASSES}
# short names of the classes, the ones a region tileset carries (tiles.json "classes", the game's collision source)
KEY = {'.': 'floor', '#': 'solid', 'z': 'slope', '~': 'deep_water', ',': 'shallow_water', '"': 'tall_grass',
       '^': 'ledge_n', 'v': 'ledge_s', '<': 'ledge_w', '>': 'ledge_e', '/': 'ledge_diag', 'b': 'bush', 'r': 'rock',
       's': 'sign', 'R': 'big_rock', 'B': 'bonk', 'O': 'pit', 'H': 'stairs', 'E': 'entrance', 'd': 'dig', 'W': 'warp',
       'x': 'spike', 'T': 'grave', 'P': 'plaque', 'c': 'chest', '+': 'other'}
PASSABLE = set('."",bEHdW^v<>/')  # walkable or crossed by a jump

# --- commands ---------------------------------------------------------------

def hx(a): return '%02X' % a


def cmd_areas(args):
    ent, hol = entrances(), holes()
    ex = exits()
    print('area size name                         music by stage (beginning/zelda/sword/agahnim)       ent hol sec enemies')
    for a in heads():
        sz = 'big  ' if a < 128 and not is_small(a) else 'small'
        mus = '/'.join(m + ('+' + amb if amb not in ('None', 'Stop') else '') for m, amb in music(a))
        spr = sprites(a)
        en = '/'.join(str(sum(1 for s in v if is_enemy(s[2]))) for v in spr.values())
        print('%s  %s %-28s %-52s %3d %3d %3d %s' % (hx(a), sz, area_name(a)[:28], mus[:52], len(ent.get(a, [])),
              len(hol.get(a, [])), len(secrets(a)), en))


def cmd_area(args):
    for a in args.areas:
        a = int(a, 0)
        print('== %s %s (%s)' % (hx(a), area_name(a), 'big' if a < 128 and not is_small(a) else 'small'))
        print('music:', music(a))
        print('aux tileset %d, bg palette %d' % (b(0x80FC9C + a), b(0x80FD1C + a)) if a < 128 else '')
        for x, y, e in entrances().get(a, []): print('entrance %3d at map16 (%d, %d)' % (e, x, y))
        for x, y, e in holes().get(a, []): print('hole     %3d at map16 (%d, %d)' % (e, x, y))
        for room, x, y, door in exits().get(a, []): print('exit from room %03X to (%d, %d) %s' % (room, x, y, door))
        for x, y, s in secrets(a): print('secret %-12s at map16 (%d, %d)' % (s, x, y))
        for st, lst in sprites(a).items():
            print('sprites %s: %s' % (st, ', '.join('%s(%d,%d)' % (n, x, y) for x, y, n in lst)))
        g = attr_grid(area_map16(a))
        print('attributes, one char per 16x16 (the most telling of its four 8x8 tiles):')
        order = 'EHO~^v<>/bBrRsTdWxcPz",#+.'
        for y in range(0, len(g), 2):
            row = ''
            for x in range(0, len(g[0]), 2):
                cs = [cls(g[y][x]), cls(g[y][x + 1]), cls(g[y + 1][x]), cls(g[y + 1][x + 1])]
                row += min(cs, key=order.index)
            print(row)
        print('legend:', ', '.join('%s %s' % (ch, n) for ch, n, _ in CLASSES))


def openings(a, side):
    """Passable runs (in px) along one side of an area, from its attribute map."""
    g = attr_grid(area_map16(a))
    h, wd = len(g), len(g[0])
    if side == 'N': line = [g[0][x] for x in range(wd)]
    elif side == 'S': line = [g[h - 1][x] for x in range(wd)]
    elif side == 'W': line = [g[y][0] for y in range(h)]
    else: line = [g[y][wd - 1] for y in range(h)]
    return [cls(v) for v in line]


def runs(mask):
    out, start = [], None
    for i, v in enumerate(mask + [False]):
        if v and start is None: start = i
        if not v and start is not None:
            out.append((start * 8, (i - start) * 8)); start = None
    return out


def cmd_edges(args):
    """Openings between an area and its neighbours: offset+width in px along the shared side (light world by default).
    A walk opening is passable on both sides (floor, grass, ledges); swim needs deep water on at least one side."""
    base = 0x40 if args.world == 'dark' else 0
    hd = area_heads()
    widths = []
    for a in [x for x in heads() if base <= x < base + 64]:
        g = a & 63
        n = 2 if not is_small(a) else 1
        parts = []
        for side, dx, dy in (('E', n, 0), ('S', 0, n)):
            for k in range(n):
                cx, cy = (g & 7) + dx + (k if side == 'S' else 0), (g >> 3) + dy + (k if side == 'E' else 0)
                if cx > 7 or cy > 7: continue
                nb = base + hd[cy * 8 + cx]
                mine = openings(a, side)
                other = openings(nb, 'W' if side == 'E' else 'N')
                seg = mine[k * 64:(k + 1) * 64]
                # neighbour's matching slice: its side covers its own extent
                ng = nb & 63
                off = ((g >> 3) + k - (ng >> 3)) if side == 'E' else ((g & 7) + k - (ng & 7))
                oseg = other[off * 64:(off + 1) * 64]
                walk = runs([x in PASSABLE and y in PASSABLE for x, y in zip(seg, oseg)])
                swim = runs([x in '~,' and y in '~,' and not (x == ',' and y == ',') for x, y in zip(seg, oseg)])
                widths += [r[1] for r in walk]
                txt = ' '.join('%d+%d' % r for r in walk if r[1] >= 16)
                txt += ''.join(' swim %d+%d' % r for r in swim if r[1] >= 16)
                parts.append('%s->%s %s' % (side, hx(nb), txt.strip() or 'closed'))
        print('%s %-24s %s' % (hx(a), area_name(a)[:24], ' | '.join(parts)))
    widths = [x for x in widths if x >= 16]  # an 8 px gap is a seam between two pieces, not a way through
    if widths:
        c = Counter((x // 16) * 16 for x in widths)
        print('opening widths (px, rounded down to 16):', ', '.join('%d:%d' % kv for kv in sorted(c.items())))


def components(g, chars):
    """Connected groups (4-way) of 8x8 tiles whose class is in chars: list of sizes in tiles."""
    h, wd = len(g), len(g[0])
    seen = [[False] * wd for _ in range(h)]
    sizes = []
    for y in range(h):
        for x in range(wd):
            if seen[y][x] or cls(g[y][x]) not in chars: continue
            st, n = [(x, y)], 0
            seen[y][x] = True
            while st:
                cx, cy = st.pop(); n += 1
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < wd and 0 <= ny < h and not seen[ny][nx] and cls(g[ny][nx]) in chars:
                        seen[ny][nx] = True; st.append((nx, ny))
            sizes.append(n)
    return sizes


def cmd_stats(args):
    base = 0x40 if args.world == 'dark' else 0
    total = Counter()
    m16all, m32all = set(), Counter()
    print('area name                     map16 map32 floor solid water grass ledge bush rock  bush groups (16x16 cells)')
    for a in [x for x in heads() if base <= x < base + 64]:
        m16 = area_map16(a)
        g = attr_grid(m16)
        c = Counter(cls(v) for row in g for v in row)
        total.update(c)
        n = sum(c.values())
        u16 = {v for row in m16 for v in row}
        m16all |= u16
        m32 = area_map32(a)
        m32all.update(m32)
        pct = lambda chs: 100.0 * sum(c[ch] for ch in chs) / n
        bushes = sorted(Counter(s // 4 for s in components(g, 'b')).items())
        print('%s %-24s %5d %5d %4.0f%% %4.0f%% %4.0f%% %4.0f%% %4.1f%% %3.1f%% %3.1f%%  %s' % (
            hx(a), area_name(a)[:24], len(u16), len(set(m32)), pct('.'), pct('#z'), pct('~,'), pct('"'),
            pct('^v<>/'), pct('b'), pct('rRB'), ' '.join('%dx%d' % kv for kv in bushes)))
    n = sum(total.values())
    print('world: %d distinct map16, %d distinct map32' % (len(m16all), len(m32all)))
    print('classes:', ', '.join('%s %s %.1f%%' % (ch, NAME[ch], 100.0 * v / n) for ch, v in total.most_common()))
    top = m32all.most_common(20)
    print('most used map32 blocks:', ', '.join('%d x%d' % kv for kv in top))

# --- rendering ----------------------------------------------------------------

def snes_rgb(c):
    return ((c & 31) * 255 // 31, (c >> 5 & 31) * 255 // 31, (c >> 10 & 31) * 255 // 31)


_sheets = {}
def bg_sheet(i, high):
    """64 tiles of a BG graphics pack as 8x8 lists of colour indexes (0-15)."""
    key = (i, high)
    if key not in _sheets:
        data = util.decomp(tables.kCompBgPtrs[i], util.get_byte, False)
        tiles = []
        for t in range(64):
            d = data[t * 24:t * 24 + 24]
            px = []
            for r in range(8):
                p0, p1, p2 = d[2 * r] if len(d) > 2 * r else 0, d[2 * r + 1] if len(d) > 2 * r + 1 else 0, d[16 + r] if len(d) > 16 + r else 0
                row = []
                for bit in range(7, -1, -1):
                    v = (p0 >> bit & 1) | (p1 >> bit & 1) << 1 | (p2 >> bit & 1) << 2
                    if high and v: v |= 8
                    row.append(v)
                px.append(row)
            tiles.append(px)
        _sheets[key] = tiles
    return _sheets[key]


def area_tiles(a):
    """512 BG tiles in VRAM order for an area (zelda3 InitializeTilesets with main theme 0x20/0x21)."""
    main = c_array('load_gfx.c', 'kMainTilesets')
    aux = c_array('load_gfx.c', 'kAuxTilesets')
    mt_i = 0x21 if a & 0x40 else 0x20
    mt = main[mt_i * 8:mt_i * 8 + 8]
    at_i = b(0x80FC9C + a) if a < 128 else b(0x80FC9C + (a & 0x3f))
    at = aux[at_i * 4:at_i * 4 + 4]
    packs = [mt[0], mt[1], mt[2]] + [at[k] or mt[3 + k] for k in range(4)] + [mt[7]]
    slots = [7, 6, 5, 4, 3, 2, 1, 0]
    tiles = []
    for p, s in zip(packs, slots):
        tiles += bg_sheet(p, s in (7, 2, 3, 4))
    return tiles


def area_palette(a):
    """256 colours of CGRAM for an area (zelda3 Overworld_LoadAllPalettes + Overworld_LoadPalettes)."""
    pal = [0] * 256
    sc = a & 0x3f
    mode = (2 if sc in (3, 5, 7) else 0) + (1 if a & 0x40 else 0)
    info = c_array('load_gfx.c', 'kOwBgPalInfo')
    bgp = b(0x80FD1C + a) if a < 136 else 0
    aux1, aux2, aux3 = 3, 3, 0
    d = info[bgp * 3:bgp * 3 + 3]
    if d[0] >= 0: aux1 = d[0]
    if d[1] >= 0: aux2 = d[1]
    if d[2] >= 0: aux3 = d[2]
    main = util.get_words(0x9BE6C8, 210)
    aux12 = util.get_words(0x9BE86C, 420)
    aux3t = util.get_words(0x9BE604, 98)

    def multiple(src, off, dst, x_ents, y_pals):
        for r in range(y_pals + 1):
            for k in range(x_ents + 1):
                pal[(dst >> 1) + r * 16 + k] = src[off + r * (x_ents + 1) + k]
    multiple(main, mode * 35, 0x42, 6, 4)
    multiple(aux12, aux1 * 21, 0x52, 6, 2)
    multiple(aux12, aux2 * 21, 0xB2, 6, 2)
    for k in range(7): pal[(0xE2 >> 1) + k] = aux3t[aux3 * 7 + k]
    back = 0x2A32 if a & 0x40 else 0x2669
    return [snes_rgb(c) for c in pal], snes_rgb(back)


def render_map16(img, m16, tiles, pal, back, ox=0, oy=0):
    t = map16_to_map8()
    px = img.load()
    for y, row in enumerate(m16):
        for x, v in enumerate(row):
            for k in range(4):
                m8 = t[v * 4 + k]
                tile = tiles[m8 & 0x1ff] if (m8 & 0x3ff) < 512 else None
                p = (m8 >> 10) & 7
                hf, vf = m8 >> 14 & 1, m8 >> 15 & 1
                bx, by = ox + x * 16 + (k % 2) * 8, oy + y * 16 + (k // 2) * 8
                for r in range(8):
                    for c in range(8):
                        ci = tile[7 - r if vf else r][7 - c if hf else c] if tile else 0
                        px[bx + c, by + r] = pal[p * 16 + ci] if ci else back


def need_pil():
    try:
        from PIL import Image
        return Image
    except ImportError:
        sys.exit('rendering needs Pillow: python -m pip install --user pillow')


def render_area(a):
    Image = need_pil()
    m16 = area_map16(a)
    img = Image.new('RGB', (len(m16[0]) * 16, len(m16) * 16))
    pal, back = area_palette(a)
    render_map16(img, m16, area_tiles(a), pal, back)
    return img


def cmd_png(args):
    os.makedirs(args.out, exist_ok=True)
    for a in args.areas:
        a = int(a, 0)
        img = render_area(a)
        if args.scale != 1:
            img = img.resize((int(img.width * args.scale), int(img.height * args.scale)))
        f = os.path.join(args.out, 'ow_%s.png' % hx(a))
        img.save(f)
        print(f)


def cmd_world(args):
    Image = need_pil()
    base = 0x40 if args.world == 'dark' else 0
    img = Image.new('RGB', (4096, 4096))
    for a in [x for x in heads() if base <= x < base + 64]:
        g = a & 63
        img.paste(render_area(a), ((g & 7) * 512, (g >> 3) * 512))
    if args.scale != 1:
        img = img.resize((int(4096 * args.scale), int(4096 * args.scale)))
    os.makedirs(args.out, exist_ok=True)
    f = os.path.join(args.out, 'ow_world_%s.png' % args.world)
    img.save(f)
    print(f)


def cmd_vocab(args):
    """Most used map32 blocks of a world, each drawn with the palette of the area that uses it most."""
    Image = need_pil()
    base = 0x40 if args.world == 'dark' else 0
    count, where = Counter(), {}
    for a in [x for x in heads() if base <= x < base + 64]:
        c = Counter(area_map32(a))
        count.update(c)
        for v, n in c.items():
            if n > where.get(v, (0, 0))[1]: where[v] = (a, n)
    top = count.most_common(args.top)
    cols = 16
    rows = (len(top) + cols - 1) // cols
    img = Image.new('RGB', (cols * 40, rows * 40), (40, 40, 40))
    t32 = map32_to_map16()
    for i, (v, n) in enumerate(top):
        a = where[v][0]
        pal, back = area_palette(a)
        m16 = [[t32[0][v], t32[1][v]], [t32[2][v], t32[3][v]]]
        render_map16(img, m16, area_tiles(a), pal, back, (i % cols) * 40 + 4, (i // cols) * 40 + 4)
    os.makedirs(args.out, exist_ok=True)
    f = os.path.join(args.out, 'ow_vocab_%s.png' % args.world)
    img.save(f)
    print(f)
    print('order (left to right, top to bottom): ' + ', '.join('%d x%d' % kv for kv in top))


# --- region tileset (roadmap F6b) -------------------------------------------

TILES_COLUMNS = 32      # tiles per row of tiles.png (256 px)
FLIP_H, FLIP_V = 1, 2   # flags of a block's tile: drawn mirrored, flipped


def tile_pixels(tile, p, hf, vf, pal, back, transparent):
    """The 64 RGBA pixels of one map8 tile as drawn (flips applied)."""
    out = []
    for r in range(8):
        for c in range(8):
            ci = tile[7 - r if vf else r][7 - c if hf else c] if tile else 0
            if ci:
                out.append(pal[p * 16 + ci] + (255,))
            else:
                out.append((0, 0, 0, 0) if transparent else back + (255,))
    return tuple(out)


def flipped(px, hf, vf):
    return tuple(px[(7 - r if vf else r) * 8 + (7 - c if hf else c)] for r in range(8) for c in range(8))


def cut_tiles(areas, old, transparent):
    """Cuts the map16 blocks of the areas into colored 8x8 tiles (kept once, flips reused) and blocks of four.

    old: a previous tiles.json, whose tiles and blocks keep their indices (the new ones are added after them), so
    the templates that paint with the tileset stay valid when areas are added. Returns (tiles, blocks), tiles as
    [(pixels, attribute)], blocks as dicts."""
    t8, at = map16_to_map8(), map8_attr()
    tiles = [(tuple([(0, 0, 0, 0)] * 64), None)]         # tile 0 is empty: GameMaker draws nothing for it
    index = {}
    blocks, bindex = [], {}
    if old:
        tiles = [(tuple(tuple(p) for p in px), a) for px, a in old['_pixels']]
        for i, (px, a) in enumerate(tiles):
            index.setdefault((px, a), (i, 0))
        for b_ in old['blocks']:
            blocks.append(b_)
            bindex[(b_['area'], b_['map16'])] = len(blocks) - 1

    def tile_id(px, a):
        for f in (0, FLIP_H, FLIP_V, FLIP_H | FLIP_V):
            k = (flipped(px, f & FLIP_H, f & FLIP_V), a)
            if k in index:
                i, f0 = index[k]
                return i, f ^ f0
        tiles.append((px, a))
        index[(px, a)] = (len(tiles) - 1, 0)
        return len(tiles) - 1, 0

    for a in areas:
        vram = area_tiles(a)
        pal, back = area_palette(a)
        seen = []
        for row in area_map16(a):
            for v in row:
                if v not in seen:
                    seen.append(v)
        for v in seen:
            if (hx(a), v) in bindex:
                continue
            quad = []
            for k in range(4):
                m8 = t8[v * 4 + k]
                tile = vram[m8 & 0x1ff] if (m8 & 0x3ff) < 512 else None
                attr = at[m8 & 0x1ff]
                if 0x10 <= attr < 0x1c: attr |= (m8 >> 14) & 1
                px = tile_pixels(tile, (m8 >> 10) & 7, m8 >> 14 & 1, m8 >> 15 & 1, pal, back, transparent)
                quad.append(list(tile_id(px, attr)))
            blocks.append({'area': hx(a), 'map16': v, 'tiles': quad})
            bindex[(hx(a), v)] = len(blocks) - 1
    return tiles, blocks


def cmd_tiles(args):
    """incoming/<region>/tiles/tiles.png and tiles.json: the region tileset that import_region.py brings in."""
    import json
    Image = need_pil()
    if not args.region:
        sys.exit('tiles needs --region <folder under incoming/>')
    d = os.path.join(REPO, 'incoming', args.region, 'tiles')
    jp = os.path.join(d, 'tiles.json')
    old = None
    if os.path.exists(jp) and not args.fresh:
        old = json.load(open(jp))
        if old.get('source') != 'ALttP overworld':
            sys.exit('%s was not made by owdump.py; --fresh to replace it' % jp)
        im = Image.open(os.path.join(d, 'tiles.png')).convert('RGBA')
        old['_pixels'] = []
        for i, a in enumerate(old['attributes']):
            x, y = (i % TILES_COLUMNS) * 8, (i // TILES_COLUMNS) * 8
            raw = im.crop((x, y, x + 8, y + 8)).tobytes()
            px = [tuple(raw[k:k + 4]) for k in range(0, 256, 4)]
            old['_pixels'].append((px, None if i == 0 else int(a, 16)))
    kept = [int(x, 0) for x in old['areas']] if old else []
    areas = kept + [a for a in (int(x, 0) for x in args.areas) if a not in kept]
    if not areas:
        sys.exit('tiles needs the areas to cut (e.g. 0x1b 0x2c)')
    transparent = args.transparent if old is None else old.get('transparent', False)
    tiles, blocks = cut_tiles(areas, old, transparent)
    rows = (len(tiles) + TILES_COLUMNS - 1) // TILES_COLUMNS
    img = Image.new('RGBA', (TILES_COLUMNS * 8, rows * 8), (0, 0, 0, 0))
    for i, (px, _) in enumerate(tiles):
        t = Image.new('RGBA', (8, 8))
        t.putdata(list(px))
        img.paste(t, ((i % TILES_COLUMNS) * 8, (i // TILES_COLUMNS) * 8))
    os.makedirs(d, exist_ok=True)
    img.save(os.path.join(d, 'tiles.png'))
    classes = {hx(a): KEY[cls(a)] for _, a in tiles[1:] if a is not None}
    out = {'source': 'ALttP overworld', 'areas': ['0x%02X' % a for a in areas], 'tile': 8, 'columns': TILES_COLUMNS,
           'transparent': transparent,
           'attributes': ['--'] + [hx(a) for _, a in tiles[1:]],
           'classes': {k: classes[k] for k in sorted(classes)},
           'blocks': blocks, 'animated': old.get('animated', []) if old else []}
    with open(jp, 'w', newline='\n') as f:
        f.write(dump_tiles_json(out))
    sheet = Image.new('RGBA', (16 * 20, ((len(blocks) + 15) // 16) * 20), (40, 40, 40, 255))
    for i, b_ in enumerate(blocks):
        for k, (ti, fl) in enumerate(b_['tiles']):
            t = Image.new('RGBA', (8, 8))
            t.putdata(list(flipped(tiles[ti][0], fl & FLIP_H, fl & FLIP_V)))
            sheet.paste(t, ((i % 16) * 20 + 2 + (k % 2) * 8, (i // 16) * 20 + 2 + (k // 2) * 8))
    os.makedirs(args.out, exist_ok=True)
    sp = os.path.join(args.out, 'tiles_%s_blocks.png' % args.region)
    sheet.save(sp)
    print('%s: %d tiles of 8x8 (%d rows of %d), %d blocks of 16x16 from areas %s' % (
        os.path.relpath(d, REPO).replace(os.sep, '/'), len(tiles) - 1, rows, TILES_COLUMNS, len(blocks),
        ', '.join(out['areas'])))
    print('blocks drawn in order: %s' % os.path.relpath(sp, REPO).replace(os.sep, '/'))


def dump_tiles_json(out):
    """One row of tiles.png and one block per line, so a diff shows what changed."""
    import json
    head = {k: v for k, v in out.items() if k not in ('attributes', 'blocks')}
    s = json.dumps(head, indent=1)[:-2]
    at = out['attributes']
    s += ',\n "attributes": [\n' + ',\n'.join('  ' + json.dumps(at[i:i + TILES_COLUMNS])[1:-1]
                                              for i in range(0, len(at), TILES_COLUMNS)) + '\n ]'
    s += ',\n "blocks": [\n' + ',\n'.join('  ' + json.dumps(b_, separators=(',', ':')) for b_ in out['blocks'])
    return s + '\n ]\n}\n'


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('cmd', choices=['areas', 'area', 'edges', 'stats', 'png', 'world', 'vocab', 'tiles'])
    ap.add_argument('--region', help='tiles: folder under incoming/ that gets tiles/tiles.png and tiles.json')
    ap.add_argument('--fresh', action='store_true', help='tiles: start over instead of keeping the old indices')
    ap.add_argument('--transparent', action='store_true', help='tiles: color 0 transparent instead of the backdrop')
    ap.add_argument('areas', nargs='*')
    ap.add_argument('--zelda3')
    ap.add_argument('--rom')
    ap.add_argument('--out', default=OUT)
    ap.add_argument('--world', default='light', choices=['light', 'dark'])
    ap.add_argument('--scale', type=float, default=1.0)
    ap.add_argument('--top', type=int, default=64)
    args = ap.parse_args()
    load_zelda3(args.zelda3, args.rom)
    globals()['cmd_' + args.cmd](args)


if __name__ == '__main__':
    main()
