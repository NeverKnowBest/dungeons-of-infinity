event_inherited();

Size = EnemySize.Medium;

WallCollide_Bounce = true;

Dir = irandom(360);
DirV = 0;

Speed = 1.5;

OldX = x;
OldY = y;

BodyX = x;
BodyY = y;

TailX = x;
TailY = y;

Enemy_UpdateState(EnemyState.Walking);
alarm[0] = irandom_range(20, 40);