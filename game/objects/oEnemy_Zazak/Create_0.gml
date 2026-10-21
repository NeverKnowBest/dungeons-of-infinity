event_inherited();

Size = EnemySize.Large;

Dir = RandomDir();
HeadDir = Dir;

StandingTurnHeadDir = 1;
StandinHeadTurnDelay = 30;
SightDist = 100;
SightOffset = 10;
Speed = 0.75;
CanShoot = true;

CheckForWater = true;
InWaterSprYOffset = -4;

Enemy_UpdateState(EnemyState.Walking);