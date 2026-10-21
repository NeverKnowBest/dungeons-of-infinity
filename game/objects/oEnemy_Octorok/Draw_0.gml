Enemy_DrawShadow();

Enemy_PixelRender();

draw_self();

switch(Dir){
	case LEFT: draw_sprite(Sprite_Mouth_Left, MouthFrame, x - 9, y - 7); break;
	case RIGHT: draw_sprite(Sprite_Mouth_Right, MouthFrame, x, y - 7); break;
	case DOWN: draw_sprite(Sprite_Mouth_Down, MouthFrame, x - 4, y - 4); break;	
}

shader_reset();	

//var _y = y;
//draw_text(x, _y, "St:" + string(State)); _y += 8;
//draw_text(x, _y, "SC:" + string(ShotCount));