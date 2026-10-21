event_inherited();

visible = true;

ShootX = x;
ShootY = y + 2;
ShootDelay = 120;
alarm[0] = ShootDelay;

FloorLevelStr = GetFloorLevelString(FloorLevel);

WallInit = true;
WallInst = noone;