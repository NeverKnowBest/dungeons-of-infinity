if(Destroy) exit;

if(Open){
	Alpha += AlphaSpeed;
	fx_set_parameter(FX_BW, "g_Intensity", Alpha);
	audio_sound_gain(oTitle.Music, 0, MusicFadeTime);
	if(Alpha >= 1){
		Alpha = 1;
		Open = false;
		audio_stop_sound(oTitle.Music);
		alarm[0] = 35;
	}
	
	exit;
}

TextY -= (TextSpeed * (input_check("down") ? 2 : 1));
if(TextY < TextYMax) TextY = TextYMax;

if(!keyboard_check(vk_alt) && input_check_pressed("menu_input")){
	Close = true;
}

if(Close){
	Alpha -= AlphaSpeed;
	fx_set_parameter(FX_BW, "g_Intensity", Alpha);
	audio_sound_gain(Music, 0, MusicFadeTime);
	if(Alpha <= 0){
		audio_stop_sound(Music);
		alarm[1] = 25;
		Close = false;
		Destroy = true;
	}
}