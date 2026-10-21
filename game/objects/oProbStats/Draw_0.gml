if(!visible) exit

draw_set_color(c_dkgrey);
draw_set_alpha(0.7);
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + 100, oCamera.Y + 240, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(global.Font_Small);
var _y = DrawY;


for(var i = 0; i < ItemClasses; i++){
	
	var _ObjIndex = ObjIndexFromItemClass(i);
	var _ObjName = string_delete(string_upper(object_get_name(_ObjIndex)), 1, 6);

	if(Counts[i] > 0){
		
		draw_set_halign(fa_left);
		draw_text(DrawX, _y, _ObjName + ": " + string(Counts[i]));
		
		draw_set_halign(fa_right);
		var _Percentage = string(Percents[i]);
		draw_text(DrawX + 90, _y, _Percentage);
		_y+=6;
	}
	
}

draw_set_halign(fa_center);

if(Total > 0){
	_y += 12;
	draw_text(DrawX + 46, _y + 6, "TOTAL: " + string(Total));
}


draw_set_halign(fa_left);