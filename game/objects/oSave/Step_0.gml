if(Open){
	Alpha += AlphaSpeed;
	if(Alpha >= 1){
		Alpha = 1;
		Open = false;
	}
	exit;
}


if(input_check_pressed("up")){
	SelectorPos--;
	if(SelectorPos < 0) SelectorPos = MenuItems - 1;
	audio_play_sound(Sound_Text, 1, false);
}
if(input_check_pressed("down")){
	SelectorPos++;
	if(SelectorPos >= MenuItems) SelectorPos = 0;
	audio_play_sound(Sound_Text, 1, false);
}

if(input_check_pressed("menu_input")){
	
	switch(SelectorPos){
		
		case 0:
			audio_play_sound(Sound_TextDone, 1, false);
			QuitTo = 1;
			alarm[0] = 15;
			break;
			
		case 1:
			audio_play_sound(Sound_TextDone, 1, false);
			QuitTo = 2;
			alarm[0] = 15;
			break;
			
	}
}