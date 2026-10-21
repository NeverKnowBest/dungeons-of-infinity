if(Alpha < 1){
	//used just for the intro scene
	draw_set_alpha(Alpha);

	if(ShowShadow) draw_sprite(ShadowSpr, 0, x + ShadowOffsetX, y_base + ShadowOffsetY);

	var _y = floor(y);
	draw_sprite(sprite_index, image_index, x, _y);

	if(ShowAmount && Amount > 1){	
		draw_set_font(global.Font_ItemValues);
		draw_set_halign(fa_left);
		draw_text(x + AmountOffsetX, _y - 6, string(Amount));
	}

	draw_set_alpha(1);
}else{
	event_inherited();
}

