event_inherited();

Size = EnemySize.Large;

Type = FlipCoin_Bin();

Speed = 1;

Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking, EnemyState.Walking));

VX_Extra = 0;
VY_Extra = 0;

OpenMouth = false;

CanShoot = true;

SightDist = 196;
SightOffset = 2;


SaveVariables = ["Type"];