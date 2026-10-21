event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Standing);
	alarm[0] = 30;
}

PauseCheck

switch(State){
	case EnemyState.Jumping:
		
		if(JumpLanded){
			
			Hops--;
			
			if(Hops <= 0){
				Enemy_UpdateState(EnemyState.Standing);
			}else{
				vz = 2;	
			}
			
			layer = WalkingLayer;
		}
		break;
}