import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
from PIL import Image, ImageDraw
T=REPO+'/data/room-templates/Tiled Objects/'
H=HERE+''
SP=HERE+'preview/'
OUT=(16,16,24,255)
PD,PM,PL=(64,32,104,255),(112,64,168,255),(160,112,208,255)
GD,GM,GL=(168,112,24,255),(232,176,48,255),(248,232,128,255)
W=(248,248,248,255)
def px(im,pts,c):
    for p in pts: im.putpixel(p,c)

def counter():
    # 16 x 72: draped purple cloth with gold trim, front end hanging with a fringe
    im=Image.new('RGBA',(16,72),(0,0,0,0)); d=ImageDraw.Draw(im)
    d.rectangle([0,0,15,63],fill=OUT)
    d.rectangle([1,1,14,62],fill=PM)
    d.rectangle([1,1,14,1],fill=PL)            # light top edge
    d.line([1,2,1,62],fill=PL)
    d.line([14,2,14,62],fill=PD)
    d.line([3,3,3,60],fill=GM); d.line([12,3,12,60],fill=GD)   # gold trim stripes
    for y in range(6,60,8):                     # small gold diamonds down the middle
        px(im,[(7,y),(8,y),(7,y+1),(8,y+1)],GM); px(im,[(7,y-1),(8,y+2)],GL)
    # front face of the cloth (counter's front, seen from above)
    d.rectangle([0,56,15,67],fill=OUT)
    d.rectangle([1,57,14,66],fill=PD)
    d.line([1,57,14,57],fill=PM)
    d.line([1,63,14,63],fill=GM)
    for x in range(1,15,2):                     # fringe
        px(im,[(x,64),(x,65)],GM); px(im,[(x,66)],GD)
        px(im,[(x,67)],OUT)
    return im

def vase():
    im=Image.new('RGBA',(12,16),(0,0,0,0)); d=ImageDraw.Draw(im)
    # stems/leaves
    G1,G2=(40,120,48,255),(88,184,72,255)
    d.line([5,5,5,10],fill=G1); d.line([7,4,6,10],fill=G1); d.line([3,6,5,10],fill=G1); d.line([9,6,7,10],fill=G1)
    px(im,[(4,8),(8,8)],G2)
    # blossoms
    for (cx,cy,c) in [(3,4,(248,104,136,255)),(6,2,(248,216,64,255)),(9,4,(232,72,72,255)),(5,6,(248,160,200,255))]:
        px(im,[(cx-1,cy),(cx+1,cy),(cx,cy-1),(cx,cy+1)],c); px(im,[(cx,cy)],W)
    # vase
    d.rectangle([3,10,8,15],fill=OUT); d.rectangle([4,10,7,14],fill=(72,112,200,255))
    d.line([4,11,4,13],fill=(144,184,248,255)); px(im,[(7,13),(6,14)],(40,64,136,255))
    d.line([3,10,8,10],fill=OUT); d.line([4,11,7,11],fill=GM)
    return im

def gift(w,h,box,boxd,rib):
    im=Image.new('RGBA',(w,h+3),(0,0,0,0)); d=ImageDraw.Draw(im)
    d.rectangle([0,3,w-1,h+2],fill=OUT); d.rectangle([1,4,w-2,h+1],fill=box)
    d.line([1,h+1,w-2,h+1],fill=boxd); d.line([w-2,4,w-2,h+1],fill=boxd)
    mx=w//2
    d.line([mx,4,mx,h+1],fill=rib); d.line([1,4+(h-2)//2,w-2,4+(h-2)//2],fill=rib)
    # bow
    px(im,[(mx-2,1),(mx-1,2),(mx+1,2),(mx+2,1),(mx-2,2),(mx+2,2),(mx,3)],rib)
    px(im,[(mx-3,1),(mx-3,2),(mx+3,1),(mx+3,2),(mx-2,0),(mx+2,0)],OUT)
    return im

def plant():
    im=Image.new('RGBA',(16,24),(0,0,0,0)); d=ImageDraw.Draw(im)
    G0,G1,G2=(24,72,32,255),(40,120,48,255),(88,184,72,255)
    d.ellipse([1,1,14,15],fill=G0); d.ellipse([2,2,13,13],fill=G1)
    for p in [(5,4),(9,5),(4,9),(10,10),(7,7),(6,12)]: px(im,[p,(p[0]+1,p[1])],G2)
    for (cx,cy,c) in [(4,5,(248,104,136,255)),(10,4,(248,216,64,255)),(11,10,(232,72,72,255)),(5,11,(248,216,64,255)),(8,8,(248,160,200,255))]:
        px(im,[(cx-1,cy),(cx+1,cy),(cx,cy-1),(cx,cy+1)],c); px(im,[(cx,cy)],W)
    # pot
    d.polygon([(3,15),(12,15),(11,23),(4,23)],fill=OUT)
    d.polygon([(4,16),(11,16),(10,22),(5,22)],fill=(184,96,48,255))
    d.line([4,16,11,16],fill=(232,152,88,255)); d.line([5,18,5,21],fill=(232,152,88,255)); d.line([10,17,9,22],fill=(120,56,24,255))
    d.line([3,15,12,15],fill=OUT); d.line([4,17,11,17],fill=GM)
    return im

def amphora(body,dark,light):
    im=Image.new('RGBA',(12,16),(0,0,0,0)); d=ImageDraw.Draw(im)
    d.rectangle([4,0,7,1],fill=OUT); d.rectangle([4,1,7,3],fill=OUT); px(im,[(5,1),(6,1),(5,2),(6,2)],body)
    d.ellipse([1,3,10,15],fill=OUT); d.ellipse([2,4,9,14],fill=body)
    d.line([3,6,3,11],fill=light); px(im,[(4,5),(4,12)],light)
    d.line([8,7,8,12],fill=dark); px(im,[(7,13),(6,14),(5,14)],dark)
    d.line([2,8,9,8],fill=GM); d.line([3,10,8,10],fill=GM)
    return im

def bunting(w):
    im=Image.new('RGBA',(w,12),(0,0,0,0))
    cols=[(232,56,56,255),(248,216,64,255),(64,136,232,255),(80,192,80,255),(248,136,200,255)]
    import math
    ys=[int(round(1+3*math.sin(math.pi*x/(w-1)))) for x in range(w)]
    for x in range(w): im.putpixel((x,ys[x]),(64,40,24,255))
    i=0
    for x0 in range(2,w-5,6):
        c=cols[i%len(cols)]; i+=1
        y0=ys[x0+2]+1
        for r in range(5):
            for x in range(x0+r//2, x0+5-r//2):
                im.putpixel((x,y0+r),c if r<4 else OUT)
            im.putpixel((x0+r//2,y0+r),OUT); im.putpixel((x0+4-r//2,y0+r),OUT)
    return im

base=Image.open(H+'sanct_base4.png').convert('RGBA')
b=base.copy()
cx=184
b.alpha_composite(counter(),(cx,264))
b.alpha_composite(plant(),(160,240))
b.alpha_composite(amphora((64,112,200,255),(32,56,128,255),(160,200,248,255)),(162,266))
b.alpha_composite(vase(),(cx+2,268))
b.alpha_composite(amphora((184,96,48,255),(120,56,24,255),(232,152,88,255)),(cx+2,296))
b.alpha_composite(bunting(42),(159,256))
b.save(H+'sanct_base6.png')
prev=b.copy()
prev.alpha_composite(Image.open(H+'flute/boy_0.png').convert('RGBA'),(164,291))
prev.alpha_composite(Image.open(H+'sanct_over5.png').convert('RGBA'))
prev.crop((130,220,260,360)).resize((520,560),Image.NEAREST).save(SP+'counter2.png')
