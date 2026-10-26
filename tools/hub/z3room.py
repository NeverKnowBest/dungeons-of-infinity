# Library: read zelda3 room dumps and render BG layers.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import numpy as np
from PIL import Image
CHRBASE=0x4000
class Room:
    def __init__(self,path):
        d=open(path,'rb').read();o=0
        def take(n):
            nonlocal o
            b=d[o:o+n];o+=n;return b
        self.hdr=take(16)
        self.vram=np.frombuffer(take(0x10000),np.uint8)
        self.pal=np.frombuffer(take(512),'<u2')
        self.aux=np.frombuffer(take(512),'<u2')
        self.bg2=np.frombuffer(take(0x2000),'<u2').reshape(64,64)
        self.bg1=np.frombuffer(take(0x2000),'<u2').reshape(64,64)
        self.at2=np.frombuffer(take(0x1000),np.uint8).reshape(64,64)
        self.at1=np.frombuffer(take(0x1000),np.uint8).reshape(64,64)
        self._tiles=None
    @property
    def tiles(self):
        if self._tiles is None:
            t=np.zeros((1024,8,8),np.uint8)
            v=self.vram[CHRBASE:CHRBASE+1024*32].reshape(1024,32)
            for r in range(8):
                p0=v[:,2*r];p1=v[:,2*r+1];p2=v[:,16+2*r];p3=v[:,17+2*r]
                for c in range(8):
                    b=7-c
                    t[:,r,c]=((p0>>b)&1)|(((p1>>b)&1)<<1)|(((p2>>b)&1)<<2)|(((p3>>b)&1)<<3)
            self._tiles=t
        return self._tiles
    def colors(self):
        c=self.pal.astype(np.int32)
        r=(c&31)<<3;g=((c>>5)&31)<<3;b=((c>>10)&31)<<3
        return np.stack([r|r>>5,g|g>>5,b|b>>5],-1).astype(np.uint8)
    def tile_rgba(self,e,cols):
        g=self.tiles[e&0x3ff]
        if e&0x4000: g=g[:,::-1]
        if e&0x8000: g=g[::-1]
        p=(e>>10)&7
        out=np.zeros((8,8,4),np.uint8)
        out[...,:3]=cols[p*16+g];out[...,3]=np.where(g>0,255,0)
        return out
    def render(self,region=None,bg1=False):
        """BG1 is off (TM=0x16) in single-layer rooms, so by default only BG2 is drawn.
        Returns (low, high) RGBA arrays for tile region (x0,y0,x1,y1); low has an opaque backdrop."""
        x0,y0,x1,y1=region or (0,0,64,64)
        cols=self.colors()
        W=(x1-x0)*8;H=(y1-y0)*8
        low=np.zeros((H,W,4),np.uint8);low[...,3]=255
        high=np.zeros((H,W,4),np.uint8)
        cache={}
        def put(dst,e,ty,tx):
            if e not in cache: cache[e]=self.tile_rgba(e,cols)
            t=cache[e];m=t[...,3:4]>0
            sl=dst[ty*8:ty*8+8,tx*8:tx*8+8]
            sl[...]=np.where(m,t,sl)
        for layer in ((self.bg2,self.bg1) if bg1 else (self.bg2,)):
            for ty in range(y0,y1):
                for tx in range(x0,x1):
                    e=int(layer[ty,tx])
                    put(high if e&0x2000 else low,e,ty-y0,tx-x0)
        return low,high
