FloorLevel = GetFloorLevelID(GetFloorLevelString(x, y));

DB_Init = false;
DB_Started = false;

DialogueSentence = 0;

#region DialogueBox

	function ScriptFunction_Dialogue_NPC() {
		if(DialogueSentence >= array_length(Dialogue)) DialogueSentence = 0;
		return Dialogue[DialogueSentence++];
	}
		
	DB_Script = ds_grid_create(3, 2); var i = 0; var Addr=0;

			DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = method(self, ScriptFunction_Dialogue_NPC);	DB_Script[# ++i, Addr] = 1; i = 0;
	Addr=1; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;



#endregion