event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){
	
	case EnemyState.Idle:
		if(!oLink.Cape && distance_to_object(oLink) <= 24){
			Enemy_UpdateState(EnemyState.Wake);
		}	
		break;
	
	case EnemyState.Wake:
		WakeColorFrame = (WakeColorFrame + 1) mod 3;
		break;
		
	case EnemyState.Walking:
		
		var _Speed = (oLink.Cape ? 0 : Speed);
		
		var LinkDir = point_direction(x, y, oLink.x, oLink.y);
		vx = lengthdir_x(_Speed, LinkDir);
		vy = lengthdir_y(_Speed, LinkDir);

		if(JumpLanded){
			vz = JumpVZ;
			GravityStatus = true;
		}
		
		break;
	
}