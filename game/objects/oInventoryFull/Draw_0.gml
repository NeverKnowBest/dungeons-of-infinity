if(oLink.State == LinkState.TreasureOpening) exit;

draw_sprite_stretched(sWindow_InventoryFull, 0, X, Y, W, H);
draw_set_font(global.Font_Small);
draw_set_halign(fa_center);
draw_set_color(#FFFFFF);

if(MaxedOut){
	draw_text(oLink.x, Y + 4, "MAXED");
	draw_text(oLink.x, Y + 11, "OUT");
}else{
	
	draw_text(oLink.x, Y + 4, "INVENTORY");
	draw_text(oLink.x, Y + 11, "FULL");
}

if(CanConsume){
	draw_text(oLink.x + 1, Y + 20, "CONSUME?");
}else if(CanPickup){
	draw_text(oLink.x + 1, Y + 20, "PICKUP?");
}
	
draw_set_halign(fa_left);
