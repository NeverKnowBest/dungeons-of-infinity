switch(State){
	
	case ArcadeState.UnUsed:

		break;

	case ArcadeState.Reset:

		break;
		
	case ArcadeState.AttractScreen:
		break;
	
	case ArcadeState.GameStartInit:
		Music_Fade(0.25, 12);
		with(oLink) UpdateState(LinkState.VideoGame);
		//oLink.actionVideoGame = true;
		State = ArcadeState.GameStarted;
		break;
		
	case ArcadeState.GameStarted:

		
		break;
		
	case ArcadeState.GameOver:
		with(oLink) UpdateState(LinkState.Standing);
		break;	
	
	case ArcadeState.Unload:
		if(surface_exists(Sprite_BG)) surface_free(Sprite_BG);
		if(surface_exists(GameSurface)) surface_free(GameSurface);
		global.Arcade_ActiveInst = noone;		
		Music_Fade(1, 12);
		//oLink.actionVideoGame = false;
		with(oLink) UpdateState(LinkState.Standing);
		global.ArcadeVP_Show = false;
		GameAllowed = false
		State = ArcadeState.UnUsed;
		break;
		
}