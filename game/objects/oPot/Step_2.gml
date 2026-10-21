switch(State){

	case PickupObjState.Destroyed:
		
		if(!audio_is_playing(global.CrashSoundID) || AllowAnotherCrashSound){ 
			//this is so you don't hear more than 1 sound at a time, apparant when breaking multiple pots with sword. So add a small delay until next sound
			AllowAnotherCrashSound = false;
			global.CrashSoundID = audio_play_sound(Sound_PotShatter, 1, false);
			alarm[0] = 3;
		}
		

		var inst = instance_create_layer(x, y - 8, "ObjsHigher_" + FloorLevelStr, oPotExplosion);
		if(global.Xmas){
			inst.PaletteIndex = 0;
		}else{
			inst.PaletteIndex = 1 + Index;
		}

		
		PickupObj_RevealContents();
		
		instance_destroy(id);
		
		break;
	
}