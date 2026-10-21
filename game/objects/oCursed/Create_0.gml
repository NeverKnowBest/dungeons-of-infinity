GenerateCurse();

Music_Mute(true);

audio_play_sound(Sound_Cursed, 1, false);	

with(oLink){
	UpdateState(LinkState.Idle);
}

global.Paused = true;

DB_Script = 0;
DB_Init = false;
DB_Started = false;

#region DialogueBox

	function DBScriptFunction_Cursed_Info(){
		
		if(Pendant_Check(Pendant.Immunity)){
			return "Curse blocked by the Pendant of Immunity!"
		}else{
			return "Oh No! You have been cursed!\\Effect: " + global.CurseEffectStr + "\\Task: " + string_replace(global.CurseTaskStr, ".", "") + " to\\remove the curse.";
		}

	} 

	
	DB_Script = ds_grid_create(3, 2); var i = 0; 

var	Addr=0;	DB_Script[# 0, Addr] = DBScriptCode.Dialogue	DB_Script[# ++i, Addr] = method(self, DBScriptFunction_Cursed_Info);	DB_Script[# ++i, Addr] = 1; i = 0;
	Addr=1;	DB_Script[# 0, Addr] = DBScriptCode.End;		DB_Script[# ++i, Addr] = 0; 


#endregion

