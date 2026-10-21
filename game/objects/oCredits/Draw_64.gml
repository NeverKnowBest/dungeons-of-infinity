if(!surface_exists(TextSurface)) TextSurface = surface_create(TextSurfaceW, floor(TextSurfaceH));

draw_set_halign(fa_center);

//draw_set_color(#FFFFFF);
draw_set_font(global.Font_Blue);

surface_set_target(TextSurface);
draw_clear_alpha(c_black, 0.0);

draw_set_alpha(Alpha);

for(var i = 0; i < TextArrayLen; i++){
	var _Y = TextY + (i * 64);
	draw_text_transformed(TextX, _Y, TextArray[i], 4, 4, 0);		
}

surface_reset_target();
	
draw_surface(TextSurface, TextSurfaceX, TextSurfaceY);

draw_set_alpha(1);
draw_set_halign(fa_left);