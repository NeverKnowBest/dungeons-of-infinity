event_inherited();

if(DB_Init_GrandChild){

	DB_Init_GrandChild = false;
	
	DB_Started_GrandChild = true;
	
	exit;
	
}


if(DB_Started_GrandChild){
	
	if(!instance_exists(global.DB_Inst)){
		
		DB_Started_GrandChild = false;
		
		switch(ResponseIndex){
			case -1:

				global.Paused = true;
				with(oLink){					
					var inst = instance_create_layer(x, y, "ObjsHigher_Upper", ObjIndexFromItemClass(other.ItemHolding));
					HoldUpItem(inst);
				}
				Inventory_DeleteItemClass(ItemClass.WishStone);
				ItemHolding = -1;
				ResponseIndex = 0;
				alarm[2] = 90;
				break
			
			case 0:
				ResponseIndex = 1;
				break;
			
		}
		

		
	}
	

}