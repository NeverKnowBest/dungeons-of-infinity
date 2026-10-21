visible = false; //visible set to false so DepthDrawObjs can sort and draw everything manually


FlyingFrame = 0;

FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

z = 5;


//Type 1 = Hearts, Magic = 2
sprite_index = asset_get_index("sHeartGuy" + string(Type));
if(Type == 2) image_speed /= 2;

Disappear = false;
Disappeared = false;

DB_Init = false;
DB_Started = false;

#region DialogueBox

	function DBScriptFunction_HeartGuy(){ return LinkHealth >= 3;	} 
	function DBScriptFunction_MagicGuy(){ return global.Inventory.ItemData[ItemClass.Magic].Amount > 33;	}

	Dialogue_HeartGuy = "Hi, I'm fealing weak, can you\\spare me 3/4 of your health?\\I'll give you all of my rupees\\in exchange."

	Dialogue_HeartGuy_NotEnough = "Hi, I'm looking to buy health from someone. Looks like you don't have enough to spare. Come back when you have more."

	Dialogue_MagicGuy = "Hi, I'm fealing weak, can you\\spare me all of your magic?\\I'll give you all of my rupees\\in exchange."

	Dialogue_MagicGuy_NotEnough = "Hi, I'm looking to buy magic from someone. Looks like you don't have enough to spare. Come back when you have more."

	Dialogue_ThanksSucker = "Haha, thanks sucker!"
	Dialogue_BeatIt = "Fine, beat it kid"
	
	DB_Script = ds_grid_create(5, 7); var i = 0; var Addr=0;
	
	var ScriptFunction = (Type == 1 ? DBScriptFunction_HeartGuy : DBScriptFunction_MagicGuy);
	var Dialogue = (Type == 1 ? Dialogue_HeartGuy : Dialogue_MagicGuy);
	var NotEnough = (Type == 1 ? Dialogue_HeartGuy_NotEnough : Dialogue_MagicGuy_NotEnough);

			DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, ScriptFunction);	DB_Script[# ++i, Addr] = 1;			DB_Script[# ++i, Addr] = 3; i = 0;
	Addr=1; DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo;	DB_Script[# ++i, Addr] = Dialogue;						DB_Script[# ++i, Addr] = 2;			DB_Script[# ++i, Addr] = 4; i = 0;
	Addr=2; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_ThanksSucker;			DB_Script[# ++i, Addr] = 6; i = 0;
	Addr=3; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = NotEnough;						DB_Script[# ++i, Addr] = 5; i = 0;
	Addr=4; DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = Dialogue_BeatIt;				DB_Script[# ++i, Addr] = 5; i = 0;
	Addr=5; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0;
	Addr=6; DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0;

#endregion
