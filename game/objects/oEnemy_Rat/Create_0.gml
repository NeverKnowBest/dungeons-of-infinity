event_inherited(); //parent: oEnemy

Size = EnemySize.Tiny;

WalkSpeed = 1.5;

CheckForWater = true;
InWaterSprYOffset = 2;


Dir = RandomDir();
Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking, EnemyState.Walking));



