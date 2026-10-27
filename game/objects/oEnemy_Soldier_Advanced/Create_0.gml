event_inherited();

switch(LevelDef.EnemyStats){
	
	case DungeonLevel.Castle: 
		Size = EnemySize.Medium;
		ColorIndex = SoldierColor.Green;
		HeadIndex = SoldierHead.Normal;
		Weapon = SoldierWeapon.Sword;
		Enemy_SetEnergy(2);
		Attack = 0.5;
		break;
	case DungeonLevel.CastleBasement: 
		Size = EnemySize.Medium;
		ColorIndex = SoldierColor.Blue; 
		HeadIndex = SoldierHead.Normal;
		Weapon = SoldierWeapon.Sword;
		Enemy_SetEnergy(2);
		Attack = 0.5;
		break;
	case DungeonLevel.CastleJails: 
		Size = EnemySize.Large;
		ColorIndex = SoldierColor.Grey; 
		HeadIndex = SoldierHead.Knight;
		Weapon = SoldierWeapon.Spear;
		Enemy_SetEnergy(3);
		Attack = 0.75;
		break;
	case DungeonLevel.Catacombs: 
		Size = EnemySize.Large;
		ColorIndex = SoldierColor.Grey; 
		HeadIndex = SoldierHead.Skull;
		Weapon = SoldierWeapon.Stick;
		Enemy_SetEnergy(3);
		Attack = 0.75;
		break;
	case DungeonLevel.WaterTemple: 
		Size = EnemySize.Large;
		ColorIndex = SoldierColor.Blue; 
		HeadIndex = SoldierHead.Dragon;
		Weapon = SoldierWeapon.Fork;
		Enemy_SetEnergy(6);
		Attack = 1.75;
		break;
	case DungeonLevel.Aghanim1: 
		Size = EnemySize.Large;
		ColorIndex = SoldierColor.Red; 
		Weapon = SoldierWeapon.Sword;
		HeadIndex = choose(SoldierHead.Pig, SoldierHead.Pig2, SoldierHead.Demon);
		break;

}


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