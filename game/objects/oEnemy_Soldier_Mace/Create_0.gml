event_inherited();

switch(global.Level.Index){
	
	case DungeonLevel.CastleJails: 
		ColorIndex = SoldierColor.Grey; 
		HeadIndex = SoldierHead.Knight;
		Enemy_SetEnergy(4);
		Attack = 1;
		break;
	case DungeonLevel.Aghanim1: 
		ColorIndex = SoldierColor.Gold; 
		HeadIndex = SoldierHead.Warrior;
		Enemy_SetEnergy(9);
		Attack = 3.25;
		break;

}

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
