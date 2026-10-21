
if(State == ArcadeState.UnUsed) exit;

//BG
surface_set_target(GameSurface);
draw_set_color(#066ab5);
draw_rectangle(0, 0, CamW, CamH, false);

//Icons
draw_set_font(global.ArcadeFont);
draw_set_color(c_white);
draw_set_halign(fa_left);

	//Cherry
	draw_sprite_stretched(sArcade_Mothula_Icon_Cherry, 0, 16, 7, 33, 9);
	draw_text(50, 8, string(WinMul[1]) + "x");
	
	//Plum
	draw_sprite_stretched(sArcade_Mothula_Icon_Plum, 0, 16, 20, 33, 9);
	draw_text(50, 21, string(WinMul[2]) + "x");
	
	//Orange
	draw_sprite_stretched(sArcade_Mothula_Icon_Orange, 0, 75, 7, 30, 9);
	draw_text(107, 8, string(WinMul[3]) + "x");
	
	//Bell
	draw_sprite_stretched(sArcade_Mothula_Icon_Bell, 0, 74, 20, 33, 9);
	draw_text(107, 21, string(WinMul[4]) + "x");
	
	//7
	draw_sprite_stretched(sArcade_Mothula_Icon_7, 0, 134, 7, 33, 9);
	draw_text(170, 8, string(WinMul[5]) + "x");
	
	//Jackpot
	draw_sprite_stretched(sArcade_Mothula_Icon_Jackpot, 0, 131, 19, 39, 11);
	draw_text(170, 21, string(WinMul[6]) + "x");
	

//Reels
for(var _SlotIndex = 0; _SlotIndex < 3; _SlotIndex++){
	draw_sprite_stretched(sArcade_Mothula_Reel, 0, ReelPosX[_SlotIndex], 56, 56, 72);
	//var _y = 36;
	//draw_text(ReelPosX[_SlotIndex], _y, "PS: " + string(ReelPos[_SlotIndex])); _y += 9;
	//draw_text(ReelPosX[_SlotIndex], _y, "PS_S: " + string(ReelSpinIndexSeek[_SlotIndex] * 16)); _y += 9;
}
draw_sprite(sArcade_Mothula_ReelLine, 0, 68, 88);
draw_sprite(sArcade_Mothula_ReelLine, 0, 128, 88);


surface_reset_target();
