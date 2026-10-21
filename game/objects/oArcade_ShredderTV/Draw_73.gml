if(State != ArcadeState.UnUsed){
	
	//First copy the game surface on the arcade VP, then switch surface to arcade VP to draw anything that's an over-lay.
	
	surface_copy_part(global.ArcadeVP_Surface, 0, 0, GameSurface, 0, 0, CamW, CamH);

	surface_set_target(global.ArcadeVP_Surface);
	
	draw_sprite(sShredderTV_Face, AnimationFrame_Face, 50, 48);
	draw_sprite(sShredderTV_Mask, AnimationFrame_Mask, 48, 53 + AnimationFrame_Mask);
	
	if(AnimationIndex >= 4){
		draw_sprite(sShredderTV_Hand, 0, (AnimationIndex >= 8 ? -4 : 0), 80);
		
	}
	surface_reset_target();
	

	
}

