# Sanctuary hub rooms (data only): the Sanctuary (2x2) and the Hall of Fame (2x1), Unique templates in the Other class,
# and the hub layout (Special dungeon template 5) with the two rooms. The rooms go into the Tiled map and the game's
# room templates are then rebuilt from it with tools/templates/convert.py.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import sys, json, re
sys.path.insert(0, HERE)
import tiledjson
from gids import GID
from build2 import load, save, remove_tiled_objects, room_templates, FORK, TILED, DATA_D, BOY_TEXT

W = H = 512
ROOMS = [  # name, Tiled position, grid position, size in grid cells, objects
    ('Sanctuary', (1176, 1176), (3, 3), (2, 2), [
        ('Objs', 'NPC', 164, 291, 16, 24, {'name': 'Villager_FluteBoy', 'type': 'Sitting',
                                          'properties': [('Dialogue', 'string', BOY_TEXT), ('NoWall', 'string', '')]}),
    ]),
    ('HallOfFame', (600, 1176), (5, 3), (2, 1), []),
]


def tiled():
    txt = open(TILED).read()
    td = json.loads(txt)
    names = [r[0] for r in ROOMS]
    old = [o for o in td['layers'][0]['objects'] if o['name'] in names]
    for o in old:
        td = json.loads(txt)
        rid = o['id']
        ids = [ob['id'] for l in td['layers'] if 'objects' in l for ob in l['objects']
               if ob['id'] == rid or any(p['name'] == 'Room' and p['value'] == rid for p in ob.get('properties', []))]
        txt = remove_tiled_objects(txt, ids)
        json.loads(txt)
    td = json.loads(txt)
    oid = td['nextobjectid']
    lay = {}
    ids = {}
    for name, (rx, ry), _, size, objs in ROOMS:
        room_id = oid; oid += 1; ids[name] = room_id
        lay.setdefault('Rooms', []).append({"height": 256 * size[1], "id": room_id, "name": name, "rotation": 0, "type": "Unique",
                                           "visible": True, "width": 256 * size[0], "x": rx, "y": ry})
        for layer, g, x, y, w, h, extra in objs:
            lay.setdefault(layer, []).append({"gid": GID[g], "height": h, "id": oid, "name": extra.get('name', ''),
                "properties": [{"name": n, "type": t, "value": v} for n, t, v in extra.get('properties', [])] +
                              [{"name": "Room", "type": "object", "value": room_id}],
                "rotation": 0, "type": extra.get('type', ''), "visible": True, "width": w, "x": rx + x, "y": ry + y})
            oid += 1
    for lname, olist in lay.items():
        key = '"name":"%s",\n         "objects":[' % lname
        a = txt.index(key) + len(key)
        b = txt.index('}],\n         "opacity"', a) + 1
        txt = txt[:b] + ''.join(', \n' + tiledjson._obj(o, 16) for o in olist) + txt[b:]
    txt = re.sub(r'"nextobjectid":\d+,', '"nextobjectid":%d,' % oid, txt, count=1)
    assert json.loads(txt)['nextobjectid'] == oid
    open(TILED, 'w').write(txt)
    return ids


def data(ids):
    room_templates()
    rooms = []
    for name, (rx, ry), (gx, gy), size, objs in ROOMS:
        rooms.append({"x": gx * 256, "GridW": size[0], "GridH": size[1], "y": gy * 256, "width": 256 * size[0], "height": 256 * size[1], "Template": -1,
                      "Lighting": 0, "Section_ID": 0, "Section_WallType": 0, "Section_Color": 0, "SpecialObj": 0,
                      "SpecialObjSection": 0, "Warp_DestRoomIndex": -1, "WarpDest_WarpRoomIndex": -1,
                      "Warp_DestGridPosition": -1, "GridX": gx, "GridY": gy, "Doors": []})
    dd, nul = load(DATA_D)
    dd[6][5] = {"Rooms": rooms}
    save(DATA_D, dd, nul)


if __name__ == '__main__':
    ids = tiled()
    data(ids)
    print(ids)
