// Feather disable GM2064
if(!instance_exists(oLink)) exit;

switch(State){
	
	case HubExitState.Idle:
		if(global.Paused || instance_exists(oMenu_Game) || instance_exists(oDialogueBox)) exit;
		if(oLink.y >= y && abs(oLink.x - x) <= 12 && oLink.State != LinkState.Dead){
			State = HubExitState.Menu;
			global.HubDepart = false;
			global.MenuInst = instance_create_layer(0, 0, "System", oMenu_Game, {Mode : "Depart"});
			with(oLink) UpdateState(LinkState.Inventory);
		}
		break;
		
	case HubExitState.Menu:
		if(instance_exists(oMenu_Game)) exit;
		if(global.HubDepart){
			State = HubExitState.Leaving;
			with(oLink) Link_SetAutoMove(0, 1, WalkSpeed, 16);
			Music_Fade(0, 20);
		}else{
			State = HubExitState.Back;
			with(oLink) Link_SetAutoMove(0, -1, WalkSpeed, 12);
		}
		break;
		
	case HubExitState.Back:
		if(oLink.y < y - 8) State = HubExitState.Idle;
		break;
		
	case HubExitState.Leaving:
		FadeAlpha = min(1, FadeAlpha + 0.05);
		if(FadeAlpha >= 1 && !Started){
			Started = true;
			Hub_StartRun();
		}
		break;
		
}
