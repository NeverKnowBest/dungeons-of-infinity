AltTabCheck();

if(global.AltTab) alarm[6]++;

if(AllowStart || global.DebugEnabled || global.CanSkipTitle){
	if(!instance_exists(oCredits) && !keyboard_check(vk_alt) && input_check_pressed("menu_input")){
		audio_stop_all();
		//instance_destroy(id);
		room_goto_next();
		exit;		
	}
}

if(global.DebugEnabled){
	if(keyboard_check_pressed(vk_escape)) game_end();
}

if(ShowBG){
	_Contrast -= 0.03;
	if(_Contrast <= 1) _Contrast = 1;
	_Brightness += 0.03;
	if(_Brightness >= 1) _Brightness = 1;

	fx_set_parameter(FX_Contrast, "g_ContrastIntensity", _Contrast);
	fx_set_parameter(FX_Contrast, "g_ContrastBrightness", _Brightness);
	
	if(_Contrast == 1 && _Brightness == 1){
		ShowBG = false;
		AllowStart = true;
	}
}