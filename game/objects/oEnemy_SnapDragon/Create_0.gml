event_inherited();

Size = EnemySize.Large;

Type = (global.Level.Index > DungeonLevel.LanmolasLair ? 1 : 0);

switch(Type){
	case 0 :
		Enemy_SetEnergy(5);
		Attack = 2;
		Speed = 0.75;
		JumpSpeed = 2.5;
		break;
	
	case 1:
		Enemy_SetEnergy(7);
		Attack = 2.75;
		Speed = 1;
		JumpSpeed = 2.75;
		break;
		
}

CheckForWater = true;

Gravity = -0.4;

WallCollide_Bounce = true;

Hops = 0;

Enemy_UpdateState(EnemyState.Walking);