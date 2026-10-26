# Builds the Sanctuary pictures with the side door (church) and the Hall of Fame room.
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
from PIL import Image
import numpy as np
H=HERE+''
HA=HERE+''
SP=HERE+'preview/'
B4=np.array(Image.open(H+'sanct_base4.png').convert('RGBA'))   # church without counter decor
B6=np.array(Image.open(H+'sanct_base6.png').convert('RGBA'))   # church with the festive counter
O5=np.array(Image.open(H+'sanct_over5.png').convert('RGBA'))

DOOR_SRC=B4[440:496,228:284]          # front door in the bottom wall, 56x56, interior side on top
def door_right():   # door in a right wall: bottom wall rotated so its interior faces left
    return np.rot90(DOOR_SRC,1)       # CCW: top->left
def door_left():
    return np.rot90(DOOR_SRC,-1)      # CW: top->right
DOOR_Y=268                            # top of the 56px door block on the side walls (opening ~ y 280..308)

def clear_pew(img,x0,y0,src_y):
    img[y0:y0+24,x0:x0+48]=B4[src_y:src_y+24,x0:x0+48]

# ---------------- church ----------------
church=B6.copy()
clear_pew(church,288,280,304)                       # bottom right pew, mirrors the Flute Boy corner
church[DOOR_Y:DOOR_Y+56,344:400]=door_right()
Image.fromarray(church).save(HA+'church_base.png')
Image.fromarray(O5).save(HA+'church_over.png')

# ---------------- hall ----------------
# The church nave (top wall, windows, altar dais) closed at the bottom by the end of the front corridor.
def hall(src,is_over):
    out=np.zeros((512,512,4),np.uint8)
    out[0:336,112:400]=src[0:336,112:400]
    rows=src[404:512]                                # corridor end: side walls, 36 rows of floor, bottom wall
    out[336:444,112:192]=rows[:,160:240]
    out[336:444,320:400]=rows[:,272:352]
    segs=[rows[:,216:240],rows[:,272:296]]
    x=192;k=0
    while x<320:
        s=segs[k%2]; w=min(24,320-x); out[336:444,x:x+w]=s[:,:w]; x+=w; k+=1
    if not is_over:
        # floor below the dais: pews removed, floor and carpet carried down to the new bottom wall
        for (x0,y0) in [(176,200),(176,240),(176,280)]: out[y0:y0+24,x0:x0+48]=B4[280:304,x0:x0+48]
        for (x0,y0) in [(288,200),(288,240),(288,280)]: out[y0:y0+24,x0:x0+48]=B4[304:328,x0:x0+48]
        out[336:372,168:344]=out[296:332,168:344]
        out[DOOR_Y:DOOR_Y+56,112:168]=door_left()
    return out
hb=hall(B4,False); ho=hall(O5,True)
Image.fromarray(hb).save(HA+'hall_base.png'); Image.fromarray(ho).save(HA+'hall_over.png')

for name,b,o,crop in [('prev_church',church,O5,(96,40,416,360)),('prev_hall',hb,ho,(96,0,416,460))]:
    c=Image.fromarray(b); c.alpha_composite(Image.fromarray(o))
    c.crop(crop).resize(((crop[2]-crop[0])*2,(crop[3]-crop[1])*2),Image.NEAREST).save(SP+name+'.png')
