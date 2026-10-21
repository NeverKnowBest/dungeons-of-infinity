/// @description Wake or Sleep done
if(State == EnemyState.Wake)
	Enemy_UpdateState(EnemyState.Shooting);
else
	Enemy_UpdateState(EnemyState.Idle);