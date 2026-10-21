Enemy_PixelRender(,,,State != EnemyState.Walking);

for(var i = 0; i < 4; i++){
	var _x = lengthdir_x(5, BubbleAngle[i]);
	var _y = lengthdir_y(5, BubbleAngle[i]);
	draw_sprite(sprite_index, 1, x + _x, y + _y);
}


draw_sprite(sprite_index, 0, x, y);

shader_reset();

//draw_text(x, y, string(LightIndex));
