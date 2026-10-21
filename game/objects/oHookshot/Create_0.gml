event_inherited();

Speed = 4;
Dir = 0;
DistFromLink = 8;
DistMax = 110;
Returning = false;
BBoxEdge = 0;
StartPointX = x;
StartPointY = y;

Chains = 0;
ChainXList = ds_list_create();
ChainYList = ds_list_create();
ChainAniCounter = 3;
ChainAniFrame = 0;

FloorLevel = oLink.FloorLevel;
FloorLevelStr = GetFloorLevelString(FloorLevel);

HitEnemy = false;

GoingThroughBushes = false;

CapturedItem = noone;
CapturedItemCenterX = 0;
CapturedItemCenterY = 0;
switch(oLink.Facing){
	case UP: Dir = 90; ObjSetY(y_base-4); BBoxEdge = oLink.bbox_top; x-=4; StartPointX-=4; StartPointY = BBoxEdge - 3; break;
	case DOWN: Dir = 270; ObjSetY(y_base+4); BBoxEdge = oLink.bbox_bottom; x+=4; StartPointX+=4; StartPointY = BBoxEdge + 5; break;
	case LEFT: Dir = 180; x-=4; BBoxEdge = oLink.bbox_left; StartPointX = BBoxEdge - 3; break;
	case RIGHT: Dir = 0; x+=4; BBoxEdge = oLink.bbox_right; StartPointX = BBoxEdge + 4; break;
}

vx = lengthdir_x(Speed, Dir);
vy = lengthdir_y(Speed, Dir);

image_angle = Dir;

audio_play_sound(Sound_Hookshot, 1, true);

OutsideRoomDestroy = false;