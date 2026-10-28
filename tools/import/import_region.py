# Imports the graphics and music of a region from incoming/<region>/ into the GameMaker project (roadmap F6).
#
#   python tools/import/import_region.py <region>            converts, writes the assets, registers them in Zelda.yyp
#   python tools/import/import_region.py <region> --dry-run  only converts and builds the preview, game/ is untouched
#   python tools/import/import_region.py <region> --remove   takes out everything the last import of the region made
#   python tools/import/import_region.py --export-band Castle [file.png]   the tileset band of a theme, to paint over
#
# <region> is a folder name under incoming/ or a path. The convention is in incoming/README.md. The colors follow
# docs/design/direcao.md: 32 levels per channel (SNES), hard alpha, a dark outline and few colors per sprite.
# Converted frames, the preview (preview.png) and the report go to tools/import/out/<region>/ (ignored by git).
# What an import made is recorded in incoming/<region>/imported.json; the validator uses it.
import os, sys, re, json, wave, hashlib

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
GAME = os.path.join(REPO, 'game')
INCOMING = os.path.join(REPO, 'incoming')
MUSIC_GML = os.path.join(GAME, 'scripts', '__Music', '__Music.gml')
MANIFEST_KEYS = {'name', 'defaults', 'sprites', 'tileset', 'music', 'palettes'}
PALETTE_KEYS = {'base', 'frame'}
SPRITE_KEYS = {'frame', 'count', 'fps', 'origin', 'colors', 'outline', 'outline_color', 'alpha'}
DEFAULTS = {'fps': 8, 'origin': 'center', 'colors': 7, 'outline': 'check', 'outline_color': None, 'alpha': 'hard'}
BAND_W, BAND_H = 1248, 48          # a theme band of sTiles: 156 x 6 tiles of 8px
DARK = 64                          # luma below this counts as outline dark
OUTLINE_MAX = 56                   # the sprite's darkest color is its outline color if its luma is below this
NAME_RE = re.compile(r'^s[A-Z][A-Za-z0-9_]*$')
SONG_RE = re.compile(r'^[A-Z][A-Za-z0-9]*$')


class ImportError_(Exception):
    pass


def region_dir(arg):
    d = arg if os.path.isdir(arg) else os.path.join(INCOMING, arg)
    if not os.path.isdir(d):
        raise ImportError_('no folder %s (put the graphics in incoming/<region>/)' % arg)
    return os.path.abspath(d)


def gm_name(slug, manifest):
    if manifest.get('name'):
        n = manifest['name']
    else:
        n = ''.join(p[:1].upper() + p[1:] for p in re.split(r'[^A-Za-z0-9]+', slug) if p)
    if not re.match(r'^[A-Z][A-Za-z0-9]*$', n):
        raise ImportError_('region name "%s" must be letters and digits, starting with a capital (manifest "name")' % n)
    return n


def source_files(d):
    """Every file the import reads, relative to the region folder (the record keeps their hashes)."""
    out = []
    for root, _, files in os.walk(d):
        for f in files:
            rel = os.path.relpath(os.path.join(root, f), d).replace(os.sep, '/')
            if rel != 'imported.json' and not f.lower().endswith('.md'):
                out.append(rel)
    return sorted(out)


def source_hashes(d):
    return {rel: hashlib.sha1(open(os.path.join(d, rel), 'rb').read()).hexdigest() for rel in source_files(d)}


def load_manifest(d):
    p = os.path.join(d, 'manifest.json')
    if not os.path.exists(p):
        return {}
    try:
        m = json.load(open(p, encoding='utf-8'))
    except ValueError as e:
        raise ImportError_('manifest.json is not valid JSON: %s' % e)
    bad = set(m) - MANIFEST_KEYS
    if bad:
        raise ImportError_('manifest.json: unknown keys %s (allowed: %s)' % (sorted(bad), sorted(MANIFEST_KEYS)))
    for k, v in list(m.get('defaults', {}).items()) + [kv for s in m.get('sprites', {}).values() for kv in s.items()]:
        if k not in SPRITE_KEYS:
            raise ImportError_('manifest.json: unknown sprite option "%s" (allowed: %s)' % (k, sorted(SPRITE_KEYS)))
    return m


def sprite_name(stem):
    n = stem if NAME_RE.match(stem) else 's' + stem
    if not NAME_RE.match(n):
        raise ImportError_('"%s": file names may only have letters, digits and _, and start with a letter' % stem)
    return n


# ---------------------------------------------------------------- reading


def read_sprites(d, manifest):
    """[(name, [RGBA images], options)] from sprites/: one file per sprite, numbered files (_0, _1...) as frames,
    a sheet cut by the manifest "frame" size, or an animated GIF."""
    from PIL import Image, ImageSequence
    sd = os.path.join(d, 'sprites')
    if not os.path.isdir(sd):
        return []
    opts = {sprite_name(k): v for k, v in manifest.get('sprites', {}).items()}
    files = {}
    for root, _, fs in os.walk(sd):
        for f in fs:
            stem, ext = os.path.splitext(f)
            if ext.lower() in ('.png', '.gif'):
                files[stem] = os.path.join(root, f)
            elif not f.lower().endswith('.md'):
                raise ImportError_('sprites/%s: only .png and .gif are read' % f)
    groups = {}
    for stem, p in files.items():
        m = re.match(r'^(.*)_(\d+)$', stem)
        numbered = m and (sum(1 for s in files if re.match(re.escape(m.group(1)) + r'_\d+$', s)) > 1
                          or sprite_name(m.group(1)) in opts)
        if numbered:
            groups.setdefault(m.group(1), []).append((int(m.group(2)), p))
        else:
            groups.setdefault(stem, []).append((None, p))
    out = []
    for base in sorted(groups):
        name = sprite_name(base)
        items = groups[base]
        if len(items) > 1 and any(i is None for i, _ in items):
            raise ImportError_('sprites/%s: there is both a plain file and numbered frames' % base)
        o = dict(DEFAULTS, **manifest.get('defaults', {}))
        o.update(opts.get(name, {}))
        frames = []
        for _, p in sorted(items, key=lambda t: t[0] or 0):
            im = Image.open(p)
            if getattr(im, 'n_frames', 1) > 1:
                dur = im.info.get('duration')
                for f in ImageSequence.Iterator(im):
                    frames.append(f.convert('RGBA'))
                if dur and 'fps' not in opts.get(name, {}) and 'fps' not in manifest.get('defaults', {}):
                    o['fps'] = round(1000.0 / dur, 3)     # the GIF's own speed
            else:
                frames.append(im.convert('RGBA'))
        if o.get('frame'):
            fw, fh = o['frame']
            sheet = frames
            frames = []
            for im in sheet:
                if im.width % fw or im.height % fh:
                    raise ImportError_('%s: the sheet (%dx%d) is not a multiple of the frame %dx%d'
                                       % (name, im.width, im.height, fw, fh))
                for y in range(0, im.height, fh):
                    for x in range(0, im.width, fw):
                        frames.append(im.crop((x, y, x + fw, y + fh)))
            if o.get('count'):
                frames = frames[:o['count']]
            else:      # empty cells at the end of a sheet are not frames
                while len(frames) > 1 and frames[-1].getbbox() is None:
                    frames.pop()
        sizes = {f.size for f in frames}
        if len(sizes) > 1:
            raise ImportError_('%s: the frames have different sizes %s' % (name, sorted(sizes)))
        out.append((name, frames, o))
    unused = set(opts) - {n for n, _, _ in out}
    if unused:
        raise ImportError_('manifest.json: sprites %s have no file in sprites/' % sorted(unused))
    return out


def read_palettes(d, manifest, sprite_names):
    """[(palette sprite, base sprite, base frame, family, [recolors])] from palettes/<Name>/1.png, 2.png...: recolors
    of one frame of a sprite of the family s<Name>_* (roadmap F7). Recolor n becomes palette index n (ColorIndex)."""
    from PIL import Image
    pd = os.path.join(d, 'palettes')
    opts = manifest.get('palettes', {})
    if not os.path.isdir(pd):
        if opts:
            raise ImportError_('manifest.json has "palettes" but there is no palettes/ folder')
        return []
    out = []
    for fam in sorted(os.listdir(pd)):
        fd = os.path.join(pd, fam)
        if not os.path.isdir(fd):
            if fam.lower().endswith('.md'):
                continue
            raise ImportError_('palettes/%s: one folder per palette (palettes/<Name>/1.png, 2.png...)' % fam)
        name = sprite_name(fam)
        o = opts.get(fam, opts.get(name, {}))
        bad = set(o) - PALETTE_KEYS
        if bad:
            raise ImportError_('manifest.json: unknown palette option %s (allowed: %s)' % (sorted(bad), sorted(PALETTE_KEYS)))
        files = {}
        for f in os.listdir(fd):
            stem, ext = os.path.splitext(f)
            if f.lower().endswith('.md'):
                continue
            if ext.lower() != '.png' or not stem.isdigit():
                raise ImportError_('palettes/%s/%s: the recolors are named 1.png, 2.png...' % (fam, f))
            files[int(stem)] = os.path.join(fd, f)
        if sorted(files) != list(range(1, len(files) + 1)):
            raise ImportError_('palettes/%s: the recolors must be numbered from 1 with no gaps (%s)' % (fam, sorted(files)))
        family = [n for n in sprite_names if n == name or n.startswith(name + '_')]
        base = sprite_name(o['base']) if 'base' in o else (family[0] if family else None)
        if base not in sprite_names:
            raise ImportError_('palettes/%s: no sprite %s in sprites/ to recolor (set "base" in the manifest)'
                               % (fam, base or name + '_*'))
        if base not in family:
            family.append(base)
        out.append((name + '_Pal', base, int(o.get('frame', 0)), family, [Image.open(files[i]).convert('RGBA') for i in sorted(files)]))
    unused = set(sprite_name(k) for k in opts) - {p[0][:-4] for p in out}
    if unused:
        raise ImportError_('manifest.json: palettes %s have no folder in palettes/' % sorted(unused))
    return out


def build_palette(pal, arrs, warn):
    """The palette sprite for the palette shader: column 0 holds every color of the family, column n the color it
    takes with palette index n (from recolor n, compared pixel by pixel with the converted base frame)."""
    import numpy as np
    global SNAP
    if SNAP is None:
        SNAP = np.array([snap(v) for v in range(256)], np.uint8)
    name, base, frame, family, recolors = pal
    if frame >= len(arrs[base]):
        raise ImportError_('%s: %s has no frame %d' % (name, base, frame))
    b = arrs[base][frame]
    colors = sorted({tuple(int(x) for x in c) for n in family for a in arrs[n] for c in a[a[..., 3] > 0][:, :3]},
                    key=lambda c: (luma(c), c))
    in_base = {tuple(int(x) for x in c) for c in b[b[..., 3] > 0][:, :3]}
    missing = [c for c in colors if c not in in_base]
    if missing:
        warn('%d colors of the %s sprites are not in %s frame %d and keep their color in every variant'
             % (len(missing), name[:-4], base, frame))
    table = np.zeros((len(colors), 1 + len(recolors), 4), np.uint8)
    table[..., 3] = 255
    for y, c in enumerate(colors):
        table[y, :, :3] = c
    for k, im in enumerate(recolors, 1):
        v = np.array(im, np.uint8)
        if v.shape[:2] != b.shape[:2]:
            raise ImportError_('%s: recolor %d is %dx%d, %s is %dx%d' % (name, k, v.shape[1], v.shape[0], base, b.shape[1], b.shape[0]))
        solid = v[..., 3] >= 128
        both = (b[..., 3] > 0) & solid
        if ((b[..., 3] > 0) & ~solid).any():
            warn('recolor %d: %d pixels of the sprite are clear in it (their color is kept)' % (k, int(((b[..., 3] > 0) & ~solid).sum())))
        if (solid & (b[..., 3] == 0)).any():
            warn('recolor %d: %d pixels outside the sprite are ignored' % (k, int((solid & (b[..., 3] == 0)).sum())))
        m = {}
        for cb, cn in zip(b[both][:, :3], SNAP[v[both][:, :3]]):
            m.setdefault(tuple(int(x) for x in cb), set()).add(tuple(int(x) for x in cn))
        split = {c: t for c, t in m.items() if len(t) > 1}
        if split:
            c, t = sorted(split.items())[0]
            raise ImportError_('%s: in recolor %d the color %s of %s becomes %d colors %s; one color can only become one'
                               % (name, k, c, base, len(t), sorted(t)))
        for y, c in enumerate(colors):
            if c in m:
                table[y, k, :3] = next(iter(m[c]))
    return table, len(colors)


# ---------------------------------------------------------------- palette rules


def snap(v):
    return int(round(round(int(v) * 31 / 255.0) * 255 / 31.0))


SNAP = None


def luma(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]


def convert(frames, o, warn):
    """Applies the palette rules to the frames (numpy RGBA arrays) and returns them with a few numbers."""
    import numpy as np
    from PIL import Image
    global SNAP
    if SNAP is None:
        SNAP = np.array([snap(v) for v in range(256)], np.uint8)
    arr = [np.array(f, np.uint8) for f in frames]
    info = {}
    if o['alpha'] not in ('hard', 'keep'):
        raise ImportError_('alpha must be hard or keep (not %s)' % o['alpha'])
    semi = sum(int(((a[..., 3] > 0) & (a[..., 3] < 255)).sum()) for a in arr)
    if semi and o['alpha'] == 'hard':
        warn('%d semi transparent pixels made solid or clear' % semi)
    for a in arr:
        if o['alpha'] == 'hard':
            a[..., 3] = np.where(a[..., 3] >= 128, 255, 0)
        a[..., :3] = np.where(a[..., 3:] > 0, a[..., :3], 0)
    def colors():
        return {tuple(c) for a in arr for c in a[a[..., 3] > 0][:, :3]}
    info['colors_in'] = len(colors())
    off = sum(int((a[..., :3][a[..., 3] > 0] != SNAP[a[..., :3][a[..., 3] > 0]]).any(axis=-1).sum()) for a in arr)
    for a in arr:
        a[..., :3] = SNAP[a[..., :3]]
    info['off_grid'] = off
    mode = o['outline']
    if mode not in ('check', 'add', 'darken', 'off'):
        raise ImportError_('outline must be check, add, darken or off (not %s)' % mode)
    limit = int(o['colors'] or 0)
    oc = o.get('outline_color')
    if oc is None:
        dark = sorted((c for c in colors() if luma(c) < OUTLINE_MAX), key=luma)
        oc = dark[0] if dark else (24, 24, 24)
    oc = tuple(snap(v) for v in oc)
    if limit and len(colors()) > limit:
        # the outline color is kept as it is; the other colors share what is left of the limit
        def rest(a):
            return (a[..., 3] > 0) & (a[..., :3] != np.array(oc, np.uint8)).any(axis=-1)
        to = merge_colors(np.concatenate([a[rest(a)][:, :3] for a in arr]), max(limit - 1, 1))
        for a in arr:
            m = rest(a)
            a[..., :3][m] = np.array([to[tuple(c)] for c in a[m][:, :3]], np.uint8).reshape(-1, 3)
        warn('colors reduced from %d to %d' % (info['colors_in'], len(colors())))
    # outline: the opaque pixels that touch a clear one (or the edge)
    edge_cut = False
    for a in arr:
        op = a[..., 3] > 0
        pad = np.pad(op, 1)
        clear_n = ~pad[:-2, 1:-1] | ~pad[2:, 1:-1] | ~pad[1:-1, :-2] | ~pad[1:-1, 2:]
        if mode == 'add':
            out = ~op & (pad[:-2, 1:-1] | pad[2:, 1:-1] | pad[1:-1, :-2] | pad[1:-1, 2:])
            a[out] = oc + (255,)
            if op[0].any() or op[-1].any() or op[:, 0].any() or op[:, -1].any():
                edge_cut = True
        elif mode == 'darken':
            border = op & clear_n
            lum = a[..., :3] @ np.array([0.299, 0.587, 0.114])
            a[border & (lum >= DARK)] = oc + (255,)
    if edge_cut:
        warn('the sprite touches the edge of its frame, so the added outline is cut there (leave 1px free)')
    if mode != 'off':
        tot = dk = 0
        for a in arr:
            op = a[..., 3] > 0
            pad = np.pad(op, 1)
            border = op & (~pad[:-2, 1:-1] | ~pad[2:, 1:-1] | ~pad[1:-1, :-2] | ~pad[1:-1, 2:])
            lum = a[..., :3] @ np.array([0.299, 0.587, 0.114])
            tot += int(border.sum())
            dk += int((border & (lum < DARK)).sum())
        info['outline'] = dk / tot if tot else 1.0
        if info['outline'] < 0.85:
            warn('only %d%% of the outline is dark (use "outline": "add" or "darken" in the manifest)'
                 % round(100 * info['outline']))
    info['colors_out'] = len(colors())
    if limit and info['colors_out'] > limit:
        warn('%d colors (limit %d)' % (info['colors_out'], limit))
    return arr, info


def merge_colors(px, keep):
    """Maps each color of px (N x 3) to one of at most `keep` colors that are already in it: the two closest
    colors are merged, the rarer one taking the other, until few enough are left (no new colors, no averages)."""
    import numpy as np
    cols, counts = np.unique(px, axis=0, return_counts=True)
    cols = [tuple(int(v) for v in c) for c in cols]
    n = dict(zip(cols, counts.tolist()))
    to = {c: c for c in cols}
    alive = list(cols)
    while len(alive) > keep:
        best = None
        for i in range(len(alive)):
            for j in range(i + 1, len(alive)):
                a, b = alive[i], alive[j]
                dist = (0.299 * (a[0] - b[0]) ** 2 + 0.587 * (a[1] - b[1]) ** 2 + 0.114 * (a[2] - b[2]) ** 2)
                if best is None or dist < best[0]:
                    best = (dist, a, b)
        _, a, b = best
        big, small = (a, b) if n[a] >= n[b] else (b, a)
        n[big] += n[small]
        alive.remove(small)
        for c, t in to.items():
            if t == small:
                to[c] = big
    return to


def origin_of(o, w, h):
    v = o['origin']
    if isinstance(v, list) and len(v) == 2:
        return int(v[0]), int(v[1]), 9
    table = {'top-left': (0, 0, 0), 'center': (w // 2, h // 2, 4), 'bottom': (w // 2, h, 7)}
    if v not in table:
        raise ImportError_('origin must be [x, y], "center", "bottom" or "top-left" (not %s)' % v)
    return table[v]


# ---------------------------------------------------------------- tileset


def themes():
    s = open(os.path.join(GAME, 'scripts', '__Dungeon', '__Dungeon.gml')).read()
    body = re.search(r'enum DungeonLevel\s*\{([^}]*)\}', s).group(1)
    return [re.sub(r'//.*', '', x).strip() for x in body.split(',') if re.sub(r'//.*', '', x).strip()]


def tiles_image():
    from PIL import Image
    t = open(os.path.join(GAME, 'sprites', 'sTiles', 'sTiles.yy')).read()
    fid = re.search(r'"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]+)"', t).group(1)
    return Image.open(os.path.join(GAME, 'sprites', 'sTiles', fid + '.png')).convert('RGBA')


def theme_band(theme):
    names = themes()
    if theme not in names or names.index(theme) == 0:
        raise ImportError_('theme must be one of %s' % ', '.join(names[1:]))
    y = (4 + (names.index(theme) - 1) * 6) * 8      # LevelTilesY in scripts/__Levels
    return tiles_image().crop((0, y, BAND_W, y + BAND_H))


def read_tileset(d, manifest):
    from PIL import Image
    p = os.path.join(d, 'tileset.png')
    if not os.path.exists(p):
        if manifest.get('tileset'):
            raise ImportError_('manifest.json has "tileset" but there is no tileset.png')
        return None
    im = Image.open(p).convert('RGBA')
    if im.size != (BAND_W, BAND_H):
        raise ImportError_('tileset.png must be %dx%d (one theme band of sTiles, 156 x 6 tiles); it is %dx%d. '
                           'Start from --export-band <Theme>' % (BAND_W, BAND_H, im.width, im.height))
    base = (manifest.get('tileset') or {}).get('base', 'Castle')
    return im, base


# ---------------------------------------------------------------- music


def read_music(d, manifest):
    """[(song, [(sound name, wav path or (path, start, end) in frames)])] from music/."""
    md = os.path.join(d, 'music')
    loops = manifest.get('music', {})
    if not os.path.isdir(md):
        if loops:
            raise ImportError_('manifest.json has "music" but there is no music/ folder')
        return []
    files = {}
    for f in sorted(os.listdir(md)):
        stem, ext = os.path.splitext(f)
        if ext.lower() != '.wav':
            raise ImportError_('music/%s: only .wav is read' % f)
        files[stem] = os.path.join(md, f)
    songs = {}
    for stem, p in files.items():
        m = re.match(r'^(.*)_(Intro|Main)$', stem)
        song, part = (m.group(1), m.group(2)) if m else (stem, None)
        if not SONG_RE.match(song):
            raise ImportError_('music/%s.wav: the song name must be letters and digits, starting with a capital' % stem)
        songs.setdefault(song, {})[part] = p
    out = []
    for song, parts in sorted(songs.items()):
        if None in parts and len(parts) > 1:
            raise ImportError_('music/%s: there is both %s.wav and _Intro/_Main files' % (song, song))
        if None in parts:
            p = parts[None]
            w = wave.open(p)
            n, rate = w.getnframes(), w.getframerate()
            loop = (loops.get(song) or {}).get('loop')
            if loop:
                cut = int(round(float(loop) * rate))
                if not 0 < cut < n:
                    raise ImportError_('music "%s": loop %s s is outside the song (%.2f s)' % (song, loop, n / rate))
                out.append((song, [('Music_%s_Intro' % song, (p, 0, cut)), ('Music_%s_Main' % song, (p, cut, n))]))
            else:
                out.append((song, [('Music_%s' % song, (p, 0, n))]))
        else:
            if 'Main' not in parts:
                raise ImportError_('music/%s_Intro.wav has no %s_Main.wav' % (song, song))
            lst = [('Music_%s_%s' % (song, k), (parts[k], 0, wave.open(parts[k]).getnframes()))
                   for k in ('Intro', 'Main') if k in parts]
            out.append((song, lst))
    unused = set(loops) - set(songs)
    if unused:
        raise ImportError_('manifest.json: music %s has no file in music/' % sorted(unused))
    return out


def write_wav(src, a, b, dst):
    w = wave.open(src)
    w.setpos(a)
    data = w.readframes(b - a)
    o = wave.open(dst, 'wb')
    o.setnchannels(w.getnchannels())
    o.setsampwidth(w.getsampwidth())
    o.setframerate(w.getframerate())
    o.writeframes(data)
    o.close()
    return (b - a) / float(w.getframerate()), w.getframerate()


def song_lines(song, sounds, slug):
    names = [n for n, _ in sounds]
    intro = names[0] if len(names) == 2 else 'noone'
    enum = ',\n\t%s' % song          # appended to the end of enum SongIndex; the table line says where it is from
    table = '\tglobal.Music_SongAsset[SongIndex.%s] =\t{Intro: %s,\tMain : %s};\t// incoming/%s\n' % (
        song, intro, names[-1], slug)
    return enum, table


def music_add(song, sounds, slug):
    s = open(MUSIC_GML).read()
    enum, table = song_lines(song, sounds, slug)
    if not song_exists(song):
        m = re.search(r'enum SongIndex\s*\{[^}]*?(\s*)\}', s)
        s = s[:m.start(1)] + enum + s[m.start(1):]
    if table not in s:
        rows = list(re.finditer(r'\tglobal\.Music_SongAsset\[SongIndex\.\w+\][^\n]*\n', s))
        s = s[:rows[-1].end()] + table + s[rows[-1].end():]
    open(MUSIC_GML, 'w').write(s)


def music_remove(song, sounds, slug):
    s = open(MUSIC_GML).read()
    enum, table = song_lines(song, sounds, slug)
    s = s.replace(table, '')
    s = re.sub(re.escape(enum) + r'\b', '', s)
    open(MUSIC_GML, 'w').write(s)


def song_exists(song):
    s = open(MUSIC_GML).read()
    body = re.search(r'enum SongIndex\s*\{([^}]*)\}', s).group(1)
    return song in [re.sub(r'//.*', '', x).strip() for x in body.split(',')]


# ---------------------------------------------------------------- preview


def preview(path, rows, tileset, link):
    """rows: [(name, before frames, after frames, text)]; one row per sprite, before | after, Link for scale."""
    from PIL import Image, ImageDraw
    import numpy as np
    bg, ink = (168, 176, 152, 255), (24, 24, 24, 255)
    pieces = []
    for name, before, after, text in rows:
        w, h = before[0].size
        z = 3 if max(w, h) <= 64 else 1
        cw, chh = w * z, h * z
        lz = link.resize((link.width * z, link.height * z), Image.NEAREST)
        width = 8 + lz.width + 16 + len(before) * (cw + 4) + 24 + len(after) * (cw + 4) + 8
        height = 14 + max(chh, lz.height) + 8
        im = Image.new('RGBA', (max(width, 16 + 6 * len(name + text) + 18), height), bg)
        d = ImageDraw.Draw(im)
        d.text((8, 2), '%s   %s' % (name, text), fill=ink)
        x = 8
        im.alpha_composite(lz, (x, 14 + max(chh, lz.height) - lz.height))
        x += lz.width + 16
        for f in before:
            im.alpha_composite(f.resize((cw, chh), Image.NEAREST), (x, 14))
            x += cw + 4
        d.text((x + 4, 14 + chh // 2 - 5), '>', fill=ink)
        x += 24
        for f in after:
            im.alpha_composite(Image.fromarray(f).resize((cw, chh), Image.NEAREST), (x, 14))
            x += cw + 4
        pieces.append(im)
    if tileset:
        base, before, after = tileset
        im = Image.new('RGBA', (BAND_W + 16, 14 * 3 + BAND_H * 3 + 16), bg)
        d = ImageDraw.Draw(im)
        y = 2
        for label, band in (('tileset: base theme (layout to follow)', base), ('tileset.png', before),
                            ('tileset converted (sTiles_<Region>)', Image.fromarray(after))):
            d.text((8, y), label, fill=ink)
            im.alpha_composite(band, (8, y + 12))
            y += 14 + BAND_H + 4
        pieces.append(im)
    if not pieces:
        return False
    W = max(p.width for p in pieces)
    out = Image.new('RGBA', (W, sum(p.height for p in pieces)), bg)
    y = 0
    for p in pieces:
        out.alpha_composite(p, (0, y))
        y += p.height
    out.save(path)
    return True


def link_reference():
    from PIL import Image
    n = 'sLinkCharacter_Link'
    t = open(os.path.join(GAME, 'sprites', n, n + '.yy')).read()
    fid = re.search(r'"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]+)"', t).group(1)
    im = Image.open(os.path.join(GAME, 'sprites', n, fid + '.png')).convert('RGBA')
    link = Image.new('RGBA', (16, 24))   # Link facing down: the parts sheet has 16x16 cells, the head over the body
    link.alpha_composite(im.crop((64, 16, 80, 32)), (0, 8))
    link.alpha_composite(im.crop((0, 0, 16, 16)), (0, 0))
    return link


# ---------------------------------------------------------------- main


def registered(kind):
    s = open(os.path.join(GAME, 'Zelda.yyp')).read()
    return set(re.findall(r'"path":"%s/([^/"]+)/' % kind, s))


def gm():
    sys.path.insert(0, os.path.join(REPO, 'tools', 'hub'))
    import gm_assets
    return gm_assets


def remove_record(rec, slug):
    g = gm()
    for n in rec.get('sprites', []):
        g.remove('sprites', n)
    for song, sounds in rec.get('songs', {}).items():
        music_remove(song, [(n, None) for n in sounds], slug)
    for n in rec.get('sounds', []):
        g.remove('sounds', n)
    if rec.get('folder'):
        for sub in ('Music', 'Sprites', ''):
            g.remove_folder(rec['folder'] + ('/' + sub if sub else ''))


def run(arg, dry=False, remove=False):
    d = region_dir(arg)
    slug = os.path.basename(d)
    out = os.path.join(HERE, 'out', slug)
    recp = os.path.join(d, 'imported.json')
    old = json.load(open(recp)) if os.path.exists(recp) else {}
    if remove:
        if not old:
            raise ImportError_('incoming/%s was never imported (no imported.json)' % slug)
        remove_record(old, slug)
        os.remove(recp)
        print('Removed %d sprites, %d sounds and %d songs of %s.' % (
            len(old.get('sprites', [])), len(old.get('sounds', [])), len(old.get('songs', {})), slug))
        return 0

    from PIL import Image
    manifest = load_manifest(d)
    region = gm_name(slug, manifest)
    sprites = read_sprites(d, manifest)
    tileset = read_tileset(d, manifest)
    music = read_music(d, manifest)
    if not (sprites or tileset or music):
        raise ImportError_('incoming/%s has nothing to import (sprites/, tileset.png, music/)' % slug)
    palettes = read_palettes(d, manifest, [n for n, _, _ in sprites])
    sprites_names = [n for n, _, _ in sprites] + [p[0] for p in palettes]
    if tileset:
        sprites_names.append('sTiles_' + region)
    sound_names = [n for _, snd in music for n, _ in snd]
    # never overwrite something that is not from this region
    mine_s, mine_a = set(old.get('sprites', [])), set(old.get('sounds', []))
    taken = [n for n in sprites_names if n in registered('sprites') and n not in mine_s]
    taken += [n for n in sound_names if n in registered('sounds') and n not in mine_a]
    taken += ['SongIndex.' + s for s, _ in music if song_exists(s) and s not in old.get('songs', {})]
    if taken:
        raise ImportError_('already in the project and not from incoming/%s: %s' % (slug, ', '.join(taken)))

    os.makedirs(os.path.join(out, 'frames'), exist_ok=True)
    report, rows, warnings = [], [], 0
    converted = []
    arrs = {}
    for name, frames, o in sprites:
        msgs = []
        arr, info = convert(frames, o, msgs.append)
        w, h = frames[0].size
        org = origin_of(o, w, h)
        paths = []
        for i, a in enumerate(arr):
            p = os.path.join(out, 'frames', '%s_%d.png' % (name, i))
            Image.fromarray(a).save(p)
            paths.append(p)
        fps = o['fps'] if len(arr) > 1 else None
        text = '%dx%d, %d frame%s%s, origin %d,%d, colors %d>%d%s' % (
            w, h, len(arr), 's' if len(arr) > 1 else '', ', %s fps' % fps if fps else '', org[0], org[1],
            info['colors_in'], info['colors_out'],
            ', outline %d%% dark' % round(100 * info['outline']) if 'outline' in info else '')
        report.append('%s: %s' % (name, text))
        report += ['  ! ' + m for m in msgs]
        warnings += len(msgs)
        rows.append((name, frames, arr, text))
        converted.append((name, paths, fps, org))
        arrs[name] = arr
    for pal in palettes:
        msgs = []
        table, n = build_palette(pal, arrs, msgs.append)
        p = os.path.join(out, 'frames', '%s_0.png' % pal[0])
        Image.fromarray(table).save(p)
        converted.append((pal[0], [p], None, (0, 0, 0)))
        text = '%d colors x %d variants, from %s frame %d' % (n, len(pal[4]), pal[1], pal[2])
        rows.append((pal[0], [Image.fromarray(table)], [table], text))
        report.append('%s: palette, %s' % (pal[0], text))
        report += ['  ! ' + m for m in msgs]
        warnings += len(msgs)
    tile = None
    if tileset:
        im, base = tileset
        msgs = []
        arr, info = convert([im], dict(DEFAULTS, colors=0, outline='off', alpha='keep'), msgs.append)
        p = os.path.join(out, 'frames', 'sTiles_%s_0.png' % region)
        Image.fromarray(arr[0]).save(p)
        converted.append(('sTiles_' + region, [p], None, (0, 0, 0)))
        tile = (theme_band(base), im, arr[0])
        report.append('sTiles_%s: tileset band %dx%d over the layout of %s, colors %d>%d'
                      % (region, BAND_W, BAND_H, base, info['colors_in'], info['colors_out']))
        report += ['  ! ' + m for m in msgs]
        warnings += len(msgs)
    wavs = []
    for song, snd in music:
        parts = []
        for n, (src, a, b) in snd:
            p = os.path.join(out, n + '.wav')
            dur, rate = write_wav(src, a, b, p)
            parts.append('%s %.2f s' % (n, dur))
            wavs.append((n, p, dur, rate))
        report.append('SongIndex.%s: %s' % (song, ', '.join(parts)))
    have_preview = preview(os.path.join(out, 'preview.png'), rows, tile, link_reference())
    open(os.path.join(out, 'report.txt'), 'w').write('\n'.join(report) + '\n')
    print('\n'.join(report))
    if have_preview:
        print('Preview: %s' % os.path.relpath(os.path.join(out, 'preview.png'), REPO).replace(os.sep, '/'))
    if dry:
        print('Dry run: nothing written in game/.')
        return 0

    g = gm()
    # what the previous import made and this one no longer makes goes away
    gone = {'sprites': [n for n in old.get('sprites', []) if n not in sprites_names],
            'sounds': [n for n in old.get('sounds', []) if n not in sound_names],
            'songs': {s: v for s, v in old.get('songs', {}).items() if s not in dict(music)}}
    remove_record(gone, slug)
    for song, v in old.get('songs', {}).items():       # the table line changes with the sounds
        music_remove(song, [(n, None) for n in v], slug)
    folder = 'Regions/' + region
    fs = g.folder(folder + '/Sprites') if converted else None
    for name, paths, fps, org in converted:
        g.sprite(name, paths[0], folder=fs, frames=paths, fps=fps, origin=org)
    if wavs:
        fm = g.folder(folder + '/Music')
        for n, p, dur, rate in wavs:
            g.sound(n, p, dur, folder=fm, sample_rate=rate)
    for song, snd in music:
        music_add(song, snd, slug)
    rec = {'region': region, 'folder': folder, 'sprites': sprites_names, 'sounds': sound_names,
           'songs': {s: [n for n, _ in snd] for s, snd in music}, 'sources': source_hashes(d)}
    json.dump(rec, open(recp, 'w'), indent=1)
    if gone['sprites'] or gone['sounds']:
        print('Removed (no longer in incoming/%s): %s' % (slug, ', '.join(gone['sprites'] + gone['sounds'])))
    print('Imported %d sprites, %d sounds and %d songs into game/ (IDE folder %s)%s.' % (
        len(sprites_names), len(sound_names), len(music), folder,
        ', %d warnings' % warnings if warnings else ''))
    return 0


def main():
    args = sys.argv[1:]
    try:
        if args[:1] == ['--export-band']:
            if len(args) < 2:
                raise ImportError_('usage: --export-band <Theme> [file.png]')
            dst = args[2] if len(args) > 2 else 'tileset.png'
            theme_band(args[1]).save(dst)
            print('Wrote %s (%dx%d, theme %s)' % (dst, BAND_W, BAND_H, args[1]))
            return 0
        names = [a for a in args if not a.startswith('--')]
        if len(names) != 1:
            print(__doc__ or open(__file__).read().split('\nimport')[0])
            return 2
        return run(names[0], dry='--dry-run' in args, remove='--remove' in args)
    except ImportError_ as e:
        print('ERROR: %s' % e)
        return 1


if __name__ == '__main__':
    sys.exit(main())
