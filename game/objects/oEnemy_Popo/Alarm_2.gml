/// @description Move alarm


if(State == EnemyState.Walking){
	if(vx != 0 || vy != 0){
		vxold = vx;	
		vyold = vy;
		vx = 0;
		vy = 0
	}else{
		vx = vxold;
		vy = vyold;
	}
	
}

alarm[2] = MoveDelay;