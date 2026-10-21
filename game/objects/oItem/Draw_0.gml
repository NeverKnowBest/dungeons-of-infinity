

if(Alpha == 1) PixelRender_Dim(Lighting, Lighting, Palette, PaletteSpr, Index, false, []);

draw_set_alpha(Alpha);

if(ShowShadow) draw_sprite(ShadowSpr, 0, x + ShadowOffsetX, y_base + ShadowOffsetY);

var _y = floor(y);

draw_sprite(sprite_index, image_index, x, _y);


Obj_DrawInWater(false);

		
if( (ShowAmount && Amount > 1) || global.ItemData[Class].Type == ItemType.Inv_Chrg){	
	draw_set_font(global.Font_ItemValues);
	draw_set_halign(fa_left);
	draw_text(x + AmountOffsetX, _y - 6, string(Amount));
}


if(ShowPrice && Price > 1){	

	draw_set_font(global.FontNumbers);
	draw_set_halign(fa_center);
	draw_set_color(Price_Color);
	
	draw_text(x, _y + 4, Price_Modified);		
	
	draw_set_color(c_white);
	draw_set_halign(fa_left);

}

draw_set_alpha(1);

if(Alpha == 1) shader_reset();

//draw_text(x, y, string(FloorLevel));
//draw_text(x, y + 16, string(From == ItemFrom.Shop));

