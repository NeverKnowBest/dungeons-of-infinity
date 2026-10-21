surface_set_target(oZerberk_MiniArcade_Game.GameSurface);

if(oZerberk_MiniArcade_Game.State == MiniArcadeState.GameOver)
	draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), 1, 1, 0, #606060, 1);
else
	draw_self();

surface_reset_target();