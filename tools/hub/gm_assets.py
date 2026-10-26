# Helpers that write GameMaker 2024 asset files (sprites, sounds, objects) and register them in Zelda.yyp.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import os, uuid, shutil, re
from PIL import Image

GAME = REPO+'/game'
ELDER = GAME + '/sprites/sVillager_Elder_Down/sVillager_Elder_Down.yy'


def u():
    return str(uuid.uuid4())


def sprite(name, png_path, folder=('Sprites', 'folders/Sprites.yy'), frames=None, fps=None, origin=None):
    if frames is None:
        frames = [png_path]
    ims = [Image.open(p).convert('RGBA') for p in frames]
    im = ims[0]
    w, h = im.size
    d = os.path.join(GAME, 'sprites', name)
    layer = u()
    fids = [u() for _ in ims]
    old = os.path.join(d, name + '.yy')
    if os.path.exists(old):   # keep the frame/layer ids so the files overwrite the previous ones
        t = open(old).read()
        of = re.findall(r'"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]+)"', t)
        ol = re.findall(r'"\$GMImageLayer":"","%Name":"([0-9a-f-]+)"', t)
        if len(of) == len(fids) and ol:
            fids = of; layer = ol[0]
    if os.path.isdir(d):
        shutil.rmtree(d)
    for fid, fim in zip(fids, ims):
        os.makedirs(os.path.join(d, 'layers', fid))
        fim.save(os.path.join(d, fid + '.png'))
        fim.save(os.path.join(d, 'layers', fid, layer + '.png'))
    s = open(ELDER).read()
    fl = re.search(r'    \{"\$GMSpriteFrame".*\n', s).group(0)
    s = s.replace(fl, ''.join(fl.replace('a476df4c-aa92-41d9-85ab-6c3ef8b85dc0', f) for f in fids))
    kf = re.search(r'            \{"\$Keyframe<SpriteFrameKeyframe>".*\n', s).group(0)
    kfs = ''
    for i, f in enumerate(fids):
        kfs += kf.replace('a476df4c-aa92-41d9-85ab-6c3ef8b85dc0', f).replace('13fd97b7-8b86-43a1-aa00-69501580382f', u()).replace('"Key":0.0,', '"Key":%d.0,' % i)
    s = s.replace(kf, kfs)
    s = s.replace('"length":1.0,', '"length":%d.0,' % len(fids))
    if fps:
        s = s.replace('"playbackSpeed":0.0,', '"playbackSpeed":%s,' % float(fps))
    s = s.replace('dd4ef468-ff95-46c6-bc73-d2c54d25cdbf', layer)
    s = s.replace('sVillager_Elder_Down', name)
    s = s.replace('"bbox_bottom":22,', '"bbox_bottom":%d,' % (h - 1))
    s = s.replace('"bbox_right":15,', '"bbox_right":%d,' % (w - 1))
    s = s.replace('"bbox_top":7,', '"bbox_top":0,')
    s = s.replace('"height":23,', '"height":%d,' % h)
    s = s.replace('"width":16,', '"width":%d,' % w)
    ox, oy, ok = (0, 0, 0) if origin is None else origin
    s = s.replace('"origin":7,', '"origin":%d,' % ok)
    s = s.replace('"xorigin":8,', '"xorigin":%d,' % ox)
    s = s.replace('"yorigin":23,', '"yorigin":%d,' % oy)
    s = s.replace('"name":"Elder",\n    "path":"folders/Objects/Characters/NPCs/Villagers/Inside/Elder.yy",',
                  '"name":"%s",\n    "path":"%s",' % folder)
    assert folder[1] in s
    open(os.path.join(d, name + '.yy'), 'w').write(s)
    register('sprites', name)


def sound(name, wav_path, duration, folder=('Music', 'folders/Sounds/Music.yy')):
    d = os.path.join(GAME, 'sounds', name)
    os.makedirs(d, exist_ok=True)
    shutil.copy(wav_path, os.path.join(d, name + '.wav'))
    yy = '''{
  "$GMSound":"v2",
  "%%Name":"%(n)s",
  "audioGroupId":{
    "name":"audiogroup_Music",
    "path":"audiogroups/audiogroup_Music",
  },
  "bitDepth":1,
  "channelFormat":0,
  "compression":0,
  "compressionQuality":4,
  "conversionMode":0,
  "duration":%(dur).6f,
  "exportDir":"",
  "name":"%(n)s",
  "parent":{
    "name":"%(fn)s",
    "path":"%(fp)s",
  },
  "preload":false,
  "resourceType":"GMSound",
  "resourceVersion":"2.0",
  "sampleRate":22050,
  "soundFile":"%(n)s.wav",
  "volume":0.7,
}''' % {'n': name, 'dur': duration, 'fn': folder[0], 'fp': folder[1]}
    open(os.path.join(d, name + '.yy'), 'w').write(yy)
    register('sounds', name)


EVENT = '    {"$GMEvent":"v1","%%Name":"","collisionObjectId":null,"eventNum":%d,"eventType":%d,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},\n'


def obj(name, events, sprite_name=None, parent=None, folder=('Objects', 'folders/Objects.yy')):
    """events: dict filename -> code, e.g. {'Create_0': '...', 'Step_0': '...', 'Draw_64': '...'}"""
    types = {'Create': 0, 'Destroy': 1, 'Alarm': 2, 'Step': 3, 'Draw': 8, 'CleanUp': 12, 'Other': 7}
    d = os.path.join(GAME, 'objects', name)
    os.makedirs(d, exist_ok=True)
    ev = ''
    for fn, code in events.items():
        t, n = fn.split('_')
        ev += EVENT % (int(n), types[t])
        open(os.path.join(d, fn + '.gml'), 'w').write(code)
    spr = 'null' if not sprite_name else '{\n    "name":"%s",\n    "path":"sprites/%s/%s.yy",\n  }' % (sprite_name, sprite_name, sprite_name)
    par = 'null' if not parent else '{\n    "name":"%s",\n    "path":"objects/%s/%s.yy",\n  }' % (parent, parent, parent)
    yy = '''{
  "$GMObject":"",
  "%%Name":"%(n)s",
  "eventList":[
%(ev)s  ],
  "managed":true,
  "name":"%(n)s",
  "overriddenProperties":[],
  "parent":{
    "name":"%(fn)s",
    "path":"%(fp)s",
  },
  "parentObjectId":%(par)s,
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":%(spr)s,
  "spriteMaskId":null,
  "visible":true,
}''' % {'n': name, 'ev': ev, 'fn': folder[0], 'fp': folder[1], 'par': par, 'spr': spr}
    open(os.path.join(d, name + '.yy'), 'w').write(yy)
    register('objects', name)


def register(kind, name):
    p = GAME + '/Zelda.yyp'
    s = open(p).read()
    line = '    {"id":{"name":"%s","path":"%s/%s/%s.yy",},},\n' % (name, kind, name, name)
    if line in s:
        return
    # insert after the last entry of the same kind
    idx = [m.end() for m in re.finditer(r'    \{"id":\{"name":"[^"]*","path":"%s/[^\n]*\n' % kind, s)]
    assert idx, kind
    s = s[:idx[-1]] + line + s[idx[-1]:]
    open(p, 'w').write(s)
