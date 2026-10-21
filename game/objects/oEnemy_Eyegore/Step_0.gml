event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
	Eyegore_UpdateDir(DirFaceLink());
}

PauseCheck

switch(State){
	
	case EnemyState.Idle:
		if(!IdleDelay && distance_to_object(oLink) <= 30 && !oLink.Cape){
			Enemy_UpdateState(EnemyState.Wake);
		}		
		break;
	
	case EnemyState.Wake:
		if(image_index >= 2.9){
			Enemy_UpdateState(EnemyState.Walking);
			alarm[1] = 200;
		}
		break;
		
	case EnemyState.Walking:
	
		if(WallCollide_X) Eyegore_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Eyegore_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
		
		break;
	
	case EnemyState.Sleep:
		if(image_index <= 1){
			Enemy_UpdateState(EnemyState.Idle);
		}
		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 18;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 22;
		break;	
}