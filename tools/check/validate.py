#!/usr/bin/env python3
"""Static checks for the Dungeons of Infinity project.

Runs without GameMaker, so it works anywhere (including Claude's sandbox).
Run it before every delivery:

    python tools/check/validate.py              # report, exit code 1 on errors
    python tools/check/validate.py --orphans    # only list unregistered resources
    python tools/check/validate.py --strict     # warnings also fail

Checks:
  * project: every resource in Zelda.yyp exists on disk; folders on disk that
    the project does not register ("orphans", dead code and old assets)
  * objects: parent, sprite and event files exist; stray .gml files
  * sprites and sounds: frame images and audio files exist
  * GML: duplicate global functions, references to assets that do not exist,
    known gotchas (array literal starting with #RRGGBB, lower case text with
    global.Font_Small)
  * data: the included files in Zelda.yyp exist; data_d, the room template
    files (game/datafiles/data/rooms) and the Tiled maps parse as JSON, and
    the room template files match what convert.py makes from the Tiled maps
  * docs: no arrows or em dashes in the Portuguese docs (house style)
  * level sheet: every ExitLook it names is a look in ExitLooks_Init (__Doors)
  * region specs (docs/regioes/*.md): every section and header field (the
    "* **Name:**" lines) of _modelo.md is there,
    a valid Estado, and the assets and docs they cite exist; the reference
    sheets (docs/ref/*.md) are checked for assets too
  * test scenarios (tools/test/scenarios/*.json): known steps, keys, cheats,
    enemies and enum names (the same check tools/test/run.py does)
  * incoming graphics (incoming/<region>/, roadmap F6): what the last
    import_region.py made is still in the project, and the sources did not
    change since then
"""
import glob
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
GAME = os.path.join(REPO, 'game')
YYP = os.path.join(GAME, 'Zelda.yyp')

RESOURCE_DIRS = ['scripts', 'objects', 'sprites', 'sounds', 'rooms', 'fonts',
                 'shaders', 'paths', 'sequences', 'tilesets', 'notes', 'extensions',
                 'timelines', 'animcurves', 'particles']

# GameMaker event types -> file name prefix
EVENT_NAMES = {0: 'Create', 1: 'Destroy', 2: 'Alarm', 3: 'Step', 4: 'Collision',
               5: 'Keyboard', 6: 'Mouse', 7: 'Other', 8: 'Draw', 9: 'KeyPress',
               10: 'KeyRelease', 12: 'CleanUp', 13: 'Gesture'}

PT_DOCS = ['CLAUDE.md', 'docs/roadmap.md', 'docs/design/direcao.md', 'docs/dev/receitas.md']
PT_DOC_DIRS = ['docs/ref', 'docs/regioes']  # every .md inside is Portuguese too

REGION_DIR = 'docs/regioes'
REGION_MODEL = '_modelo.md'
REGION_STATES = ('ideia', 'especificada', 'em produção', 'pronta')
REF_DIR = 'docs/ref'
# a whole `code span` that looks like a GameMaker asset name
ASSET_SPAN = re.compile(r'`((?:o|s)[A-Z]\w*|(?:Sound|Music)_\w+)`')
DOC_SPAN = re.compile(r'`(docs/[\w./-]+\.md)`')
NEW_MARKERS = ('(novo)', 'órfão')  # lines that may cite assets that do not exist


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []
        self.notes = []

    def error(self, msg):
        self.errors.append(msg)

    def warn(self, msg):
        self.warnings.append(msg)

    def note(self, msg):
        self.notes.append(msg)


def load_yy(path):
    """GameMaker .yy/.yyp files are JSON with trailing commas."""
    txt = open(path, encoding='utf-8-sig').read()
    txt = re.sub(r',(\s*[}\]])', r'\1', txt)
    return json.loads(txt)


def rel(p):
    return os.path.relpath(p, REPO).replace('\\', '/')


_dir_cache = {}
CASE_MISMATCH = []


def resolve(path):
    """Find a path ignoring letter case, like Windows does. Returns the real
    path or None. Case mismatches are recorded (they break on Linux and macOS)."""
    if os.path.exists(path):
        return path
    parts = os.path.relpath(path, REPO).replace('\\', '/').split('/')
    cur = REPO
    for part in parts:
        if cur not in _dir_cache:
            try:
                _dir_cache[cur] = {n.lower(): n for n in os.listdir(cur)}
            except OSError:
                return None
        real = _dir_cache[cur].get(part.lower())
        if real is None:
            return None
        cur = os.path.join(cur, real)
    CASE_MISMATCH.append(rel(path))
    return cur


def is_lfs_pointer(path):
    with open(path, 'rb') as f:
        return f.read(40).startswith(b'version https://git-lfs')


# ---------------------------------------------------------------- project

def check_project(rep):
    yyp = load_yy(YYP)
    registered = {}  # (dir, name) -> yy path
    for r in yyp.get('resources', []):
        p = r['id']['path']
        d = p.split('/')[0]
        registered[(d, r['id']['name'])] = p
        if not resolve(os.path.join(GAME, p)):
            rep.error('registered in Zelda.yyp but missing on disk: game/%s' % p)

    reg_lower = {(d, n.lower()) for (d, n) in registered}
    orphans = []
    for d in RESOURCE_DIRS:
        full = os.path.join(GAME, d)
        if not os.path.isdir(full):
            continue
        for name in sorted(os.listdir(full)):
            if os.path.isdir(os.path.join(full, name)) and (d, name.lower()) not in reg_lower:
                orphans.append('game/%s/%s' % (d, name))

    names = {}
    for (d, n) in registered:
        names.setdefault(n, []).append(d)
    for n, ds in names.items():
        if len(ds) > 1:
            rep.error('asset name used by more than one resource: %s (%s)' % (n, ', '.join(ds)))
    return registered, orphans


# ---------------------------------------------------------------- objects, sprites, sounds

def check_objects(rep, registered):
    gml_files = []
    for (d, name), p in sorted(registered.items()):
        if d != 'objects':
            continue
        path = resolve(os.path.join(GAME, p))
        if not path:
            continue
        yy = load_yy(path)
        folder = os.path.dirname(path)
        for key, kind in (('parentObjectId', 'objects'), ('spriteId', 'sprites'), ('spriteMaskId', 'sprites')):
            ref = yy.get(key)
            if ref and (kind, ref['name']) not in registered:
                rep.error('%s: %s %s is not in the project' % (name, key, ref['name']))
        expected = set()
        for ev in yy.get('eventList', []):
            t, num = ev.get('eventType'), ev.get('eventNum', 0)
            prefix = EVENT_NAMES.get(t)
            if prefix is None:
                continue
            if t == 4:
                other = (ev.get('collisionObjectId') or {}).get('name', '')
                if other and ('objects', other) not in registered:
                    rep.error('%s: collision event with missing object %s' % (name, other))
                fname = 'Collision_%s.gml' % other
            else:
                fname = '%s_%d.gml' % (prefix, num)
            expected.add(fname)
            if not resolve(os.path.join(folder, fname)):
                rep.error('%s: event file missing: %s' % (name, fname))
        for f in os.listdir(folder):
            if f.endswith('.gml'):
                if f.lower() in {e.lower() for e in expected}:
                    gml_files.append(os.path.join(folder, f))
                else:
                    rep.warn('%s: %s is not an event of the object (never runs)' % (name, f))
    return gml_files


def check_sprites_sounds(rep, registered):
    for (d, name), p in sorted(registered.items()):
        path = resolve(os.path.join(GAME, p))
        if not path:
            continue
        folder = os.path.dirname(path)
        if d == 'sprites':
            yy = load_yy(path)
            for fr in yy.get('frames', []):
                img = os.path.join(folder, fr['name'] + '.png')
                if not resolve(img):
                    rep.error('%s: frame image missing (%s.png)' % (name, fr['name']))
        elif d == 'sounds':
            yy = load_yy(path)
            sf = yy.get('soundFile')
            if sf and not resolve(os.path.join(folder, sf)):
                rep.error('%s: audio file missing (%s)' % (name, sf))


# ---------------------------------------------------------------- GML

STRING_RE = re.compile(r'@"[^"]*"|@\'[^\']*\'|"(?:\\.|[^"\\\n])*"')
COMMENT_RE = re.compile(r'/\*.*?\*/|//[^\n]*', re.S)


def strip_code(src):
    """Remove comments and strings, keeping line count."""
    def blank(m):
        return re.sub(r'[^\n]', ' ', m.group(0))
    src = COMMENT_RE.sub(blank, src)
    return STRING_RE.sub(lambda m: '""' + ' ' * (len(m.group(0)) - 2) if '\n' not in m.group(0) else blank(m), src)


def check_gml(rep, registered, orphans, object_gml):
    script_gml = []
    for (d, name), p in registered.items():
        if d == 'scripts':
            f = resolve(os.path.join(GAME, os.path.dirname(p), name + '.gml'))
            if f:
                script_gml.append(f)
            else:
                rep.error('script %s has no %s.gml' % (name, name))
    files = sorted(script_gml) + sorted(object_gml)
    sources = {f: open(f, encoding='utf-8-sig', errors='replace').read() for f in files}
    code = {f: strip_code(s) for f, s in sources.items()}

    # global functions, macros, enums
    funcs = {}
    macros = {}
    known = set(n for (_, n) in registered)
    for f in script_gml:
        for m in re.finditer(r'^function\s+([A-Za-z_]\w*)', code[f], re.M):
            funcs.setdefault(m.group(1), []).append(rel(f))
        for m in re.finditer(r'^\s*#macro\s+(\w+)[ \t]*(.*)', sources[f], re.M):
            known.add(m.group(1))
            if re.match(r'(-?[\d.]+|"[^"]*"|true|false)\s*(//.*)?$', m.group(2).strip()):
                macros[m.group(1)] = rel(f)     # a constant, not an expression that can take a value (LinkHealth)
        for m in re.finditer(r'\benum\s+(\w+)', code[f]):
            known.add(m.group(1))
    for fn, where in funcs.items():
        if len(where) > 1:
            rep.error('function %s defined more than once: %s' % (fn, ', '.join(where)))
    known |= set(funcs)

    # asset style names that do not exist
    orphan_names = {o.split('/')[-1] for o in orphans}
    asset_re = re.compile(r'(?<![\w.$])((?:s|o)[A-Z]\w*|(?:Sound|Music)_\w+)\b')
    missing = {}
    for f in files:
        c = code[f]
        local = set(re.findall(r'\bvar\s+(\w+)', c)) | set(re.findall(r'^\s*(\w+)\s*=', c, re.M))
        for params in re.findall(r'\bfunction\s*\w*\s*\(([^)]*)\)', c):
            local |= {a.split('=')[0].strip() for a in params.split(',')}
        for m in asset_re.finditer(c):
            n = m.group(1)
            if n in known or n in local:
                continue
            line = c.count('\n', 0, m.start()) + 1
            missing.setdefault(n, []).append('%s:%d' % (rel(f), line))
    for n, where in sorted(missing.items()):
        if n in orphan_names:
            rep.error('%s is used but only exists as an unregistered (orphan) resource: %s' % (n, where[0]))
        else:
            rep.warn('%s looks like an asset but does not exist: %s' % (n, ', '.join(where[:3])))

    # gotchas
    names = '|'.join(sorted(macros, key=len, reverse=True))
    macro_re = re.compile(r'(?:(?:^|[{,;])[ \t]*(%s)[ \t]*(?:=(?!=)|:(?!=))|\.(%s)\b)' % (names, names), re.M) if macros else None
    for f in files:
        c = code[f]
        # a variable or struct field named like a macro is replaced by the macro's value (Night is 3, __Chess)
        for m in (macro_re.finditer(c) if macro_re else []):
            name = m.group(1) or m.group(2)
            line = c.count('\n', 0, m.start()) + 1
            rep.error('%s:%d %s is a macro (%s): a variable or field of that name is replaced by its value'
                      % (rel(f), line, name, macros[name]))
        for m in re.finditer(r'\[\s*#[0-9A-Fa-f]{6}', sources[f]):
            line = sources[f].count('\n', 0, m.start()) + 1
            rep.error('%s:%d array literal starts with a #RRGGBB colour ([# is a ds_grid accessor); use make_colour_rgb'
                      % (rel(f), line))
        for m in re.finditer(r'\b\w+\[\s*(\w+)\s*\]\s*=[^;\n]*\b\1\+\+', c):
            line = c.count('\n', 0, m.start()) + 1
            rep.warn('%s:%d a[i] = ...i++: GML evaluates the right side first, so the value goes to the next index'
                     % (rel(f), line))
        # archetype enemies have oEnemy_Archetype as parent (roadmap F7)
        for m in re.finditer(r'object_get_parent\([^)]*\)\s*==\s*oEnemy\b(?!_)', c):
            line = c.count('\n', 0, m.start()) + 1
            rep.warn('%s:%d object_get_parent(...) == oEnemy misses the archetype enemies (parent oEnemy_Archetype); use object_is_ancestor'
                     % (rel(f), line))
        # level rules belong in the level sheet (roadmap F4)
        if not re.search(r'[\\/]__(Levels|Test)[\\/]', f):
            for m in re.finditer(r'switch\s*\(\s*global\.Level\.Index\s*\)|global\.Level\.Index\s*(==|!=|<|>|[-+*/](?!=))', c):
                line = c.count('\n', 0, m.start()) + 1
                rep.warn('%s:%d level rule on global.Level.Index; read a LevelDef field instead (scripts/__Levels)'
                         % (rel(f), line))
        src = sources[f]
        for m in re.finditer(r'draw_set_font\(\s*global\.Font_Small\s*\)', src):
            nxt = re.search(r'draw_set_font\(', src[m.end():])
            block = src[m.end(): m.end() + (nxt.start() if nxt else len(src))]
            for call in re.finditer(r'draw_text\w*\([^;\n]*', block):
                for lit in STRING_RE.finditer(call.group(0)):
                    text = re.sub(r'\\.', '', lit.group(0).lstrip('@')[1:-1])
                    if re.search(r'[a-z]', text):
                        line = src.count('\n', 0, m.end() + call.start()) + 1
                        rep.warn('%s:%d lower case text "%s" drawn with global.Font_Small (upper case only)'
                                 % (rel(f), line, text[:30]))
    rep.note('GML files checked: %d (%d scripts, %d object events), global functions: %d'
             % (len(files), len(script_gml), len(object_gml), len(funcs)))


# ---------------------------------------------------------------- data and docs

def check_data(rep):
    for f in load_yy(YYP).get('IncludedFiles', []):
        p = os.path.join(GAME, f['filePath'], f['name'])
        if not os.path.exists(p):
            rep.error('included file in Zelda.yyp is missing on disk: game/%s/%s' % (f['filePath'], f['name']))

    data_files = [('data_d', os.path.join(GAME, 'datafiles', 'data', 'data_d'))]
    sys.path.insert(0, os.path.join(REPO, 'tools', 'templates'))
    import convert
    rooms = [(cls, os.path.join(convert.ROOMS_DIR, cls + '.json')) for cls, _, _, _ in convert.CLASSES]
    data_files += rooms
    parsed = {}
    for name, p in data_files:
        shown = os.path.relpath(p, REPO).replace(os.sep, '/')
        if not os.path.exists(p):
            rep.error('missing %s' % shown)
        elif is_lfs_pointer(p):
            rep.warn('%s is a Git LFS pointer (run git lfs pull); not checked' % shown)
        else:
            if os.path.getsize(p) > 45e6:
                rep.warn('%s is %.0f MB; GitHub warns at 50 MB and refuses 100 MB (split the class by subclass)'
                         % (shown, os.path.getsize(p) / 1e6))
            try:
                parsed[name] = json.loads(open(p, 'rb').read().rstrip(b'\0'))
            except ValueError as e:
                rep.error('%s is not valid JSON: %s' % (shown, e))
    # the room template files must be what convert.py makes from the Tiled maps right now
    if all(cls in parsed for cls, _ in rooms):
        warnings = []
        try:
            fresh = convert.convert(warnings)
        except convert.ConvertError as e:
            rep.error('tools/templates/convert.py fails on the Tiled maps: %s' % e)
        else:
            for w in warnings:
                rep.warn('room templates: %s' % w)
            stale = [cls for ci, (cls, _) in enumerate(rooms)
                     if convert.class_text(fresh[ci]) != convert.class_text(parsed[cls])]
            if stale:
                rep.error('game/datafiles/data/rooms is out of date with data/room-templates (%s); '
                          'run python tools/templates/convert.py' % ', '.join(stale))
    check_room_sets(rep, convert)
    tdir = os.path.join(REPO, 'data', 'room-templates')
    for f in sorted(os.listdir(tdir)):
        if f.endswith('.json'):
            try:
                d = json.load(open(os.path.join(tdir, f), encoding='utf-8'))
            except ValueError as e:
                rep.error('data/room-templates/%s is not valid JSON: %s' % (f, e))
                continue
            ids = [o['id'] for l in d.get('layers', []) for o in l.get('objects', [])]
            if len(ids) != len(set(ids)):
                rep.error('data/room-templates/%s has repeated object ids' % f)


def check_control_chars(rep):
    """Control characters in source and docs: a regex '\\b' written through a shell that eats one backslash
    becomes a backspace and the regex silently stops matching (found in F11)."""
    bad = re.compile(rb'[\x00-\x08\x0b\x0c\x0e-\x1f]')
    globs = ['tools/**/*.py', 'game/scripts/**/*.gml', 'game/objects/**/*.gml', 'docs/**/*.md', '.claude/**/*.md',
             'tools/**/*.md', 'data/room-templates/sets/**/*.json', 'tools/test/scenarios/*.json']
    for g in globs:
        for p in glob.glob(os.path.join(REPO, g), recursive=True):
            raw = open(p, 'rb').read()
            m = bad.search(raw)
            if m:
                rep.error('%s:%d has a control character (0x%02x); a backslash was probably lost'
                          % (rel(p), raw.count(b'\n', 0, m.start()) + 1, raw[m.start()]))


def check_room_sets(rep, convert):
    """Room sets (roadmap F11): maps written by make_rooms.py match their description, the game files match the
    maps, every set file is an included file in Zelda.yyp and every RoomSet in the level sheet exists."""
    import make_rooms
    try:
        sets = convert.convert_sets([])
    except convert.ConvertError as e:
        rep.error('tools/templates/convert.py fails on a room set: %s' % e)
        return
    for n in sorted(os.listdir(convert.SETS_DIR)) if os.path.isdir(convert.SETS_DIR) else []:
        if not os.path.exists(os.path.join(convert.SETS_DIR, n, 'rooms.json')):
            continue
        try:
            halves = make_rooms.load_set(n)
        except make_rooms.RoomError as e:
            rep.error('room set %s: %s' % (n, e))
            continue
        by_class = {}
        for h in halves:
            by_class.setdefault(h.cls, []).append(h)
        ci_of = {c[0]: i for i, c in enumerate(convert.CLASSES)}
        for cls, hs in by_class.items():
            p = convert.map_path(ci_of[cls], n)
            text = json.dumps(make_rooms.build_map(cls, hs), indent=1) + '\n'
            if not os.path.exists(p) or open(p, encoding='utf-8').read() != text:
                rep.error('data/room-templates/sets/%s: the maps are out of date with rooms.json; '
                          'run python tools/templates/make_rooms.py %s' % (n, n))
                break
    rooms = convert.ROOMS_DIR
    index = os.path.join(rooms, 'sets.json')
    if not os.path.exists(index) or open(index, encoding='utf-8').read() != convert.sets_index(sets):
        rep.error('game/datafiles/data/rooms/sets.json is out of date; run python tools/templates/convert.py')
    for n, classes in sets.items():
        for cls, subclasses in classes.items():
            p = os.path.join(rooms, 'sets', n, cls + '.json')
            if not os.path.exists(p) or open(p, 'rb').read().decode('utf-8') != convert.class_text(subclasses):
                rep.error('game/datafiles/data/rooms/sets/%s/%s.json is out of date; run python tools/templates/convert.py'
                          % (n, cls))
    included = {(f['filePath'], f['name']) for f in load_yy(YYP).get('IncludedFiles', [])}
    for fp, name in convert.set_files(sets):
        if (fp, name) not in included:
            rep.error('game/%s/%s is not an included file in Zelda.yyp; run python tools/templates/convert.py' % (fp, name))
    for fp, name in included:
        if fp.startswith('datafiles/data/rooms/sets/') and (fp, name) not in convert.set_files(sets):
            rep.error('Zelda.yyp includes game/%s/%s, which no room set makes; run python tools/templates/convert.py'
                      % (fp, name))
    src = open(os.path.join(GAME, 'scripts', '__Levels', '__Levels.gml'), encoding='utf-8').read()
    for m in re.finditer(r'\bRoomSet\s*=\s*"([^"]*)"', COMMENT_RE.sub("", src)):
        if m.group(1) and m.group(1) not in sets:
            rep.error('__Levels.gml: RoomSet "%s" is not a room set (data/room-templates/sets)' % m.group(1))
    # painted rooms (roadmap F12b) paint with the level's RegionTiles: a level whose set paints must name that tileset
    for m in re.finditer(r'with\(_L\[DungeonLevel\.(\w+)\]\)\{(.*?)\n\t\}', COMMENT_RE.sub("", src), re.S):
        rs = re.search(r'\bRoomSet\s*=\s*"([^"]*)"', m.group(2))
        if not rs or rs.group(1) not in sets:
            continue
        painted = {t['Region']['tileset'] for subs in sets[rs.group(1)].values() for sub in subs for t in sub if 'Region' in t}
        rt = re.search(r'\bRegionTiles\s*=\s*"([^"]*)"', m.group(2))
        for name in sorted(painted - {rt.group(1) if rt else ''}):
            rep.error('__Levels.gml: %s takes room set %s, painted with %s, but its RegionTiles is "%s"'
                      % (m.group(1), rs.group(1), name, rt.group(1) if rt else ''))
    diffs = make_rooms.selftest()
    for d in diffs:
        rep.error('tools/templates/make_rooms.py --selftest: %s' % d)


def check_tiles(rep, registered):
    """Tilesets and the imported tile art (roadmap F6b): each tileset's texture (output_tileset.png, which the IDE
    writes and a build only copies) and tile_count fit its sprite; every TilesBand and RegionTiles of the level sheet
    exists; every region tileset has its data file, included in Zelda.yyp, with a class for each of its tiles."""
    try:
        from PIL import Image
    except ImportError:
        Image = None
    for (d, name), p in sorted(registered.items()):
        if d != 'tilesets':
            continue
        yy = load_yy(os.path.join(GAME, p))
        spr = registered.get(('sprites', (yy.get('spriteId') or {}).get('name')))
        if not spr:
            rep.error('%s: its sprite is not in the project' % name)
            continue
        sy = load_yy(os.path.join(GAME, spr))
        count = (sy['width'] // yy['tileWidth']) * (sy['height'] // yy['tileHeight'])
        if yy.get('tile_count') != count:
            rep.error('%s: tile_count %s but its sprite has %d tiles of %dx%d' % (
                name, yy.get('tile_count'), count, yy['tileWidth'], yy['tileHeight']))
        tex = os.path.join(GAME, 'tilesets', name, 'output_tileset.png')
        if not os.path.exists(tex):
            rep.error('%s: no output_tileset.png (the game draws nothing from it); import_region.py writes it' % name)
        elif Image is not None:
            cols = yy.get('out_columns', 1)
            cell = yy['tileWidth'] + 2 * yy.get('out_tilehborder', 2)
            w, h = Image.open(tex).size
            if w != cols * cell or h < -(-count // cols) * cell:
                rep.error('%s: output_tileset.png is %dx%d, %d tiles in %d columns need %dx%d; the texture is out of date '
                          '(import_region.py writes it)' % (name, w, h, count, cols, cols * cell, -(-count // cols) * cell))
    tiles_gml = open(os.path.join(GAME, 'scripts', '__Tiles', '__Tiles.gml'), encoding='utf-8').read()
    bands = set(re.findall(r'global\.TileBands\[\$ "(\w+)"\]', tiles_gml))
    src = COMMENT_RE.sub('', open(os.path.join(GAME, 'scripts', '__Levels', '__Levels.gml'), encoding='utf-8').read())
    for m in re.finditer(r'\bTilesBand\s*=\s*"([^"]*)"', src):
        if m.group(1) and m.group(1) not in bands:
            rep.error('__Levels.gml: TilesBand "%s" is not an imported band (global.TileBands in __Tiles.gml)' % m.group(1))
    tdir = os.path.join(GAME, 'datafiles', 'data', 'tiles')
    data = sorted(f[:-5] for f in os.listdir(tdir) if f.endswith('.json')) if os.path.isdir(tdir) else []
    for m in re.finditer(r'\bRegionTiles\s*=\s*"([^"]*)"', src):
        if m.group(1) and m.group(1) not in data:
            rep.error('__Levels.gml: RegionTiles "%s" has no game/datafiles/data/tiles/%s.json' % (m.group(1), m.group(1)))
    included = {(f['filePath'], f['name']) for f in load_yy(YYP).get('IncludedFiles', [])}
    for n in data:
        if ('datafiles/data/tiles', n + '.json') not in included:
            rep.error('game/datafiles/data/tiles/%s.json is not an included file in Zelda.yyp' % n)
        if ('tilesets', 'ts_' + n) not in registered:
            rep.error('game/datafiles/data/tiles/%s.json has no tileset ts_%s' % (n, n))
            continue
        try:
            js = json.load(open(os.path.join(tdir, n + '.json'), encoding='utf-8'))
        except ValueError as e:
            rep.error('game/datafiles/data/tiles/%s.json is not valid JSON: %s' % (n, e))
            continue
        count = load_yy(os.path.join(GAME, registered[('tilesets', 'ts_' + n)])).get('tile_count', 0)
        if len(js.get('class', [])) > count:
            rep.error('data/tiles/%s.json has %d tile classes, ts_%s only %d tiles' % (n, len(js['class']), n, count))
        bad = [i for i, b in enumerate(js.get('blocks', [])) if any(t[0] >= len(js.get('class', [])) for t in b)]
        if bad:
            rep.error('data/tiles/%s.json: blocks %s use tiles with no class' % (n, bad[:5]))


def pt_docs():
    docs = list(PT_DOCS)
    for d in PT_DOC_DIRS:
        full = os.path.join(REPO, d)
        if os.path.isdir(full):
            docs += ['%s/%s' % (d, f) for f in sorted(os.listdir(full)) if f.endswith('.md')]
    return docs


def check_docs(rep):
    for d in pt_docs():
        p = os.path.join(REPO, d)
        if not os.path.exists(p):
            continue
        for i, line in enumerate(open(p, encoding='utf-8'), 1):
            line = line.replace('(→)', '').replace('(—)', '')  # the rule itself
            if '→' in line or '—' in line:
                rep.warn('%s:%d uses an arrow or em dash (house style)' % (d, i))


def check_doc_refs(rep, path, registered, as_error):
    names = {n for (_, n) in registered}
    for i, line in enumerate(open(os.path.join(REPO, path), encoding='utf-8'), 1):
        if any(m in line for m in NEW_MARKERS):
            continue
        for a in ASSET_SPAN.findall(line):
            if a not in names and a != 'oEnemy_Exemplo':
                msg = '%s:%d cites %s, which is not in Zelda.yyp (write "(novo)" on the line if it is still to be made)' % (path, i, a)
                (rep.error if as_error else rep.warn)(msg)
        for d in DOC_SPAN.findall(line):
            if not os.path.exists(os.path.join(REPO, d)):
                rep.warn('%s:%d cites %s, which does not exist' % (path, i, d))


def check_regions(rep, registered):
    rdir = os.path.join(REPO, REGION_DIR)
    model = os.path.join(rdir, REGION_MODEL)
    if not os.path.exists(model):
        rep.error('missing %s/%s (the region spec model)' % (REGION_DIR, REGION_MODEL))
        return
    model_text = open(model, encoding='utf-8').read()
    sections = [l[3:].strip() for l in model_text.splitlines() if l.startswith('## ')]
    fields = re.findall(r'^\* \*\*(.+?):\*\*', model_text, re.M)
    for f in sorted(os.listdir(rdir)):
        if not f.endswith('.md') or f.startswith('_') or f == 'README.md':
            continue
        path = '%s/%s' % (REGION_DIR, f)
        text = open(os.path.join(rdir, f), encoding='utf-8').read()
        have = {l[3:].strip() for l in text.splitlines() if l.startswith('## ')}
        for sec in sections:
            if sec not in have:
                rep.error('%s is missing the section "## %s" (see %s)' % (path, sec, REGION_MODEL))
        for field in fields:
            if '**%s:**' % field not in text:
                rep.error('%s is missing the field "**%s:**" (see %s)' % (path, field, REGION_MODEL))
        m = re.search(r'\*\*Estado:\*\*\s*(.+)', text)
        if not m:
            rep.error('%s has no "**Estado:**" line' % path)
        elif m.group(1).strip().lower() not in REGION_STATES:
            rep.error('%s: Estado "%s" is not one of: %s' % (path, m.group(1).strip(), ', '.join(REGION_STATES)))
        check_doc_refs(rep, path, registered, as_error=True)
    ref = os.path.join(REPO, REF_DIR)
    if os.path.isdir(ref):
        for f in sorted(os.listdir(ref)):
            if f.endswith('.md'):
                check_doc_refs(rep, '%s/%s' % (REF_DIR, f), registered, as_error=False)


def check_exit_looks(rep):
    """Every ExitLook the level sheet names is a look in ExitLooks_Init (roadmap F4b)."""
    sys.path.insert(0, os.path.join(REPO, 'tools', 'test'))
    import scenario
    looks = scenario.exit_looks()
    path = os.path.join(REPO, 'game', 'scripts', '__Levels', '__Levels.gml')
    if not looks or not os.path.exists(path):
        rep.error('no exit looks found (ExitLooks_Init in __Doors.gml) or no level sheet')
        return
    for name in re.findall(r'ExitLook\s*=\s*"(\w+)"', open(path, encoding='utf-8').read()):
        if name not in looks:
            rep.error('game/scripts/__Levels/__Levels.gml: ExitLook "%s" is not in ExitLooks_Init (%s)' % (name, ', '.join(sorted(looks))))


def check_scenarios(rep):
    sys.path.insert(0, os.path.join(REPO, 'tools', 'test'))
    import scenario
    sdir = os.path.join(REPO, 'tools', 'test', 'scenarios')
    if not os.path.isdir(sdir):
        return
    for f in sorted(os.listdir(sdir)):
        if f.endswith('.json'):
            _, errors = scenario.load(os.path.join(sdir, f))
            for e in errors:
                rep.error('tools/test/scenarios/%s: %s' % (f, e))


def check_incoming(rep, registered):
    """incoming/<region>/imported.json (written by tools/import/import_region.py) matches the project and the files."""
    idir = os.path.join(REPO, 'incoming')
    if not os.path.isdir(idir):
        return
    sys.path.insert(0, os.path.join(REPO, 'tools', 'import'))
    import import_region
    for slug in sorted(os.listdir(idir)):
        d = os.path.join(idir, slug)
        if not os.path.isdir(d):
            continue
        recp = os.path.join(d, 'imported.json')
        if not os.path.exists(recp):
            if import_region.source_files(d):
                rep.note('incoming/%s is not imported yet (python tools/import/import_region.py %s)' % (slug, slug))
            continue
        try:
            rec = json.load(open(recp, encoding='utf-8'))
        except ValueError as e:
            rep.error('incoming/%s/imported.json is not valid JSON: %s' % (slug, e))
            continue
        missing = [n for kind, key in (('sprites', 'sprites'), ('sounds', 'sounds'), ('tilesets', 'tilesets'))
                   for n in rec.get(key, []) if (kind, n) not in registered]
        if rec.get('band') and rec['band'] not in import_region.bands():
            missing.append('the tile band ' + rec['band'])
        if missing:
            rep.error('incoming/%s was imported but %s are not in Zelda.yyp; run python tools/import/import_region.py %s'
                      % (slug, ', '.join(missing), slug))
        if import_region.source_hashes(d) != rec.get('sources'):
            rep.warn('incoming/%s changed since the last import; run python tools/import/import_region.py %s'
                     % (slug, slug))


# ---------------------------------------------------------------- main

def check_resource_order(rep):
    """Zelda.resource_order (the IDE's order of resources) only lists files that exist."""
    p = os.path.join(GAME, 'Zelda.resource_order')
    if not os.path.exists(p):
        return
    for path in re.findall(r'"path":"((?:scripts|objects|sprites|sounds|rooms|shaders|fonts|paths|tilesets)/[^"]+)"', open(p, encoding='utf-8').read()):
        if not resolve(os.path.join(GAME, path)):
            rep.warn('Zelda.resource_order lists %s, which does not exist (remove its line)' % path)


def check_archetypes(rep, registered):
    """Archetype enemies (roadmap F7): a child of oEnemy_Archetype has an EnemyArch entry and no events of its own,
    an entry names an object of the project whose parent is oEnemy_Archetype, and its Sprites exist."""
    path = os.path.join(GAME, 'scripts', '__EnemyArch', '__EnemyArch.gml')
    if not os.path.exists(path):
        return
    src = strip_code(open(path, encoding='utf-8').read())
    entries = set(re.findall(r'\bEnemyArch\(\s*(\w+)\s*,\s*\{', src))
    children = set()
    for (d, name), p in registered.items():
        if d != 'objects':
            continue
        yp = resolve(os.path.join(GAME, p))
        if not yp:
            continue
        yy = load_yy(yp)
        if (yy.get('parentObjectId') or {}).get('name') == 'oEnemy_Archetype':
            children.add(name)
            if yy.get('eventList'):
                rep.warn('%s: an archetype enemy should have no events of its own (its entry in __EnemyArch does it all)' % name)
    for n in sorted(children - entries):
        rep.error('%s has oEnemy_Archetype as parent but no EnemyArch(%s, {...}) in EnemyArch_Init' % (n, n))
    for n in sorted(entries - children):
        rep.error('__EnemyArch: EnemyArch(%s, ...) but %s is not an object of the project with oEnemy_Archetype as parent' % (n, n))
    sprites = {name for (d, name) in registered if d == 'sprites'}
    for base in set(re.findall(r'\[\s*EnemyState\.\w+\s*,\s*"(\w+)"\s*\]', open(path, encoding='utf-8').read())):
        dirs = all(base + s_ in sprites for s_ in ('_Left', '_Right', '_Up', '_Down'))
        if not dirs and base not in sprites:
            rep.error('__EnemyArch: no sprite %s (nor %s_Left/_Right/_Up/_Down)' % (base, base))


def main():
    args = sys.argv[1:]
    rep = Report()
    registered, orphans = check_project(rep)
    if '--orphans' in args:
        print('\n'.join(orphans))
        return 0
    object_gml = check_objects(rep, registered)
    check_sprites_sounds(rep, registered)
    check_gml(rep, registered, orphans, object_gml)
    check_data(rep)
    check_control_chars(rep)
    check_docs(rep)
    check_regions(rep, registered)
    check_exit_looks(rep)
    check_tiles(rep, registered)
    check_archetypes(rep, registered)
    check_resource_order(rep)
    check_scenarios(rep)
    check_incoming(rep, registered)

    if CASE_MISMATCH:
        for p in sorted(set(CASE_MISMATCH)):
            rep.warn('path only matches ignoring letter case (breaks on Linux/macOS): %s' % p)

    by_dir = {}
    for o in orphans:
        by_dir[o.split('/')[1]] = by_dir.get(o.split('/')[1], 0) + 1
    if orphans:
        rep.warn('unregistered (orphan) resources on disk: %d (%s); list them with --orphans'
                 % (len(orphans), ', '.join('%s %d' % kv for kv in sorted(by_dir.items()))))

    for title, items in (('ERRORS', rep.errors), ('WARNINGS', rep.warnings), ('NOTES', rep.notes)):
        if items:
            print('%s (%d)' % (title, len(items)))
            for it in items:
                print('  ' + it)
    ok = not rep.errors and not ('--strict' in args and rep.warnings)
    print('OK' if ok else 'FAILED')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
