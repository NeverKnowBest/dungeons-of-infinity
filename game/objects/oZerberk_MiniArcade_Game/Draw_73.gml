surface_set_target(GameSurface);

draw_set_halign(fa_center);
draw_set_color(c_white);

switch(State){
	
	case MiniArcadeState.Title:
		draw_set_color(#1010FF);
		draw_set_font(global.ArcadeFont2);
		draw_text_ext(GameCentre, 22, "SPORK INVADERS", 20, string_width("INVADERS"));		

		draw_set_font(global.ArcadeFont);
		draw_set_color(c_white);
		draw_text(GameCentre, 66, "HI-SCORE: " + string(Hiscore));
		draw_text(GameCentre, 84, "PRESS START");

		break;
	
	case MiniArcadeState.Start:
		if(ShowLevel){
			draw_set_font(global.ArcadeFont2);
			draw_text(GameCentre, 45, "LEVEL " + string(Level + 1));		
		}	
		break;
	
	case MiniArcadeState.GameOver:
		draw_set_font(global.ArcadeFont2);
		draw_text(GameCentre, 45, "GAME OVER");	
		draw_set_font(global.ArcadeFont);
		draw_text(GameCentre, 66, "HI-SCORE: " +  string(Hiscore));
		break;
	
	
}


draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_font(global.ArcadeFont);
draw_text(4, 4, string(Score));


surface_reset_target();

surface_copy(global.ArcadeVP_Surface, ScreenX + BorderW, ScreenY + BorderW, GameSurface);

