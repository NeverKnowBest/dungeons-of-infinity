if(Closing){
	Alpha -= 0.18;
	if(Alpha <= 0) instance_destroy();
	exit;
}
Alpha = min(1, Alpha + 0.18);
Slide *= 0.6;
if(abs(Slide) < 0.5) Slide = 0;

if(InputDelay > 0){
	InputDelay--;
	exit;
}

var _Count = array_length(global.Statues);
if(input_check_pressed("menu_right")){
	Index = (Index + 1) mod _Count;
	Sel = 0;
	Slide = 24;
	audio_play_sound(Sound_Text, 1, false);
}else if(input_check_pressed("menu_left")){
	Index = (Index + _Count - 1) mod _Count;
	Sel = 0;
	Slide = -24;
	audio_play_sound(Sound_Text, 1, false);
}

var _Rows = array_length(Gallery_Achievements(global.Statues[Index].Key));
if(input_check_pressed("menu_down")){
	Sel = (Sel + 1) mod _Rows;
	audio_play_sound(Sound_Text, 1, false);
}else if(input_check_pressed("menu_up")){
	Sel = (Sel + _Rows - 1) mod _Rows;
	audio_play_sound(Sound_Text, 1, false);
}

if(input_check_pressed("menu_back") || input_check_pressed("menu_access") || input_check_pressed("menu_input")){
	Closing = true;
	audio_play_sound(Sound_Throw, 1, false);
}
