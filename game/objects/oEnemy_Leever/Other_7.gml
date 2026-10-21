switch(State){

	case EnemyState.Wake:
		Enemy_UpdateState(EnemyState.Walking);			
		break;
	
	case EnemyState.Sleep:
		Enemy_UpdateState(EnemyState.Idle);
		break;
}