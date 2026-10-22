if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;

	DB_Init = false;
	DB_Started = true;

}

var _FoodValue;
if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		if(global.DB_ExitCode == 1){

			//find cheapest food item to give
			var _FoodBagIndex = -1;
			var _FoodSlotIndex = -1;
			var _FoodMinValue = 100;

			for(var _BagIndex = 0; _BagIndex < Inventory_Bags; _BagIndex++){
		
				var _Bag =  global.Inventory.Bags[_BagIndex];
		
				if(!_Bag.Owns) continue;

				for(var _SlotIndex = 0; _SlotIndex < _Bag.SlotCount; _SlotIndex++){

					var _Slot = _Bag.Slots[_SlotIndex];
		
					if(_Slot.Locked || _Slot.Ignore) continue;
		
					var _ItemClass = _Slot.ItemClass;
					var _ItemIndex = _Slot.ItemIndex;
				
					switch(_ItemClass){
					
						case ItemClass.Food:
							switch(_ItemIndex){
								default:
									_FoodValue = FoodHearts(_ItemIndex);
									break;
								case Food.GoldenEgg:
									_FoodValue = 0; //make this the highest priority
									break;
							}
							break;
						
						case ItemClass.Pop:
							_FoodValue = PopHearts;
							break;
					
						case ItemClass.Potion:
							switch(_ItemIndex){
								case Potion.Milk:
									_FoodValue = MILKHEARTS;
									break;
							
								default:
									continue;
							}
							break;
						
						default:
							continue;
					}

					if(_FoodValue < _FoodMinValue){
						_FoodMinValue = _FoodValue;
						_FoodBagIndex = _BagIndex;
						_FoodSlotIndex = _SlotIndex;
					}
					
				}
						
			}	
			
			var _FoodSlot = global.Inventory.Bags[_FoodBagIndex].Slots[_FoodSlotIndex];
			
			if(_FoodSlot.ItemClass == ItemClass.Food && _FoodSlot.ItemIndex == Food.GoldenEgg){
				var _RupeeInst = ItemSpawn(ItemClass.Rupee, oLink.x, oLink.y - 16, ItemFrom.KinstoneGold, ItemSpawnType.Float, FloorLevel);
				with(_RupeeInst){
					Setup = false;
					Rupee_Init(500);	
				}				
			}else{
				ItemSpawn(ItemClass.Rupee, oLink.x, oLink.y - 16, ItemFrom.KinstoneGreen, ItemSpawnType.Float, FloorLevel);
			}
			
			audio_play_sound(Sound_ItemGetFanfare, 1, false);		

			with(oLink) UpdateState(LinkState.TreasureOpening);
			global.Paused = true;
			
			Inventory_Add(_FoodSlot.ItemClass, _FoodSlot.ItemIndex, -1, [_FoodBagIndex, _FoodSlotIndex]);	
			
			ReceivedFood = true;
			
		}
		DB_Started = false;
	}
}

