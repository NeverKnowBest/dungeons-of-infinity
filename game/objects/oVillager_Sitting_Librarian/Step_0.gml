event_inherited();

if(DB_Init_GrandChild){
	
	//if(ResponseIndex == -1){
	//	ResponseIndex = global.ItemData[oItem_Mushroom].Owns[0] ? 0 : -1;
	//}
	
	DB_Init_GrandChild = false;
	
	DB_Started_GrandChild = true;
	
	exit;
	
}


if(DB_Started_GrandChild){
	
	if(!instance_exists(global.DB_Inst)){
		
		DB_Started_GrandChild = false;
		
		switch(ResponseIndex){
			case -1:
				if(global.DB_ExitCode == 1){
					NPC_SetResponse(0);
				}else{
					NPC_SetResponse(1);					
				}					
				break;
			case 0:
				global.Paused = true;
				with(oLink){					
					var inst = instance_create_layer(x, y, "ObjsHigher_Upper", other.ItemHolding);
					HoldUpItem(inst);
				}
				ItemHolding = noone;
				ResponseIndex = 2;
				break;
			
			case 1:
				ResponseIndex = -1;
				break;

			
		}
		
	}
	

}



