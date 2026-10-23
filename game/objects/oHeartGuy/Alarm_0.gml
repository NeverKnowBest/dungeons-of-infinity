switch(Type){
	case 1: //Hearts
		var _InvHealth = global.Inventory.ItemData[ItemClass.Heart];
		var RemoveHealth = _InvHealth.Amount * 0.75;
		HealthAdd(-RemoveHealth);
		break;
	case 2: //Magic
		if(!Cheat_On("Cheat_Inf_Magic")) global.Inventory.ItemData[ItemClass.Magic].Amount = 0;
		break;
	
}


ItemSpawn(ItemClass.Rupee, x, y - 2 - z, ItemFrom.Treasure, ItemSpawnType.Float, FloorLevel);
audio_play_sound(Sound_ItemGetFanfare, 1, false);
instance_destroy(id);