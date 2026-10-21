draw_sprite_stretched(sMenu, 0, x, y, sprite_width, sprite_height);

draw_set_font(oMenu.TitleFont);


var _y = y + 16

for(var i = 0; i < MenuCount[Menu_Index]; i++){
	
	var _x = x + 32;
	
	switch(Menu_Index){
		case MenuID.NameSelect:
			if(i < UserCount){
				draw_text(_x, _y, string(i + 1) + ".  ");
				_x += 12;
			}else _y+=8
			break;
	
		case MenuID.NewGame:
			
			break;
	}
	
	draw_text(_x, _y, Menu[Menu_Index][i]);
	_y += 16;
	
}
		


draw_sprite(sMenu_Selector, oMenu.Selector_Frame, Selector_X, Selector_Y);