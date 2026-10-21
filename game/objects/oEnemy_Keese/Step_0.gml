event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){
	
	case EnemyState.Standing:
		if(CanFly && distance_to_object(oLink) <= 32 && !oLink.Cape){
			Enemy_UpdateState(EnemyState.Walking);
		}		
		break;
		
	case EnemyState.Walking:
		if(WallCollide_X || WallCollide_Y){
			Dir = (Dir + 180) mod 360;
		}
		
		Dir = (Dir + (AngleDir * 3)) mod 360;
		vx = lengthdir_x(Speed, Dir);
		vy = lengthdir_y(Speed, Dir);	
		if(Land){
			z -= 0.5;
			if(z <= 0){
				z = 0;
				Land = false;
				Enemy_UpdateState(EnemyState.Standing);
			}
		}else if(z < MaxZ) z += 0.5;
		
		break;
	

}