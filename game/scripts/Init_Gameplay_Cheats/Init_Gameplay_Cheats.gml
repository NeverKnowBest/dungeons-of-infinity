function Init_Gameplay_Cheats(){
	/// Cheats initialization
	
	// Inf. Health
	global.Inventory.ItemData[ItemClass.HeartPiece].Amount = 16;
	LinkHealth = global.Inventory.ItemData[ItemClass.HeartPiece].Amount;
	
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

function Init_Cheats_Struct() {
	var _CheatsStruct = global.Users[global.UserIndex].Cheats;
	
	if(!variable_struct_exists(_CheatsStruct, "Inf_Health")) variable_struct_set(_CheatsStruct, "Inf_Health", false);
	if(!variable_struct_exists(_CheatsStruct, "Inf_Magic")) variable_struct_set(_CheatsStruct, "Inf_Magic", false);
	if(!variable_struct_exists(_CheatsStruct, "Inf_Rupees")) variable_struct_set(_CheatsStruct, "Inf_Rupees", false);
	if(!variable_struct_exists(_CheatsStruct, "Inf_Keys")) variable_struct_set(_CheatsStruct, "Inf_Keys", false);
	if(!variable_struct_exists(_CheatsStruct, "Inf_Arrows")) variable_struct_set(_CheatsStruct, "Inf_Arrows", false);
}