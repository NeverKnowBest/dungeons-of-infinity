
enum ArcadeState{
	UnUsed,
	Reset,
	AttractScreen,
	GameStartInit,
	GameStarted,
	GameOver,
	Unload
}


global.ArcadeFont = font_add_sprite_ext(sVideoGame_Font, " !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'abcdefghijklmnopqrstuvwxyz{|}", false, 0);
global.ArcadeFont2 = font_add_sprite_ext(sVideoGame_Font2, " !'#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_'abcdefghijklmnopqrstuvwxyz{|}", false, 0);

global.ArcadeVP_Sizes = array_create(4);

global.ArcadeVP_Surface = 0;

global.ArcadeVP_Show = false;

global.ArcadeCam_W = 160;
global.ArcadeCam_H = 140;

global.ArcadeVP_RenderX = 0;
global.ArcadeVP_RenderY = 0;
global.ArcadeVP_RenderW = 0;
global.ArcadeVP_RenderH = 0;
	
global.Arcade_ActiveInst = noone;

global.Arcade_UsedPlayers = ds_list_create();

function Arcade_SetCam(_W = 160, _H = 140){
	
	global.ArcadeCam_W = _W;
	global.ArcadeCam_H = _H;
	
	Arcade_SetVP(_W, _H);
	
}

function Arcade_SetVP(_W = 160, _H = 140){

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


