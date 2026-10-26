# Hall of Fame (2x1 room, 512x256): walls from the end of the Sanctuary's front corridor, a red carpet running from the
# door on the left wall to the far end, and the altar lamps at both ends. Statues are objects placed along the top wall.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
from PIL import Image, ImageDraw
import numpy as np
H=HERE+''; HA=HERE+''
SP=HERE+'preview/'
B4=np.array(Image.open(H+'sanct_base4.png').convert('RGBA'))
O5=np.array(Image.open(H+'sanct_over5.png').convert('RGBA'))
W,Hh=512,256
src=B4[384:512]
w=src[56:112]
def hband(width):
    band=np.zeros((56,width,4),np.uint8)
    band[:,0:80]=w[:,160:240]; band[:,width-80:width]=w[:,272:352]
    segs=[w[:,216:240],w[:,272:296]]; x=80;k=0
    while x<width-80:
        s=segs[k%2]; n=min(24,width-80-x); band[:,x:x+n]=s[:,:n]; x+=n; k+=1
    return band
out=np.zeros((Hh,W,4),np.uint8)
b=hband(W); out[200:256]=b; out[0:56]=b[::-1]
side=src[8:56]
for y in range(56,200,48):
    n=min(48,200-y)
    out[y:y+n,0:56]=side[:n,160:216]; out[y:y+n,W-56:W]=side[:n,296:352]
clean=B4[280:320,176:224]
for yy in range(56,200,40):
    for xx in range(56,W-56,48):
        h=min(40,200-yy); ww=min(48,W-56-xx); out[yy:yy+h,xx:xx+ww]=clean[:h,:ww]
img=Image.fromarray(out,'RGBA'); d=ImageDraw.Draw(img)
# carpet from the door to the far wall, like the church's (red with gold edges)
RED=(107,33,33,255); GOLD=(132,115,33,255); GD=(90,74,33,255); K=(24,24,24,255)
d.rectangle([56,114,455,142],fill=K)
d.rectangle([56,115,455,141],fill=GOLD)
d.line([56,115,455,115],fill=GD); d.line([56,141,455,141],fill=GD)
d.rectangle([56,118,455,138],fill=RED)
# flower pots in the bottom corners (same as the Sanctuary)
src_txt=open(H+'festive_draw.py').read().split('base=Image.open')[0]
ns={}; exec(src_txt,ns)
for (px_,py_) in [(60,172),(436,172)]:
    img.alpha_composite(ns['plant'](),(px_,py_))
# lamps at both ends (the altar lamp stands, carpet pixels removed)
lamp=np.concatenate([B4[128:160,200:216]],0).copy()
ov=O5[128:160,200:216]
m=ov[...,3]>0; lamp[m]=ov[m]
reds={(107,33,33),(99,24,24),(115,33,33)}
dom=[tuple(c) for c in lamp[...,:3].reshape(-1,3)]
from collections import Counter
cc=Counter(dom).most_common(3)
for col,_ in cc[:1]:
    mm=(lamp[...,0]==col[0])&(lamp[...,1]==col[1])&(lamp[...,2]==col[2]); lamp[mm,3]=0
L=Image.fromarray(lamp,'RGBA')
for lx in (72,424):
    img.alpha_composite(L,(lx,64))
a=np.array(img)
a[100:156,0:56]=np.rot90(B4[440:496,228:284],-1)
img=Image.fromarray(a,'RGBA')
img.save(HA+'hall3_base.png')
Image.new('RGBA',(W,Hh),(0,0,0,0)).save(HA+'hall3_over.png')
# preview with statues
pv=img.copy()
names=[('Armos','Bronze',1),('Lanmola','Silver',0),('Moldorm','Silver',1),('Agahnim','Gold',0)]
fl=Image.open(H+'../hub/flameL_0.png') if False else None
for (k,t,f),cx in zip(names,(136,216,296,376)):
    pv.alpha_composite(Image.open(HA+f'statues/ped_{t}.png'),(cx-20,102))
    pv.alpha_composite(Image.open(HA+f'statues/fig_{k}_{f}.png'),(cx-20,106-50))
pv.resize((1024,512),Image.NEAREST).save(SP+'hall3.png')
print(cc)
