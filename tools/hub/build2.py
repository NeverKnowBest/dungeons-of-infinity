# Sanctuary hub, stage 2: the original ALttP Sanctuary (room 0x12) as a 2x2 hub room.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import sys, json, re
sys.path.insert(0, HERE)
import tiledjson, gm_assets
from gids import GID

FORK = REPO+''
TILED = FORK + '/data/room-templates/Room Templates Other.json'
DATA_R = FORK + '/game/datafiles/data/data_r'
DATA_D = FORK + '/game/datafiles/data/data_d'
W = H = 512
RX, RY = 1176, 1176            # free spot in the Tiled map
BOY_TEXT = "Hey there! Want a new look? I can only fit you with the ones you've earned."
OBJS = [  # layer, gid name, x, y, w, h, extra
    ('Objs', 'NPC', 164, 291, 16, 24, {'name': 'Villager_FluteBoy', 'type': 'Sitting',
                                      'properties': [('Dialogue', 'string', BOY_TEXT), ('NoWall', 'string', '')]}),
]


def load(p):
    raw = open(p, 'rb').read()
    return json.loads(raw.rstrip(b'\0')), raw.endswith(b'\0')


def save(p, d, nul):
    open(p, 'wb').write(json.dumps(d, separators=(',', ':'), ensure_ascii=False).encode() + (b'\0' if nul else b''))


def remove_tiled_objects(txt, ids):
    for i in ids:
        key = '\n                 "id":%d,\n' % i
        k = txt.index(key)
        start = txt.rindex('\n                {\n', 0, k)
        end = txt.index('\n                }', k) + len('\n                }')
        # remove the separator too: either the ", " before us or the ", " after us
        if txt[start - 2:start] == ', ':
            txt = txt[:start - 2] + txt[end:]
        elif txt[end:end + 3] == ', \n':
            txt = txt[:start + 1] + txt[end + 3:]
        else:
            txt = txt[:start] + txt[end:]
    return txt


def tiled():
    txt = open(TILED).read()
    td = json.loads(txt)
    old = [o for o in td['layers'][0]['objects'] if o['name'] == 'Sanctuary']
    if old:
        rid = old[0]['id']
        ids = [o['id'] for l in td['layers'] if 'objects' in l for o in l['objects']
               if o['id'] == rid or any(p['name'] == 'Room' and p['value'] == rid for p in o.get('properties', []))]
        txt = remove_tiled_objects(txt, ids)
        json.loads(txt)
    td = json.loads(txt)
    room_id = td['nextobjectid']
    lay = {'Rooms': [{"height": H, "id": room_id, "name": "Sanctuary", "rotation": 0, "type": "Unique",
                      "visible": True, "width": W, "x": RX, "y": RY}]}
    oid = room_id + 1
    for layer, g, x, y, w, h, extra in OBJS:
        lay.setdefault(layer, []).append({"gid": GID[g], "height": h, "id": oid, "name": extra.get('name', ''),
            "properties": [{"name": n, "type": t, "value": v} for n, t, v in extra.get('properties', [])] +
                          [{"name": "Room", "type": "object", "value": room_id}],
            "rotation": 0, "type": extra.get('type', ''), "visible": True, "width": w, "x": RX + x, "y": RY + y})
        oid += 1
    for lname, olist in lay.items():
        key = '"name":"%s",\n         "objects":[' % lname
        a = txt.index(key) + len(key)
        b = txt.index('}],\n         "opacity"', a) + 1
        txt = txt[:b] + ''.join(', \n' + tiledjson._obj(o, 16) for o in olist) + txt[b:]
    txt = re.sub(r'"nextobjectid":\d+,', '"nextobjectid":%d,' % oid, txt, count=1)
    assert json.loads(txt)['nextobjectid'] == oid
    open(TILED, 'w').write(txt)
    return room_id


def data(room_id):
    dr, nul = load(DATA_R)
    uniq = dr[9][2]
    layers = ["Pit", "Holes", "Water", "FloorObjs", "WallsLower", "WallsUpper", "WallsCommon", "Objs",
              "Stairs", "Doors", "LowerFloor", "ExtraCeilings", "OutOfBounds"]
    e = {k: [] for k in layers}
    oid = room_id + 1
    for layer, g, x, y, w, h, extra in OBJS:
        e[layer].append({"height": float(h), "x": float(x), "y": float(y), "width": float(w), "gid": float(GID[g]),
                         "id": float(oid), "visible": True, "rotation": 0.0, "type": extra.get('type', ''),
                         "name": extra.get('name', ''),
                         "properties": [{"type": t, "name": n, "value": v} for n, t, v in extra.get('properties', [])] +
                                       [{"type": "object", "name": "Room", "value": float(room_id)}]})
        oid += 1
    e.update({"x": float(RX), "y": float(RY), "width": float(W), "height": float(H), "id": float(room_id),
              "visible": True, "rotation": 0.0, "type": "Unique", "name": "Sanctuary",
              "Sections": [{} for _ in range(31)], "SizeIndex": 3,
              "RoomTransformationsAllowed": [True] + [False] * 7})
    uniq[:] = [t for t in uniq if t['name'] != 'Sanctuary'] + [e]
    save(DATA_R, dr, nul)

    dd, nul = load(DATA_D)
    room = {"x": 768, "GridW": 2, "GridH": 2, "y": 768, "width": 512, "height": 512, "Template": -1, "Lighting": 0,
            "Section_ID": 0, "Section_WallType": 0, "Section_Color": 0, "SpecialObj": 0, "SpecialObjSection": 0,
            "Warp_DestRoomIndex": -1, "WarpDest_WarpRoomIndex": -1, "Warp_DestGridPosition": -1,
            "GridX": 3, "GridY": 3, "Doors": []}
    dd[6][5] = {"Rooms": [room]}
    save(DATA_D, dd, nul)


def walls_gml():
    rects = json.load(open(HERE+'sanct_walls.json'))
    rows = ',\n\t\t'.join('[%d, %d, %d, %d]' % tuple(r) for r in rects)
    return rows


def assets():
    gm_assets.sprite('sHub_Sanctuary', HERE+'sanct_base.png')
    gm_assets.sprite('sHub_Sanctuary_Over', HERE+'sanct_over.png')
    gm_assets.sound('Music_Sanctuary_Intro', HERE+'audio/Music_Sanctuary_Intro.wav', 38.4)
    gm_assets.sound('Music_Sanctuary_Main', HERE+'audio/Music_Sanctuary_Main.wav', 23.55)
    gm_assets.obj('oHubBackdrop', {'Draw_0': '// Draws one layer of a pre-rendered hub room (set sprite_index when creating it)\nPixelRender_Normal();\n'})
    gm_assets.obj('oHubExit', {
        'Create_0': open(HERE+'oHubExit_Create.gml').read(),
        'Step_0': open(HERE+'oHubExit_Step.gml').read(),
        'Draw_64': open(HERE+'oHubExit_Draw64.gml').read(),
    })


if __name__ == '__main__':
    rid = tiled()
    data(rid)
    assets()
    open(HERE+'walls.txt', 'w').write(walls_gml())
    print('ok', rid)
