


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
		draw_text(CamW_2, CamW_3, "PITFALL");
		
		draw_set_font(global.ArcadeFont);
		draw_text(CamW_2, CamH_2 + 5, "HI-SCORE");
		draw_text(CamW_2, CamH_2 + 15, string(Hiscore));
			
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

		for(var LifeIndex = 0; LifeIndex < Harry.Lives - 1; LifeIndex++){
			draw_sprite(sPitfall_Life, 0, 8 + (LifeIndex * 8), 4)	
		}
		
		var NewHighScore = (Score > Hiscore ? "!" : "");
		draw_text(CamW_2, 4, NewHighScore + ScoreText(Score, 6) + NewHighScore); 
		
		break;
		
	case ArcadeState.GameOver:

		draw_text(CamW_2, CamH_3 + 13, "GAME OVER");
		
		if(ShowNewHiscore){
			draw_text(CamW_2, CamH_2 + 5, "NEW HI-SCORE");
			draw_text(CamW_2, CamH_2 + 15, string(Hiscore));
		}
		
		break;	
	

}

surface_reset_target();
	

