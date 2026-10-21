if(DB_Started_GrandChild){

	if(!instance_exists(global.DB_Inst)){
		
		DB_Started_GrandChild = false;
		
		switch(ResponseIndex){
			case 0:
				if(global.DB_ExitCode == 1){
					NPC_SetResponse(2)
				}else{
					NPC_SetResponse(3)					
				}				
				break;
				
			case 2:
				global.Paused = true;
				Inventory_DeleteObj(oItem_Mushroom);
				with(oLink){					
					var inst = instance_create_layer(x, y, "ObjsHigher_Upper", other.ItemHolding);
					HoldUpItem(inst);
				}
				ItemHolding = noone;
				ResponseIndex = 1;
				break
				
			case 3:
				ResponseIndex = -1;
				break;
			
		}
		
	}
	

}