/// @description Shot delay

if(ShotCount <= 0){
	Enemy_UpdateState(EnemyState.Walking);
}else{
	Octorok_Shoot();
}

