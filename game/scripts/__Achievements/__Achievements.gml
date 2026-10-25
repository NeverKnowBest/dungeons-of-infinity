// Feather disable GM2064

// Achievements, and what they unlock.
//
// Every achievement belongs to one statue of the Hall of Statues (bronze, silver or gold). A statue is revealed when
// all of its achievements are done. Some achievements also unlock a skin (changed with the Flute Boy in the
// Sanctuary) or a bonus item (picked at the Sanctuary door before a run). Nothing is unlocked on a new user.
//
// Unlocked achievements are kept in the user file: global.Users[i].Achievements is a struct of Key -> true.
// Achievements are not granted while cheats are on.

enum StatueTier{
	Bronze,
	Silver,
	Gold
}

#macro ACH_SPEEDRUN_TIME (60 * 60 * 1000000)	// "Speedrunner": beat the game in under an hour (get_timer microseconds)

// Statues of the Hall of Statues, in display order
global.Statues = [
	{ Key: "Armos",		Name: "Armos Knight",	Tier: StatueTier.Bronze },
	{ Key: "Lanmola",	Name: "Lanmola",		Tier: StatueTier.Silver },
	{ Key: "Moldorm",	Name: "Moldorm",		Tier: StatueTier.Silver },
	{ Key: "Agahnim",	Name: "Agahnim",		Tier: StatueTier.Gold }
];

// Skin: index into LinkCharacter, or -1. Gear: StartingGear value, or -1.
global.AchievementList = [
	// Armos Knight (bronze)
	{ Key: "BossArmos",		Statue: "Armos",	Name: "Prison Break",		Desc: "Defeat the Armos Knights",			Skin: -1,						Gear: StartingGear.Shield },
	{ Key: "ReachCatacombs",Statue: "Armos",	Name: "Into the Depths",	Desc: "Reach the Catacombs",				Skin: LinkCharacter.Girl,		Gear: -1 },
	{ Key: "Chests25",		Statue: "Armos",	Name: "Treasure Hunter",	Desc: "Open 25 treasure chests",			Skin: -1,						Gear: StartingGear.Rupees },
	{ Key: "Monsters100",	Statue: "Armos",	Name: "Monster Slayer",		Desc: "Defeat 100 monsters",				Skin: LinkCharacter.Monkey,		Gear: -1 },
	// Lanmola (silver)
	{ Key: "BossLanmola",	Statue: "Lanmola",	Name: "Sand Serpent",		Desc: "Defeat Lanmola",						Skin: -1,						Gear: StartingGear.Orbs },
	{ Key: "ReachVillage",	Statue: "Lanmola",	Name: "Hometown",			Desc: "Reach the Village",					Skin: -1,						Gear: StartingGear.Inventory },
	{ Key: "Rupees2000",	Statue: "Lanmola",	Name: "Rich Kid",			Desc: "Collect 2000 rupees",				Skin: LinkCharacter.Frog,		Gear: -1 },
	{ Key: "Deaths10",		Statue: "Lanmola",	Name: "Never Give Up",		Desc: "Fall 10 times",						Skin: -1,						Gear: StartingGear.Antidotes },
	// Moldorm (silver)
	{ Key: "BossMoldorm",	Statue: "Moldorm",	Name: "Worm Food",			Desc: "Defeat Moldorm",						Skin: -1,						Gear: StartingGear.Rod },
	{ Key: "ReachMines",	Statue: "Moldorm",	Name: "Under the Mountain",	Desc: "Reach the Mines",					Skin: LinkCharacter.Fox,		Gear: -1 },
	{ Key: "Monsters1000",	Statue: "Moldorm",	Name: "Exterminator",		Desc: "Defeat 1000 monsters",				Skin: LinkCharacter.Penguin,	Gear: -1 },
	{ Key: "Chests100",		Statue: "Moldorm",	Name: "Collector",			Desc: "Open 100 treasure chests",			Skin: LinkCharacter.Rabbit,		Gear: -1 },
	// Agahnim (gold)
	{ Key: "Win",			Statue: "Agahnim",	Name: "Hero of Hyrule",		Desc: "Defeat Agahnim",						Skin: -1,						Gear: StartingGear.Heart },
	{ Key: "WinFast",		Statue: "Agahnim",	Name: "Speedrunner",		Desc: "Defeat Agahnim in under an hour",	Skin: LinkCharacter.Wolf,		Gear: -1 },
	{ Key: "WinChallenge",	Statue: "Agahnim",	Name: "Glutton for Pain",	Desc: "Defeat Agahnim with a challenge on",	Skin: LinkCharacter.Mouse,		Gear: -1 },
	{ Key: "Win3",			Statue: "Agahnim",	Name: "Legend",				Desc: "Defeat Agahnim 3 times",				Skin: -1,						Gear: -1 }
];

global.SkinNames = ["Link", "Girl", "Monkey", "Frog", "Fox", "Penguin", "Rabbit", "Wolf", "Mouse"];


#region Queries

function Achievement_Get(_Key){
	for(var i = 0; i < array_length(global.AchievementList); i++){
		if(global.AchievementList[i].Key == _Key) return global.AchievementList[i];
	}
	return undefined;
}

function Achievement_IsDone(_Key){
	if(global.UserIndex < 0) return false;
	var _User = global.Users[global.UserIndex];
	if(!variable_struct_exists(_User, "Achievements")) return false;
	return _User.Achievements[$ _Key] == true;
}

/// The achievement that unlocks a skin (undefined for skins that are always available)
function Skin_UnlockAchievement(_Skin){
	for(var i = 0; i < array_length(global.AchievementList); i++){
		if(global.AchievementList[i].Skin == _Skin) return global.AchievementList[i];
	}
	return undefined;
}

function Skin_IsUnlocked(_Skin){
	var _Ach = Skin_UnlockAchievement(_Skin);
	return _Ach == undefined || Achievement_IsDone(_Ach.Key);
}

/// The achievement that unlocks a bonus item (undefined for items that are always available)
function Gear_UnlockAchievement(_Gear){
	for(var i = 0; i < array_length(global.AchievementList); i++){
		if(global.AchievementList[i].Gear == _Gear) return global.AchievementList[i];
	}
	return undefined;
}

function Gear_IsUnlocked(_Gear){
	if(_Gear == StartingGear.None) return true;
	var _Ach = Gear_UnlockAchievement(_Gear);
	return _Ach == undefined || Achievement_IsDone(_Ach.Key);
}

/// Done / total achievements of a statue
function Statue_Progress(_StatueKey){
	var _Done = 0, _Total = 0;
	for(var i = 0; i < array_length(global.AchievementList); i++){
		var _Ach = global.AchievementList[i];
		if(_Ach.Statue != _StatueKey) continue;
		_Total++;
		if(Achievement_IsDone(_Ach.Key)) _Done++;
	}
	return [_Done, _Total];
}

function Statue_IsRevealed(_StatueKey){
	var _P = Statue_Progress(_StatueKey);
	return _P[1] > 0 && _P[0] == _P[1];
}

#endregion


#region Unlocking

/// Marks an achievement as done (once), saves the user and shows the "Achievement unlocked" banner
function Achievement_Unlock(_Key){

	if(global.UserIndex < 0) return;
	if(global.CheatsEnabled) return;
	if(Achievement_IsDone(_Key)) return;

	var _Ach = Achievement_Get(_Key);
	if(_Ach == undefined) return;

	var _User = global.Users[global.UserIndex];
	if(!variable_struct_exists(_User, "Achievements")) _User.Achievements = {};
	_User.Achievements[$ _Key] = true;
	User_Save();

	Achievement_ShowToast(_Ach);

}

function Achievement_ShowToast(_Ach){

	if(room != Room_Dungeon) return;

	var _Reward = "";
	if(_Ach.Skin != -1) _Reward = "New look: " + global.SkinNames[_Ach.Skin];
	if(_Ach.Gear != -1) _Reward = "New bonus item: " + global.GearInfo[_Ach.Gear].Label;

	instance_create_layer(0, 0, "System", oAchievementToast, { Title: _Ach.Name, Reward: _Reward });

}

/// Achievements based on the user's lifetime stats (saved stats plus the ones of the run in progress)
function Achievements_CheckStats(){

	if(global.UserIndex < 0) return;

	var _Stats = global.Users[global.UserIndex].Stats;
	var _Add = global.StatsToAdd;
	var _Get = function(_Stats, _Add, _Stat){
		return _Stats[_Stat] + (is_array(_Add) && array_length(_Add) > _Stat ? _Add[_Stat] : 0);
	};

	var _Monsters = _Get(_Stats, _Add, Stat.Monsters);
	var _Chests = _Get(_Stats, _Add, Stat.Treasures);
	var _Rupees = _Get(_Stats, _Add, Stat.Rupees);
	var _Deaths = _Get(_Stats, _Add, Stat.Deaths);
	var _Wins = _Get(_Stats, _Add, Stat.GamesWon);

	if(_Monsters >= 100)	Achievement_Unlock("Monsters100");
	if(_Monsters >= 1000)	Achievement_Unlock("Monsters1000");
	if(_Chests >= 25)		Achievement_Unlock("Chests25");
	if(_Chests >= 100)		Achievement_Unlock("Chests100");
	if(_Rupees >= 2000)		Achievement_Unlock("Rupees2000");
	if(_Deaths >= 10)		Achievement_Unlock("Deaths10");

	// Users that already beat the game before achievements existed get the ones a win implies
	if(_Wins >= 1){
		Achievement_Unlock("Win");
		Achievement_Unlock("BossArmos");
		Achievement_Unlock("BossLanmola");
		Achievement_Unlock("BossMoldorm");
		Achievement_Unlock("ReachCatacombs");
		Achievement_Unlock("ReachVillage");
		Achievement_Unlock("ReachMines");
	}
	if(_Wins >= 3) Achievement_Unlock("Win3");

}

/// Called when a new level starts
function Achievements_OnLevelStart(_LevelIndex){
	switch(_LevelIndex){
		case DungeonLevel.Catacombs:	Achievement_Unlock("ReachCatacombs"); break;
		case DungeonLevel.Village:		Achievement_Unlock("ReachVillage"); break;
		case DungeonLevel.Mines:		Achievement_Unlock("ReachMines"); break;
	}
	Achievements_CheckStats();
}

/// Called when Link picks up a boss crystal
function Achievements_OnBossDefeated(_LevelIndex){
	switch(_LevelIndex){
		case DungeonLevel.CastleJails:		Achievement_Unlock("BossArmos"); break;
		case DungeonLevel.LanmolasLair:		Achievement_Unlock("BossLanmola"); break;
		case DungeonLevel.MoldormsLair:		Achievement_Unlock("BossMoldorm"); break;
	}
	Achievements_CheckStats();
}

/// Called when Agahnim is defeated
function Achievements_OnGameWon(){
	Achievement_Unlock("Win");
	if(global.Time_PlayingTotalEnd > 0 && global.Time_PlayingTotalEnd < ACH_SPEEDRUN_TIME) Achievement_Unlock("WinFast");
	if(Achievements_AnyChallengeActive()) Achievement_Unlock("WinChallenge");
	Achievements_CheckStats();
}

function Achievements_AnyChallengeActive(){
	if(variable_global_exists("ChallengeOptions")){
		for(var i = 0; i < array_length(global.ChallengeOptions); i++){
			if(global.ChallengeOptions[i] > 0) return true;
		}
	}
	if(variable_global_exists("Challenges")){
		for(var i = 0; i < array_length(global.Challenges); i++){
			if(global.Challenges[i]) return true;
		}
	}
	return false;
}

#endregion


#region Skins and bonus items saved per user

function User_GetSkin(){
	var _User = global.Users[global.UserIndex];
	var _Skin = variable_struct_exists(_User, "Skin") ? _User.Skin : 0;
	return Skin_IsUnlocked(_Skin) ? _Skin : 0;
}

/// Changes Link's look right away and remembers it for this user
function Skin_Set(_Skin){
	if(!Skin_IsUnlocked(_Skin)) return;
	global.Users[global.UserIndex].Skin = _Skin;
	User_Save();
	global.LinkCharacterIndex = _Skin;
	with(oLink){
		Link_LoadCharacterIndex();
		UpdateSprites();
	}
}

function User_GetBonusItem(){
	var _User = global.Users[global.UserIndex];
	var _Gear = variable_struct_exists(_User, "BonusItem") ? _User.BonusItem : StartingGear.None;
	return Gear_IsUnlocked(_Gear) ? _Gear : StartingGear.None;
}

function Gear_Set(_Gear){
	if(!Gear_IsUnlocked(_Gear)) return;
	global.Users[global.UserIndex].BonusItem = _Gear;
	global.StartingGear = _Gear;
	User_Save();
}

#endregion
