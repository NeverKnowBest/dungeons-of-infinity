event_inherited();

Size = EnemySize.Medium;

Visible = false;

SpawnDelay = 40;
SleepDelay = 60;

CheckForWater = true;
InWaterSprYOffset = -2;

switch(LevelDef.EnemyStats){
	
	default:
	case DungeonLevel.WaterTemple:
		Type = 1;
		Enemy_SetEnergy(4);
		Attack = 2.5;
		break;
	
	case DungeonLevel.Aghanim1:
		Type = 0;
		Enemy_SetEnergy(5);
		Attack = 3;
		break;
	
}

Enemy_UpdateState(EnemyState.Idle);
