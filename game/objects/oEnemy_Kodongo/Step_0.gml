event_inherited(); 

if(KnockBackDone || StunDone || ShockDone){
	alarm[1] = -1;
	ScriptPos = 1;
	Dir = DirFaceLink();
	
	Enemy_UpdateState(Script[# 0, ScriptPos]);	
	
}

PauseCheck

switch(State){
	
	case EnemyState.Walking:
		if(WallCollide_X) Kodongo_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Kodongo_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
		
		break;
	
	case EnemyState.Shooting:
		if(Type == 1 && !oLink.Cape){
			Dir = DirFaceLink();
			Enemy_UpdateSprite(State);
		}
		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 18;
		InWaterSprYOffset = -2;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 16;
		InWaterSprYOffset = -3;
		break;	
}