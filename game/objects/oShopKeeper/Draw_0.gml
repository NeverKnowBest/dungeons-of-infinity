PixelRender_Dim(true, true, false, noone, 0, false, []);

draw_self();

if(ShopType == ShopTypes.Various && SoldOut){
	draw_sprite(sShadow_Sign, 0, x, SignY)
	draw_sprite(sSoldOut, 0, x, SignY);
}

shader_reset();
