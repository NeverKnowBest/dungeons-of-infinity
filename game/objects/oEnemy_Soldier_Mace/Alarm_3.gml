/// @description SpinAllowed

if(oLink.Cape){
	Enemy_UpdateState(EnemyState.Standing);
	exit;
}

Enemy_UpdateState(distance_to_object(oLink) <= SpinStartDist ? EnemyState.Shooting : EnemyState.Walking);

