

if(ShowRed){
	draw_set_color(#C60000);
	draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
}

if(!FadeToGame){
	draw_set_color(c_black);
	draw_set_alpha(FadeToBlack_Alpha);
	draw_rectangle(oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2, false);
	draw_set_alpha(1);
}
	
	
if(ShowMenu){
	draw_set_font(global.Font_Blue);
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	
	var MenuX = oCamera.X + 92;
	var MenuY = oCamera.Y + 128;
	var Selector_X = MenuX - 20;
	Selector_Y[0] = MenuY;
	Selector_Y[1] = MenuY + 16;
	Selector_Y[2] = MenuY + 32;
	for(var i = 0; i < array_length(MenuText); i++){
		draw_text(oCamera.X + 92, oCamera.Y + 128 + (i * 16), MenuText[i]);
	}
	
	draw_sprite(sMenu_Selector_Active, Selector_Frame, Selector_X, Selector_Y[Selector_Index]);
	
}else{
	var _TunicIndex = max(global.Inventory.ItemData[ItemClass.Tunic].Index, 0);
	if(ReviveLink){
		PixelRender(false, false, oLink.PaletteSpr != noone, oLink.PaletteSpr, _TunicIndex, true, oLink.StarColors[oLink.StarColorIndex]);
		draw_sprite(oLink.sprite_index, oLink.image_index, oLink.x, oLink.y);
		shader_reset();
	}else{
		if(!FadeToGame){
			PixelRender(false, false, oLink.PaletteSpr != noone, oLink.PaletteSpr, _TunicIndex, false, 0);
			draw_sprite(oLink.sprite_index, oLink.image_index, oLink.x, oLink.y);
			shader_reset();
		}
	}
}

if(PendantAni){
	draw_sprite(sItem_Pendant, Pendant.Revival, oLink.x + 4, PendantAni_Y)	
}

if(FadeToWhite || FadeToGame){
	draw_set_color(c_white);
	draw_set_alpha(FadeToWhite_Alpha);
	draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W, oCamera.Y + CAM_H, false);
	draw_set_alpha(1);
}