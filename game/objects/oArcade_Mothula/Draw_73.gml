


if(State == ArcadeState.UnUsed) exit;
	
	
//First copy the game surface on the arcade VP, then switch surface to arcade VP to draw anything that's an over-lay.
	
surface_copy_part(global.ArcadeVP_Surface, 0, 0, GameSurface, 0, 0, CamW, CamH);
	
	
surface_set_target(global.ArcadeVP_Surface);
	
draw_set_font(global.ArcadeFont);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);


	

//if(CurrentHand > PokerHand.Nothing){
//	//current hand odds highlight
//	draw_set_halign(fa_left);
//	var YPos = 51 - ((CurrentHand - 1) * 6);
//	draw_rectangle(5, YPos, 68, YPos + 6, false);
//}
	
//draw_set_color(c_white);
	
//draw_set_halign(fa_right);
//draw_set_font(global.Font_Small);
//for(var Mul = 0; Mul < 5; Mul++){
//	for(var i = 0; i < 9; i++){
//		draw_text(91 + (Mul * 26), 4 + (i * 6), string(WinMul[9 - i] * (Mul + 1)));
//	}
//}
//draw_set_halign(fa_left);
//for(var i = 0; i < 9; i++){
//	draw_text(6, 4 + (i * 6), string_upper(Poker_HandString(9 - i)));
//}	
			

draw_set_font(global.ArcadeFont);
draw_set_halign(fa_left);
draw_text(5, CamH - 13, "BALANCE:" + string(global.Inventory.ItemData[ItemClass.Rupee].Amount));
			
var Button1X = 132;
var ButtonsY = 135;
draw_sprite(sPoker_Button_Bet, 0, Button1X, ButtonsY);
draw_set_font(global.Font_Small);
draw_set_color(c_black);
draw_text(Button1X + 19, ButtonsY + 3, string(Bet + 1));
draw_set_color(c_white);
	
var Button2X = 162;
draw_sprite(sPoker_Button_Spin, 0, Button2X, ButtonsY);
	
			
switch(State){
	
	case ArcadeState.UnUsed:
		break;

	case ArcadeState.Reset:
		break;
		
	case ArcadeState.AttractScreen:

		draw_set_font(global.ArcadeFont2);
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(CamW_2, 36, "MOTHULA'S MONEY");		
			
		break;
	
	case ArcadeState.GameStartInit:
		
		break;
		
	case ArcadeState.GameStarted:

		switch(GameState){
			case SlotState.Spin:
				draw_set_font(global.ArcadeFont);		
				draw_set_halign(fa_center);
				draw_text(CamW_2, 40, "GOOD LUCK");
				break;
				
		}
		
		break;
		
	case ArcadeState.GameOver:
		if(GameState == SlotState.Win){
			draw_set_font(global.ArcadeFont);		
			draw_set_halign(fa_center);
			draw_text(CamW_2, 40, WinAmount > 0 ? "YOU WIN " + string(WinAmount) + "!" : "GAME OVER");
		}
		break;	
	

}

//Reels
for(var i = 0; i < 3; i++){
	
	draw_sprite_part(global.MothulaSlot_ReelSprite, 0, 0, ReelPos[i], 48, 64, ReelPosX_Symbols[i], ReelPosY_Symbols);
	
	var _2ndReelOffset = ReelPos[i] - global.MothulaSlot_ReelH + 64;
	
	if(_2ndReelOffset > 0){
		draw_sprite_part(global.MothulaSlot_ReelSprite, 0, 0, 0, 48, _2ndReelOffset, ReelPosX_Symbols[i], ReelPosY_Symbols + 64 - _2ndReelOffset);
	}
	
}

//Reel shading
draw_sprite_stretched(sArcade_Mothula_ReelShading, 0, ReelPosX_Symbols[0], ReelPosY_Symbols, 48, 12);
draw_sprite_stretched(sArcade_Mothula_ReelShading, 0, ReelPosX_Symbols[1], ReelPosY_Symbols, 48, 12);
draw_sprite_stretched(sArcade_Mothula_ReelShading, 0, ReelPosX_Symbols[2], ReelPosY_Symbols, 48, 12);

draw_sprite_stretched(sArcade_Mothula_ReelShading_Flipped, 0, ReelPosX_Symbols[0], 112, 48, 12);
draw_sprite_stretched(sArcade_Mothula_ReelShading_Flipped, 0, ReelPosX_Symbols[1], 112, 48, 12);
draw_sprite_stretched(sArcade_Mothula_ReelShading_Flipped, 0, ReelPosX_Symbols[2], 112, 48, 12);

surface_reset_target();


