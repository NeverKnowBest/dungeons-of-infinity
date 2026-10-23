if(instance_exists(ErrorMsgInst)) exit;

draw_set_halign(fa_left);

var _y = 0;
//draw_text(8, _y, "CHX: " + string(NameEntryCross_X)); _y+=12;
//draw_text(8, _y, "CHY: " + string(NameEntryCross_Y)); _y+=12;
//draw_text(8, _y, "GridX: " + string(NameEntryCross_GridX)); _y+=12;
//draw_text(8, _y, "GridY: " + string(NameEntryCross_GridY)); _y+=12;
//draw_text(8, _y, "Letter: " + LetterGrid_GetLetter()); _y+=12;


var _MainTitle = Menu_Title[MenuWin_Main_MenuIndex]
var _OptionsTitle = Menu_Title[MenuWin_Options_MenuIndex];

//Draw Main menu

draw_set_font(MenuWin_Main_Active ? global.MenuFont : global.MenuFont_Innactive);

for(var i = 0; i < Menu_Count[MenuWin_Main_MenuIndex]; i++){
	
	draw_text(MenuWinInst_Main.x + 32, Menu_Y[MenuWin_Main_MenuIndex][i], Menu[MenuWin_Main_MenuIndex][i]);
	
	switch(MenuWin_Main_MenuIndex){
		case MenuIndex.NameSelect:
				if(i < global.MaxUsers) draw_text(MenuWinInst_Main.x + 43, Menu_Y[MenuWin_Main_MenuIndex][i], global.Users[i].Name);
			break;
	
	}
	
	
	
	
}
		

//Draw Options menu

draw_set_font(global.MenuFont);


var PosX, PosY, _ChallengeIndex;
if(MenuWinInst_Options.visible){
	
	switch(MenuWin_Options_MenuIndex){
		
		default:
			
			for(var i = 0; i < Menu_Count[MenuWin_Options_MenuIndex]; i++){
				
				if(MenuWin_Options_MenuIndex == MenuIndex.Settings && (i < Settings_Scroll || i >= Settings_Scroll + SETTINGS_VISIBLE_ROWS)) continue;
				var _OffsetY = 0;
				
				switch(MenuWin_Options_MenuIndex){
					case MenuIndex.NewGame_Start:
						//character
						if(i == 1) draw_sprite(global.CharacterSprites, global.LinkCharacterIndex, MenuWinInst_Options.x + 94, Menu_Y[MenuWin_Options_MenuIndex][i] - 6);
						//starting gear
						if(i == 2){
							var _SlotIndex = global.StartingGear * 4;
							var _SprIndex = global.GearSprites[_SlotIndex];
							var _ImgIndex = global.GearSprites[_SlotIndex + 1];
							var _SprOffsetX = 0;//global.GearSprites[_SlotIndex + 2];
							var _SprOffsetY = global.GearSprites[_SlotIndex + 3];
							var _PosX = MenuWinInst_Options.x + 102 + _SprOffsetX;
							var _PosY = Menu_Y[MenuWin_Options_MenuIndex][i] + 17 + _SprOffsetY;
							draw_sprite(_SprIndex, _ImgIndex, _PosX, _PosY);
							switch(_SprIndex){
								case sItem_Rupee:
									draw_set_font(global.Font_ItemValues);
									draw_text(_PosX - 1, _PosY - 6, string(StartingGear_Rupees))
									draw_set_font(global.MenuFont);
									break;
								//case sItem_BagSlot:
								//	draw_set_font(global.Font_ItemValues);
								//	draw_text(_PosX + 2, _PosY - 7, "+")
								//	draw_set_font(global.MenuFont);
								//	break;
								case sItem_Rod:
									draw_set_font(global.Font_ItemValues);
									draw_text(_PosX, _PosY - 6, string(global.MaxRodCharge[Rod.Stone]))
									draw_set_font(global.MenuFont);
									break;
								case sItem_Orb:
									draw_set_font(global.Font_ItemValues);
									draw_text(_PosX + 3, _PosY - 6, string(StartingGear_Orbs))
									draw_set_font(global.MenuFont);
									break;
								
							}

						}
						if(i == 3){
							
							var _DrawSkull = false;
							
							for(var _ChallengeOptionIndex = 0; _ChallengeOptionIndex < ChallengeOptionCount; _ChallengeOptionIndex++){
								if(global.ChallengeOptions[_ChallengeOptionIndex] > 0){
									_DrawSkull = true;
									break;									
								}
							}
							
							if(!_DrawSkull){
								for(_ChallengeIndex = 0; _ChallengeIndex < ChallengeCount; _ChallengeIndex++){
									if(global.Challenges[_ChallengeIndex]){
										_DrawSkull = true;
										break;
									}
								}							
							}
							
							if(_DrawSkull){
								var _PosX = MenuWinInst_Options.x + 95;
								var _PosY = Menu_Y[MenuWin_Options_MenuIndex][i] + 1;
								draw_sprite(sLargeMap_Boss, 0, _PosX, _PosY);								
							}
						}
						break;
					
					//case MenuIndex.Gear:
					//	draw_set_font(global.Font_Small);
					//	break;

					case MenuIndex.Challenges:
						draw_set_font(global.Font_Small);
						_OffsetY = 4;
						break;
					
				}
				
				draw_text(MenuWinInst_Options.x + 32, Menu_Y[MenuWin_Options_MenuIndex][i] + _OffsetY, Menu[MenuWin_Options_MenuIndex][i]);
				if(MenuWin_Options_MenuIndex == MenuIndex.Settings && i > 0){
					draw_set_halign(fa_right);
					draw_text(MenuWinInst_Options.x + MenuWinInst_Options.W - 16, Menu_Y[MenuWin_Options_MenuIndex][i], Settings_Value(i));
					draw_set_halign(fa_left);
					if(Settings_IsSlider(i)){
						var _BX = MenuWinInst_Options.x + MenuWinInst_Options.W - 16 - 34 - 46;
						var _BY = Menu_Y[MenuWin_Options_MenuIndex][i] + 6;
						draw_set_color(c_dkgray); draw_rectangle(_BX, _BY, _BX + 40, _BY + 3, false);
						draw_set_color(c_white); draw_rectangle(_BX, _BY, _BX + round(40 * Settings_Fraction(i)), _BY + 3, false);
						draw_rectangle(_BX + round(40 * Settings_Fraction(i)) - 1, _BY - 2, _BX + round(40 * Settings_Fraction(i)) + 1, _BY + 5, false);
					}
				}
				
				draw_set_font(global.MenuFont);
				
			}
			if(MenuWin_Options_MenuIndex == MenuIndex.Settings){
				var _AX = MenuWinInst_Options.x + MenuWinInst_Options.W - 16;
				draw_set_color(c_white);
				if(Settings_Scroll > 0) draw_triangle(_AX - 4, 66, _AX + 4, 66, _AX, 60, false);
				if(Settings_Scroll + SETTINGS_VISIBLE_ROWS < Menu_Count[MenuIndex.Settings]) draw_triangle(_AX - 4, 190, _AX + 4, 190, _AX, 196, false);
			}
			break;
		
		case MenuIndex.NewUser:
			
			//letters
			draw_set_halign(fa_center);
			draw_set_valign(fa_center);
			var Chr = 0;
			for(_y = 0; _y < global.LetterGridRows; _y++){
				
				if(_y == global.LetterGridRows - 1){
					draw_set_halign(fa_left);
					draw_set_valign(fa_left);
				}
				
				for(var _x = 0; _x < global.LetterGridColumns; _x++){
					var Letter = global.NewUserChrMap[Chr];
					PosX = LetterGridX + (_x * global.LetterGridSpacingW) + (_y < global.LetterGridRows - 1 ? 3 : 0);
					PosY = LetterGridY + (_y * global.LetterGridSpacingH) + (_y < global.LetterGridRows - 1 ? 8 : 0);
					switch(Letter){
						case "!": draw_text(PosX, PosY, "Ok"); break;
						case "@": draw_text(PosX, PosY, ""); break;
						case "#": draw_text(PosX, PosY, "Back"); break;
						case "$": draw_text(PosX, PosY, ""); break;
						default:  draw_text(PosX, PosY, Letter); break;
					}
					Chr++;
				}
			
			}
		
			//crosshair
			LetterGrid_DrawCrossHair_H();
			LetterGrid_DrawCrossHair_V();			
			
			break;
		
		case MenuIndex.Character:
			for(var i = 0; i < LinkCharacters; i++){
				PosX = MenuWinInst_Options.x + 24 + ((i mod 3) * 42);
				PosY = MenuWinInst_Options.y + 21 + ((i div 3) * 48);
				//if(i < 2)	
					draw_sprite(global.CharacterSprites, i, PosX, PosY);
				//else 
				//	draw_sprite_ext(global.CharacterSprites, i, PosX, PosY, 1, 1, 0, c_black, 1);
				if(i == global.LinkCharacterIndex) draw_sprite(sCharacterSelector, 0, PosX - 3, PosY - 2);
			}
			
			break;
			
		case MenuIndex.Stats:
			
			draw_set_halign(fa_right);
			
			PosX = MenuWinInst_Options.x + 112;
			PosY = MenuWinInst_Options.y + 14;
			var Stats = global.Users[global.UserIndex].Stats;
			
			draw_text(PosX, PosY, "Games Played:"); PosY+=16;
			draw_text(PosX, PosY, "Games Won:"); PosY+=16;
			draw_text(PosX, PosY, "Best Time:"); PosY+=16;
			draw_text(PosX, PosY, "Deaths:"); PosY+=16;
			draw_text(PosX, PosY, "Monsters Killed:"); PosY+=16;
			draw_text(PosX, PosY, "Rupees Collected:"); PosY+=16;
			draw_text(PosX, PosY, "Treasures Opened:"); PosY+=16;
			
			draw_set_halign(fa_left);
			PosX = MenuWinInst_Options.x + 116;
			PosY = MenuWinInst_Options.y + 14;
			draw_text(PosX, PosY, string(Stats[Stat.GamesPlayed])); PosY+=16;
			draw_text(PosX, PosY, string(Stats[Stat.GamesWon])); PosY+=16;
			draw_text(PosX, PosY, Stats[Stat.BestTime] == 0 ? "0" : Time_Str(Stats[Stat.BestTime])); PosY+=16;
			draw_text(PosX, PosY, string(Stats[Stat.Deaths])); PosY+=16;
			draw_text(PosX, PosY, string(Stats[Stat.Monsters])); PosY+=16;
			draw_text(PosX, PosY, string(Stats[Stat.Rupees])); PosY+=16;
			draw_text(PosX, PosY, string(Stats[Stat.Treasures])); PosY+=16;
			break;
			
	}
	
	
	//extra drawing stuff. If menu has to be drawn, plus other things need to be drawn too
	switch(MenuWin_Options_MenuIndex){
	
		case MenuIndex.Gear:
			//draw_set_halign(fa_center);
			//draw_set_font(global.FontNumbers);

			for(var _ItemIndex = 0; _ItemIndex < GearItems; _ItemIndex++){
				var _SlotIndex = _ItemIndex * 4;
				var _SprOffsetX = global.GearSprites[_SlotIndex + 2];
				var _SprOffsetY = global.GearSprites[_SlotIndex + 3];
				var _PosX = MenuWinInst_Options.x + 123 + _SprOffsetX;
				var _PosY = MenuWinInst_Options.y + 35 + (_ItemIndex * 16) + _SprOffsetY;
				var _SprIndex = global.GearSprites[_SlotIndex];
				var _ImgIndex = global.GearSprites[_SlotIndex + 1];				
				draw_sprite(_SprIndex, _ImgIndex, _PosX, _PosY);
				switch(_ItemIndex){
					case StartingGear.Rupees:
						draw_set_font(global.Font_ItemValues);
						draw_text(_PosX - 1, _PosY - 6, string(StartingGear_Rupees))
						draw_set_font(global.MenuFont);
						break;
					//case StartingGear.Inventory:
					//	draw_set_font(global.Font_ItemValues);
					//	draw_text(_PosX + 2, _PosY - 7, "+")
					//	draw_set_font(global.MenuFont);
					//	break;
					case StartingGear.Rod:
						draw_set_font(global.Font_ItemValues);
						draw_text(_PosX, _PosY - 6, string(global.MaxRodCharge[Rod.Stone]))
						draw_set_font(global.MenuFont);
						break;
					case StartingGear.Orbs:
						draw_set_font(global.Font_ItemValues);
						draw_text(_PosX + 3, _PosY - 6, string(StartingGear_Orbs))
						draw_set_font(global.MenuFont);
						break;

							
				}
				
			}
			//draw_set_halign(fa_left);
			//draw_set_font(global.MenuFont);
			break;
			
		case MenuIndex.Challenges:
			
			var _X = MenuWinInst_Options.x + 103;
			var _Y = MenuWinInst_Options.y + 30;
			for(var _ChallengeOptionIndex = 0; _ChallengeOptionIndex < ChallengeOptionCount; _ChallengeOptionIndex++){
				
				switch(_ChallengeOptionIndex){
					
					case ChallengeOption.StartingHearts:
					case ChallengeOption.HeartsMax:
					case ChallengeOption.Defense:
					case ChallengeOption.Inventory:
						draw_sprite_stretched(sChallengeOptions, _ChallengeOptionIndex, _X + 0.5, _Y + 1, 8 * (4 - global.ChallengeOptions[_ChallengeOptionIndex]), 8);
						break;
					
					case ChallengeOption.MaxRupees:
						draw_sprite_stretched(sChallengeOptions, _ChallengeOptionIndex, _X + 1, _Y + 1, 8 * (4 - global.ChallengeOptions[_ChallengeOptionIndex]), 8);
						break;
						
					case ChallengeOption.ShopPrices:
						draw_sprite_stretched(sChallengeOptions, _ChallengeOptionIndex, _X + 1, _Y + 1, 8 * (global.ChallengeOptions[_ChallengeOptionIndex] + 1), 8);
						break;
						
					case ChallengeOption.Darkness:
						if(global.ChallengeOptions[_ChallengeOptionIndex] == ChallengeOption_Darkness.NoLights){
							draw_sprite(sChallengeOptions, 9, _X + 0.5, _Y + 1);
						}else{
							draw_sprite_stretched(sChallengeOptions, _ChallengeOptionIndex, _X + 0.5, _Y + 1, 8 * (4 - global.ChallengeOptions[_ChallengeOptionIndex]), 8);
						}						
						break;
					
					default:
						draw_sprite_stretched(sChallengeOptions, _ChallengeOptionIndex, _X + 0.5, _Y + 1, 8 * (global.ChallengeOptions[_ChallengeOptionIndex] + 1), 8);
						break;
				}
				_Y += 10;
			}			
			for(_ChallengeIndex = 0; _ChallengeIndex < ChallengeCount; _ChallengeIndex++){
				draw_sprite(global.Challenges[_ChallengeIndex] ? sCheckbox : sCheckBox_Innactive, global.Challenges[_ChallengeIndex] ? 1 : 0, _X, _Y);
				_Y += 10;
			}
			if(Selector_Index_Options > 0 && Selector_Index_Options <= ChallengeOptionCount){
				var _OptionIndex = Selector_Index_Options - 1;
				_OptionsTitle = global.ChallengeOptionTitles[_OptionIndex][global.ChallengeOptions[_OptionIndex]];
			}else if(Selector_Index_Options > ChallengeOptionCount){
				_OptionsTitle = global.ChallengeTitles[Selector_Index_Options - ChallengeOptionCount - 1];
			}
			break;
			
		case MenuIndex.Controls_Gamepad:

			draw_set_halign(fa_right);
			
			PosX = MenuWinInst_Options.x + 136;
			PosY = MenuWinInst_Options.y + 14;

			draw_text(PosX, PosY, "Sword:"); PosY+=16;
			draw_text(PosX, PosY, "Action:"); PosY+=16;
			draw_text(PosX, PosY, "Item:"); PosY+=16;
			draw_text(PosX, PosY, "Map:"); PosY+=16;
			draw_text(PosX, PosY, "Strafe:"); PosY+=16;
			draw_text(PosX, PosY, "Inventory:"); PosY+=16;
			draw_text(PosX, PosY, "Menu:"); PosY+=16;
			draw_text(PosX, PosY, "HUD:"); PosY+=16;
			
			
			draw_set_halign(fa_left);
			PosX = MenuWinInst_Options.x + 140;
			PosY = MenuWinInst_Options.y + 14;
				
			for(var i = 0; i < global.BindingIconCount[Input_Index.Gamepad]; i++){

				if(Bindings_Remap){
					_OptionsTitle = "Backspace to skip";
					if(i == global.BindingRemap_VerbIndex)
						draw_rectangle(PosX, PosY, PosX + 36, PosY + 15, false);	
					else draw_text(PosX, PosY, global.BindingIcons[Input_Index.Gamepad][i]);
				}else draw_text(PosX, PosY, global.BindingIcons[Input_Index.Gamepad][i]); 
					
				PosY+=16;
			}

			break;
		
		case MenuIndex.Controls_Keyboard:
		
			draw_set_halign(fa_right);
			draw_set_font(global.Font_Small);
			
			PosX = MenuWinInst_Options.x + 136;
			PosY = MenuWinInst_Options.y + 22;
			var _TextSep = 9;
			
			draw_text(PosX, PosY, "UP:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "DOWN:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "LEFT:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "RIGHT:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "SWORD:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "ACTION:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "ITEM:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "MAP:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "STRAFE:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "INVENTORY:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "MENU:"); PosY+=_TextSep;
			draw_text(PosX, PosY, "HUD:"); PosY+=_TextSep;
			

			draw_set_halign(fa_left);
			PosX = MenuWinInst_Options.x + 140;
			PosY = MenuWinInst_Options.y + 22;
				
			for(var i = 0; i < global.BindingIconCount[Input_Index.Keyboard]; i++){
				
				var BindingIcon = string_upper(global.BindingIcons[Input_Index.Keyboard][i]);
				BindingIcon = string_replace(BindingIcon, "empty", "");
				
				if(Bindings_Remap){
					_OptionsTitle = "Backspace to skip";
					if(i == global.BindingRemap_VerbIndex)
						draw_rectangle(PosX, PosY, PosX + 36, PosY + 5, false);	
					else draw_text(PosX, PosY, BindingIcon);
				}else draw_text(PosX, PosY, BindingIcon); 
					
				PosY+=_TextSep;
				
			}

			break;
		
	}
}




if(Menu_Selector[MenuWin_Main_MenuIndex]) draw_sprite(MenuWin_Main_Active ? sMenu_Selector_Active : sMenu_Selector_Innactive, Selector_Frame, MenuWinInst_Main.x + 12, Menu_Y[MenuWin_Main_MenuIndex][Selector_Index_Main]);
if(Menu_Active && MenuWin_Options_Active && Menu_Selector[MenuWin_Options_MenuIndex]) draw_sprite(sMenu_Selector_Active, Selector_Frame, MenuWinInst_Options.x + 12, Menu_Y[MenuWin_Options_MenuIndex][Selector_Index_Options]);



draw_set_halign(fa_center);
draw_set_font(MenuWin_Main_Active ? global.MenuFont : global.MenuFont_Innactive);
draw_text(MenuWinInst_Title1.x + (MenuWinInst_Title1.W / 2), MenuWinInst_Title1.y + 8.5, _MainTitle);

draw_set_font(global.MenuFont);
if(MenuWinInst_Title2.visible) draw_text(MenuWinInst_Title2.x + (MenuWinInst_Title2.W / 2), MenuWinInst_Title2.y + 8.5, _OptionsTitle);

//draw_set_halign(fa_left);
//draw_text(0, 0, string(global.BindingRemap_InputIndex));