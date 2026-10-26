import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import numpy as np, sys
a=np.fromfile(sys.argv[1],'<i2').reshape(-1,2).astype(np.float64)
m=a.mean(axis=1); sr=44100; hop=441
k=len(m)//hop; env=np.sqrt((m[:k*hop].reshape(k,hop)**2).mean(1))
seg=env[1000:3000]
res=[]
for lag in range(500, k-3000):
    c=np.corrcoef(seg, env[1000+lag:3000+lag])[0,1]; res.append((c,lag/100))
res.sort(reverse=True); print(res[:6])
