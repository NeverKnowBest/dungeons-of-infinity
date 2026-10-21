event_inherited();

OutsideRoomDestroy = false;
OutsideCameraDestroy = true;

DestroyAnimation = true;

Enemy = true;

Damage = 1.5;

HitV = 4;
HitTime = 16;

TrailDelay = 2;

ObjSetImageSpeed(0);

LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.65, [1.0, 0.6, 0.3]);
