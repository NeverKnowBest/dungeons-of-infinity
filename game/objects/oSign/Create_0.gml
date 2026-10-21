
DB_Init = false;
DB_Started = false;

Dialogue = ""

Active = true;

Hidden = false;

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

WallObj = WallObj_Create("Objs_" + FloorLevelStr, x - 8, y - 16, 2, 2);


#region DialogueBox
		
	DB_Script = ds_grid_create(3, 2); var i = 0; var Addr=0;

			DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue;	DB_Script[# ++i, Addr] = 1; i = 0;
	Addr=1; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;



#endregion