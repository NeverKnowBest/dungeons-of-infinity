event_inherited();

Enemy_ApplyVariant();	// colour, head, energy and attack of the level (EnemyVariants_Init in scripts/__EnemyArch)

Size = EnemySize.Large;

Dir = RandomDir();

WalkSpeed = 0.75;

HeadDir = Dir;
HeadSpr = noone;

WeaponInst = instance_create_layer(x, y, layer, oSoldierWeapon_Mace);
WeaponInst.SoldierInst = id;
WeaponInst.depth = depth - 1;
WeaponInst.FloorLevel = FloorLevel;
WeaponInst.FloorLevelStr = GetFloorLevelString(FloorLevel);
WeaponInst.IdleLayer = layer_get_id("ObjsHigher_" + WeaponInst.FloorLevelStr);

Strafe = false;
StrafeDir = LEFT;
StrafeTime = 120;

SpinAllowed = true;
SpinStartDist = 30;

IdleDelay = 24;

LinkNotVisibleDist = 80;

CheckForWater = true;

Enemy_UpdateState(EnemyState.Standing);
