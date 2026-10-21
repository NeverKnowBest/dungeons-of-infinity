image_index = choose(0,1,2,3);

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

WallObj = WallObj_Create("Objs_" + FloorLevelStr, x - 8, y - 16, 2, 1);

ItemHolding = (Prob(Chance_DeadGuyBonusItem) ? RandomItem : -1);

DB_Init = false;
DB_Started = false;

#region DialogueBox

	function DBScriptFunction_DeadGuy_CheckLoot(){ return ItemHolding != -1;} 

	Dialogue_DeadGuy_Intro = "Looks like a dead explorer! Search his body for loot?"
	Dialogue_DeadGuy_NoLoot = "Nothing was found."
	
	DB_Script = ds_grid_create(5, 5); var i = 0;
	
var	Addr=0; DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo;	DB_Script[# ++i, Addr] = Dialogue_DeadGuy_Intro;		DB_Script[# ++i, Addr] = 1;			DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, DBScriptFunction_DeadGuy_CheckLoot);	DB_Script[# ++i, Addr] = 4;	DB_Script[# ++i, Addr] = 2; i = 0;
	Addr=2; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_DeadGuy_NoLoot;		DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=3; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;
	Addr=4; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0;

#endregion