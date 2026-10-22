/// @description Stand delay

var _NextState;
if(FloorLevel != oLink.FloorLevel || distance_to_object(oWall) <= 8 || distance_to_object(oLink) >= 128)
	Enemy_UpdateState(EnemyState.Walking);
else{
	if(oLink.Cape || instance_number(oBomb) >= 5){ //don't shoot if there's too many bombs. Otherwise it gets too crazy in large rooms with many Hinoxes
		_NextState = choose(EnemyState.Walking, EnemyState.Running);
	}else{
		_NextState = choose(EnemyState.Walking, EnemyState.Running, EnemyState.Shooting, EnemyState.Shooting, EnemyState.Shooting, EnemyState.Shooting);
	}
	
	Enemy_UpdateState(_NextState);
	
}