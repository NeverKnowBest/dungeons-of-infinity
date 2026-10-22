// Feather disable GM2064
if(Exiting){
	ExitFade += 0.01;
	audio_sound_gain(MusicID, 1 - ExitFade, 0);
	if(ExitFade >= 1){
		instance_create_layer(0, 0, "System", oQuit, {QuitTo: 1});
	}
	exit;
}

if(Blackout){
	BlackoutFade += 0.0045;	
	if(BlackoutFade >= 1){
		BlackoutFade = 1;
		Blackout = false;
		alarm[2] = 40;
	}
}

if(EndGraphics){

	EndGraphicsFade -= 0.05;
	if(EndGraphicsFade <= 0){
		EndGraphicsFade = 0;
	}

}

if(AllowExit){
	if(input_check("menu_access") || input_check("sword") || input_check("action") || input_check("item") || input_check("inventory") || input_check("map")){
		Exiting = true;
	}
}