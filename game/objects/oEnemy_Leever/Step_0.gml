event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){

	case EnemyState.Walking:
		
		if(WallCollide_X || WallCollide_Y){
			Leever_UpdateDir();
		}else if(!oLink.Cape && !oLink.InDoor_Full){ 
			Dir = point_direction(x, y, oLink.x, oLink.y);
		}
		
		vx = lengthdir_x(Speed, Dir);
		vy = lengthdir_y(Speed, Dir);		
		
		break;

}