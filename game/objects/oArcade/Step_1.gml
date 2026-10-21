
event_inherited();

switch(State){
	
	case ArcadeState.UnUsed:

		break;
		
	case ArcadeState.AttractScreen:		
	
		
		if(input_check_pressed("item") || input_check_pressed("sword")){
			var _Rupees = global.Inventory.ItemData[ItemClass.Rupee];
			if(_Rupees.Amount > 0){
				Credits++;
				_Rupees.Amount--;
				audio_play_sound(Sound_Arcade_InsertCoin, 1, false);
			}else{
				audio_play_sound_stopall(Sound_Error);
			}
		}
		
		if(Credits > 0 && input_check_pressed("inventory")){
			Credits--;
			State = ArcadeState.GameStartInit;
		}
		
		break;

		
	case ArcadeState.GameStarted:
		if(input_check_pressed("menu_access")){
			input_clear_momentary(true);
			State = ArcadeState.Unload;
		}
		break;
		
	case ArcadeState.GameOver:
		//if(input_check_pressed("")) State = ArcadeState.Reset;
		if(input_check_pressed("menu_access")){
			input_clear_momentary(true);
			State = ArcadeState.Unload;
		}
		break;	
	

}

