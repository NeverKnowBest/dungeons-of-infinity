event_inherited();

Size = EnemySize.Large;

Gravity = -0.075;

JumpZ = 2;
Speed = 1.2;

WallCollide_Bounce = true;

Hops = 0;

WalkingLayer = layer;

CheckForWater = true;

Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Jumping));
