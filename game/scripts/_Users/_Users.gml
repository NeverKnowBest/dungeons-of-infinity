enum Stat{
	GamesPlayed,
	GamesWon,
	Deaths,
	Monsters,
	Rupees,
	Treasures	
}
global.StatCount = 6;

enum Pref{
	SFX,
	Music,
	LowHealthSound,
	FoodMagic,
	NPCDialogue,
	HUD
}

enum Pref_OnOff{
	Off,
	On
}

enum Pref_LowHealthSound{
	Classic,
	Minimal,
	NoSound	
}

enum Pref_FoodMagic{
	Inventory,
	Consume,
	ConsumeNoWaste
}

enum Pref_NPCDialogue{
	Collide,
	Button
}

enum Pref_HUD{
	Everything,
	Hearts,
	HeartsMagic,
	Essentials	
}

global.MaxUsers = 5;
global.UserIndex = 0;

global.DefaultUserData_Pref_SFX = Pref_OnOff.On;
global.DefaultUserData_Pref_Music = Pref_OnOff.On;
global.DefaultUserData_Pref_LowHealthSound = Pref_LowHealthSound.Classic;
global.DefaultUserData_Pref_FoodMagic = Pref_FoodMagic.Inventory;
global.DefaultUserData_Pref_NPCDialogue = Pref_NPCDialogue.Collide;
global.DefaultUserData_Pref_HUD = Pref_HUD.Everything;

global.Pref_MaxVolume = 10;
global.Pref_Strings[Pref.SFX] = ["Off", "On"];
global.Pref_Strings[Pref.Music] = ["Off", "On"];
global.Pref_Strings[Pref.LowHealthSound] = ["Classic", "Minimal", "No Sound"];
global.Pref_Strings[Pref.FoodMagic] = ["Add to inventory", "Consume if needed", "Consume if no waste"];
global.Pref_Strings[Pref.NPCDialogue] = ["Collide to start", "Action button"];
global.Pref_Strings[Pref.HUD] = ["Hide Everything", "Show Life", "Show Life & Magic", "Show Essentials"];

global.Pref_Count_SFX = array_length(global.Pref_Strings[Pref.SFX]);
global.Pref_Count_Music = array_length(global.Pref_Strings[Pref.Music]);
global.Pref_Count_LowHealthSound = array_length(global.Pref_Strings[Pref.LowHealthSound]);
global.Pref_Count_FoodMagic = array_length(global.Pref_Strings[Pref.FoodMagic]);
global.Pref_Count_NPCDialogue = array_length(global.Pref_Strings[Pref.NPCDialogue]);
global.Pref_Count_HUD = array_length(global.Pref_Strings[Pref.HUD]);


global.StatsToAdd = array_create(global.StatCount);

function User_Create() constructor {
	
	Name = "";
	
	Prefs = {
		SFX : global.DefaultUserData_Pref_SFX,
		Music : global.DefaultUserData_Pref_Music,
		LowHealthSound : global.DefaultUserData_Pref_LowHealthSound,
		FoodMagic : global.DefaultUserData_Pref_FoodMagic,
		NPCDialogue : global.DefaultUserData_Pref_NPCDialogue,
		HUD : global.DefaultUserData_Pref_HUD
	};
	
	Stats = {
		GamesPlayed : 0,
		GamesWon : 0,
		Deaths : 0,
		Monsters: 0,
		Rupees: 0,
		Treasures: 0
	};

	LevelData = 0;
	
	InputProfile_Gamepad = input_profile_export("gamepad",,false);
	
	InputProfile_Keyboard = input_profile_export("keyboard",,false);
	
}

function User_VerifyIntegrity(){
	
	//preferences may change with updates. This function checks to see if there's fields missing then updates them

	//var User = global.Users[global.UserIndex];
		
	//if(!variable_struct_exists(User, "Name")) variable_struct_set(User, "Name", "");
		
	//var Prefs = User.Prefs;
	//if(!variable_struct_exists(Prefs, "SFX")) variable_struct_set(Prefs, "SFX", global.DefaultUserData_Pref_SFX);
	//if(!variable_struct_exists(Prefs, "Music")) variable_struct_set(Prefs, "Music", global.DefaultUserData_Pref_Music);
	//if(!variable_struct_exists(Prefs, "LowHealthSound")) variable_struct_set(Prefs, "LowHealthSound", global.DefaultUserData_Pref_LowHealthSound);
	//if(!variable_struct_exists(Prefs, "FoodMagic")) variable_struct_set(Prefs, "FoodPickup", global.DefaultUserData_Pref_FoodMagic);
	//if(!variable_struct_exists(Prefs, "NPCDialogue")) variable_struct_set(Prefs, "NPCDialogue", global.DefaultUserData_Pref_NPCDialogue);
	//if(!variable_struct_exists(Prefs, "HUD")) variable_struct_set(Prefs, "HUD", global.DefaultUserData_Pref_HUD);
		
	////Also check if pref settings are higher than available options, since options may be removed, and old values might be higher and now invalid. Set to default if that's the case
		
	//if(Prefs.SFX >= global.Pref_Count_SFX) Prefs.SFX = global.DefaultUserData_Pref_SFX;
	//if(Prefs.Music >= global.Pref_Count_Music) Prefs.Music = global.DefaultUserData_Pref_Music;
	//if(Prefs.LowHealthSound >= global.Pref_Count_LowHealthSound) Prefs.LowHealthSound = global.DefaultUserData_Pref_LowHealthSound;
	//if(Prefs.FoodMagic >= global.Pref_Count_FoodMagic) Prefs.FoodMagic = global.DefaultUserData_Pref_FoodMagic;
	//if(Prefs.NPCDialogue >= global.Pref_Count_NPCDialogue) Prefs.NPCDialogue = global.DefaultUserData_Pref_NPCDialogue;
	//if(Prefs.HUD >= global.Pref_Count_HUD) Prefs.HUD = global.DefaultUserData_Pref_HUD;
		
	//var Stats = User.Stats;
	//if(!variable_struct_exists(Stats, "GamesPlayed")) variable_struct_set(Stats, "GamesPlayed", 0);
	//if(!variable_struct_exists(Stats, "GamesWon")) variable_struct_set(Stats, "GamesWon", 0);
	//if(!variable_struct_exists(Stats, "Deaths")) variable_struct_set(Stats, "Deaths", 0);
	//if(!variable_struct_exists(Stats, "Monsters")) variable_struct_set(Stats, "Monsters", 0);
	//if(!variable_struct_exists(Stats, "Rupees")) variable_struct_set(Stats, "Rupees", 0);
	//if(!variable_struct_exists(Stats, "Treasures")) variable_struct_set(Stats, "Treasures", 0);
	
	//User_Save();
	
}

function User_Save(){
	
	global.Users[global.UserIndex].InputProfile_Gamepad = input_profile_export("gamepad",,false);
	global.Users[global.UserIndex].InputProfile_Keyboard = input_profile_export("keyboard",,false);
	
	global.Users[global.UserIndex].Stats.GamesPlayed += global.StatsToAdd[Stat.GamesPlayed];
	global.Users[global.UserIndex].Stats.GamesWon += global.StatsToAdd[Stat.GamesWon];
	global.Users[global.UserIndex].Stats.Deaths += global.StatsToAdd[Stat.Deaths];
	global.Users[global.UserIndex].Stats.Monsters += global.StatsToAdd[Stat.Monsters];
	global.Users[global.UserIndex].Stats.Rupees += global.StatsToAdd[Stat.Rupees];
	global.Users[global.UserIndex].Stats.Treasures += global.StatsToAdd[Stat.Treasures];
	global.StatsToAdd = 0; global.StatsToAdd = array_create(global.StatCount); 
	
	var JSONStr = json_stringify(global.Users);
	var Buffer = buffer_create( string_byte_length(JSONStr) + 1, buffer_fixed, 1);
	buffer_write(Buffer, buffer_string, JSONStr);
	buffer_save(Buffer, "Users.json");
	buffer_delete(Buffer);
	
}


function User_Delete(){	
	array_delete(global.Users, global.UserIndex, 1);
	array_insert(global.Users, global.UserIndex, new User_Create());	
	User_Save();
}

