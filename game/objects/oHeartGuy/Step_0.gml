if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;

	DB_Init = false;
	DB_Started = true;

}

if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		if(global.DB_ExitCode == 1){
			Disappear = true;
			with(oLink) UpdateState(LinkState.TreasureOpening);
			global.Paused = true;
		}
		DB_Started = false;
	}
}


		
if(!Disappeared){
	FlyingFrame+=0.125
	z += (sin(FlyingFrame) * 0.4);
}

if(Disappear){
	instance_create_layer(x, y - z - 8, "ObjsHigher_Upper", oPoof);

	alarm[0] = 30;
	Disappear = false;
	Disappeared = true;
}
