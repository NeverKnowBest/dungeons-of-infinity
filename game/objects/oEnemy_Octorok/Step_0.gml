event_inherited(); 

if(KnockBackDone || StunDone){
	Dir = DirFaceLink();
	Enemy_UpdateState(EnemyState.Shooting);	
}

PauseCheck

switch(State){

	case EnemyState.Walking:

		if(WallCollide_X) Octorok_UpdateDir(Dir == LEFT ? RIGHT: LEFT);
		if(WallCollide_Y) Octorok_UpdateDir(Dir == UP ? DOWN: UP);
		
		break;
}
