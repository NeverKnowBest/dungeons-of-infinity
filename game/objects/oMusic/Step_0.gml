
switch(State){
	

	case MusicState.Playing:
	
		if(SongPlaying_Intro && !audio_is_playing(SongPlaying_Inst) && SongPlaying_Index != -1){
			SongPlaying_Inst = audio_play_sound(global.Music_SongAsset[SongPlaying_Index].Main, 1, true);
			_Music_SetGain(Mute ? 0 : SongPlaying_Gain);
			SongPlaying_Intro = false;
		}
		
		if(Fade){
			_Music_SetGain(SongPlaying_Gain + Fade_GainPerFrame);	
			Fade_Frames--;
			if(Fade_Frames == 0){
				if(Fade_NextSongIndex != -1){
					Music_Play(Fade_NextSongIndex, 10);
				}else{
					if(SongPlaying_Gain == 0) Music_Stop();
				}
				Fade = false;
			}
		}
		
		break;

}

if(SongPlaying_Inst != noone){
	
	if(MuteEnable){
		
		switch(Mute){
			
			case true:
				_Music_SetGain(0)
				//audio_sound_gain(SongPlaying_Inst, 0, 0);
				break;
				
			case false:
				_Music_SetGain(1.0, 500);
				//audio_sound_gain(SongPlaying_Inst, SongPlaying_Gain, 500);
				break;
			
		}
		
		MuteEnable = false;
	}
}
