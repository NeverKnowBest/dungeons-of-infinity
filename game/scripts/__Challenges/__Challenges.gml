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
#macro ChallengeOptionCount 9

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
#macro ChallengeCount 3


global.ChallengeOptionTitles = array_create(ChallengeOptionCount);

global.ChallengeOptionTitles[ChallengeOption.StartingHearts] = ["4 hearts", "3 hearts", "2 hearts", "1 heart"];
global.ChallengeOptionTitles[ChallengeOption.HeartsMax] = ["16 hearts", "8 hearts", "6 hearts", "5 hearts"];
global.ChallengeOptionTitles[ChallengeOption.Defense] = ["Normal", "Lvl 4 defense max", "Lvl 3 defense max", "Lvl 2 defense max"];
global.ChallengeOptionTitles[ChallengeOption.Darkness] = ["Normal", "More dark rooms", "All dark rooms", "No lights, no lamps"];
global.ChallengeOptionTitles[ChallengeOption.Inventory] = ["5 slots", "4 slots", "3 slots", "2 slots"];
global.ChallengeOptionTitles[ChallengeOption.MaxRupees] = ["No Limit", "400 Rupees", "300 Rupees", "200 Rupees"];
global.ChallengeOptionTitles[ChallengeOption.ShopPrices] = ["Normal prices", "More expensive", "Much more expensive", "5th Avenue"];
global.ChallengeOptionTitles[ChallengeOption.Enemies] = ["Normal", "More enemies", "Much more enemies", "I am Death Incarnate!"];
global.ChallengeOptionTitles[ChallengeOption.Curses] = ["Normal", "More curses", "Much more curses", "Curses Galore!"];


global.ChallengeTitles = array_create(ChallengeCount);

global.ChallengeTitles[Challenges.NoMap] = "Map isn't visible";
global.ChallengeTitles[Challenges.NoFood] = "No food items spawned";
global.ChallengeTitles[Challenges.WallMaster] = "A Wall Master hunts you";

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