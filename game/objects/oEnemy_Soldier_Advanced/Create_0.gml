event_inherited();

Enemy_ApplyVariant();	// colour, head, weapon, energy and attack of the level (EnemyVariants_Init in scripts/__EnemyArch)


Dir = RandomDir();

WalkSpeed = 0.5;
RunSpeed = 1;

HeadDir = Dir;
HeadSpr = noone;
StandingTurnHeadDir = 1;
StandinHeadTurnDelay = 30;
StandingHeadChecks = 6;

WeaponInst = instance_create_layer(x, y, layer, oSoldierWeapon);
WeaponInst.SoldierInst = id;
WeaponInst.FloorLevel = FloorLevel;

Strafe = false;
StrafeDir = LEFT;
StrafeTime = 60;

Sight = true; //after chasing expires, turn off sight for a second
SightDist = 100;
SightOffset = 10;

LinkHitSword = false;

PlayRunSound = true;

CheckForWater = true;
InWaterSprYOffset = -3;

Setup = true;

SaveVariables = ["HeadIndex", "Weapon", "Attack"];

Enemy_UpdateState(EnemyState.Walking);
//image_index = 0;
//image_speed = 0.05;//0.5;