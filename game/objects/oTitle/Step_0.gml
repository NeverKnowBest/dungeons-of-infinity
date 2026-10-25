AltTabCheck();

if(global.AltTab) alarm[6]++;

// Any key or button during the intro jumps straight to the finished title screen
if(!AllowStart && !keyboard_check(vk_alt) && Title_AnyButtonPressed()){
	Title_SkipIntro();
	exit;
}

// the press that skipped the intro must not also start the game
if(variable_instance_exists(id, "SkipCooldown") && SkipCooldown > 0){
	SkipCooldown--;
	exit;
}

if(AllowStart || DEBUG || global.CanSkipTitle){
	if(!instance_exists(oCredits) && !keyboard_check(vk_alt) && input_check_pressed("menu_input")){
		audio_stop_all();
		//instance_destroy(id);
		room_goto_next();
		exit;		
	}
}

if(DEBUG){
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