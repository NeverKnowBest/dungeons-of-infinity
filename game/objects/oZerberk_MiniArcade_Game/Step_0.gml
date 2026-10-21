switch(State){
	
	case MiniArcadeState.Title:
		if(input_check_pressed("inventory")){
			State = MiniArcadeState.Start;
			ShowLevel = true;
			ShowScore = true;
			Score = 0;
			Level = 0;
			LevelChange = false;
			alarm[2] = 100;
			instance_create_depth(0,0, depth, oZerberk_MiniArcade_Ship);
		}

		break;
	
	case MiniArcadeState.Start:
		if(LevelChange && instance_number(oZerberk_MiniArcade_Alien) == 0){
			LevelChange = false;
			alarm[3] = 60;
		}
		break;
	
	case MiniArcadeState.GameOver:
		if(input_check_pressed("inventory") || input_check_pressed("sword")){			
			State = MiniArcadeState.Title;
		}
		break;
	
	
}


