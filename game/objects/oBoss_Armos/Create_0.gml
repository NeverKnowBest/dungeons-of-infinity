event_inherited();

Enemy_UpdateState(EnemyState.Idle);

image_speed = 0;

RoomX = global.Level.Rooms[RoomIndex].x;
RoomY = global.Level.Rooms[RoomIndex].y;

DestroyObj = oBoss_Armos_Explosion;
Hit_Sound = Sound_Boss_Hit;
DestroySound = Sound_Boss_Destroy;

CircleAngleStart = 0;
CircleAngle = 0;

WaypointX = 0;
WaypointY = 0;

KnockBackTimeLen = 20;
KnockBackV = 4.0;

Init = true;




