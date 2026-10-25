if(!instance_exists(oCamera)) exit;

// slide down from above the screen, wait, slide back up
var _T = min(Timer, Duration - Timer);
var _Slide = clamp(_T / SlideFrames, 0, 1);

var _X = oCamera.X + ((CAM_W - W) / 2);
var _Y = oCamera.Y + 4 + (Slot * (H + 2)) - ((1 - _Slide) * (H + 8));

draw_sprite_stretched(sHUD_Window_Curse, 0, _X, _Y, W, H);

var _CX = _X + (W / 2);
draw_set_halign(fa_center);

draw_set_font(global.Font_Small);
draw_set_color(#F8D848);
draw_text(_CX, _Y + 7, "ACHIEVEMENT UNLOCKED");

draw_set_font(global.MenuFont);
draw_set_color(#FFFFFF);
draw_text(_CX, _Y + 15, Title);

if(Reward != ""){
	draw_set_font(global.Font_Small);
	draw_set_color(#A8D8F8);
	draw_text(_CX, _Y + 31, string_upper(Reward));
}

draw_set_halign(fa_left);
draw_set_color(#FFFFFF);
