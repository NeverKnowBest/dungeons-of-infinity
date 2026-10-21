if(DB_Init){
	
	if(Dialogue != ""){
		global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);
		global.DB_Inst.Script = DB_Script;
		DB_Started = true;
	}
	DB_Init = false;	

}

if(DB_Started){

	if(!instance_exists(global.DB_Inst)){
		
		DB_Started = false;

	}
	

}

Dir = y <= oLink.y + 6 && distance_to_object(oLink) < 48 ? DirFaceLink() : DOWN;
NPC_UpdateDir();





