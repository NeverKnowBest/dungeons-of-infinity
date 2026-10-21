event_inherited();

switch(State){
	
	case ArcadeState.UnUsed:

		break;

	case ArcadeState.Reset:
		
		global.Arcade_ActiveInst = self;

		Arcade_SetCam(CamW, CamH);

		GameSurface = surface_create(RoomW, RoomH);
		
		Level = 0;
		Lives = 2;
		Score = 0;
		SpawnedArcade = false;
		
		State = ArcadeState.AttractScreen;
		
		Zerberk_Level_Reset();

		break;
		
	case ArcadeState.AttractScreen:
		break;
	
	case ArcadeState.GameStartInit:
		
		Zerberk_Level_Reset();
		
		
		break;
		
	case ArcadeState.GameStarted:

		if(!Zerberk_InLevel(Hero.x, Hero.y)){
			Zerberk_Level_Reset();			
		}
		
		
		break;
		
	case ArcadeState.GameOver:
		if(input_check_pressed("inventory") || input_check_pressed("sword")){			
			State = ArcadeState.Reset;
		}	
		break;	
	
	case ArcadeState.Unload:
		Zerberk_Level_Destroy();
		break;
		
}





