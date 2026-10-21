//event_inherited();

if(DB_Init){
	
	if(Dialogue != ""){
		global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);
		global.DB_Inst.Script = DB_Script;
		global.DB_Inst.CenterText = true;
		DB_Started = true;
	}
	DB_Init = false;	

}

if(DB_Started){

	if(!instance_exists(global.DB_Inst)){
		
		DB_Started = false;
		
	}
}