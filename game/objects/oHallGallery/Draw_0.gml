// Layout (inside a 240x216 window): name and tier on top, the statue on the left, its achievements on the right,
// the selected achievement's goal and reward at the bottom.
var _Statue = global.Statues[Index];
var _Revealed = Statue_IsRevealed(_Statue.Key);
var _Progress = Statue_Progress(_Statue.Key);
var _Achs = Gallery_Achievements(_Statue.Key);

var _X = oCamera.X;
var _Y = oCamera.Y;
draw_set_alpha(Alpha / 1.6);
draw_set_color(c_black);
draw_rectangle(_X, _Y, _X + CAM_W - 1, _Y + CAM_H - 1, false);
draw_set_alpha(Alpha);
draw_set_color(c_white);

var _FW = 240;
var _FH = 200;
var _FX = _X + ((CAM_W - _FW) / 2);
var _FY = _Y + ((CAM_H - _FH) / 2);
var _CX = _FX + (_FW / 2);
draw_sprite_stretched(sHUD_Window_Curse, 0, _FX, _FY, _FW, _FH);

// name, tier and progress
draw_set_font(global.MenuFont);
draw_set_halign(fa_center);
draw_text(_CX, _FY + 8, _Revealed ? _Statue.Name : "???");
var _TierNames = ["BRONZE", "SILVER", "GOLD"];
var _TierColors = [make_colour_rgb(216, 144, 72), make_colour_rgb(200, 208, 224), make_colour_rgb(248, 208, 72)];
draw_set_font(global.Font_Small);
draw_set_color(_TierColors[_Statue.Tier]);
draw_text(_CX, _FY + 24, _TierNames[_Statue.Tier] + " STATUE  " + string(_Progress[0]) + "/" + string(_Progress[1]));
draw_set_color(c_white);

// the statue on its pedestal (left column), sliding in when changing statue
var _SX = _FX + 62 + Slide;
var _Base = _FY + 128;
draw_sprite_ext(sHall_Pedestal, _Statue.Tier, _SX, _Base, 1.5, 1.5, 0, c_white, Alpha);
draw_sprite_ext(Statue_Figure(_Statue.Key), _Revealed ? 0 : 1, _SX, _Base - 18, 1.5, 1.5, 0, c_white, Alpha);

// arrows on the window's sides and one dot per statue under it
draw_set_font(global.MenuFont);
if((current_time div 400) mod 2 == 0){
	draw_text(_FX + 14, _FY + 70, "<");
	draw_text(_FX + _FW - 14, _FY + 70, ">");
}
var _Count = array_length(global.Statues);
for(var i = 0; i < _Count; i++){
	var _DX = _FX + 62 - ((_Count - 1) * 4) + (i * 8);
	draw_set_color(i == Index ? c_white : make_colour_rgb(80, 80, 96));
	draw_rectangle(_DX - 1, _FY + 136, _DX + 1, _FY + 138, false);
}

// achievements (right column): name once done, "???" until then
draw_set_halign(fa_left);
var _LX = _FX + 116;
for(var i = 0; i < array_length(_Achs); i++){
	var _Ach = _Achs[i];
	var _Done = Achievement_IsDone(_Ach.Key);
	var _RY = _FY + 46 + (i * 22);
	var _Text = _Done ? _Ach.Name : "???";
	draw_set_font(global.MenuFont);
	if(i == Sel){
		draw_set_color(make_colour_rgb(40, 64, 40));
		draw_rectangle(_LX - 3, _RY - 3, _LX + string_width(_Text) + 2, _RY + string_height(_Text) - 1, false);
	}
	draw_set_color(_Done ? c_white : make_colour_rgb(120, 120, 120));
	draw_text(_LX, _RY, _Text);
}

// goal and reward of the selected achievement
var _SelAch = _Achs[Sel];
draw_set_font(global.Font_Small);
draw_set_halign(fa_center);
draw_set_color(make_colour_rgb(200, 200, 200));
draw_text(_CX, _FY + 152, string_upper(_SelAch.Desc));
var _Reward = Achievement_RewardText(_SelAch);
if(_Reward != ""){
	draw_set_color(make_colour_rgb(168, 216, 248));
	draw_text(_CX, _FY + 164, string_upper(_Reward));
}

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1);
