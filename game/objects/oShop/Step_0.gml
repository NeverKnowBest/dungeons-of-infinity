
if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;
	DB_Init = false;
	DB_Started = true;

}

if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		switch(global.DB_ExitCode){

			case 1:
				
				oHUD.AddRupees -= oLink.ShopItemLook.Price_Modified;

				if(Inventory_ItemIsEquiped){
					if(Inventory_EquipedItem.ItemClass == ItemClass.Coupon){
						if(oLink.ShopItemLook.Price_CouponApplied){
							Inventory_EquipedItem.Amount--;
							if(Inventory_EquipedItem.Amount <= 0) Inventory_DeleteSlot(Inventory_EquipedSlot);
							Inventory_Update();	
						}
					}
				}
				
				if(oLink.ShopItemLook.object_index == oItem_Treasure){
					HoldUpItem(oLink.ShopItemLook, oLink.ShopItemLook.From, false);
					Treasure_Open(oLink.ShopItemLook);
				}else{
					HoldUpItem(oLink.ShopItemLook,oLink.ShopItemLook.From);					
				}
				//SoldItem = oLink.ShopItemLook.object_index;
				
				global.Paused = true;
				
				ItemsSold++;

				break;

		}
		
		DB_Started = false;
	}
}


