event_inherited();

StartX = x;
StartY = y;
StartRoomIndex = RoomIndex;

Size = EnemySize.Large;


Attack = 0.25 + (LevelDef.Depth * 0.25);
Speed = min(0.475 + (LevelDef.Depth * 0.025), 0.75);
IdleFrames = 41 - LevelDef.Depth;

IgnoreWalls = true;
SpeedMod = 0.1;
AttackSpeed = 1.5;
AttackDist = 32;
AttackFrames = 36;
Dir = 1;

z_base = 24;
z = z_base;
z_frame = 0;

layer = global.LayerID_ObjsHighest;

Enemy_UpdateState(EnemyState.Idle);
		
SpawnWait = true;
CanHurtLink = false;
Alpha = 0;
Invisible = false;
alarm[2] = 200;
