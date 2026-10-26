import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import re
src=open(REPO+'/game/scripts/__RoomTemplates/__RoomTemplates.gml').read()
body=re.search(r'enum TemplateObjGID\{(.*?)\}',src,re.S).group(1)
vals={};cur=-1
for item in body.split(','):
    item=re.sub(r'//.*','',item).strip()
    if not item: continue
    if '=' in item:
        n,v=item.split('='); n=n.strip(); cur=int(v)
    else:
        n=item; cur+=1
    vals[n]=cur
GID=vals
