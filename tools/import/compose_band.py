"""Composes a region's tileset band (incoming/<region>/tileset.png) from a theme band and ROM pieces (roadmap F6b).

  python tools/import/compose_band.py <region>              writes incoming/<region>/tileset.png
  python tools/import/compose_band.py <region> --preview    also tools/import/out/<region>/band_preview.png

The recipe is incoming/<region>/band.json; the band keeps the layout of its base theme (cells as [column, row] of
the 156 x 6 tiles of a band, sizes in tiles), so the base theme's drawing code still fits:

  "base":    the theme whose band is the starting point (import_region.py --export-band <base>)
  "recolor": [{"area": [c, r, w, h], "to_blocks": [n, ...]}]   the colors of the area, darkest to lightest, become
             the colors of those region blocks (tiles/tiles.json), darkest to lightest; both must have the same count
  "blocks":  [{"at": [c, r], "block": n}]                       a 16x16 region block over 2x2 cells
  "tiles":   [{"at": [c, r], "block": n, "quarter": k}]         one 8x8 quarter of a block (0 top left .. 3 bottom right)
  "fill":    [{"area": [c, r, w, h], "color_of_block": [n, k]}] solid color: the k-th darkest color of block n
  "crenels": [{"area": [c, r, w, h], "edges": ["top", ...], "period": 8, "depth": 3, "color_of_block": [n, k]}]
             battlements: along each edge of the area, the outer `depth` pixels of every second half `period` take
             that color (the gaps between the merlons)

Every color comes from the ROM pieces of the region, so the importer's palette rules leave the band as it is. Needs
Pillow (python -m pip install --user pillow).
"""
import os, sys, json

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import import_region as ir

TILE = 8


def region_tiles(d):
    from PIL import Image
    t = os.path.join(d, 'tiles')
    meta = json.load(open(os.path.join(t, 'tiles.json'), encoding='utf-8'))
    return meta, Image.open(os.path.join(t, 'tiles.png')).convert('RGBA')


def block_image(meta, sheet, n):
    from PIL import Image
    if not 0 <= n < len(meta['blocks']):
        raise ir.ImportError_('band.json: block %d does not exist (tiles.json has %d)' % (n, len(meta['blocks'])))
    cols, im = meta['columns'], Image.new('RGBA', (16, 16))
    for k, (i, f) in enumerate(meta['blocks'][n]['tiles']):
        t = sheet.crop(((i % cols) * TILE, (i // cols) * TILE, (i % cols + 1) * TILE, (i // cols + 1) * TILE))
        if f & 1:
            t = t.transpose(Image.FLIP_LEFT_RIGHT)
        if f & 2:
            t = t.transpose(Image.FLIP_TOP_BOTTOM)
        im.paste(t, ((k % 2) * TILE, (k // 2) * TILE))
    return im


def ramp(pixels):
    """The opaque colors, darkest to lightest."""
    return sorted({p[:3] for p in pixels if p[3]}, key=lambda c: (0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2], c))


def box(area):
    c, r, w, h = area
    if c < 0 or r < 0 or w < 1 or h < 1 or c + w > ir.BAND_W // TILE or r + h > ir.BAND_H // TILE:
        raise ir.ImportError_('band.json: area %s is outside the band (156 x 6 tiles)' % (area,))
    return c * TILE, r * TILE, (c + w) * TILE, (r + h) * TILE


def compose(slug):
    d = os.path.join(ir.REPO, 'incoming', slug)
    recipe = json.load(open(os.path.join(d, 'band.json'), encoding='utf-8'))
    bad = set(recipe) - {'base', 'recolor', 'blocks', 'tiles', 'fill', 'crenels'}
    if bad:
        raise ir.ImportError_('band.json: unknown keys %s' % sorted(bad))
    meta, sheet = region_tiles(d)
    band = ir.theme_band(recipe['base']).copy()
    px = band.load()

    def block_color(nk):
        cs = ramp(block_image(meta, sheet, nk[0]).getdata())
        return cs[nk[1]] + (255,)

    for op in recipe.get('recolor', []):
        x0, y0, x1, y1 = box(op['area'])
        src = ramp(band.crop((x0, y0, x1, y1)).getdata())
        dst = ramp([p for n in op['to_blocks'] for p in block_image(meta, sheet, n).getdata()])
        if len(src) != len(dst):
            raise ir.ImportError_('band.json: recolor %s has %d colors, blocks %s have %d'
                                  % (op['area'], len(src), op['to_blocks'], len(dst)))
        m = dict(zip(src, dst))
        for y in range(y0, y1):
            for x in range(x0, x1):
                p = px[x, y]
                if p[3]:
                    px[x, y] = m[p[:3]] + (p[3],)
    for op in recipe.get('blocks', []):
        x0, y0, _, _ = box(list(op['at']) + [2, 2])
        band.paste(block_image(meta, sheet, op['block']), (x0, y0))
    for op in recipe.get('tiles', []):
        x0, y0, _, _ = box(list(op['at']) + [1, 1])
        q = op['quarter']
        band.paste(block_image(meta, sheet, op['block']).crop(((q % 2) * TILE, (q // 2) * TILE,
                                                               (q % 2 + 1) * TILE, (q // 2 + 1) * TILE)), (x0, y0))
    for op in recipe.get('fill', []):
        x0, y0, x1, y1 = box(op['area'])
        band.paste(block_color(op['color_of_block']), (x0, y0, x1, y1))
    for op in recipe.get('crenels', []):
        x0, y0, x1, y1 = box(op['area'])
        per, dep, col = op.get('period', 8), op.get('depth', 3), block_color(op['color_of_block'])
        for e in op['edges']:
            if e not in ('top', 'bottom', 'left', 'right'):
                raise ir.ImportError_('band.json: crenel edge %r (top, bottom, left, right)' % e)
            along = range(x0, x1) if e in ('top', 'bottom') else range(y0, y1)
            for a in along:
                if ((a - (x0 if e in ('top', 'bottom') else y0)) % per) < per // 2:
                    continue
                for k in range(dep):
                    x, y = {'top': (a, y0 + k), 'bottom': (a, y1 - 1 - k),
                            'left': (x0 + k, a), 'right': (x1 - 1 - k, a)}[e]
                    px[x, y] = col
    return d, recipe, band


def preview(slug, recipe, band):
    """Base band over the new one, both 3x, rows of 52 tiles."""
    from PIL import Image, ImageDraw
    base, sc, per = ir.theme_band(recipe['base']), 3, 52
    w, h = per * TILE * sc, ir.BAND_H * sc
    parts = (ir.BAND_W // TILE + per - 1) // per
    out = Image.new('RGBA', (w, parts * (2 * h + 30)), (24, 24, 32, 255))
    dr = ImageDraw.Draw(out)
    for i in range(parts):
        y = i * (2 * h + 30)
        dr.text((2, y + 2), 'columns %d-%d: %s (top), %s (bottom)' % (i * per, (i + 1) * per - 1, recipe['base'], slug),
                fill=(230, 230, 230, 255))
        for k, im in enumerate((base, band)):
            part = im.crop((i * per * TILE, 0, (i + 1) * per * TILE, ir.BAND_H)).resize((w, h), Image.NEAREST)
            out.paste(part, (0, y + 14 + k * (h + 2)), part)
    p = os.path.join(ir.REPO, 'tools', 'import', 'out', slug, 'band_preview.png')
    os.makedirs(os.path.dirname(p), exist_ok=True)
    out.save(p)
    return p


def main(args):
    if not args or args[0].startswith('-'):
        sys.exit(__doc__)
    try:
        d, recipe, band = compose(args[0])
    except ir.ImportError_ as e:
        sys.exit('ERROR: %s' % e)
    p = os.path.join(d, 'tileset.png')
    band.save(p)
    print('Wrote %s (%dx%d, base %s, %d colors)' % (os.path.relpath(p, ir.REPO), band.width, band.height,
                                                    recipe['base'], len(ramp(band.getdata()))))
    if '--preview' in args:
        print('Preview %s' % os.path.relpath(preview(args[0], recipe, band), ir.REPO))


if __name__ == '__main__':
    main(sys.argv[1:])
