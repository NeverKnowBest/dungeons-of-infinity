event_inherited();

CamW = 192;
CamH = 168;
CamX = 0;
CamY = 0;
RoomW = CamW;
RoomH = CamH;

CamW_2 = CamW / 2;
CamH_2 = CamH / 2;
CamW_3 = CamW / 3;
CamH_3 = CamH / 3;
CamW_4 = CamW / 4;
CamH_4 = CamH / 4;

Hero = noone;

Level = 0;
Lives = 2;
Score = 0;


Hiscore = Arcade_Hiscore_Load(ArcadeGame.Zerberk);
if(Hiscore == -1) Hiscore = 3000;
	
LevelCornersX = [4, 60, 128, 184];
LevelCornersY = [4, 48, 108, 152];

WallWidth = [60, 72, 60];
WallHeight = [48, 64, 48];

NextDoorStart = 6;
DoorStart = 0;
DoorEnd = 0;

StartWallData = 0;
EndWallData = 0;

SpawnedArcade = false;
SpawnArcadeScore = 2000;

