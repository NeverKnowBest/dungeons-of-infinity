import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import re
from PIL import Image, ImageDraw
import numpy as np
S=REPO+'/game/sprites/'
OUT=HERE+'statues/'
SP=HERE+'preview/'
def frames(n):
    s=open(f'{S}{n}/{n}.yy').read()
    fr=re.findall(r'"\$GMSpriteFrame":"v1","%Name":"([0-9a-f-]+)"',s)
    return [Image.open(f'{S}{n}/{f}.png').convert('RGBA') for f in fr]
RAMPS={
 'Bronze':[(40,20,8),(96,52,24),(152,92,44),(204,138,72),(240,192,128),(255,232,184)],
 'Silver':[(32,36,52),(80,88,112),(136,144,168),(184,192,212),(224,228,240),(255,255,255)],
 'Gold':  [(56,32,0),(128,88,8),(200,144,24),(240,192,48),(252,232,104),(255,255,208)],
}
def figure(kind):
    if kind=='Armos':
        return frames('sBoss_Armos')[0]
    if kind=='Agahnim':
        return frames('sBoss_Aghanim_Down')[0]
    if kind=='Lanmola':
        c=Image.new('RGBA',(36,46),(0,0,0,0))
        head=frames('sBoss_Lanmola_Head')[0]; body=frames('sBoss_Lanmola_Body')[0]; tail=frames('sBoss_Lanmola_Tail')[0]
        for im,(x,y) in [(tail,(4,30)),(body,(10,25)),(body,(16,19)),(body,(19,12)),(body,(15,6))]:
            c.alpha_composite(im,(x,y))
        c.alpha_composite(head,(9,0))
        return c
    if kind=='Moldorm':
        c=Image.new('RGBA',(40,44),(0,0,0,0))
        head=frames('sBoss_Moldorm_Head')[0]; big=frames('sBoss_Moldorm_Body_Large')[0]; small=frames('sBoss_Moldorm_Body_Small')[0]; tail=frames('sBoss_Moldorm_Tail')[0]
        for im,(x,y) in [(tail,(22,28)),(small,(14,27)),(big,(4,16))]:
            c.alpha_composite(im,(x,y))
        c.alpha_composite(head,(8,0))
        return c
def metal(fig,tier):
    a=np.array(fig).astype(float)
    lum=0.3*a[...,0]+0.59*a[...,1]+0.11*a[...,2]
    m=a[...,3]>0
    # normalise over the figure so every boss gets the full ramp
    lo,hi=np.percentile(lum[m],8),np.percentile(lum[m],99)
    t=np.clip((lum-lo)/max(hi-lo,1),0,1)
    ramp=np.array(RAMPS[tier],float)
    idx=np.clip((t**1.15*4.6).astype(int)+1,1,5)
    idx[lum<36]=0
    out=np.zeros_like(a); out[...,:3]=ramp[idx]; out[...,3]=np.where(m,255,0)
    return Image.fromarray(out.astype(np.uint8),'RGBA')
def outline(im,col=(16,12,20,255)):
    p=Image.new('RGBA',(im.width+2,im.height+2),(0,0,0,0)); p.alpha_composite(im,(1,1)); im=p
    a=np.array(im); m=a[...,3]>0
    o=np.zeros_like(m)
    for dx,dy in ((1,0),(-1,0),(0,1),(0,-1)):
        o|=np.roll(np.roll(m,dy,0),dx,1)
    o&=~m
    a[o]=col
    return Image.fromarray(a,'RGBA')
def silhouette(fig):
    a=np.array(fig); m=a[...,3]>0
    out=np.zeros_like(a); out[m]=(36,30,48,255)
    return Image.fromarray(out,'RGBA')
QM=["01110","11011","00011","00110","00100","00000","00100"]
def pedestal(tier,w=36):
    p=Image.new('RGBA',(w,16),(0,0,0,0)); d=ImageDraw.Draw(p)
    K=(16,12,20,255); T1,T2=(200,196,176,255),(160,152,136,255); F1,F2=(120,112,104,255),(88,80,76,255)
    d.rectangle([0,0,w-1,15],fill=K)
    d.rectangle([1,1,w-2,5],fill=T2); d.line([1,1,w-2,1],fill=T1)
    d.rectangle([1,6,w-2,14],fill=F1); d.line([1,14,w-2,14],fill=F2); d.line([w-2,6,w-2,14],fill=F2)
    d.line([0,6,w-1,6],fill=K)
    # metal plaque
    r=RAMPS[tier]; px=w//2-7
    d.rectangle([px,8,px+13,12],fill=K); d.rectangle([px+1,9,px+12,11],fill=r[3]); d.line([px+1,9,px+12,9],fill=r[5]); d.line([px+1,11,px+12,11],fill=r[2])
    return p
def build(kind,tier,revealed,W=40,H=64):
    fig=figure(kind)
    fig=outline(metal(fig,tier)) if revealed else outline(silhouette(fig),(20,16,28,255))
    c=Image.new('RGBA',(W,H),(0,0,0,0))
    ped=pedestal(tier,36)
    fx=(W-fig.width)//2; fy=H-14-fig.height
    c.alpha_composite(ped,((W-36)//2,H-16))
    c.alpha_composite(fig,(fx,fy))
    if not revealed:
        # question mark in the middle of the silhouette
        a=np.array(c)
        cx=W//2-2; cy=fy+fig.height//2-4
        for yy,row in enumerate(QM):
            for xx,ch in enumerate(row):
                if ch=='1':
                    for (ox,oy,col) in ((1,1,(16,12,20,255)),(0,0,(248,248,248,255))):
                        pass
        img=c.copy(); dr=img.load()
        for yy,row in enumerate(QM):
            for xx,ch in enumerate(row):
                if ch=='1': dr[cx+xx+1,cy+yy+1]=(16,12,20,255)
        for yy,row in enumerate(QM):
            for xx,ch in enumerate(row):
                if ch=='1': dr[cx+xx,cy+yy]=(248,248,248,255)
        c=img
    return c
STAT=[('Armos','Bronze'),('Lanmola','Silver'),('Moldorm','Silver'),('Agahnim','Gold')]
if __name__=='__main__':
    prev=Image.new('RGBA',(8*44,70),(88,64,56,255))
    for i,(k,t) in enumerate(STAT):
        a=build(k,t,True); b=build(k,t,False)
        a.save(OUT+f'{k}_0.png'); b.save(OUT+f'{k}_1.png')
        prev.alpha_composite(a,(i*88,3)); prev.alpha_composite(b,(i*88+44,3))
    prev.resize((prev.width*3,prev.height*3),Image.NEAREST).save(SP+'statues.png')

def figure_only(kind,tier,revealed):
    fig=figure(kind)
    fig=outline(metal(fig,tier)) if revealed else outline(silhouette(fig),(20,16,28,255))
    c=Image.new('RGBA',(40,50),(0,0,0,0))
    c.alpha_composite(fig,((40-fig.width)//2,50-fig.height))
    if not revealed:
        dr=c.load(); cx=18; cy=50-fig.height//2-4
        for yy,row in enumerate(QM):
            for xx,ch in enumerate(row):
                if ch=='1': dr[cx+xx+1,cy+yy+1]=(16,12,20,255)
        for yy,row in enumerate(QM):
            for xx,ch in enumerate(row):
                if ch=='1': dr[cx+xx,cy+yy]=(248,248,248,255)
    return c

def gallery_assets():
    for k,t in STAT:
        figure_only(k,t,True).save(OUT+f'fig_{k}_0.png'); figure_only(k,t,False).save(OUT+f'fig_{k}_1.png')
    for t in ('Bronze','Silver','Gold'):
        p=Image.new('RGBA',(40,16),(0,0,0,0)); p.alpha_composite(pedestal(t,36),(2,0)); p.save(OUT+f'ped_{t}.png')
