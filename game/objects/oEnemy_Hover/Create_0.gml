event_inherited();

Size = EnemySize.Tiny;

Speed_Initial = 2;
FacingDir = choose(-1, 1);
SlowdownSpeed = 0;
TMID = FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower;

Enemy_UpdateState(EnemyState.Standing);