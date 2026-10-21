event_inherited(); //parent: oEnemy

Size = EnemySize.Small;

ObjSetImageSpeed(choose(1, 0.5));
alarm[0] = irandom_range(90, 180);

MaxSpeed = 0.4;
MoveDelay = 10;

CheckForWater = true;
InWaterSprW = sprite_width + 2;
InWaterSprYOffset = -4;

Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking));

WallCollide_Bounce = true;

ShadowOffsetY = -1;

vxold = vx;
vyold = vy;



