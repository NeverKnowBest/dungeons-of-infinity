event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Standing);	
}

PauseCheck

switch(State){
	
	case EnemyState.Jumping:
		if(JumpLanded){
			Enemy_UpdateState(EnemyState.Standing);	
			layer = WalkingLayer;
		}
		break;
		

}