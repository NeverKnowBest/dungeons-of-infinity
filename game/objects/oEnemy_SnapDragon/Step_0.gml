event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck


if(WallCollide_X) SnapDragon_UpdateDir(Dir == LEFT ? RIGHT : LEFT);
if(WallCollide_Y) SnapDragon_UpdateDir(Dir == UP ? DOWN : UP);

switch(State){
	case EnemyState.Walking:
		
		if(JumpLanded){
			
			Hops--;
			
			if(Hops <= 0){
				Enemy_UpdateState(EnemyState.Standing);
			}else{
				GravityStatus = true;
				vz = JumpSpeed;	
			}
	
		}
		break;
}
