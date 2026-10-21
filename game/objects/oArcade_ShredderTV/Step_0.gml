event_inherited();


switch(State){

	case ArcadeState.UnUsed:

		break;

	case ArcadeState.Reset:
		
		global.Arcade_ActiveInst = self;
		
		Arcade_SetCam(CamW, CamH);

		GameSurface = surface_create(RoomW, RoomH);
		
		State = ArcadeState.AttractScreen;

		break;
		
	case ArcadeState.GameStartInit:

		
		break;
		
	case ArcadeState.GameStarted:


		break;
		
	case ArcadeState.GameOver:
	
		break;	
	
	case ArcadeState.Unload:

		break;
		
}





