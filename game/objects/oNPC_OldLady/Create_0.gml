enum NPCState_OldLady{
	Sleeping,
	Waking,
	Awake,
	Letter,
	Reward,
	Farewell
}
State = NPCState_OldLady.Sleeping;

Wake_Init = false;
Wake_HeadFrame = 0;
Wake_HeadFrames = [1,0,1,0,1,1,1,2,2];

Dying_Init = false;
Dying_HeadFrame = 0;
Dying_HeadFrames = [1,1,1,0,0];

AniDelay = 16;

DeliveredLetter = false;

TurningGrey = false;
TurningGreyAlpha = 0;

FloorLevel = GetFloorLevelID(x, y);

DB_Init = false;
DB_Started = false;

#region DialogueBox
	
	Dialogue_Intro = "Cough, cough...I don't feel very good. I only wish I knew how my friend Pezo was doing. I haven't seen him in 8 years. He was captured during the rebellion. They would have sent him to jail. ";
	Dialogue_Letter = "Oh! You have a letter from Pezo?! Thank you very much! Here, take this reward for your troubles, it is all that I own.";
	Dialogue_NoLetter = "If you see him, please tell him that Doris misses him.";
	
	Dialogue_ReadLetter = "Cough...Cough...Now please\\read me his letter...\\\\'My dearest Doris,\\I lay here in my cold cell, thinking\\about you.\\Jail is lonely at night and my\\heart aches living without you.\\Sleeping alone between these cold\\walls, I cry. I have thought about\\us under warm blankets, caressing\\you, as moonbeams guide us\\through our dreams.\\I sense you're not feeling well, my\\heart aches thinking of you in\\pain. I wish I could take it away\\from you, carry your burden.\\\\I will always be with you, in our\\dreams riding the clouds, holding\\hands, laughing and smiling, as we\\once did.\\Though distance may keep us apart\\for the moment, you are embedded\\deep within my heart.\\Love always,\\Pezo.'"
	
	Dialogue_ThankYou = "Thank you, that is what I needed\\to hear.\\\\";
	Dialogue_Farewell = "Farewell...\\\\\\my...\\\\\\friend...";
	
	function ScriptFunction_OldLady_Letter(){
		return global.Inventory.ItemData[ItemClass.Letter].Owns[0] || DeliveredLetter;
	}
	function ScriptFunction_OldLady_DialogueAwake(){
		return Dialogue_Intro + (ScriptFunction_OldLady_Letter() ? Dialogue_Letter : Dialogue_NoLetter);
	}
	function ScriptFunction_OldLady_DialogueFarewell(){
		return (ScriptFunction_OldLady_Letter() ? Dialogue_ThankYou + Dialogue_Farewell: Dialogue_Farewell);		
	}
	
	DB_Script_Awake = ds_grid_create(5, 4); var i = 0; var Addr=0;

			DB_Script_Awake[# 0, Addr] = DBScriptCode.Dialogue;	DB_Script_Awake[# ++i, Addr] = method(self, ScriptFunction_OldLady_DialogueAwake);	DB_Script_Awake[# ++i, Addr] = 1; i = 0;
	Addr=1;	DB_Script_Awake[# 0, Addr] = DBScriptCode.IfGoto;	DB_Script_Awake[# ++i, Addr] = method(self, ScriptFunction_OldLady_Letter);		DB_Script_Awake[# ++i, Addr] = 3;	DB_Script_Awake[# ++i, Addr] = 2; i = 0;
	Addr=2; DB_Script_Awake[# 0, Addr] = DBScriptCode.End;		DB_Script_Awake[# ++i, Addr] = 0; i = 0;
	Addr=3; DB_Script_Awake[# 0, Addr] = DBScriptCode.End;		DB_Script_Awake[# ++i, Addr] = 1; i = 0;


	DB_Script_Letter = ds_grid_create(5, 2); i = 0; Addr=0;

			DB_Script_Letter[# 0, Addr] = DBScriptCode.Dialogue;	DB_Script_Letter[# ++i, Addr] = Dialogue_ReadLetter;	DB_Script_Letter[# ++i, Addr] = 1; i = 0;
	Addr=1; DB_Script_Letter[# 0, Addr] = DBScriptCode.End;			DB_Script_Letter[# ++i, Addr] = 0; i = 0;



	DB_Script_Farewell = ds_grid_create(5, 4); i = 0; Addr=0;

			DB_Script_Farewell[# 0, Addr] = DBScriptCode.Dialogue;	DB_Script_Farewell[# ++i, Addr] = method(self, ScriptFunction_OldLady_DialogueFarewell);	DB_Script_Farewell[# ++i, Addr] = 1; i = 0;
	Addr=1;	DB_Script_Farewell[# 0, Addr] = DBScriptCode.IfGoto;	DB_Script_Farewell[# ++i, Addr] = method(self, ScriptFunction_OldLady_Letter);		DB_Script_Farewell[# ++i, Addr] = 3;	DB_Script_Farewell[# ++i, Addr] = 2; i = 0;
	Addr=2; DB_Script_Farewell[# 0, Addr] = DBScriptCode.End;		DB_Script_Farewell[# ++i, Addr] = 0; i = 0;
	Addr=3; DB_Script_Farewell[# 0, Addr] = DBScriptCode.End;		DB_Script_Farewell[# ++i, Addr] = 1; i = 0;


#endregion