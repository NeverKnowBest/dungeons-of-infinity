"""Where a region stands in the "nova região" flow (roadmap F10), read from its spec and the project.

    python tools/region/status.py topo-do-castelo
    python tools/region/status.py docs/regioes/topo-do-castelo.md

Reads docs/regioes/<region>.md and checks each step of the flow against the project: the level sheet
entry and the chapter it belongs to, the NextPool of the chapter before, the exit look, the graphics in
incoming/<region>/, the enemies, the sounds and music, and the reference scenario. It also flags what
the tools cannot do yet (a "GAP" line: the skill stops there instead of improvising) and what Guilherme
still has to deliver (a "WAIT" line, e.g. the graphics in incoming/).

It only reads files (standard library, no GameMaker). Exit code 0 with a report (the report is the result),
1 when the spec does not exist, 2 on bad arguments.
"""
import os, re, sys, glob

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(REPO, 'tools', 'test'))
import scenario  # noqa: E402  (enums, exit looks)

SCRIPTS = os.path.join(REPO, 'game', 'scripts')
LEVELS = os.path.join(SCRIPTS, '__Levels', '__Levels.gml')
ARCH = os.path.join(SCRIPTS, '__EnemyArch', '__EnemyArch.gml')
ENEMIES = os.path.join(SCRIPTS, '__Enemies', '__Enemies.gml')
NEW = '(novo)'

# Archetype moves that exist (F7) and the ones still missing, with words a spec would use for them.
ARCH_MOVES = ['Dir', 'Toward', 'Scuttle', 'Dash']
ARCH_MISSING = {
    'Shoot': ['atira', 'projétil', 'projetil', 'shoot', 'octorok'],
    'Hop': ['pula', 'salta', 'hop', 'tektite'],
    'Wave': ['onda', 'wave', 'keese', 'bari'],
    'Hide': ['esconde', 'some no chão', 'hide', 'leever', 'zol'],
}


def read(path):
    return open(path, encoding='utf-8', errors='replace').read()


def strip_gml(src):
    return re.sub(r'//[^\n]*', '', re.sub(r'/\*.*?\*/', '', src, flags=re.S))


def registered_assets():
    names = set()
    for m in re.finditer(r'"name":"(\w+)","path":"(?:objects|sprites|sounds)/', read(os.path.join(REPO, 'game', 'Zelda.yyp'))):
        names.add(m.group(1))
    return names


def level_sheet():
    """{level member: {'depth': n, 'next': member or None, 'pool': [(member, weight)], 'look': str, 'theme': str}}.

    Defaults as in Level_Create: Depth and Theme are the level's own index, Next the index + 1,
    NextPool [[Next, 1]], ExitLook "StairsDown"."""
    members = scenario.enums().get('DungeonLevel', {})
    src = strip_gml(read(LEVELS))
    sheet = {}
    for name, value in members.items():
        if re.search(r'_L\[DungeonLevel\.%s\]\s*=\s*new Level_Create' % name, src):
            sheet[name] = {'depth': value, 'next': '', 'pool': None, 'look': 'StairsDown', 'theme': name, 'roomset': ''}
    for m in re.finditer(r'with\(_L\[DungeonLevel\.(\w+)\]\)\{(.*?)\n\t\}', src, re.S):
        d = sheet.get(m.group(1))
        if d is None:
            continue
        body = m.group(2)
        x = re.search(r'\bDepth\s*=\s*(\d+)', body)
        if x:
            d['depth'] = int(x.group(1))
        x = re.search(r'\bNext\s*=\s*(?:DungeonLevel\.(\w+)|-1)', body)
        if x:
            d['next'] = x.group(1)  # None for Next = -1 (the last level)
        x = re.search(r'\bNextPool\s*=\s*(\[.*?\]\])', body, re.S)
        if x:
            d['pool'] = [(a, int(w)) for a, w in re.findall(r'DungeonLevel\.(\w+)\s*,\s*(\d+)', x.group(1))]
        x = re.search(r'\bExitLook\s*=\s*"(\w+)"', body)
        if x:
            d['look'] = x.group(1)
        x = re.search(r'\bTheme\s*=\s*DungeonLevel\.(\w+)', body)
        if x:
            d['theme'] = x.group(1)
        x = re.search(r'\bRoomSet\s*=\s*"(\w*)"', body)
        if x:
            d['roomset'] = x.group(1)
    by_value = {v: n for n, v in members.items()}
    for name, d in sheet.items():
        if d['next'] == '':
            d['next'] = by_value.get(members[name] + 1)
        if d['pool'] is None:
            d['pool'] = [(d['next'], 1)] if d['next'] else []
    return sheet


def spec_fields(text):
    return {m.group(1): m.group(2).strip() for m in re.finditer(r'^\* \*\*(.+?):\*\*\s*(.*)$', text, re.M)}


def spec_section(text, title):
    m = re.search(r'^## %s\s*$(.*?)(?=^## |\Z)' % re.escape(title), text, re.M | re.S)
    return m.group(1) if m else ''


def enemy_rows(text):
    rows = []
    for line in spec_section(text, 'Inimigos').splitlines():
        m = re.match(r'\|\s*`(oEnemy_\w+)`(.*)$', line)
        if m:
            rows.append((m.group(1), line))
    return rows


class Report:
    def __init__(self):
        self.lines, self.gaps, self.waits, self.todo = [], [], [], []

    def ok(self, msg):
        self.lines.append('  ok    ' + msg)

    def do(self, msg):
        self.lines.append('  todo  ' + msg)
        self.todo.append(msg)

    def gap(self, key, msg):
        self.lines.append('  GAP   [%s] %s' % (key, msg))
        self.gaps.append((key, msg))

    def wait(self, msg):
        self.lines.append('  WAIT  ' + msg)
        self.waits.append(msg)

    def note(self, msg):
        self.lines.append('  note  ' + msg)

    def head(self, title):
        self.lines.append('')
        self.lines.append(title)


def main(argv):
    if len(argv) != 1:
        print(__doc__)
        return 2
    arg = argv[0]
    path = arg if arg.endswith('.md') else os.path.join(REPO, 'docs', 'regioes', arg + '.md')
    path = os.path.abspath(path)
    slug = os.path.splitext(os.path.basename(path))[0]
    try:
        sys.stdout.reconfigure(encoding='utf-8')  # the spec's Portuguese words; Windows defaults to cp1252
    except (AttributeError, ValueError):
        pass
    if not os.path.exists(path):
        print('no spec at %s: copy docs/regioes/_modelo.md and fill it first' % os.path.relpath(path, REPO))
        return 1
    text = read(path)
    fields = spec_fields(text)
    assets = registered_assets()
    sheet = level_sheet()
    looks = scenario.exit_looks()
    r = Report()

    # 1. Spec
    r.head('1. Spec (docs/regioes/%s.md)' % slug)
    estado = fields.get('Estado', '?')
    r.note('Estado: %s' % estado)
    tipo = fields.get('Tipo', '').lower()
    if re.search(r'área externa|area externa|jardim|campina|floresta', tipo) and 'dungeon' not in tipo:
        r.gap('area-externa', 'Tipo is an outdoor area: the generator only makes dungeons (roadmap Ideias, outdoor areas)')
    if re.search(r'outro zelda|minish|link.s awakening|oracle', tipo):
        r.note('region from another Zelda: check docs/ref for its sheet and docs/dev/receitas.md "Conteúdo de outro Zelda"')
    m = re.search(r'`DungeonLevel\.(\w+)`', fields.get('Fase', ''))
    level = m.group(1) if m else None
    if not level:
        r.do('header field "**Fase:**" names no `DungeonLevel.X`: choose the enum member')
    depth = None
    m = re.search(r'Depth`?\s*(\d+)', fields.get('Capítulo', ''))
    if m:
        depth = int(m.group(1))
        r.ok('chapter: Depth %d' % depth)
    else:
        r.do('"**Capítulo:**" gives no `Depth` N')

    # 2. Graphics
    r.head('2. Graphics (incoming/%s, F6)' % slug)
    inc = os.path.join(REPO, 'incoming', slug)
    graficos = fields.get('Gráficos', '')
    if 'só assets que já existem' in graficos.lower():
        r.ok('the spec uses only existing assets')
    elif not os.path.isdir(inc):
        r.wait('incoming/%s/ does not exist: Guilherme delivers the graphics first (incoming/README.md)' % slug)
    else:
        files = [os.path.relpath(p, inc) for p in glob.glob(os.path.join(inc, '**', '*'), recursive=True) if os.path.isfile(p)]
        r.ok('incoming/%s/ has %d files' % (slug, len(files)))
        if os.path.exists(os.path.join(inc, 'imported.json')):
            r.ok('imported (imported.json); the validator says if the sources changed since')
        else:
            r.do('import: python tools/import/import_region.py %s --dry-run, then without --dry-run' % slug)
        if os.path.exists(os.path.join(inc, 'tileset.png')):
            r.gap('tileset', 'tileset.png: the importer makes sTiles_<Region>, but sTiles is full and no level can use another band yet (roadmap Ideias, "Tileset de região")')
        if any(f.lower().startswith('sounds') for f in files):
            r.gap('sfx', 'sounds/: the importer only reads music/*.wav; sound effects are not imported (F6)')

    # 3. Level sheet and exits
    r.head('3. Level sheet and exits (__Levels.gml, F4 and F4b)')
    if level and level in sheet:
        d = sheet[level]
        r.ok('DungeonLevel.%s has an entry (Depth %d, ExitLook %s, Theme %s)' % (level, d['depth'], d['look'], d['theme']))
        if depth is not None and d['depth'] != depth:
            r.do('Depth in the sheet is %d, the spec says %d' % (d['depth'], depth))
    elif level:
        r.do('new DungeonLevel.%s (end of the enum in __Dungeon.gml) and its entry in Levels_Init' % level)
    if depth is not None:
        same = sorted(n for n, d in sheet.items() if d['depth'] == depth and n != level)
        before = sorted(n for n, d in sheet.items() if d['depth'] == depth - 1)
        after = sorted(n for n, d in sheet.items() if d['depth'] == depth + 1)
        r.note('chapter %d now: %s' % (depth, ', '.join(same) or '(none)'))
        r.note('chapter %d (before): %s; chapter %d (after): %s' % (depth - 1, ', '.join(before) or '(none)', depth + 1, ', '.join(after) or '(none)'))
        for b in before:
            pool = sheet[b]['pool'] or []
            if level and any(p == level for p, _ in pool):
                r.ok('%s NextPool leads to %s (%s)' % (b, level, pool))
            else:
                r.do('%s NextPool %s: add %s with the weight the spec gives' % (b, pool, level or 'the new level'))
    look_text = fields.get('Visual da saída', '')
    named = [w for w in re.findall(r'`(\w+)`', look_text) if w[0].isupper()]
    if not named:
        r.do('"**Visual da saída:**" names no look (`StairsDown`, `StairsUp`...)')
    if level in sheet and named and sheet[level]['look'] != named[0]:
        r.do('ExitLook in the sheet is %s, the spec says %s' % (sheet[level]['look'], named[0]))
    for w in named:
        if w in looks:
            r.ok('exit look %s exists (ExitLooks_Init)' % w)
        elif NEW in look_text:
            r.do('new exit look %s in ExitLooks_Init (__Doors.gml): drawing, sounds, LinkAnim, Entrance, MapIcon (receitas, "Estágio alternativo" step 3)' % w)
        else:
            r.do('exit look %s is not in ExitLooks_Init and the line does not say "(novo)"' % w)

    # 4. Rooms
    r.head('4. Rooms (room set, make_rooms.py and convert.py, F11)')
    salas = spec_section(text, 'Salas')
    if re.search(r'subclasse|conjunto de (templates|salas)|templates? nov|salas novas|\(novo\)', salas, re.I):
        set_name = level or '<Fase>'
        desc = os.path.join(REPO, 'data', 'room-templates', 'sets', set_name, 'rooms.json')
        if os.path.exists(desc):
            r.ok('room set %s described (data/room-templates/sets/%s/rooms.json)' % (set_name, set_name))
        else:
            r.do('room set %s: describe the halves in data/room-templates/sets/%s/rooms.json, then make_rooms.py %s and convert.py (receitas, "Conjunto de salas de uma região")' % (set_name, set_name, set_name))
        if os.path.exists(os.path.join(REPO, 'game', 'datafiles', 'data', 'rooms', 'sets', set_name)):
            r.ok('room set %s converted (game/datafiles/data/rooms/sets/%s)' % (set_name, set_name))
        elif os.path.exists(desc):
            r.do('python tools/templates/make_rooms.py %s && python tools/templates/convert.py' % set_name)
        if level in sheet and sheet[level]['roomset'] == set_name:
            r.ok('the level sheet has RoomSet "%s"' % set_name)
        else:
            r.do('RoomSet = "%s" in the level sheet' % set_name)
        if re.search(r'\b(Stairs|Obstacles|Sections|Jails)\b|escadas? internas?|obst[áa]culos', salas):
            r.gap('salas-classe', 'the spec asks for rooms of a class make_rooms.py does not write yet (it writes Main_Upper and Main_Lower halves); those rooms keep the shared templates until the helper learns it')
    if re.search(r'refer[êe]ncia para a F8|convers[ãa]o da F8', salas, re.I):
        r.note('rooms of reference for F8: only a reference, not needed to build the region')
    if re.search(r'(precisa|pede|depende) da F8', salas, re.I):
        r.gap('f8', 'the rooms depend on converting ALttP rooms (F8, not done)')

    # 5. Enemies
    r.head('5. Enemies (F7)')
    arch_src = read(ARCH) if os.path.exists(ARCH) else ''
    arch = set(re.findall(r'EnemyArch\((oEnemy_\w+)', arch_src))
    data = set(re.findall(r'EnemyDataInit\((oEnemy_\w+)', read(ENEMIES)))
    for obj, line in enemy_rows(text):
        kind = 'archetype' if obj in arch else 'own code'
        if obj in assets:
            r.ok('%s exists (%s%s)' % (obj, kind, '' if obj in data else ', NO EnemyDataInit: the generator never places it'))
            if obj not in data:
                r.do('EnemyDataInit for %s in Enemies_InitData' % obj)
            create = os.path.join(REPO, 'game', 'objects', obj, 'Create_0.gml')
            if os.path.exists(create) and 'EnemyStats' in read(create):
                r.note('%s reads LevelDef.EnemyStats in its Create: check what it takes from the EnemyStats level' % obj)
        elif NEW in line:
            low = line.lower()
            missing = [mv for mv, words in ARCH_MISSING.items() if any(re.search(r'\b%s\b' % re.escape(w), low) for w in words)]
            if missing:
                r.gap('arquetipo', '%s (novo) needs the archetype move %s, which F7 does not have yet (has: %s)' % (obj, '/'.join(missing), ', '.join(ARCH_MOVES)))
            else:
                r.do('%s (novo): sprites via the importer, object child of oEnemy_Archetype, EnemyDataInit, EnemyArch entry (receitas, "Inimigo novo por arquétipo")' % obj)
        else:
            r.do('%s is not in Zelda.yyp and the row does not say "(novo)"' % obj)
    chefe = spec_section(text, 'Chefe').strip()
    if chefe and not chefe.lower().startswith('nenhum'):
        r.note('boss: own code, not a data entry; plan a preview and one or two tuning rounds (roadmap, "Expectativa")')

    # 6. Music, sound, weather
    r.head('6. Music, sound and weather')
    for sec in ('Música e som', 'Clima e efeitos'):
        for line in spec_section(text, sec).splitlines():
            for a in re.findall(r'`((?:Sound|Music)_\w+)`', line):
                if a in assets:
                    r.ok('%s exists' % a)
                elif NEW in line and a.startswith('Music_'):
                    r.do('%s (novo): music/*.wav in incoming/%s, the importer adds it to SongIndex' % (a, slug))
                elif NEW in line:
                    r.gap('sfx', '%s (novo) is a sound effect: no tool extracts SFX from the ROM (tools/alttp has music only) and the importer only reads music/' % a)
            for o in re.findall(r'`(o[A-Z]\w*)`', line):
                if o not in assets and NEW in line:
                    r.do('%s (novo): code of the region (planned in the spec, code changes)' % o)

    # 7. Tests
    r.head('7. Tests (F3, F3b)')
    if level:
        refs = glob.glob(os.path.join(REPO, 'tools', 'test', 'scenarios', 'ref_*_%s.json' % level))
        if refs:
            r.ok('reference scenario %s' % os.path.basename(refs[0]))
        else:
            n = len(glob.glob(os.path.join(REPO, 'tools', 'test', 'scenarios', 'ref_*.json')))
            r.do('reference scenario ref_%02d_%s.json (copy the closest ref_*, receitas "Comparar antes e depois")' % (n, level))
        r.do('region scenario: start in %s with a fixed seed, walk to the exit (step exit), contact sheet with 5 seeds' % level)

    print('Region %s: %s' % (slug, fields.get('Origem', '')))
    print('\n'.join(r.lines))
    print('')
    if r.gaps:
        keys = sorted({k for k, _ in r.gaps})
        print('STOP: %d gap(s) the tools do not cover yet: %s (see .claude/skills/nova-regiao/references/lacunas.md)' % (len(r.gaps), ', '.join(keys)))
    if r.waits:
        print('WAIT: %d delivery(ies) from Guilherme missing' % len(r.waits))
    if not r.gaps and not r.waits:
        print('READY: no gaps; %d step(s) to do' % len(r.todo))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
