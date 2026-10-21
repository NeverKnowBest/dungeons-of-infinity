visible = false;

x += sprite_get_xoffset(sprite_index);
y += sprite_get_yoffset(sprite_index);

FloorLevel = GetFloorLevelID(x, y);
RoomIndex = Dungeon_GetRoomIndex(x, y);

State = NPCState.Idle;
						
SprUp = asset_get_index("s" + Name + "_Up");
SprDown = asset_get_index("s" + Name + "_Down");
SprLeft = asset_get_index("s" + Name + "_Left");
SprRight = asset_get_index("s" + Name + "_Right");
		
WallInst = noone;

Dir = DOWN;
vx = 0;
vy = 0;

CanPauseObj = true;
LastImageSpeed = image_speed;

DB_Init = false;
DB_Init_Child = false; //for oNPC_Sitting and oNPC_Walking
DB_Init_GrandChild = false; //for any obj that is a oNPC_Sitting and oNPC_Walking

DB_InitDone = false;

DB_Started = false;
DB_Started_Child = false;
DB_Started_GrandChild = false;

DB_Delay = false;
DB_Delay_Len = 8;



DialogueIndex = 0;
ResponseIndex = -1; 

DialogueIgnore = false;

ItemHolding = noone;
GiveItem = false;

#region DialogueBox
	
	function Dialogue_GetCurrentSentence(){	
		return ResponseIndex > -1 ? Response[ResponseIndex] : Dialogue[DialogueIndex];
	}

	function ScriptFunction_Dialogue_NPC_IsQuestion(){
		var Sentence = Dialogue_GetCurrentSentence();
		return string_char_at(Sentence, 1) == "?";  //if first character is ?, then treat as a question, returns true
	}


	function ScriptFunction_Dialogue_NPC() {
		
		var Sentence = Dialogue_GetCurrentSentence();
		
		if(string_char_at(Sentence, 1) == "?") Sentence = string_copy(Sentence, 2, string_length(Sentence) - 1);
		
		if(ResponseIndex == -1){
			DialogueIndex = (DialogueIndex + 1) mod array_length(Dialogue);
		}
		
		return Sentence;
	}

	
	DB_Script = ds_grid_create(4, 5); var i = 0; var Addr=0;

	DB_Script[# 0, Addr] = DBScriptCode.IfGoto;			DB_Script[# ++i, Addr] = method(self, ScriptFunction_Dialogue_NPC_IsQuestion);	DB_Script[# ++i, Addr] = 1; DB_Script[# ++i, Addr] = 2; i = 0; Addr++;
	DB_Script[# 0, Addr] = DBScriptCode.Dialogue_YesNo;	DB_Script[# ++i, Addr] = method(self, ScriptFunction_Dialogue_NPC);				DB_Script[# ++i, Addr] = 4; DB_Script[# ++i, Addr] = 3; i = 0; Addr++;
	DB_Script[# 0, Addr] = DBScriptCode.Dialogue;		DB_Script[# ++i, Addr] = method(self, ScriptFunction_Dialogue_NPC);				DB_Script[# ++i, Addr] = 3; i = 0; Addr++;
	DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 0; i = 0; Addr++; 
	DB_Script[# 0, Addr] = DBScriptCode.End;			DB_Script[# ++i, Addr] = 1; i = 0; Addr++; 

	




#endregion