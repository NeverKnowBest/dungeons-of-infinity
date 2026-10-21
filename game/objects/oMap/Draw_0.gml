draw_set_alpha(Alpha / 2.2);
draw_set_color(c_black)
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);

draw_set_alpha(Alpha);
draw_set_color(c_white);

draw_sprite_stretched(sprite_index, 0, FrameX, FrameY, 204, 204);	


if(global.MapHidden){
	draw_set_alpha(1);
	exit;
}

draw_sprite_ext(MapSprite, 0, MapX, MapY, 0.75, 0.75, 0, c_white, Alpha);	

draw_sprite_ext(LinkSprite, 0, MapX, MapY, 0.75, 0.75, 0, c_white, abs(dsin(LinkAlpha)) * Alpha);

draw_set_alpha(1);
