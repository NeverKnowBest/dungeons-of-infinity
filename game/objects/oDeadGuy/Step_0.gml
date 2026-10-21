if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;

	DB_Init = false;
	DB_Started = true;

}

if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		if(global.DB_ExitCode == 1){
			
			global.Paused = true;
			
			if(!global.Cursed && Prob(Chance_Curse_DeadGuy)){
				instance_create_layer(x, y - 18, "ObjsHighest", oCursed);		
			}else{
				
				if(ItemHolding == RandomItem){
					
					var inst = instance_create_layer(x, y, "ObjsHigher_Upper", ObjIndexFromItemClass(Probs_RandomItemClass(ItemFrom.Treasure)), {From : ItemFrom.Treasure});

					//If item is revival pendant, just set it as a large magic(a dead guy would have been revised if he had it)
					if(inst.object_index == oItem_Pendant && inst.Index == Pendant.Revival){
						instance_destroy(inst);
						var inst = instance_create_layer(x, y, "ObjsHigher_Upper", oItem_Magic_Large, {From : ItemFrom.Treasure});
					}
					
					if(Item_Valid(inst.Class, inst.Index)){				
				
						HoldUpItem(inst);		
					
					}else{
					
						instance_destroy(inst);
						ItemHolding = -1;
						
					}
					
				}
				
				if(ItemHolding == -1) MsgBox("Nothing was found.");
					
			}

			ItemHolding = -1;

		}
		DB_Started = false;
	}
}