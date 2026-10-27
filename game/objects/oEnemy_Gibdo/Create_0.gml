event_inherited();

Size = EnemySize.Large;

Type = (LevelDef.EnemyStats >= DungeonLevel.LanmolasLair ? 1 : 0);

switch(Type){
	case 0: 
		Enemy_SetEnergy(4);
		Attack = 1.25;
		WalkSpeed = 0.75;
		break;
	
	case 1:
		Enemy_SetEnergy(6);
		Attack = 2.25;
		WalkSpeed = 1;
		break;
	
}

DirChangeTime = 90;

Enemy_UpdateState(EnemyState.Walking);