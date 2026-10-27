enum ArcadeGame{
	Pitfall,
	Zerberk,
	SporkInvaders
}

enum ArcadeState{
	UnUsed,
	Reset,
	AttractScreen,
	GameStartInit,
	GameStarted,
	GameOver,
	Unload,
	Special
}


global.ArcadeFont =  font_add_sprite_ext(sVideoGame_Font , " !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}", false, 0);
global.ArcadeFont2 = font_add_sprite_ext(sVideoGame_Font2, " !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}", false, 0);

global.ArcadeVP_Sizes = array_create(4);

global.ArcadeVP_Surface = 0;

global.ArcadeVP_Show = false;

global.ArcadeCam_W = 200;
global.ArcadeCam_H = 150;

global.ArcadeVP_RenderX = 0;
global.ArcadeVP_RenderY = 0;
global.ArcadeVP_RenderW = 0;
global.ArcadeVP_RenderH = 0;
	
global.Arcade_ActiveInst = noone;

global.Arcade_UsedPlayers = ds_list_create();

function Arcade_SetCam(_W = global.ArcadeCam_W, _H = global.ArcadeCam_H){
	
	global.ArcadeCam_W = _W;
	global.ArcadeCam_H = _H;
	
	Arcade_SetVP(_W, _H);
	
}

function Arcade_SetVP(_W = global.ArcadeCam_W, _H = global.ArcadeCam_H){

	global.ArcadeVP_Sizes[0] = global.ArcadeCam_W;
	global.ArcadeVP_Sizes[1] = global.ArcadeCam_H;
	global.ArcadeVP_Sizes[2] = global.ArcadeCam_W * 2;
	global.ArcadeVP_Sizes[3] = global.ArcadeCam_H * 2;
	
	if(surface_exists(global.ArcadeVP_Surface)) surface_free(global.ArcadeVP_Surface);
	global.ArcadeVP_Surface = surface_create(global.ArcadeCam_W, global.ArcadeCam_H);
	
	Surface_Clear(global.ArcadeVP_Surface);

	global.ArcadeVP_RenderW = global.ArcadeCam_W * 4;
	global.ArcadeVP_RenderH = global.ArcadeCam_H * 4;
	global.ArcadeVP_RenderX = (view_get_wport(0) - global.ArcadeVP_RenderW) / 2;
	global.ArcadeVP_RenderY = (view_get_hport(0) - global.ArcadeVP_RenderH) / 2;

	
}

function Arcade_Slot_KeyCheck_Start(){
	
	if(input_check_pressed("item")){
		Bet = (Bet + 1) mod 5;
		audio_play_sound(Sound_Poker_Blip, 1, false);
	}
	
	if(input_check_pressed("sword")){
		if(global.Inventory.ItemData[ItemClass.Rupee].Amount >= Bet + 1){
			State = ArcadeState.GameStartInit;
		}else{
			audio_play_sound_stopall(Sound_Error);
		}
	}
	
}

function Arcade_Hiscore_Load(_GameIndex){

	var Highscores = Arcade_Hiscores_Load();
	
	if(Highscores == -1) return -1
	
	return Highscores[_GameIndex];
	
}

function Arcade_Hiscores_Load(){

	var Buffer = xzip_read(USERSFILE, XZIPFILE_ARCADES);
	if(Buffer == -1) return -1
	
	var JSONStr = buffer_read(Buffer, buffer_string);
	buffer_delete(Buffer);
	
	
	
	return json_parse(JSONStr);
	
}

function Arcade_Hiscore_Check(_GameIndex){

	if(Score > Hiscore){
		
		Hiscore = Score
		
		var Highscores = Arcade_Hiscores_Load();
		if(Highscores == -1) return false;
		
		Highscores[_GameIndex] = Hiscore;
		
		if(global.TestMode) return true;
		var _Buffer = EncodeDataToBuffer(Highscores);
		xzip_write(USERSFILE, _Buffer, XZIPFILE_ARCADES);
		buffer_delete(_Buffer);
		return true;
	}
	
	return false;
	
}
