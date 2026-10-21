event_inherited();


if(Hit_Started){
	audio_stop_sound(Sound_Chicken);
	audio_play_sound(Sound_Chicken, 1, false);
}

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Running);
	Chicken_SetScared();
}
PauseCheck

if(PickedUp){
	if(oLink.Facing == LEFT) Dir = -1;
	if(oLink.Facing == RIGHT) Dir = 1;
	layer = PickupLayer;
	exit;
}else{
	layer = NormalLayer;
}

if(State == EnemyState.Running){
	Dir = Chicken_GetDir();
}else{
	if(WallCollide_X) Dir *= -1;
}

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
	
	case EnemyState.Jumping: //using Jumping for when its being thrown
		if(JumpLanded){
			vx = 0;
			vy = 0;
			Enemy_UpdateState(EnemyState.Running);
		}
		break;
	
	case EnemyState.Running:
		
		var _Dir = point_direction(oLink.x, oLink.y, x, y);
		vx = lengthdir_x(RunSpeed, _Dir);
		vy = lengthdir_y(RunSpeed, _Dir);
		break;
}
