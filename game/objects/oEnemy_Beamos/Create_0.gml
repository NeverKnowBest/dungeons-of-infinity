event_inherited();

switch(global.Level.Index){

	default:
		Index = 0;
		Attack = 2;
		break;
		
	case DungeonLevel.WaterTemple:
		Index = 1;
		Attack = 2.75;
		break;
		
	
	case DungeonLevel.Aghanim1:
		Index = 2;
		Attack = 3.5;
		break;
		
	

}


FloorLevelStr = GetFloorLevelString(x, y);
WallInst = noone;

EyeR = 5;
EyeA = 0;
EyeX = Beamos_EyeX();
EyeY = Beamos_EyeY();
EyeImgIndex = 0;
EyeMove = true;
EyeMoveDelay = 4;
EyeLight = Lighting_CreateLight(RoomIndex, EyeX, EyeY, 0.18, [0.6,0.6,0.6]);

AngleToLink = 0;
SightDistance = 140;

Beamos_Laser_Reset();
LaserPointSpacing = 3;
LaserLights = [];
LightArrayIndex = array_create(3, -1);

LaserLength = 25;

Flashing = false;
FlashColors = [KB_R, KB_B, KB_R, KB_G, KB_R, KB_B, KB_R]
FlashColorIndex = 0;
FlashSpeed = 2;

CanShoot = false;
CanShootDelay = 16;
Shooting = false;

WallInit = true;

alarm[0] = EyeMoveDelay;
alarm[1] = CanShootDelay;

ClosestWall = 0;
ClosestWallPosX = 0;
ClosestWallPosY = 0;

CheckForWater = true;