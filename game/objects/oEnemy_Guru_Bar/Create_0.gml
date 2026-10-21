CenterX = x + 8;
CenterY = y + 8;

Reset_StartX = x;
Reset_StartY = y;

FloorLevelStr = GetFloorLevelString(FloorLevel);

Type = Gurus_GetType();

RotSpeed = 2 + (Type * 0.2);

BlockSeperation = 16;
SeperationDist = 14;

State = EnemyState.Walking;

FrozenSparkleCounter = 0
FrozenSparkleTime = 40;

GuruCount = (GurusDestroyed ? 0 : 4);

for(var i = 0; i < GuruCount; i++){
	var PosX = CenterX + lengthdir_x(BlockSeperation + (i * SeperationDist), Angle);
	var PosY = CenterY + lengthdir_y(BlockSeperation + (i * SeperationDist), Angle);
	var VarStruct = {FloorLevel : UPPERLOWER, ItemHolding : noone, SectionID: SectionID, GuruBarInst : id, RoomIndex: RoomIndex};
	GuruInst[i] = instance_create_layer(PosX, PosY, "ObjsHighest", oEnemy_Guru, VarStruct);
}

DestroyGurus = false;

WallInst = WallObj_Create("Objs_" + FloorLevelStr, x, y, 2, 2);
WallInst.BlockProjectiles = false;
WallInst.BlockItems = false;

Setup = true;