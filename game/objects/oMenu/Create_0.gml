

//var profile = ds_map_create();
//profile = input_profile_export("gamepad", 0, false, true);

//var player = ds_map_create();
//player = input_player_export(0, false, true);


//var system = ds_map_create();
//system = input_system_export(false, true);

//var p = input_profile_get();
//var b = input_binding_get("sword",,, "gamepad")

//var i = input_binding_get_icon(b);



MenuWin_Main_MenuIndex = MenuIndex.NameSelect;
MenuWin_Main_Active = true;
MenuWin_Main_X_Default = 144;
MenuWin_Main_X_End = 0;

MenuWin_Main_Shift = false;
MenuWin_Main_Shift_Dir = -1;
MenuWin_Main_Shift_V = 5;

MenuWin_Options_MenuIndex = MenuIndex.Options;
MenuWin_Options_Active = false;

ErrorMsgInst = noone;

var _CreateNewFile = false;
if(file_exists(USERSFILE)){
		
	var Buffer = xzip_read(USERSFILE, XZIPFILE_USERS);
	if(Buffer == -1){
		
		ErrorMsgInst = MsgBox("Error reading User file, creating new file.",,,,80);
		
		_CreateNewFile = true;
		
	}else{
		var JSONStr = buffer_read(Buffer, buffer_string);
		buffer_delete(Buffer);

		global.Users = json_parse(JSONStr);
	}
	
}else{
	
	_CreateNewFile = true;

}

if(_CreateNewFile){
	
	global.Users = array_create(0);

	repeat(global.MaxUsers){
		array_insert(global.Users, array_length(global.Users), new User_Create());
	}

	xzip_create(USERSFILE, XZIPFILE_USERS);
	
	HighScores = array_create(8);
	HighScores[ArcadeGame.Pitfall] = 5000;
	HighScores[ArcadeGame.Zerberk] = 3000;
	HighScores[ArcadeGame.SporkInvaders] = 100;
	var _Buffer = EncodeDataToBuffer(HighScores);
	xzip_write(USERSFILE, _Buffer, XZIPFILE_ARCADES);
	buffer_delete(_Buffer);
	
	User_Save();
	
}

global.LinkCharacterIndex = 0;

var SprW = 16;
var SprH = 24;	
var SprSurface = surface_create(SprW, SprH);
surface_set_target(SprSurface);

for(var _CharacterIndex = 0; _CharacterIndex < LinkCharacters; _CharacterIndex++){
	
	var SpriteSheet = global.LinkCharacterSpr[_CharacterIndex];
	draw_clear_alpha(c_black, 0.0);
	draw_sprite_part(SpriteSheet, 0,   48, 16,   16, 16,   0, 8);    //source body
	draw_sprite_part(SpriteSheet, 0,   16, 0,    16, 16,   0, 0);    //source head	
	if(_CharacterIndex == 0){
		global.CharacterSprites = sprite_create_from_surface(SprSurface, 0, 0, SprW, SprH, false, false, 0, 0);
	}else{
		sprite_add_from_surface(global.CharacterSprites, SprSurface, 0, 0, SprW, SprH, false, false);
	}

}

surface_reset_target();		
surface_free(SprSurface);


global.ChallengeOptions = array_create(ChallengeOptionCount);
global.ChallengeOptions[ChallengeOption.StartingHearts] = 0;
global.ChallengeOptions[ChallengeOption.HeartsMax] = 0;
global.ChallengeOptions[ChallengeOption.Defense] = 0;
global.ChallengeOptions[ChallengeOption.Darkness] = 0;
global.ChallengeOptions[ChallengeOption.Inventory] = 0;
global.ChallengeOptions[ChallengeOption.MaxRupees] = 0;
global.ChallengeOptions[ChallengeOption.ShopPrices] = 0;
global.ChallengeOptions[ChallengeOption.Enemies] = 0;
global.ChallengeOptions[ChallengeOption.Curses] = 0;

global.Challenges = array_create(ChallengeCount, false);

Selector_Index_Main = 0;
Selector_Index_Options = 0;
Selector_Frame = 0;
alarm[0] = 8;

LetterGridX = 0;
LetterGridY = 0;

NameEntryCross_X = 0;
NameEntryCross_Y = 0;
NameEntryCross_GridX = 0;
NameEntryCross_GridY = 0;
NameEntryCross_Move = false;
NameEntryCross_MoveV = 2;
NameEntryCross_MoveDirX = 0;
NameEntryCross_MoveDirY = 0;
NameEntryCross_MoveEndX = 0;
NameEntryCross_MoveEndY = 0;
NameEntryCross_ReboundX = false;
NameEntryCross_ReboundY = false;

NameEntry_Name = "";
NameEntry_Rename = false;

Bindings_Remap = false;
Bindings_GetIcons(Input_Index.Gamepad);
Bindings_GetIcons(Input_Index.Keyboard);

	
Menu_Create(MenuIndex.NameSelect, "Select User",,,, "1.", "2.", "3.", "4.", "5.", "{s}Exit");
Menu_Create(MenuIndex.NewUser, "Register Your Name", 24, false,, "");
Menu_Create(MenuIndex.NewGame, "",,,, "New Game", "{s}Options", "{s}Stats", "{s}Cheats", "{s}Back");
Menu_Create(MenuIndex.ContinueGame, "",,,, "Continue", "{s}New Game", "{s}Options", "{s}Stats", "{s}Back");
Menu_Create(MenuIndex.NewGame_Start, "Start Game", 18,,, "Start", "{s}Character", "{s}Bonus Item", "{s}Challenges", "{s}Back");
Menu_Create(MenuIndex.Character, "Select a Character", 18, false,, "");

Menu_Create(MenuIndex.Gear, "Pick a Bonus Item", 18,, 16,  "None", 
															string(StartingGear_Rupees) + " Rupees", 
															"+1 Inv Slot",
															"+1 Health", 
															"Wooden Shield", 
															"Rod of Stone", 
															string(StartingGear_Orbs) + " Fire Orbs", 
															"Antidote");
															
Menu_Create(MenuIndex.Challenges, "Enable Challenges", 18,,10,	"BACK", 
																"STARTING HEARTS",
																"MAX HEARTS",
																"MAX DEFENSE",
																"DARKNESS",
																"STARTING INV",
																"MAX RUPEES",
																"SHOP PRICES",
																"ENEMIES",
																"CURSES",
																"NO MAP",
																"NO FOOD ITEMS",
																"WALL MASTER");
																
Menu_Create(MenuIndex.Options, "Options",,,, "Back", "{s}Controls", "{s}User");
Menu_Create(MenuIndex.Controls, "Controls", 30,,, "Back", "{s}Gamepad", "{s}Keyboard");
Menu_Create(MenuIndex.Controls_Gamepad, "Remap Gamepad", 25,,, "Back", "Remap", "Default");
Menu_Create(MenuIndex.Controls_Keyboard, "Remap Keyboard", 25,,, "Back", "Remap", "Default");
Menu_Create(MenuIndex.User, "User",,,, "Back", "{s}Rename", "{s}Delete");
Menu_Create(MenuIndex.UserDelete, "Delete?", 10,,, "No", "Yes");
Menu_Create(MenuIndex.Stats, "Stats", 22, false,, "");
Menu_Create(MenuIndex.Cheats, "Cheats", 25,,, "Back", "Save", "Inf. HP", "Inf. Magic", "Inf. Rupees");

Win_Main_Activate(MenuWin_Main_MenuIndex);


depth = -100;

var MenuMusic = audio_play_sound(Music_Fairy_Main, 1, true);
audio_sound_gain(MenuMusic, 0.5, 0);