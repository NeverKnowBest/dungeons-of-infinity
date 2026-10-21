

event_inherited();

instance_destroy(WallInst);

WallInst = WallObj_Create("ObjsHigher_" + FloorLevelStr, bbox_left, bbox_top, 3.75, 2);
WallInst.FloorLevel = FloorLevel;

MiniScreenY = y - 25;
CamW = 128;
CamH = 112;

RoomW = CamW;
RoomH = CamH;


CamW_2 = CamW / 2;
CamH_2 = CamH / 2;
CamW_3 = CamW / 3;
CamH_3 = CamH / 3;
CamW_4 = CamW / 4;
CamH_4 = CamH / 4;


MiniScreen_Sprite = sArcade_Screen_ShredderTV;

AnimationIndex = 0;
AnimationFrame_Face = 0;
AnimationFrame_Mask = 0;
AnimationDelay = 20;
alarm[1] = AnimationDelay;