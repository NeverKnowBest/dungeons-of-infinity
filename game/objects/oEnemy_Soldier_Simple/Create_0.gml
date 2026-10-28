event_inherited();

Dir = RandomDir();

Size = EnemySize.Medium;

Enemy_ApplyVariant();	// colour, head, energy and attack of the level (EnemyVariants_Init in scripts/__EnemyArch)


HeadDir = Dir;
HeadSpr = noone;
HeadX = x;

WalkSpeed = 0.5;
RunSpeed = 1;

//Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking));

Enemy_UpdateState(EnemyState.Walking);

//temp 
//var LinkInSight = Enemy_LinkInSight(SightOffset, SightDist); //just to activate the first sight coordinates, can be removed after testing
