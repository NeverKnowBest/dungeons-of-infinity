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

//if(DEBUG){
//	if(!Bindings_Remap && keyboard_check_pressed(vk_escape)) game_end();
//}

if(keyboard_check(vk_alt)) exit;

var _Input_MenuUp = input_check_pressed("menu_up");
var _Input_MenuDown = input_check_pressed("menu_down");
var _Input_MenuLeft = input_check_pressed("menu_left");
var _Input_MenuRight = input_check_pressed("menu_right");
var _Input_MenuInput =  input_check_pressed("menu_input");
var _Input_MenuBack = input_check_pressed("menu_back");

switch(Menu_ActiveIndex){
	
	// Any page built from rows: up/down moves the selector (scrolling if needed), left/right changes toggles and sliders
	default:
		var _Win_Main = MenuWin_Main_Active;
		if(!_Win_Main && !(MenuWin_Options_Active && Menu_Selector[MenuWin_Options_MenuIndex])) break;
		
		var _Dir = _Input_MenuDown ? 1 : (_Input_MenuUp ? -1 : 0);
		if(_Dir != 0){
			if(_Win_Main) Selector_Index_Main = Menu_MoveSelector(MenuWin_Main_MenuIndex, Selector_Index_Main, _Dir);
			else Selector_Index_Options = Menu_MoveSelector(MenuWin_Options_MenuIndex, Selector_Index_Options, _Dir);
			break;
		}
		
		var _Row = Menu_SelectedRow();
		if(_Row != undefined && Menu_RowHasValue(_Row)) Menu_RowHold(_Row);
		break;

	case MenuIndex.Character:
		var _Step = _Input_MenuUp ? -3 : (_Input_MenuDown ? 3 : (_Input_MenuLeft ? -1 : (_Input_MenuRight ? 1 : 0)));
		if(_Step != 0){
			global.LinkCharacterIndex = (global.LinkCharacterIndex + _Step + LinkCharacters) mod LinkCharacters;
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

// Confirm runs the selected row's action; pages without rows (Stats, Character...) just close
if(_Input_MenuInput){
	var _Selected = Menu_SelectedRow();
	if(_Selected == undefined) Menu_Back();
	else Menu_RowSelect(_Selected);
}else if(_Input_MenuBack){
	Menu_Back();
}
