// Feather disable GM2064

if(YesNo){
	
	DB_Script = ds_grid_create(4, 3); var i = 0; 
	var	Addr=0;	DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo	DB_Script[# ++i, Addr] = Msg;	DB_Script[# ++i, Addr] = 2; DB_Script[# ++i, Addr] = 1; i = 0;
		Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;
		Addr=2;	DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0;

		global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox, {Method : Method, Y : Y, CenterText : CenterText});
		
		global.DB_Inst.Script = DB_Script;	
	
}else{
	DB_Script = ds_grid_create(3, 2); var i = 0; 
	var	Addr=0;	DB_Script[# 0, Addr] = DBScriptCode.Dialogue	DB_Script[# ++i, Addr] = Msg;	DB_Script[# ++i, Addr] = 1; i = 0;
		Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.End;		DB_Script[# ++i, Addr] = 0; 

		global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox, {Method : Method, Y : Y, CenterText : CenterText});
		
		global.DB_Inst.Script = DB_Script;
}	
