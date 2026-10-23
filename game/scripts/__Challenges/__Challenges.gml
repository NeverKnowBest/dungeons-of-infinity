enum ChallengeOption{
	StartingHearts,
	HeartsMax,
	Defense,
	Darkness,
	Inventory,
	MaxRupees,
	ShopPrices,
	Enemies,
	Curses
}

enum ChallengeOption_Defense{
	Normal,
	_4Max,
	_3Max,
	_2Max	
}

enum ChallengeOption_Darkness{
	Normal,
	MoreDark,
	AllDark,
	NoLights	
}

enum Challenges{
	NoMap,
	NoFood,	
	WallMaster
}


// Menu label and per-level description of each challenge option, keyed by ChallengeOption
global.ChallengeOptionInfo = [];
global.ChallengeOptionInfo[ChallengeOption.StartingHearts] =	{ Label: "STARTING HEARTS",	Titles: ["4 hearts", "3 hearts", "2 hearts", "1 heart"] };
global.ChallengeOptionInfo[ChallengeOption.HeartsMax] =			{ Label: "MAX HEARTS",		Titles: ["16 hearts", "8 hearts", "6 hearts", "5 hearts"] };
global.ChallengeOptionInfo[ChallengeOption.Defense] =			{ Label: "MAX DEFENSE",		Titles: ["Normal", "Lvl 4 defense max", "Lvl 3 defense max", "Lvl 2 defense max"] };
global.ChallengeOptionInfo[ChallengeOption.Darkness] =			{ Label: "DARKNESS",		Titles: ["Normal", "More dark rooms", "All dark rooms", "No lights, no lamps"] };
global.ChallengeOptionInfo[ChallengeOption.Inventory] =			{ Label: "STARTING INV",	Titles: ["5 slots", "4 slots", "3 slots", "2 slots"] };
global.ChallengeOptionInfo[ChallengeOption.MaxRupees] =			{ Label: "MAX RUPEES",		Titles: ["No Limit", "400 Rupees", "300 Rupees", "200 Rupees"] };
global.ChallengeOptionInfo[ChallengeOption.ShopPrices] =		{ Label: "SHOP PRICES",		Titles: ["Normal prices", "More expensive", "Much more expensive", "5th Avenue"] };
global.ChallengeOptionInfo[ChallengeOption.Enemies] =			{ Label: "ENEMIES",			Titles: ["Normal", "More enemies", "Much more enemies", "I am Death Incarnate!"] };
global.ChallengeOptionInfo[ChallengeOption.Curses] =			{ Label: "CURSES",			Titles: ["Normal", "More curses", "Much more curses", "Curses Galore!"] };

// Menu label and description of each on/off challenge, keyed by Challenges
global.ChallengeInfo = [];
global.ChallengeInfo[Challenges.NoMap] =		{ Label: "NO MAP",			Title: "Map isn't visible" };
global.ChallengeInfo[Challenges.NoFood] =		{ Label: "NO FOOD ITEMS",	Title: "No food items spawned" };
global.ChallengeInfo[Challenges.WallMaster] =	{ Label: "WALL MASTER",		Title: "A Wall Master hunts you" };

global.ChallengeMaxArray_Hearts = [16, 8, 6, 5];
#macro ChallengeMax_Hearts global.ChallengeMaxArray_Hearts[global.ChallengeOptions[ChallengeOption.HeartsMax]]

global.ChallengeMaxArray_Defense = [8, 4, 3, 2];
#macro ChallengeMax_Defense global.ChallengeMaxArray_Defense[global.ChallengeOptions[ChallengeOption.Defense]]

global.ChallengeMaxArray_Rupees = [-1, 400, 300, 200];
#macro ChallengeMax_Rupees global.ChallengeMaxArray_Rupees[global.ChallengeOptions[ChallengeOption.MaxRupees]]

global.ChallengeMaxArray_ShopPrices = [1, 1.5, 2, 2.5];
#macro ChallengeMax_ShopPrices global.ChallengeMaxArray_ShopPrices[global.ChallengeOptions[ChallengeOption.ShopPrices]]

global.ChallengeMaxArray_Curses = [1, 2, 4, 6];
#macro ChallengeMax_Curses global.ChallengeMaxArray_Curses[global.ChallengeOptions[ChallengeOption.Curses]]

#macro ChallengeMax_StartingHearts 4 - global.ChallengeOptions[ChallengeOption.StartingHearts]
#macro ChallengeMax_Inventory 5 - global.ChallengeOptions[ChallengeOption.Inventory]