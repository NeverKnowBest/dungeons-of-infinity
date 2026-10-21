draw_set_alpha(global.Inventory.Bags[InventoryBag.Main].Position / 2.2);
draw_set_color(c_black)
draw_rectangle(oCamera.X, oCamera.Y, oCamera.X + CAM_W - 1, oCamera.Y + CAM_H - 1, false);
draw_set_color(c_white);
draw_set_alpha(1);


Inventory_DrawBags();


draw_set_alpha(global.Inventory.Bags[InventoryBag.Main].Position);
draw_set_halign(fa_left);
draw_set_font(global.Font_Small);
draw_set_color(c_dkgrey);
draw_text(MenuX, MenuY, MenuStr);
draw_set_color(c_white);

if(MenuEnable){

	for(var i = 0; i < MenuItems; i++){
		if(MenuItemGrid[# 1, i]) draw_text(MenuX + MenuItemPos[i], MenuY, MenuItemGrid[# 0, i]);		
	}	
	
	draw_sprite_stretched(sInventory_Selection, 0, MenuX + MenuItemPos[MenuSelectionIndex] - 2, MenuY - 2, MenuItemW[MenuSelectionIndex] + 3, 9);
	
}


if(instance_exists(oDialogueBox) || DB_Init || DB_Started){
	draw_set_alpha(1);
	exit;
}

//Curse window
if(global.Cursed){
	
	var _CurseX = oCamera.X + global.Inventory.CurseBox_X;
	var _CurseY = oCamera.Y + global.Inventory.CurseBox_Y;
	
	var TextX = _CurseX + (DialogueBoxW_Curse / 2);
	
	draw_sprite_stretched(sHUD_Window_Curse, 0, _CurseX, _CurseY, DialogueBoxW_Curse, DialogueBoxH_Curse);

	draw_set_color(#E00000); //red
	draw_set_font(global.Font_Small);
	draw_set_halign(fa_center);
	draw_text(TextX, _CurseY + 12, "YOU ARE CURSED!");

	draw_set_color(c_white);
	draw_text(TextX, _CurseY + 24, "EFFECT: " + string_upper(string_replace(global.CurseEffectStr, "\\", " ")));
	draw_text(TextX, _CurseY + 34, "TASK: " + string_upper(string_replace(global.CurseTaskStr, "\\", " ")) + "  (" + string(global.CurseTaskCount) + " REMAINING)");

	draw_set_halign(fa_left);
	
}

//draw_text(oCamera.X, oCamera.Y, "Y:" + string(Y));
//draw_text(oCamera.X, oCamera.Y+10, "YDB:" + string(Y_DialogueBox));
//draw_text(oCamera.X, oCamera.Y+20, "DIF:" + string(Y_DialogueBox - Y));

draw_set_alpha(1);
