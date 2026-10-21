event_inherited();

Size = EnemySize.Small;

Type = (global.Level.Index <= DungeonLevel.Ruins ? 0 : 1);

switch(Type){
	case 0:
		WalkSpeed = 1;
		Enemy_SetEnergy(4);
		Attack = 1.75;
		break;
	
	case 1:
		WalkSpeed = 1.25;
		Enemy_SetEnergy(6);
		Attack = 2.5;
		break;
}

CheckForWater = true;
InWaterSprW = sprite_width + 2;

FireballCount = 0;
FireballDelay = 16;

ScriptLen = 4;
Script = ds_grid_create(2, ScriptLen);
Script[# 0, 0] = EnemyState.Walking; Script[# 1, 0] = -1;
Script[# 0, 1] = EnemyState.Standing; Script[# 1, 1] = 30;
Script[# 0, 2] = EnemyState.Shooting; Script[# 1, 2] = -1;
Script[# 0, 3] = EnemyState.Standing; Script[# 1, 3] = 30;
ScriptPos = 0;

Enemy_UpdateState(Script[# 0, ScriptPos]);
