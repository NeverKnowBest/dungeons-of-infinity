

Link_PauseHitFlashingTimer();

if(Quitting){
	exit;
}

if(Open){
	Alpha += AlphaSpeed;
	if(Alpha >= 1){
		Alpha = 1;
		Open = false;
	}
	exit;
}

if(Close){
	Alpha -= AlphaSpeed;
	if(Alpha <= 0){
		instance_destroy(id);
	}
	exit;
}	

if(keyboard_check(vk_alt)) exit;

var _Input_MenuUp = input_check_pressed("menu_up");
var _Input_MenuDown = input_check_pressed("menu_down");
var _Input_MenuInput =  input_check_pressed("menu_input");
var _Input_MenuAccess =  input_check_pressed("menu_access");
var _Input_MenuBack =  input_check_pressed("menu_back");

var _Back = false;


if(_Input_MenuUp){
	SelectorPos--;
	if(SelectorPos < 0) SelectorPos = MenuItems[Index] - 1;
	audio_play_sound(Sound_Text, 1, false);
}else if(_Input_MenuDown){
	SelectorPos++;
	if(SelectorPos >= MenuItems[Index]) SelectorPos = 0;
	audio_play_sound(Sound_Text, 1, false);
}

if(_Input_MenuInput){
	
	switch(Index){
	
		case MenuSelection_GameMenuID.Main: 
		
			switch(SelectorPos){
				case MenuSelection_GameMenu.Resume:
					_Back = true;
					break;

				case MenuSelection_GameMenu.NewGame:
					QuitTo = 0;
					Index = MenuSelection_GameMenuID.Quit;
					SelectorPos = 0;
					audio_play_sound(Sound_TextDone, 1, false);
					break;

				case MenuSelection_GameMenu.Options:
					Index = MenuSelection_GameMenuID.Options;
					SelectorPos = 0;
					audio_play_sound(Sound_TextDone, 1, false);
					break;
					
				case MenuSelection_GameMenu.QuitTitle:
					QuitTo = 1;
					Index = MenuSelection_GameMenuID.Quit;
					SelectorPos = 0;
					audio_play_sound(Sound_TextDone, 1, false);
					break;
					
				case MenuSelection_GameMenu.QuitDesktop:
					QuitTo = 2;
					Index = MenuSelection_GameMenuID.Quit;
					SelectorPos = 0;
					audio_play_sound(Sound_TextDone, 1, false);
					break;
			}
			
			break;
			
		case MenuSelection_GameMenuID.Options:
		
			switch(SelectorPos){
				case MenuSelection_GameMenuOptions.Back:
					_Back = true;
					break;

				case MenuSelection_GameMenuOptions.SFX:
					global.Users[global.UserIndex].Prefs[Pref.SFX] = !global.Users[global.UserIndex].Prefs[Pref.SFX];
					User_UpdateMusicSFX();
					audio_play_sound(Sound_TextDone, 1, false);					
					break;
				case MenuSelection_GameMenuOptions.Music:
					global.Users[global.UserIndex].Prefs[Pref.Music] = !global.Users[global.UserIndex].Prefs[Pref.Music];
					User_UpdateMusicSFX();
					audio_play_sound(Sound_TextDone, 1, false);					
					break;
				case MenuSelection_GameMenuOptions.HUD:
					global.Users[global.UserIndex].Prefs[Pref.HUD] = !global.Users[global.UserIndex].Prefs[Pref.HUD];
					audio_play_sound(Sound_TextDone, 1, false);
					break;
				case MenuSelection_GameMenuOptions.CRT:
					global.Users[global.UserIndex].Prefs[Pref.CRT] = !global.Users[global.UserIndex].Prefs[Pref.CRT];
					audio_play_sound(Sound_TextDone, 1, false);
					break;
				case MenuSelection_GameMenuOptions.ItemMsg:
					global.Users[global.UserIndex].Prefs[Pref.ItemMsg] = !global.Users[global.UserIndex].Prefs[Pref.ItemMsg];
					audio_play_sound(Sound_TextDone, 1, false);
					break;

			}
			
			break;
			
		case MenuSelection_GameMenuID.Quit:
		
			switch(SelectorPos){
				case MenuSelection_GameMenuQuit.Cancel:
					_Back = true;
					break;

				case MenuSelection_GameMenuQuit.OK:
					Music_Stop();
					audio_stop_all();
					audio_play_sound(Sound_TextDone, 1, false);
					Quitting = true;
					alarm[0] = QuitDelay;	
					break;

			}
			
			break;
			
	}
}

if(_Input_MenuAccess || _Input_MenuBack || _Back){
	
	switch(Index){
		case MenuSelection_GameMenuID.Main:
			Close = true;
			Music_Fade(1, 6);			
			break;
			
		case MenuSelection_GameMenuID.Options:
			Index = MenuSelection_GameMenuID.Main;
			SelectorPos = 0;
			User_Save();			
			break;
			
		case MenuSelection_GameMenuID.Quit:
			Index = MenuSelection_GameMenuID.Main;
			SelectorPos = 0;		
			break;
	}
	
	audio_play_sound(Sound_Throw, 1, false);
	
}