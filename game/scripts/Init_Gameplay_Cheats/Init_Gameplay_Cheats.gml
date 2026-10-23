// Every cheat available in the cheats menu. Adding an entry here adds it to both the menu and to user saves.
// Entries with a Group go on a sub-page named after it, linked under the ungrouped cheats in the order groups first appear here.
global.CheatList = [
	{ Key: "Cheat_Inf_Health",	Label: "Inf. HP" },
	{ Key: "Cheat_Inf_Magic",		Label: "Inf. Magic" },
	{ Key: "Cheat_Inf_Rupees",	Label: "Inf. Rupees" },
	{ Key: "Cheat_Inf_Arrows",	Label: "Inf. Arrows" },
	{ Key: "Cheat_Inf_Keys",		Label: "Inf. Keys" },
	{ Key: "Cheat_Inf_Bombs",	Label: "Inf. Bombs" },
	{ Key: "Cheat_Max_Tunic",	Label: "Max Tunic" },
	{ Key: "Cheat_Max_Sword",	Label: "Max Sword" },
	{ Key: "Cheat_Max_Glove",	Label: "Max Glove" },
	{ Key: "Cheat_Equipment_PendOfHealth",	Label: "Pendant of Health", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfMagic",	Label: "Pendant of Magic", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfProtection",	Label: "Pendant of Protection", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfRevival",	Label: "Pendant of Revival", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfDirection",	Label: "Pendant of Direction", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfSecrets",	Label: "Pendant of Secrets", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfImmunity",	Label: "Pendant of Immunity", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendOfWealth",	Label: "Pendant of Wealth", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_MoonPearl",	Label: "Moon Pearl", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_MasterKey",	Label: "Master Key", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_Quiver",	Label: "Quiver", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_OilLamp",	Label: "Oil Lamp", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_FoodBag",	Label: "Food Bag", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_BombBag",	Label: "Bomb Bag", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_PendantBag",	Label: "Pendant Bag", Group: "Equipment Codes" },
	{ Key: "Cheat_Equipment_TreasureBag",	Label: "Treasure Bag", Group: "Equipment Codes" },
];

function Init_Gameplay_Cheats(){
	/// Cheats initialization
	
	// Inf. Health
	if (global.Users[global.UserIndex].Cheats.Inf_Health){
		global.Inventory.ItemData[ItemClass.HeartPiece].Amount = 16;
		LinkHealth = global.Inventory.ItemData[ItemClass.HeartPiece].Amount;
	}
	
	// Inf. Magic
	if (global.Users[global.UserIndex].Cheats.Inf_Magic){
		global.Inventory.ItemData[ItemClass.Magic].Amount = MAGICAMOUNT_MAX;
	}
	
	// Inf. Rupees
	if (global.Users[global.UserIndex].Cheats.Inf_Rupees){
		global.Inventory.ItemData[ItemClass.Rupee].Amount = 9999;
	}
	
	// Inf. Keys
	if (global.Users[global.UserIndex].Cheats.Inf_Keys){
		global.Inventory.ItemData[ItemClass.Key].Amount = 9;
	}
	
	// Inf. Arrows
	if (global.Users[global.UserIndex].Cheats.Inf_Arrows){
		global.Inventory.ItemData[ItemClass.ArrowQuiver].Owns[0] = true;
		global.Inventory.ItemData[ItemClass.Arrows].Amount = MaxArrowsQuiver;
	}
}

// Adds any cheats missing from a user (older saves, or newly added cheats), defaulting to off
function Init_Cheats_Struct(_User) {
	if(!variable_struct_exists(_User, "Cheats")) variable_struct_set(_User, "Cheats", {});
	var _CheatsStruct = _User.Cheats;
	
	for(var i = 0; i < array_length(global.CheatList); i++){
		var _Key = global.CheatList[i].Key;
		if(!variable_struct_exists(_CheatsStruct, _Key)) variable_struct_set(_CheatsStruct, _Key, false);
	}
}
