// Feather disable GM2064
AltTabCheck();

if(instance_exists(ErrorMsgInst)) exit;


if(MenuWin_Main_Shift){
				
	var NewX = MenuWinInst_Main.x + (MenuWin_Main_Shift_Dir * MenuWin_Main_Shift_V);
	
	
	if( (MenuWin_Main_Shift_Dir == 1 && NewX >= MenuWin_Main_X_End) || (MenuWin_Main_Shift_Dir == -1 && NewX <= MenuWin_Main_X_End)){
		NewX = MenuWin_Main_X_End;
		Menu_Active = true;
		MenuWin_Main_Shift = false;			
	}

	Win_Main_SetX(NewX);
	if(MenuWin_Main_Shift) exit;
	

	if(MenuWin_Options_Active){
		MenuWinInst_Options.visible = true;
		MenuWinInst_Title2.visible = true;			
	}

				
}

if(!Menu_Active) exit;

//if(global.DebugEnabled){
//	if(!Bindings_Remap && keyboard_check_pressed(vk_escape)) game_end();
//}

if(keyboard_check(vk_alt)) exit;

var _Input_MenuUp = input_check_pressed("menu_up");
var _Input_MenuDown = input_check_pressed("menu_down");
var _Input_MenuLeft = input_check_pressed("menu_left");
var _Input_MenuRight = input_check_pressed("menu_right");
var _Input_MenuInput =  input_check_pressed("menu_input");
var _Input_MenuBack = input_check_pressed("menu_back");

var _Back = false;

switch(Menu_ActiveIndex){
	
	default:
		if(MenuWin_Main_Active || (MenuWin_Options_Active && Menu_Selector[MenuWin_Options_MenuIndex]) ){
			if(_Input_MenuDown){
				if(MenuWin_Main_Active)	Selector_Index_Main = (Selector_Index_Main + 1) mod Menu_Count[MenuWin_Main_MenuIndex];
				if(MenuWin_Options_Active)	Selector_Index_Options = (Selector_Index_Options + 1) mod Menu_Count[MenuWin_Options_MenuIndex];
				audio_play_sound(Sound_Text, 1, false);
			}else if(_Input_MenuUp){
				if(MenuWin_Main_Active){
					Selector_Index_Main--;
					if(Selector_Index_Main < 0) Selector_Index_Main = Menu_Count[MenuWin_Main_MenuIndex] - 1;
				}
				if(MenuWin_Options_Active){
					Selector_Index_Options--;
					if(Selector_Index_Options < 0) Selector_Index_Options = Menu_Count[MenuWin_Options_MenuIndex] - 1;
				}
				audio_play_sound(Sound_Text, 1, false);
			}
		}
		break;
		
	case MenuIndex.Character:
		if(_Input_MenuUp){
			global.LinkCharacterIndex -= 3;
			if(global.LinkCharacterIndex < 0) global.LinkCharacterIndex += LinkCharacters;
			audio_play_sound(Sound_Text, 1, false);
		}else if(_Input_MenuDown){
			global.LinkCharacterIndex += 3;
			if(global.LinkCharacterIndex >= LinkCharacters) global.LinkCharacterIndex -= LinkCharacters;
			audio_play_sound(Sound_Text, 1, false);
		}else if(_Input_MenuLeft){
			global.LinkCharacterIndex -= 1;
			if(global.LinkCharacterIndex < 0) global.LinkCharacterIndex += LinkCharacters;
			audio_play_sound(Sound_Text, 1, false);
		}else if(_Input_MenuRight){
			global.LinkCharacterIndex = (global.LinkCharacterIndex + 1) mod LinkCharacters;
			if(global.LinkCharacterIndex >= LinkCharacters) global.LinkCharacterIndex -= LinkCharacters;
			audio_play_sound(Sound_Text, 1, false);
		}
		break;


	case MenuIndex.NewUser:
		
		var KeyUp = input_check("menu_up");
		var KeyDown = input_check("menu_down");
		var KeyLeft = input_check("menu_left");
		var KeyRight = input_check("menu_right");
		
		
		//NameEntryCross_GridY = LetterGrid_GetGridY(NameEntryCross_Y);
		
		if(NameEntryCross_X != NameEntryCross_MoveEndX){
			
			NameEntryCross_X += (NameEntryCross_MoveV * NameEntryCross_MoveDirX);
			
			switch(NameEntryCross_MoveDirX){
				
				case 1:  //moving right	
					if(NameEntryCross_X >= NameEntryCross_MoveEndX){
						if(KeyRight && LetterGrid_GetGridX(NameEntryCross_MoveEndX) < global.LetterGridColumns - 1) NameEntryCross_MoveEndX += global.LetterGridSpacingW;
						else{
							NameEntryCross_X = NameEntryCross_MoveEndX;
							NameEntryCross_ReboundX = false;
						}
					}else if(!KeyRight && !NameEntryCross_ReboundX && NameEntryCross_X <= NameEntryCross_MoveEndX - 8){
						NameEntryCross_MoveEndX -= global.LetterGridSpacingW;
						NameEntryCross_MoveDirX = -1;
						NameEntryCross_ReboundX = true;
					}
					break;
					
				case -1: //moving left
					if(NameEntryCross_X <= NameEntryCross_MoveEndX){
						if(KeyLeft && NameEntryCross_GridX > 0) NameEntryCross_MoveEndX -= global.LetterGridSpacingW;
						else{
							NameEntryCross_X = NameEntryCross_MoveEndX;
							NameEntryCross_ReboundX = false;
						}
					}else if(!KeyLeft && !NameEntryCross_ReboundX && NameEntryCross_X >= NameEntryCross_MoveEndX + 8){
						NameEntryCross_MoveEndX += global.LetterGridSpacingW;
						NameEntryCross_MoveDirX = 1;
						NameEntryCross_ReboundX = true;
					}			
					break;
			}

			
		}else{

			if(KeyRight && NameEntryCross_GridX < global.LetterGridColumns - 1){
				NameEntryCross_MoveDirX = 1;
				NameEntryCross_MoveEndX += global.LetterGridSpacingW;
			}
			if(KeyLeft && NameEntryCross_GridX > 0){
				NameEntryCross_MoveDirX = -1;
				NameEntryCross_MoveEndX -= global.LetterGridSpacingW;
			}
			
		}


		if(NameEntryCross_Y != NameEntryCross_MoveEndY){
			
			NameEntryCross_Y += (NameEntryCross_MoveV * NameEntryCross_MoveDirY);
			
			switch(NameEntryCross_MoveDirY){
				
				case 1:  //moving down	
					if(NameEntryCross_Y >= NameEntryCross_MoveEndY){
						if(KeyDown && LetterGrid_GetGridY(NameEntryCross_MoveEndY) < global.LetterGridRows - 1) NameEntryCross_MoveEndY += global.LetterGridSpacingH;
						else{
							NameEntryCross_Y = NameEntryCross_MoveEndY;
							NameEntryCross_ReboundY = false;
						}
					}else if(!KeyDown && !NameEntryCross_ReboundY && NameEntryCross_Y <= NameEntryCross_MoveEndY - 13){
						NameEntryCross_MoveEndY -= global.LetterGridSpacingH;
						NameEntryCross_MoveDirY = -1;
						NameEntryCross_ReboundY = true;
					}
					break;
					
				case -1: //moving up
					if(NameEntryCross_Y <= NameEntryCross_MoveEndY){
						if(KeyUp && NameEntryCross_GridY > 0) NameEntryCross_MoveEndY -= global.LetterGridSpacingH;
						else{
							NameEntryCross_Y = NameEntryCross_MoveEndY;
							NameEntryCross_ReboundY = false;
						}
					}else if(!KeyUp && !NameEntryCross_ReboundY && NameEntryCross_Y >= NameEntryCross_MoveEndY + 13){
						NameEntryCross_MoveEndY += global.LetterGridSpacingH;
						NameEntryCross_MoveDirY = 1;
						NameEntryCross_ReboundY = true;
					}			
					break;
			}

			
		}else{

			if(KeyDown && NameEntryCross_GridY < global.LetterGridRows - 1){
				NameEntryCross_MoveDirY = 1;
				NameEntryCross_MoveEndY += global.LetterGridSpacingH;
			}
			if(KeyUp && NameEntryCross_GridY > 0){
				NameEntryCross_MoveDirY = -1;
				NameEntryCross_MoveEndY -= global.LetterGridSpacingH;
			}
			
		}
		
		NameEntryCross_GridX = LetterGrid_GetGridX(NameEntryCross_X);
		NameEntryCross_GridY = LetterGrid_GetGridY(NameEntryCross_Y);
		
		if(NameEntry_Name == "") Menu_Title[MenuWin_Options_MenuIndex] = "Register Your Name";
		else Menu_Title[MenuWin_Options_MenuIndex] = NameEntry_Name;
		
		if(_Input_MenuInput){
			
			var Letter = LetterGrid_GetLetter();
			
			switch(Letter){
				default: 
					if(string_length(NameEntry_Name) < 8){
						NameEntry_Name += Letter;
						audio_play_sound(Sound_Text, 1, false);
					}
					break;
				
				case "!":
				case "@": //Ok
							
					if(NameEntry_Name == ""){
						audio_play_sound(Sound_Error, 1, false);
						break;
					}
							
					if(NameEntry_Rename){
						global.Users[global.UserIndex].Name = NameEntry_Name;
					}else{
						global.Users[global.UserIndex] = new User_Create();
						global.Users[global.UserIndex].Name = NameEntry_Name;
						DungeonSeq_Init(global.UserIndex);
					}
							
					User_Save();
					Win_Main_Activate(MenuIndex.NameSelect,, Sound_KinstoneConnect);
					Selector_Index_Main = global.UserIndex;
					NameEntry_Rename = false;
					break;
					
				case "#":
				case "$": //Back
					Win_Main_Activate(MenuIndex.NameSelect,, Sound_Throw);
					break;
			}
					
							
			
			input_clear_momentary(true);
			
			exit;	
		}
		
		if(NameEntry_Name != "" && _Input_MenuBack){
			NameEntry_Name = string_copy(NameEntry_Name, 1, string_length(NameEntry_Name)-1);
			input_clear_momentary(true);
			exit;				
		}

		break;	
					
					
}




if(_Input_MenuInput){
		
	switch(Menu_ActiveIndex){
			
		case MenuIndex.NameSelect:
			
			if(Selector_Index_Main == Menu_Count[MenuIndex.NameSelect] - 1)
				game_end(); //exit
			else{
				global.UserIndex = Selector_Index_Main;
				if(global.Users[global.UserIndex].Name == ""){
					Win_Options_Activate(MenuIndex.NewUser);
					LetterGrid_Init();

				}else{
					var _ErrorCode = User_VerifyIntegrity();
					var _Sound = Sound_TextDone;
					switch(_ErrorCode){								
						case 1: //input profile error
							ErrorMsgInst = MsgBox("Keyboard profile error, resetting to default controls.",,,,80);
							_Sound = Sound_Error;
							break;
						case 2: //input profile error
							ErrorMsgInst = MsgBox("Gamepad profile error, resetting to default controls.",,,,80);
							_Sound = Sound_Error;
							break;
					}
					Win_Main_Activate(global.Users[global.UserIndex].SaveData == -1 ? MenuIndex.NewGame : MenuIndex.ContinueGame,, _Sound);
					Menu_Title[MenuIndex.ContinueGame] = global.Users[global.UserIndex].Name;
					Menu_Title[MenuIndex.NewGame] = global.Users[global.UserIndex].Name;
					input_profile_import(global.Users[global.UserIndex].InputProfile_Gamepad, "gamepad");
					input_profile_import(global.Users[global.UserIndex].InputProfile_Keyboard, "keyboard");	
					Bindings_GetIcons(Input_Index.Gamepad);
					Bindings_GetIcons(Input_Index.Keyboard);
						
				}
					
			}

			break;
			
		case MenuIndex.NewGame:

			switch(Selector_Index_Main){
				case MenuSelection_NewGame.NewGame:
					Win_Options_Activate(MenuIndex.NewGame_Start);	
					break;
							
				case MenuSelection_NewGame.Options:
					Win_Main_Activate(MenuIndex.Options);	
					break;

				case MenuSelection_NewGame.Stats:
					Win_Options_Activate(MenuIndex.Stats);	
					break;
						
				case MenuSelection_NewGame.Back:
					_Back = true;
					break;
				
			}
			
			break;
				
		case MenuIndex.ContinueGame:

			switch(Selector_Index_Main){
				case MenuSelection_ContinueGame.ContinueGame:
					if( (global.SaveVersionCheck && global.Users[global.UserIndex].SaveData.GameVersion == VERSION) ||
						!global.SaveVersionCheck){
						Menu_ContinueGame();
					}else{
						ErrorMsgInst = MsgBox("Save file version error!\\Use the game version the save\\was created with.",,Sound_Error,,80);
					}
					break;
						
				case MenuSelection_ContinueGame.NewGame:
					Win_Options_Activate(MenuIndex.NewGame_Start);	
					break;
							
				case MenuSelection_ContinueGame.Options:
					Win_Main_Activate(MenuIndex.Options);	
					break;

				case MenuSelection_ContinueGame.Stats:
					Win_Options_Activate(MenuIndex.Stats);	
					break;
						
				case MenuSelection_ContinueGame.Back:
					_Back = true;
					break;
				
			}
			
			break;
				
		case MenuIndex.NewGame_Start:
				
			switch(Selector_Index_Options){
				case MenuSelection_NewGame_Start.Start:
					Menu_StartGame();
					break;
						
				case MenuSelection_NewGame_Start.Character:
					Menu_ActiveIndex = MenuIndex.Character;
					MenuWin_Options_MenuIndex = MenuIndex.Character;
					Selector_Index_Options = 0;
					audio_play_sound(Sound_TextDone, 1, false);
					break;
					
				case MenuSelection_NewGame_Start.Gear:
					Menu_ActiveIndex = MenuIndex.Gear;
					MenuWin_Options_MenuIndex = MenuIndex.Gear;
					Selector_Index_Options = 0;
					audio_play_sound(Sound_TextDone, 1, false);						
					break;

				case MenuSelection_NewGame_Start.Challenges:
					Menu_ActiveIndex = MenuIndex.Challenges;
					MenuWin_Options_MenuIndex = MenuIndex.Challenges;
					Selector_Index_Options = 0;					
					audio_play_sound(Sound_TextDone, 1, false);						
					break;
					
				case MenuSelection_NewGame_Start.Back:
					_Back = true;
					break;
				
			}					
			break;
			
		case MenuIndex.Stats:
		case MenuIndex.Character:
		case MenuIndex.Gear:
			_Back = true;
			break;
				
		case MenuIndex.Challenges:
			switch(Selector_Index_Options){
				case 0: //back
					_Back = true;
					break;
					
				default:
						

					if(Selector_Index_Options > 0 && Selector_Index_Options <= ChallengeOptionCount){
						var _OptionIndex = Selector_Index_Options - 1;
						global.ChallengeOptions[_OptionIndex] = (global.ChallengeOptions[_OptionIndex] + 1) mod 4;						
					}else if(Selector_Index_Options > ChallengeOptionCount){
						var _ChallengeIndex = Selector_Index_Options - ChallengeOptionCount - 1;
						global.Challenges[_ChallengeIndex] = !global.Challenges[_ChallengeIndex];
					}
			
						
					audio_play_sound(Sound_TextDone, 1, false);
					break;
				
			}
			break;
			
		case MenuIndex.Options:
			
			switch(Selector_Index_Main){

				case MenuSelection_Options.Back:
					_Back = true;
					break;
						
				case MenuSelection_Options.Controls:
					Win_Main_Activate(MenuIndex.Controls);	
					break;

				case MenuSelection_Options.User:
					Win_Main_Activate(MenuIndex.User);	
					break;
				
			}
			
			break;

		case MenuIndex.Controls:
			
			switch(Selector_Index_Main){
							
				case MenuSelection_Options_Controls.Back:
					_Back = true;
					break;
				
				case MenuSelection_Options_Controls.Gamepad:
					Win_Options_Activate(MenuIndex.Controls_Gamepad);
					break;
				
				case MenuSelection_Options_Controls.Keyboard:
					Win_Options_Activate(MenuIndex.Controls_Keyboard);
					break;
				
			}
			
			break;	
	
		case MenuIndex.Controls_Gamepad:
			
			switch(Selector_Index_Options){
							
				case MenuSelection_Options_Controls_Gamepad.Back:
					_Back = true;
					break;
					
				case MenuSelection_Options_Controls_Gamepad.Remap:
					instance_create_layer(-100, -100, "Menu", oInputRemap, {InputIndex : Input_Index.Gamepad})
					break;
					
				case MenuSelection_Options_Controls_Gamepad.Default:
					input_profile_reset_bindings("gamepad");
					User_SaveControls();
					Bindings_GetIcons(Input_Index.Gamepad);
					audio_play_sound(Sound_Throw, 1, false);
					break;
			}
			
			break;	
	
		case MenuIndex.Controls_Keyboard:
			
			switch(Selector_Index_Options){
							
				case MenuSelection_Options_Controls_Keyboard.Back:
					_Back = true;
					break;

				case MenuSelection_Options_Controls_Keyboard.Remap:
					instance_create_layer(-100, -100, "Menu", oInputRemap, {InputIndex : Input_Index.Keyboard})
					break;
						
				case MenuSelection_Options_Controls_Keyboard.Default:
					input_profile_reset_bindings("keyboard");
					User_SaveControls();
					Bindings_GetIcons(Input_Index.Keyboard);
					audio_play_sound(Sound_Throw, 1, false);
			}
			
			break;	
	
		case MenuIndex.User:
			
			switch(Selector_Index_Main){
							
				case MenuSelection_Options_User.Back:
					_Back = true;
					break;
				
				case MenuSelection_Options_User.ChangeName:
					NameEntry_Rename = true;
					Win_Options_Activate(MenuIndex.NewUser,Sound_Throw);
					LetterGrid_Init();
					break;
				
				case MenuSelection_Options_User.Delete:
					Win_Options_Activate(MenuIndex.UserDelete,Sound_Throw);
					break;
				
			}
			
			break;	
	
		case MenuIndex.UserDelete:
			switch(Selector_Index_Options){
				case MenuSelection_Options_User_Delete.No:
					_Back = true;					
					break;
				case MenuSelection_Options_User_Delete.Yes:
					User_Delete();
					Win_Main_Activate(MenuIndex.NameSelect, true, Sound_KinstoneConnect);				
			}
			break;
					
	}
	
		

	
}

_Input_MenuBack = input_check_pressed("menu_back");

if(_Input_MenuBack || _Back){
		
	switch(Menu_ActiveIndex){
		case MenuIndex.NewGame:
			Win_Main_Activate(MenuIndex.NameSelect,, Sound_Throw);
			Selector_Index_Main = global.UserIndex;
			break;
				
		case MenuIndex.ContinueGame:
			Win_Main_Activate(MenuIndex.NameSelect,, Sound_Throw);
			Selector_Index_Main = global.UserIndex;
			break;
			
		case MenuIndex.NewGame_Start:
			Win_Main_Activate(global.Users[global.UserIndex].SaveData == -1 ? MenuIndex.NewGame : MenuIndex.ContinueGame,, Sound_Throw);
			break;
			
		case MenuIndex.Stats:
			Win_Main_Activate(global.Users[global.UserIndex].SaveData == -1 ? MenuIndex.NewGame : MenuIndex.ContinueGame,, Sound_Throw);
			break;
			
		case MenuIndex.Character:
			Menu_ActiveIndex = MenuIndex.NewGame_Start;
			MenuWin_Options_MenuIndex = MenuIndex.NewGame_Start;
			Selector_Index_Options = 0;
			audio_play_sound(Sound_TextDone, 1, false);
			break;
			
		case MenuIndex.Gear:
			Menu_ActiveIndex = MenuIndex.NewGame_Start;
			MenuWin_Options_MenuIndex = MenuIndex.NewGame_Start;
			global.StartingGear = Selector_Index_Options;
			Selector_Index_Options = 0;
			audio_play_sound(Sound_TextDone, 1, false);	
			break;
			
		case MenuIndex.Challenges:
			Menu_ActiveIndex = MenuIndex.NewGame_Start;
			MenuWin_Options_MenuIndex = MenuIndex.NewGame_Start;
			Selector_Index_Options = 0;
			audio_play_sound(Sound_Throw, 1, false);
			break;
			
		case MenuIndex.Options:
			Win_Main_Activate(global.Users[global.UserIndex].SaveData == -1 ? MenuIndex.NewGame : MenuIndex.ContinueGame,, Sound_Throw);
			break;
			
		case MenuIndex.Controls:
		case MenuIndex.User:
			Win_Main_Activate(MenuIndex.Options, false, Sound_Throw);
			break;
			
		case MenuIndex.Controls_Gamepad:
		case MenuIndex.Controls_Keyboard:
			Win_Main_Activate(MenuIndex.Controls, false, Sound_Throw);
			break;
			
		case MenuIndex.UserDelete:
			Win_Main_Activate(MenuIndex.User, false, Sound_Throw);
			break;
				
	}
		
}
		
