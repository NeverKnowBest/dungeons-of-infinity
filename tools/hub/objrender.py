# Render SNES OBJ tiles from a VRAM+CGRAM dump (sprdump output).
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import numpy as np
from PIL import Image
class Obj:
    def __init__(self, path):
        d=open(path,'rb').read()
        self.vram=np.frombuffer(d[:0x10000],np.uint8)
        c=np.frombuffer(d[0x10000:0x10200],'<u2').astype(np.int32)
        r=(c&31)<<3;g=((c>>5)&31)<<3;b=((c>>10)&31)<<3
        self.cols=np.stack([r|r>>5,g|g>>5,b|b>>5],-1).astype(np.uint8)
    def tile(self, n):
        base=(0x4000 + n*16)*2
        v=self.vram[base:base+32]
        t=np.zeros((8,8),np.uint8)
        for r in range(8):
            p0,p1,p2,p3=v[2*r],v[2*r+1],v[16+2*r],v[17+2*r]
            for c in range(8):
                b=7-c
                t[r,c]=((p0>>b)&1)|(((p1>>b)&1)<<1)|(((p2>>b)&1)<<2)|(((p3>>b)&1)<<3)
        return t
    def draw(self, img, x, y, charflags, big):
        # charflags: 16-bit (flags<<8 | char), N bit is bit 8
        n=charflags & 0x1ff; fl=charflags>>8
        pal=(fl>>1)&7; hf=fl&0x40; vf=fl&0x80
        size=16 if big else 8
        tiles=[[n, n+1],[n+16, n+17]] if big else [[n]]
        blk=np.zeros((size,size),np.uint8)
        for ty,row in enumerate(tiles):
            for tx,tn in enumerate(row):
                blk[ty*8:ty*8+8,tx*8:tx*8+8]=self.tile(tn)
        if hf: blk=blk[:,::-1]
        if vf: blk=blk[::-1]
        a=np.array(img)
        for yy in range(size):
            for xx in range(size):
                p=blk[yy,xx]
                if p and 0<=y+yy<a.shape[0] and 0<=x+xx<a.shape[1]:
                    a[y+yy,x+xx,:3]=self.cols[128+pal*16+p]; a[y+yy,x+xx,3]=255
        return Image.fromarray(a)
