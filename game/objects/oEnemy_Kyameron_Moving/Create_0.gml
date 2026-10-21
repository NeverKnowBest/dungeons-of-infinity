event_inherited();

Speed = 1.5;
vx = choose(-1, 1) * Speed;
vy = choose(-1, 1) * Speed;
WallCollide_Bounce = true;
TMID = FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower;
Timeout = false;
ParentInst = noone;
SparkleDelay = 8;
Hit_PlaySound = false;
alarm[1] = SparkleDelay;
Enemy_UpdateState(EnemyState.Walking);