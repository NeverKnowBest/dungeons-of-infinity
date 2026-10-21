RoomX = global.Level.Rooms[RoomIndex].x;
RoomY = global.Level.Rooms[RoomIndex].y;

alarm[0] = irandom_range(160,240);
alarm[1] = irandom_range(160,240);
alarm[2] = irandom_range(160,240);

alarm[6] = 2;

Hit = array_create(3);
DirtSplashInst = array_create(3);

SectionInstList[0] = ds_list_create(); //lists of all body section insts so we can destroy them in order from last to first
SectionInstList[1] = ds_list_create();
SectionInstList[2] = ds_list_create();

Destroyed[0] = false;
Destroyed[1] = false;
Destroyed[2] = false;
DestroyInit[0] = false;
DestroyInit[1] = false;
DestroyInit[2] = false;
BossCount = 3;

BossDestroyed = false;
HeartSpawn_X = 0;
HeartSpawn_Y = 0;
HeartSpawned = false;
HeartCollected = false;

SectionDestroyDelay = 16;

FlashFrame = 0;

Init = true;