FloorLevelStr = GetFloorLevelString(x, y);
FloorLevel = GetFloorLevelID(FloorLevelStr);

var WallInst = WallObj_Create("ObjsHigher_" + FloorLevelStr, x - 4, y, 5, 4);
WallInst.FloorLevel = FloorLevel;

LightIndex = Lighting_CreateLight(RoomIndex, x + 12, y + 20, 0.4, [0.8, 0.8, 0.8]);

Cans = 5;

DB_Init = false;
DB_Started = false

#region DialogueBox

	function DBScriptFunction_PopMachine_ItemInfo(){
		return Item_Info(ItemClass.Pop, 0);
	} 
	
	function DBScriptFunction_PopMachine_CheckCans(){
		return Cans > 0;	
	}
	
	function DBScriptFunction_PopMachine_CheckCost(){
		return global.Inventory.ItemData[ItemClass.Rupee].Amount >= PopMachineCost;	
	}

	DB_Script = ds_grid_create(5, 8); var i = 0; 

	DB_Script[# 0, 0] = DBScriptCode.Dialogue_Buy;		DB_Script[# ++i, 0] = "Pop: " + string(PopMachineCost) + " rupees";				DB_Script[# ++i, 0] = 1;	DB_Script[# ++i, 0] = 6;	DB_Script[# ++i, 0] = 5;	i = 0;
	DB_Script[# 0, 1] = DBScriptCode.IfGoto;			DB_Script[# ++i, 1] = method(self, DBScriptFunction_PopMachine_CheckCans);		DB_Script[# ++i, 1] = 3;	DB_Script[# ++i, 1] = 2;								i = 0;
	DB_Script[# 0, 2] = DBScriptCode.Dialogue;			DB_Script[# ++i, 2] = "No more cans left.";										DB_Script[# ++i, 2] = 6;															i = 0;
	DB_Script[# 0, 3] = DBScriptCode.IfGoto;			DB_Script[# ++i, 3] = method(self, DBScriptFunction_PopMachine_CheckCost);		DB_Script[# ++i, 3] = 7;	DB_Script[# ++i, 3] = 4;								i = 0;
	DB_Script[# 0, 4] = DBScriptCode.Dialogue;			DB_Script[# ++i, 4] = "You don't have enough rupees.";							DB_Script[# ++i, 4] = 6;															i = 0;
   	DB_Script[# 0, 5] = DBScriptCode.Dialogue			DB_Script[# ++i, 5] = method(self, DBScriptFunction_PopMachine_ItemInfo);		DB_Script[# ++i, 5] = 0;															i = 0;
   	DB_Script[# 0, 6] = DBScriptCode.End;				DB_Script[# ++i, 6] = 0;																																			i = 0;
   	DB_Script[# 0, 7] = DBScriptCode.End;				DB_Script[# ++i, 7] = 1;																																			

#endregion