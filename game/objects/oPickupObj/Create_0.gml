State = PickupObjState.Idle;

Speed = 2.5;
g = -0.125;
vx = 0;
vy = 0;
vz = 0;
vz_Init = 1.5;
z = 0;
ObjSetY(y);

WallCollided = false;
WallBounceFactor = 0.25;
CheckWallCollide = true;

Bounces = 2;
DestroyOnContact = false;
DestroyedBySword = false;
DestroyedByProjectile = false;
DestroyedByExitRoom = false;

HitCrystalSwitch = false;

WallObj = noone;
ContentsObj = -1;
ContentsObjX = x;
ContentsObjY = y;

DrawShadow = false;
ShadowAtRest = true;

Hidden = false;

Index = 0;

if(!variable_instance_exists(id, "FloorLevel")) FloorLevel = GetFloorLevelID(x, y_base);
FloorLevelStr = GetFloorLevelString(FloorLevel);

RoomIndex = Dungeon_GetRoomIndex(x, y_base);
LightIndex = -1;
Lighting = true;

InWater = false;
InWaterSprW = 16;
InWaterSprXOffset = 0;
InWaterSprYOffset = -4;

alarm[11] = 2;

mask_index = sprite_index;
