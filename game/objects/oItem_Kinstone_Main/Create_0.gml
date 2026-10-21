vx = 0;
vy = 0;
vx_Other = 0;
vy_Other = 0;
t = 0;
BaseX = x;
BaseY = y;
BaseX_Other = x;
BaseY_Other = y;
SpriteY = y;
SpriteY_Other = y;
WaypointX = 0;
WaypointY = 0;
WaypointX_Other = 0;
WaypointY_Other = 0;
Merge = false;
MergeConnected = false;
ConnectSound = false;
PoofInst = noone;
TreasureLightDim = false;
TreasureLightColor = 0.6;

LightStr = 2.0;
LightY = y;
LightY_Treasure = y + 24;
LightIndex = Lighting_CreateLight(RoomIndex, x, y, LightStr, [1, 1, 1]);

KinstoneMain_SetIndex(Index);

State = KinstoneState.Idle

DB_Init = false;
FuseInit = false;

#region DialogueBox

	function DBScriptFunction_KinstoneMatch(){
		return Inventory_ItemExists(ItemClass.Kinstone, Index);
	} 

	Dialogue_Match = "Match found! Fuse kinstone?";
	Dialogue_NoMatch = "No matching kinstones found.";
	
	DB_Script = ds_grid_create(4, 5); var i = 0; var Addr=0;


			DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, DBScriptFunction_KinstoneMatch);	DB_Script[# ++i, Addr] = 1;			DB_Script[# ++i, Addr] = 2; i = 0;
	Addr=1; DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo;	DB_Script[# ++i, Addr] = Dialogue_Match;								DB_Script[# ++i, Addr] = 4;			DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=2; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_NoMatch;								DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=3; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;
	Addr=4; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0;

#endregion
