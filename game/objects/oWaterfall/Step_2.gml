if(SoundPaused){
	
	if( (oCamera.RoomTransition != NONE && global.TransitionRoomIndex == RoomIndex) || LinkLeavingHouse){
		audio_sound_gain(SoundID, 0.6, 600);
		SoundFadeIn = true;
		SoundPaused = false;
		SoundPlaying = true;
		LinkLeavingHouse = false;
	}
	
}

if(SoundPlaying){
	
	var _NewGain = clamp(0.5 - (point_distance(x + 8, y + 52, oLink.x, oLink.y) / 460), 0, 0.6);
	if(SoundFadeIn){
		if(audio_sound_get_gain(SoundID) >= _NewGain){
			SoundFadeIn = false;
		}
	}else audio_sound_gain(SoundID, _NewGain, 0.1);
	
	if( (oCamera.RoomTransition != NONE && global.TransitionRoomIndex != RoomIndex) || oLink.House_Entering){
		audio_sound_gain(SoundID, 0, 600);
		SoundPaused = true;
		SoundPlaying = false;		
	}	
	
}

