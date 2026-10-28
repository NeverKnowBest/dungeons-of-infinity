# Builds an example region for import_region.py out of assets the project already has, so the importer can be
# tested without new graphics. Nothing here is meant to stay in the game: import it, check, then --remove it.
#
#   python tools/import/make_example.py [folder]      default tools/import/out/example (ignored by git)
#
# It covers every input the convention accepts: numbered frames, a sheet cut by the manifest, an animated GIF,
# a sprite without outline ("outline": "add"), one with too many colors, a tileset band and a song with a loop.
import os, sys, re, json, wave
from PIL import Image
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
GAME = os.path.join(REPO, 'game')
sys.path.insert(0, HERE)
import import_region


def frames(name):
    t = open(os.path.join(GAME, 'sprites', name, name + '.yy')).read()
    ids = re.findall(r'"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]+)"', t)
    return [Image.open(os.path.join(GAME, 'sprites', name, i + '.png')).convert('RGBA') for i in ids]


def main():
    d = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'out', 'example')
    for sub in ('sprites', 'music'):
        os.makedirs(os.path.join(d, sub), exist_ok=True)
    sd = os.path.join(d, 'sprites')
    for f in os.listdir(sd):
        os.remove(os.path.join(sd, f))

    # numbered frames: Enemy_ExRat_Walk_Down_0.png, _1.png
    for i, f in enumerate(frames('sEnemy_Rat_Walk_Down')):
        f.save(os.path.join(sd, 'Enemy_ExRat_Walk_Down_%d.png' % i))
    # a sheet, cut by "frame" in the manifest
    ropa = frames('sEnemy_Ropa')
    sheet = Image.new('RGBA', (16 * len(ropa), 22))
    for i, f in enumerate(ropa):
        sheet.paste(f, (16 * i, 0))
    sheet.save(os.path.join(sd, 'Enemy_ExRopa.png'))
    # an animated GIF (its speed becomes the fps)
    bari = [f.convert('RGBA') for f in frames('sEnemy_Bari_Walking')]
    pal = [f.convert('P', palette=Image.ADAPTIVE, colors=255) for f in bari]
    for p, f in zip(pal, bari):          # index 255 is the clear color
        a = np.array(p)
        a[np.array(f)[..., 3] < 128] = 255
        p.putdata(a.reshape(-1).tolist())
    pal[0].save(os.path.join(sd, 'Enemy_ExBari.gif'), save_all=True, append_images=pal[1:], duration=166,
                loop=0, transparency=255, disposal=2)
    # no outline: the rat with its dark pixels taken out
    rat = np.array(frames('sEnemy_Rat_Walk_Down')[0])
    dark = (rat[..., 3] > 0) & (rat[..., :3].astype(int).sum(axis=-1) < 200)
    rat[dark] = 0
    Image.fromarray(rat).save(os.path.join(sd, 'Enemy_ExRatNoOutline.png'))
    # too many colors and soft shading: a piece of the Sanctuary picture with a gradient over it
    hub = frames('sHub_Sanctuary')[0].crop((224, 112, 256, 144))
    g = np.array(hub).astype(float)
    g[..., :3] *= np.linspace(0.6, 1.2, 32)[None, :, None]
    Image.fromarray(np.clip(g, 0, 255).astype(np.uint8)).save(os.path.join(sd, 'Deco_ExFloor.png'))

    # tileset: the Castle band, tinted blue as if it were a new region
    band = np.array(import_region.theme_band('Castle')).astype(float)
    band[..., :3] *= np.array([0.8, 0.9, 1.15])
    Image.fromarray(np.clip(band, 0, 255).astype(np.uint8)).save(os.path.join(d, 'tileset.png'))

    # music: the first 6 s of the Sanctuary song, looping from 2 s
    src = wave.open(os.path.join(GAME, 'sounds', 'Music_Sanctuary_Main', 'Music_Sanctuary_Main.wav'))
    out = wave.open(os.path.join(d, 'music', 'ExTheme.wav'), 'wb')
    out.setparams(src.getparams())
    out.writeframes(src.readframes(src.getframerate() * 6))
    out.close()

    manifest = {
        'name': 'Example',
        'defaults': {'fps': 8, 'origin': 'center'},
        'sprites': {
            'Enemy_ExRopa': {'frame': [16, 22], 'origin': [8, 20]},
            'Enemy_ExRatNoOutline': {'outline': 'add'},
            'Deco_ExFloor': {'origin': 'top-left', 'outline': 'off'},
        },
        'tileset': {'base': 'Castle'},
        'music': {'ExTheme': {'loop': 2.0}},
    }
    json.dump(manifest, open(os.path.join(d, 'manifest.json'), 'w'), indent=1)
    print('Example region in %s' % os.path.relpath(d, REPO).replace(os.sep, '/'))


if __name__ == '__main__':
    main()
