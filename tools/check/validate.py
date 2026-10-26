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
  * data: data_r, data_d and the Tiled room templates parse as JSON
  * docs: no arrows or em dashes in the Portuguese docs (house style)
  * region specs (docs/regioes/*.md): every section of _modelo.md is there,
    a valid Estado, and the assets and docs they cite exist; the reference
    sheets (docs/ref/*.md) are checked for assets too
"""
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
    known = set(n for (_, n) in registered)
    for f in script_gml:
        for m in re.finditer(r'^function\s+([A-Za-z_]\w*)', code[f], re.M):
            funcs.setdefault(m.group(1), []).append(rel(f))
        for m in re.finditer(r'^\s*#macro\s+(\w+)', sources[f], re.M):
            known.add(m.group(1))
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
    for f in files:
        c = code[f]
        for m in re.finditer(r'\[\s*#[0-9A-Fa-f]{6}', sources[f]):
            line = sources[f].count('\n', 0, m.start()) + 1
            rep.error('%s:%d array literal starts with a #RRGGBB colour ([# is a ds_grid accessor); use make_colour_rgb'
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
    for name in ('data_r', 'data_d'):
        p = os.path.join(GAME, 'datafiles', 'data', name)
        if not os.path.exists(p):
            rep.error('missing game/datafiles/data/%s' % name)
        elif is_lfs_pointer(p):
            rep.warn('game/datafiles/data/%s is a Git LFS pointer (run git lfs pull); not checked' % name)
        else:
            try:
                json.loads(open(p, 'rb').read().rstrip(b'\0'))
            except ValueError as e:
                rep.error('game/datafiles/data/%s is not valid JSON: %s' % (name, e))
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
    sections = [l[3:].strip() for l in open(model, encoding='utf-8') if l.startswith('## ')]
    for f in sorted(os.listdir(rdir)):
        if not f.endswith('.md') or f.startswith('_') or f == 'README.md':
            continue
        path = '%s/%s' % (REGION_DIR, f)
        text = open(os.path.join(rdir, f), encoding='utf-8').read()
        have = {l[3:].strip() for l in text.splitlines() if l.startswith('## ')}
        for sec in sections:
            if sec not in have:
                rep.error('%s is missing the section "## %s" (see %s)' % (path, sec, REGION_MODEL))
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


# ---------------------------------------------------------------- main

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
    check_docs(rep)
    check_regions(rep, registered)

    if CASE_MISMATCH:
        rep.note('paths that only match ignoring letter case: %d (fine on Windows, break on Linux/macOS)'
                 % len(set(CASE_MISMATCH)))

    by_dir = {}
    for o in orphans:
        by_dir[o.split('/')[1]] = by_dir.get(o.split('/')[1], 0) + 1
    if orphans:
        rep.note('unregistered (orphan) resources on disk: %d (%s); list them with --orphans'
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
