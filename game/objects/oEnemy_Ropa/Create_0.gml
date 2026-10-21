event_inherited();

Size = EnemySize.Small;

Type = (global.Level.Index >= DungeonLevel.MoldormsLair ? 1 : 0);

switch(Type){
	case 0: 
		Enemy_SetEnergy(4);
		Attack = 1.75;
		JumpDelay = 60;
		break;
	
	case 1:
		Enemy_SetEnergy(6);
		Attack = 2.5;
		JumpDelay = 40;
		break;
		
}

Gravity = -0.125;

WalkingLayer = layer;

CheckForWater = true;
InWaterSprW = sprite_width + 2;
InWaterSprYOffset = -4;

Enemy_UpdateState(EnemyState.Standing);	