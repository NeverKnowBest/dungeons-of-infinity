event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){
	
	case EnemyState.Idle:
		if(AllowSpawn && distance_to_object(oLink) <= 32 && !oLink.Cape){
			Enemy_UpdateState(EnemyState.Wake);
		}		
		break;
	
	case EnemyState.Wake:
	
		break;

	case EnemyState.Jumping:
		if(image_index >= 0.8){
			Enemy_UpdateState(EnemyState.Walking);
		}
		
	case EnemyState.Walking:
	
		if(WallCollide_X) Enemy_UpdateState(EnemyState.Sleep);
		if(WallCollide_Y) Enemy_UpdateState(EnemyState.Sleep);
		
		break;
	
	case EnemyState.Sleep:
		if(image_index >= 3.6){
			Enemy_UpdateState(EnemyState.Idle);
		}
		break;
}