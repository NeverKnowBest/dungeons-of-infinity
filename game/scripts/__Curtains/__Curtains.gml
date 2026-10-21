function Curtain_Reveal(Inst){
	if(!Inst.Revealed){
		Inst.Revealed = true;
		audio_play_sound_stopall(Sound_Curtain);
		if(Inst.DoorInst != noone) audio_play_sound_stopall(Sound_Secret);
	}
}