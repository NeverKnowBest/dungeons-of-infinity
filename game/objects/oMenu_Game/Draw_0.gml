
draw_set_alpha(Alpha / 2.2);
draw_set_color(#000000);
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);

draw_set_alpha(Alpha);
draw_set_color(#FFFFFF);

draw_sprite_stretched(sprite_index, 0, FrameX, FrameY, FrameW, FrameH);



for(var i = 0; i < MenuItems[Index]; i++){
	
	draw_set_font(global.MenuFont_Innactive);
	
	var Text = MenuText[Index][i];
	
	var TextW = string_width(Text);
	var TextH = string_height(Text);
	
	switch(Index){
		case MenuSelection_GameMenuID.Main:
	
			draw_set_halign(fa_center);
			var TextPosX = FrameCentre;
			var TextPosY = FrameY + 24 + (i * 20);
			var SelectorX = FrameCentre - (TextW / 2) - 2;
			
			break;
	
		case MenuSelection_GameMenuID.Options:

			draw_set_halign(fa_left);
			var TextPosX = FrameX + 20;	
			var TextPosY = FrameY + 18 + (i * 18);
			var SelectorX = FrameX + 18;

			break;
		
		case MenuSelection_GameMenuID.Quit:
			draw_set_halign(fa_center);
			var TextPosX = FrameCentre;
			var TextPosY = FrameY + 48 + (i * 20);
			var SelectorX = FrameCentre - (TextW / 2) - 2;			
			break;
	}

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

	if(Index == MenuSelection_GameMenuID.Quit){
		draw_set_font(global.MenuFont);
		switch(QuitTo){
			case 0:
				draw_text(TextPosX, FrameY + 24, "New Game?");
				break;
				
			case 1:
				draw_text(TextPosX, FrameY + 24, "Quit to Title?");
				break;
				
			case 2:
				draw_text(TextPosX, FrameY + 24, "Quit to Desktop?");
				break;
		}
		
	}
	
	draw_set_halign(fa_left);

	if(Index == MenuSelection_GameMenuID.Options && i > 0){
		
		var _Pref = global.Users[global.UserIndex].Prefs[i - 1];
		if(!_Pref){
			draw_set_font(global.MenuFont_Innactive);
			draw_set_color(#404040);
		}
		
		draw_text(FrameCentre + 28, TextPosY, _Pref ? "On" : "Off");
	
	}
	
	draw_set_color(#FFFFFF);
	
}

draw_set_font(global.Font_Small);
draw_set_halign(fa_center);
draw_set_color(#AAAAAA);
draw_text(FrameCentre, PlayTimeY, "PLAYING TIME");
draw_text(FrameCentre, PlayTimeY + 8, TimePlayed);
draw_set_halign(fa_left);

draw_set_color(#FFFFFF);

draw_set_alpha(1);