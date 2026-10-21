
draw_set_color(c_dkgrey);
draw_set_alpha(0.5);
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + 70, oCamera.Y + 200, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(global.Font_Small);

var _x = oCamera.X + 4;
var _y = oCamera.Y + 4;

var GridH = ds_grid_height(global.NonDuplicatableItemsThatExist);

draw_text(_x, _y, "ITEMS:");
_y+=6;
for(var i = 0; i < GridH; i++){
	var _ItemClass = global.NonDuplicatableItemsThatExist[# 0, i];
	var _ItemIndex = global.NonDuplicatableItemsThatExist[# 1, i];
	draw_text(_x, _y, string_upper(Item_Name(_ItemClass, _ItemIndex)));
	_y+=6;
}
_y+=6;



