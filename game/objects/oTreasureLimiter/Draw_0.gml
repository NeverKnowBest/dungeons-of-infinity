if(!visible) exit

draw_set_color(c_dkgrey);
draw_set_alpha(0.7);
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + 80, oCamera.Y + 240, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(global.Font_Small);
var _y = DrawY;
draw_set_halign(fa_left);

for(var _ItemIndex = 0; _ItemIndex < ItemClasses; _ItemIndex++){

	switch(_ItemIndex){
		case ItemClass.Book:
		case ItemClass.Cane:
		case ItemClass.Crystal:
		case ItemClass.Fairy:
		case ItemClass.Heart:
		case ItemClass.Key:
		case ItemClass.Letter:
		case ItemClass.Magic:
		case ItemClass.MasterKey:
		case ItemClass.Medallion:
		case ItemClass.Mirror:
		case ItemClass.MoonPearl:
		case ItemClass.Mushroom:
		case ItemClass.Powder:
		case ItemClass.SpecialKey:
		case ItemClass.Star:
		case ItemClass.Stopwatch:
		case ItemClass.Treasure:
		case ItemClass.WishStone:
			continue;
	}
	
	var _ItemName = string_delete(string_upper(object_get_name(ObjIndexFromItemClass(_ItemIndex))), 1, 6);
	//var _ItemName = string_delete(string_upper(object_get_name(ObjIndexFromItemClass(ItemClass.Sword))), 1, 6);
	draw_text(DrawX, _y, _ItemName + ": " + string(global.ItemData[_ItemIndex].LimitCount));
	_y+=6;
		
}
	
