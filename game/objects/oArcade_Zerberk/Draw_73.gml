


if(State == ArcadeState.UnUsed) exit;
	
	
//First copy the game surface on the arcade VP, then switch surface to arcade VP to draw anything that's an over-lay.
	
surface_copy_part(global.ArcadeVP_Surface, 0, 0, GameSurface, CamX, 0, CamW, CamH);
	
	
surface_set_target(global.ArcadeVP_Surface);
	
draw_set_font(global.ArcadeFont);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_center);

switch(State){
	
	case ArcadeState.UnUsed:
		break;

	case ArcadeState.Reset:
		break;
		
	case ArcadeState.AttractScreen:
	

		draw_set_font(global.ArcadeFont2);
		draw_text(CamW_2, 56, "ZERBERK");
		
		draw_set_font(global.ArcadeFont);
		draw_text(CamW_2, 76, "HI-SCORE");
		draw_text(CamW_2, 86, string(Hiscore));
			
		draw_set_halign(fa_left);
		draw_text(3, CamH - 10, "CREDITS " + string(Credits));
			
		draw_set_halign(fa_right);
		if(CreditsFlash){
			if(Credits == 0)
				draw_text(CamW - 3, CamH - 10, "INSERT RUPEE");
			else
				draw_text(CamW - 3, CamH - 10, "PRESS START");
		}
			
		break;
	
	case ArcadeState.GameStartInit:
		
		break;
		
	case ArcadeState.GameStarted:
	case ArcadeState.Special:
		
		draw_set_font(global.ArcadeFont);
		draw_set_halign(fa_left);
		draw_text(3, CamH - 11, string(Score));		
		
		if(Lives > 0){
			var _LivesW = Lives * 7;
			draw_sprite_stretched(sZerberk_Lives, 0, CamW - 6 - _LivesW, CamH - 11, _LivesW, 8);
		}

		break;
		
	case ArcadeState.GameOver:

		draw_set_font(global.ArcadeFont2);
		draw_text(CamW_2, 56, "GAME OVER");
		
		draw_set_font(global.ArcadeFont);
		draw_text(CamW_2, 76, "HI-SCORE");
		draw_text(CamW_2, 86, string(Hiscore));

		draw_set_halign(fa_left);
		draw_text(3, CamH - 11, string(Score));	
		
		break;	
	
	
}

	
surface_reset_target();
	

