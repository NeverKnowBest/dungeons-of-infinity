event_inherited();

Size = EnemySize.Tiny;

Type = (LevelDef.EnemyStats > DungeonLevel.Ruins ? 1 : 0)

switch(Type){
	case 0:
		Attack = 0.25;
		break;
	
	case 1:
		Attack = 1.5;
		break;
	
}

IgnoreWalls = true;
ContainInRoom = true;
Speed = 1;
AngleDir = 0;
MaxZ = 20;
Land = false;
Enemy_UpdateState(EnemyState.Standing); //CanFly is set to false in Standing state, but set it back to true right after so first encounter with Link he flies away
CanFly = true;

CheckForWater = true;
InWaterSprW = sprite_width - 2;
InWaterSprYOffset = -2;