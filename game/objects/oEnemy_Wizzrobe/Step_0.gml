event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Sleep);
}

PauseCheck

switch(State){

	case EnemyState.Wake:
		Visible = !Visible;	
		break;
	case EnemyState.Sleep:
		Visible = !Visible;	
		break;
}