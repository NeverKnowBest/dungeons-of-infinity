Enemy_DrawShadow();
	
Enemy_PixelRender(true, sEnemy_SnapDragon_Pal, Type);

draw_sprite_ext(sprite_index, image_index, x, y, Dir == LEFT || Dir == RIGHT ? -1 : 1, 1, 0, c_white, 1);

shader_reset();

Obj_DrawInWater();