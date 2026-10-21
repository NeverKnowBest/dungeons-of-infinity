event_inherited(); 

if(KnockBackDone || StunDone){
	Enemy_UpdateState(choose(EnemyState.Standing, EnemyState.Walking));
}

PauseCheck