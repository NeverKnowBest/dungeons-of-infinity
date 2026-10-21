//draw_set_alpha(Alpha / 2.2);
//draw_set_color(#000000);
//draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);

draw_set_alpha(Alpha);
draw_set_color(#FFFFFF);

draw_sprite_stretched(sprite_index, 0, FrameX, FrameY, FrameW, FrameH);

draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_font(global.MenuFont);
draw_text(FrameCentre, FrameY + 16, "Game Saved!");

for(var i = 0; i < MenuItems; i++){
	
	draw_set_font(global.MenuFont_Innactive);
	
	var Text = MenuText[i];
	
	var TextW = string_width(Text);
	var TextH = string_height(Text);

	draw_set_halign(fa_center);
	var TextPosX = FrameCentre;
	var TextPosY = FrameY + 46 + (i * 20);
	var SelectorX = FrameCentre - (TextW / 2) - 2;

	if(i == SelectorPos){
		draw_set_color(#284028);
		draw_set_font(global.MenuFont);
		var SelectorY = TextPosY - 2;
		var SelectorX2 = SelectorX + TextW + 3;
		var SelectorY2 = SelectorY + TextH + 2;
		draw_rectangle(SelectorX, SelectorY, SelectorX2, SelectorY2, false)
	}
	
	draw_set_color(#FFFFFF);
	
	draw_text(TextPosX, TextPosY, Text);
	
	draw_set_halign(fa_left);
	
	draw_set_color(#FFFFFF);
	
}