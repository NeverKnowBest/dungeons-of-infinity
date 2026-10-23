function New_Game_Cheats_Init(){
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
}