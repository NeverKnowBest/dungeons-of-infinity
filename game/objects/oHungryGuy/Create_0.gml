image_index = choose(0,1,2,3);

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

WallObj = WallObj_Create("Objs_" + FloorLevelStr, x - 8, y - 16, 2, 1);

ReceivedFood = false;

DB_Init = false;
DB_Started = false;

#region DialogueBox
	
	function DBScriptFunction_HungryGuy_ReceivedFood(){ return ReceivedFood;} 
	function DBScriptFunction_HungryGuy(){ return Inventory_ItemExists(ItemClass.Food) || Inventory_ItemExists(ItemClass.Pop) || Inventory_ItemExists(ItemClass.Potion, Potion.Milk)} 
	

	Dialogue_HungryGuy = "I'm very hungry and weak, will you spare me some of your food?"

	Dialogue_HungryGuy_NotEnough = "I'm very hungry and weak. Please bring me some food if you find any."
	
	Dialogue_Thanks = "Thank you kind traveller! Here is some money."
	Dialogue_BeatIt = "Very well, hopefully I will survive the night."
	Dialogue_ReceivedFood = "I am full now, thank you for your generosity."
	
	DB_Script = ds_grid_create(5, 9); var i = 0; var Addr=0;

			DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, DBScriptFunction_HungryGuy_ReceivedFood);	DB_Script[# ++i, Addr] = 3;			DB_Script[# ++i, Addr] = 1; i = 0;
	Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, DBScriptFunction_HungryGuy);				DB_Script[# ++i, Addr] = 2;			DB_Script[# ++i, Addr] = 5; i = 0;
	Addr=2; DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo;	DB_Script[# ++i, Addr] = Dialogue_HungryGuy;									DB_Script[# ++i, Addr] = 4;			DB_Script[# ++i, Addr] = 6; i = 0;
	Addr=3; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_ReceivedFood;									DB_Script[# ++i, Addr] = 7;	i = 0;
	Addr=4; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_Thanks;										DB_Script[# ++i, Addr] = 8; i = 0;
	Addr=5; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_HungryGuy_NotEnough;							DB_Script[# ++i, Addr] = 7; i = 0;
	Addr=6; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_BeatIt;										DB_Script[# ++i, Addr] = 7; i = 0;
	Addr=7; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;
	Addr=8; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0;

#endregion
