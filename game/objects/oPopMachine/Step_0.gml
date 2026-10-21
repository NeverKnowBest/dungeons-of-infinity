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
			
			var _Inst = instance_create_layer(x, y, "ObjsHigher_Upper", oItem_Pop);

			HoldUpItem(_Inst);

			oHUD.AddRupees = -PopMachineCost;
			
			Cans--;
			
		}
		DB_Started = false;
	}
}