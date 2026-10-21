Enemy_DrawShadow();

Enemy_PixelRender(true, sEnemy_Goriya_Pal, Type);

draw_self();

if(Type == 1 && OpenMouth){

	switch(Dir){
		case LEFT:
			draw_sprite(sEnemy_Goriya_Mouth, 0, x - 6, y - 14);
			break;
		case RIGHT:
			draw_sprite(sEnemy_Goriya_Mouth, 1, x + 6, y - 14);
			break;
		case DOWN:
			draw_sprite(sEnemy_Goriya_Mouth, 2, x, y - 15);
			break;
	}

}

shader_reset();

//draw_rectangle(global.SightX1, global.SightY1, global.SightX2, global.SightY2, true);