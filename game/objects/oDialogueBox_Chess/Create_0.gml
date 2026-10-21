	
DB_Script = ds_grid_create(5, 4); var i = 0; 
var	Addr=0;	DB_Script[# 0, Addr] = DBScriptCode.Dialogue_ChessEnd	DB_Script[# ++i, Addr] = Msg;	DB_Script[# ++i, Addr] = 1; DB_Script[# ++i, Addr] = 2; DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.End;				DB_Script[# ++i, Addr] = 0; i = 0;
	Addr=2;	DB_Script[# 0, Addr] = DBScriptCode.End;				DB_Script[# ++i, Addr] = 1; i = 0;
	Addr=3;	DB_Script[# 0, Addr] = DBScriptCode.End;				DB_Script[# ++i, Addr] = 2; i = 0;

	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);
		
	global.DB_Inst.Script = DB_Script;	
	
