
Enemy_PixelRender();

draw_sprite(sEnemy_Moldorm_Tail, 0, TailX, TailY);
draw_sprite(sEnemy_Moldorm_Body, 0, BodyX, BodyY);

draw_self();

draw_sprite(sEnemy_Moldorm_Eye, 0, x + lengthdir_x(5, Dir + 30), y + lengthdir_y(5, Dir + 30))
draw_sprite(sEnemy_Moldorm_Eye, 0, x + lengthdir_x(5, Dir - 30), y + lengthdir_y(5, Dir - 30))

shader_reset();	


