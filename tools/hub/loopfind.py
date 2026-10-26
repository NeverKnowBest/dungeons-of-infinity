import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import numpy as np, sys
from numpy.fft import rfft, irfft
a=np.fromfile(sys.argv[1],'<i2').reshape(-1,2).astype(np.float64)
m=a.mean(axis=1); sr=44100
print('len',len(m)/sr)
r=np.sqrt((a**2).mean(axis=1)); print([int(r[i*sr:(i+1)*sr].mean()) for i in range(0,int(len(m)/sr),5)])
cs=np.concatenate([[0],np.cumsum(m**2)])
for t in (10,30):
    L=2*sr; ref=m[t*sr:t*sr+L]; n=len(m)
    N=1<<int(np.ceil(np.log2(n+L)))
    c=irfft(rfft(m,N)*np.conj(rfft(ref,N)),N)[:n-L]
    e=np.sqrt(np.maximum(cs[L:L+len(c)]-cs[:len(c)],1))
    nc=c/(e*np.sqrt((ref**2).sum()))
    idx=np.argsort(nc)[::-1]; shown=[]
    for i in idx:
        if all(abs(i-j)>sr for j in shown): shown.append(i)
        if len(shown)>4: break
    print(t,[(round(i/sr,3), round(float(nc[i]),4)) for i in shown])
