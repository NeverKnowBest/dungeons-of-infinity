enum MenuIndex{
	NameSelect,
	NewGame,
	ContinueGame,
	NewGame_Start,
	Options,
	NewUser,
	User,
	UserDelete,
	Stats,
	Cheats,
	Character,
	Gear,
	Challenges,
	Controls,
	Controls_Gamepad,
	Controls_Keyboard
}


enum MenuSelection_NewGame{
	NewGame,
	Options,
	Stats,
	Cheats,
	Back	
}

enum MenuSelection_ContinueGame{
	ContinueGame,
	NewGame,
	Options,
	Stats,
	Cheats,
	Back	
}

enum MenuSelection_NewGame_Start{
	Start,
	Character,
	Gear,
	Challenges,
	Back	
}

enum MenuSelection_Options{
	Back,
	Controls,
	User,
	Cheats
}

enum MenuSelection_Cheats{
	Back,
	Save,
	InfHealth,
	InfMagic,
	InfRupees,
	Max
}

enum MenuSelection_Options_Controls{
	Back,
	Gamepad,
	Keyboard
}

enum MenuSelection_Options_Controls_Gamepad{
	Back,
	Remap,
	Default
}

enum MenuSelection_Options_Controls_Keyboard{
	Back,
	Remap,
	Default
}

enum MenuSelection_Options_User{
	Back,
	ChangeName,
	Delete
}

enum MenuSelection_Options_User_Delete{
	No,
	Yes
}

enum MenuSelection_GameMenuID{
	Main,
	Options,
	Quit
}
enum MenuSelection_GameMenu{
	Resume,
	NewGame,
	Options,
	QuitTitle,	
	QuitDesktop	
}
enum MenuSelection_GameMenuOptions{
	Back,
	SFX,
	Music,
	HUD,	
	CRT,
	ItemMsg
}

enum MenuSelection_GameMenuQuit{
	Cancel,
	OK
}


global.NewUserChrMap = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","-",".",",","!","@","#","$"," "," "," "," "," "," "," "," "," "];
global.LetterGridSpacingW = 13;
global.LetterGridSpacingH = 18;
global.LetterGridColumns = 13;
global.LetterGridRows = 6;
global.MenuFont = font_add_sprite(sFont_Green, ord(" "), true, 0);
global.MenuFont_Innactive = font_add_sprite(sFont_Grey, ord(" "), true, 0);
global.MenuFont_Innactive2 = font_add_sprite(sFont_Black, ord(" "), true, 0);

function Menu_StartGame(){
	audio_stop_all();
	audio_play_sound(Sound_TextDone, 1, false);
	room_goto(Room_Dungeon);	
	
}

function Menu_ContinueGame(){
	audio_stop_all();
	audio_play_sound(Sound_TextDone, 1, false);
	global.SaveLevel = true;
	global.Continue = true;
	room_goto(Room_Dungeon);	
	
}


function Win_Main_Activate(_MenuIndex, _ResetSelector = true, _Sound = Sound_TextDone){
	
	MenuWin_Main_Active = true;
	MenuWin_Main_MenuIndex = _MenuIndex;
	
	MenuWin_Main_X_End = MenuWin_Main_X_Default;

	MenuWin_Main_Shift = true;
	MenuWin_Main_Shift_Dir = 1;
	
	MenuWin_Options_Active = false;
	
	Menu_Active = false;
	Menu_ActiveIndex = _MenuIndex;

	MenuWinInst_Main.sprite_index = sMenuWin;
	MenuWinInst_Title1.sprite_index = sMenuWin;	
	MenuWinInst_Options.visible = false;
	MenuWinInst_Title2.visible = false;
	
	if(_ResetSelector) Selector_Index_Main = 0;
	
	audio_play_sound(_Sound, 1, false);
	
}

function Win_Main_SetX(_x){
	MenuWinInst_Main.x = _x;
	MenuWinInst_Title1.x = _x;
}


function Win_Options_Activate(_MenuIndex, _Sound = Sound_TextDone){
	
	Menu_ActiveIndex = _MenuIndex;
	
	MenuWin_Options_MenuIndex = _MenuIndex;
	MenuWin_Options_Active = true;	
	
	var ScrW = camera_get_view_width(view_camera[0]);

	MenuWinInst_Options.W = Menu_TileW[_MenuIndex] * 8;
	
	MenuWin_Main_X_End = (ScrW - (MenuWinInst_Main.W + MenuWinInst_Options.W + 8)) / 2;

	MenuWinInst_Options.x = MenuWin_Main_X_End + MenuWinInst_Main.W + 8;

	MenuWinInst_Title2.W = MenuWinInst_Options.W;
	MenuWinInst_Title2.x = MenuWinInst_Options.x;

	MenuWinInst_Main.sprite_index = sMenuWin_Innactive;
	MenuWinInst_Title1.sprite_index = sMenuWin_Innactive;
	MenuWinInst_Options.visible = false;
	MenuWinInst_Title2.visible = false;
	
	MenuWin_Main_Active = false;
	MenuWin_Main_Shift = true;
	MenuWin_Main_Shift_Dir = MenuWin_Main_X_End >= MenuWinInst_Main.x ? 1 : -1;
		
	Menu_Active = false;
	
	Selector_Index_Options = 0;
	
	audio_play_sound(_Sound, 1, false);
	
}

function Menu_Create(_MenuIndex, _Title, _TileW = 20, _Selector = true, _YSpace = 16){ 
	
	Menu_Title[_MenuIndex] = _Title;
	Menu_TileW[_MenuIndex] = _TileW;
	Menu_Selector[_MenuIndex] = _Selector;
	
	for(var i = 0; i < argument_count - 5; i++){
		Menu[_MenuIndex][i] = argument[5 + i];
	}
	
	Menu_Count[_MenuIndex] = array_length(Menu[_MenuIndex]);
	
	Menu_Y[_MenuIndex][0] = 70;
	for(var i = 1; i < Menu_Count[_MenuIndex]; i++){
		var YSpace = _YSpace;
		var Str = Menu[_MenuIndex][i];
		if(string_pos("{s}", Str)  != 0){
			Menu[_MenuIndex][i] = string_copy(Str, 4, string_length(Str) - 3);
			YSpace += 8;
		}
		Menu_Y[_MenuIndex][i] = Menu_Y[_MenuIndex][i - 1] + YSpace;
	}


}

function LetterGrid_Init(){
	LetterGridX = MenuWinInst_Options.x + 14;
	LetterGridY = MenuWinInst_Options.y + 20;
	NameEntryCross_GridX = 0;
	NameEntryCross_GridY = 0;
	NameEntryCross_X = LetterGrid_GetX(NameEntryCross_GridX);
	NameEntryCross_Y = LetterGrid_GetY(NameEntryCross_GridY);
	NameEntryCross_MoveEndX = NameEntryCross_X;
	NameEntryCross_MoveEndY = NameEntryCross_Y;
	NameEntry_Name = "";	
}

function LetterGrid_GetX(_GridX){
	return LetterGridX + (_GridX * global.LetterGridSpacingW);	
}
function LetterGrid_GetY(_GridY){
	return LetterGridY + (_GridY * global.LetterGridSpacingH);	
}
function LetterGrid_GetGridX(_X){
	return floor((_X - LetterGridX) / global.LetterGridSpacingW);	
}
function LetterGrid_GetGridY(_Y){
	return floor((_Y - LetterGridY) / global.LetterGridSpacingH);
}
function LetterGrid_DrawCrossHair_H(){
	draw_set_alpha(0.5);
	for(var _x = MenuWinInst_Options.x + 6; _x < MenuWinInst_Options.x + MenuWinInst_Options.W - 6; _x++){
		draw_sprite(sPixel, 0, _x, NameEntryCross_Y + 8);
	}
	draw_set_alpha(1);
}
function LetterGrid_DrawCrossHair_V(){
	draw_set_alpha(0.5);
	for(var _y = MenuWinInst_Options.y + 6; _y < MenuWinInst_Options.y + MenuWinInst_Options.H - 6; _y++){
		draw_sprite(sPixel, 0, NameEntryCross_X + 3, _y);
	}
	draw_set_alpha(1);
}

function LetterGrid_GetLetter(){
	return global.NewUserChrMap[(NameEntryCross_GridY * global.LetterGridColumns) + NameEntryCross_GridX];
	
}