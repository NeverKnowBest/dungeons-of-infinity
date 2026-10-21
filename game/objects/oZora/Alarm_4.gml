	
var _ItemInst = ItemSpawn(PrizeClass, x, y, ItemFrom.Zora, ItemSpawnType.DropZora, FloorLevel, false);
with(_ItemInst){
	switch(global.ItemData[other.PrizeClass].Type){
		case ItemType.Inv_Bool:
		case ItemType.Pickup:
		case ItemType.Inv_Stk:
		case ItemType.Inv_NoStk:
		case ItemType.Inv_Chrg:
			Amount = other.GemPrize.Amount;
			var _Index = other.PrizeIndex;
			if(other.PrizeClass == ItemClass.Rupee) _Index = Rupee_GetIndex(Amount);
			Item_SetIndex(_Index);
			Setup = false;
			break;
	}

	layer = layer_get_id("Objs_" + GetFloorLevelString(other.FloorLevel));
}

image_index = 2;
audio_play_sound(Sound_Boss_Hit, 1, false);

alarm[5] = 40;