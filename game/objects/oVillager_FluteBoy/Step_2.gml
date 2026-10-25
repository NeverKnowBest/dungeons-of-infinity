// Feather disable GM2064
event_inherited();

// once his line is over, open the wardrobe
if(DB_Started){
	DB_Started = false;
	OpenWardrobe = true;
}

if(OpenWardrobe && !instance_exists(global.DB_Inst) && !instance_exists(oMenu_Game)){
	OpenWardrobe = false;
	with(oLink) UpdateState(LinkState.Inventory);
	global.MenuInst = instance_create_layer(0, 0, "System", oMenu_Game, { Mode: "Wardrobe" });
	DB_Delay = true;
	alarm[0] = 30;
}
