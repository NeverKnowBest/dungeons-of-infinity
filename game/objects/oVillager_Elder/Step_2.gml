event_inherited();

if(DB_Started_GrandChild && !instance_exists(global.DB_Inst) && ResponseIndex == -1){
	global.Paused = true;
	with(oLink){
		UpdateState(LinkState.Idle);
	}	
}