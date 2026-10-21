
enum Gem{Quartz, Topaz, Turquoise, Citrine, Amethyst, Jade, Diamond, Ruby, Sapphire, Opal}
#macro GemCount 10

global.GemNames = [ 					
					"Quartz",	  //Pink
					"Topaz",	  //Orange
					"Turquoise",  //Cyan
					"Citrine",    //Gold
					"Amethyst",   //Purple
					"Jade",       //Green
					"Diamond",	  //Silver 
					"Ruby",		  //Red
					"Sapphire",   //Blue
					"Opal"		  //Black
					]


function Gem_PickIndex(){
	
	return choose(
					Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,Gem.Quartz,
					Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,Gem.Topaz,
					Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,Gem.Turquoise,
					Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,Gem.Citrine,
					Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,Gem.Amethyst,
					Gem.Jade,Gem.Jade,Gem.Jade,Gem.Jade,Gem.Jade,Gem.Jade,Gem.Jade,Gem.Jade,
					Gem.Diamond,Gem.Diamond,Gem.Diamond,Gem.Diamond,Gem.Diamond,Gem.Diamond,Gem.Diamond,
					Gem.Ruby,Gem.Ruby,Gem.Ruby,Gem.Ruby,Gem.Ruby,Gem.Ruby,
					Gem.Sapphire,Gem.Sapphire,Gem.Sapphire,Gem.Sapphire,Gem.Sapphire,
					Gem.Opal,Gem.Opal,Gem.Opal,Gem.Opal
				);
	
}

function InitGemPrizes(){

	//"Quartz",		0
	//"Topaz",		1
	//"Turquoise",  2
	//"Citrine",    3	
	//"Amethyst",   4
	//"Jade",       5
	//"Diamond",	6
	//"Ruby",		7
	//"Sapphire",   8
	//"Opal"		9

	global.GemPrize[0][0] = {Class : ItemClass.Pop,			Index :  0,						Amount : 2};
	
	global.GemPrize[1][0] = {Class : ItemClass.Food,		Index :  2,						Amount : 2};
	global.GemPrize[1][1] = {Class : ItemClass.MagicLarge,	Index :  0,						Amount : 1};
	
	global.GemPrize[2][0] = {Class : ItemClass.Pop,			Index :  0,						Amount : 3};
	global.GemPrize[2][1] = {Class : ItemClass.Bombs,		Index :  0,						Amount : 10};
	global.GemPrize[2][2] = {Class : ItemClass.Orb,			Index :  Orb.Ice,				Amount : 5};
	
	global.GemPrize[3][0] = {Class : ItemClass.Food,		Index :  4,						Amount : 2};
	global.GemPrize[3][1] = {Class : ItemClass.Arrows,		Index :  0,						Amount : 60};
	global.GemPrize[3][2] = {Class : ItemClass.Rupee,		Index :  0,						Amount : 1};
	global.GemPrize[3][3] = {Class : ItemClass.Orb,			Index :  Orb.Fire,				Amount : 5};

	global.GemPrize[4][0] = {Class : ItemClass.Potion,		Index :  Potion.Antidote,		Amount : 1};
	global.GemPrize[4][1] = {Class : ItemClass.Rupee,		Index :  0,						Amount : 1};
	global.GemPrize[4][2] = {Class : ItemClass.Rupee,		Index :  0,						Amount : 1};
	global.GemPrize[4][3] = {Class : ItemClass.Rupee,		Index :  0,						Amount : 1};
	global.GemPrize[4][4] = {Class : ItemClass.Orb,			Index :  Orb.Fairy,				Amount : 2};
	
	global.GemPrize[5][0] = {Class : ItemClass.Potion,		Index :  Potion.Magic,			Amount : 1};
	global.GemPrize[5][1] = {Class : ItemClass.MagicLarge,	Index :  0,						Amount : 2};
	global.GemPrize[5][2] = {Class : ItemClass.Ring,		Index :  Ring.Bombs,			Amount : 1};
	global.GemPrize[5][3] = {Class : ItemClass.Ring,		Index :  Ring.Arrows,			Amount : 1};
	global.GemPrize[5][4] = {Class : ItemClass.Ring,		Index :  Ring.Health,			Amount : 1};
	global.GemPrize[5][5] = {Class : ItemClass.Ring,		Index :  Ring.Rupees,			Amount : 1};
	
	global.GemPrize[6][0] = {Class : ItemClass.Potion,		Index :  Potion.Milk,			Amount : 1};
	global.GemPrize[6][1] = {Class : ItemClass.BagSlot,		Index :  0,						Amount : 1};
	global.GemPrize[6][2] = {Class : ItemClass.BombBag,		Index :  0,						Amount : 1};
	global.GemPrize[6][3] = {Class : ItemClass.ArrowQuiver,	Index :  0,						Amount : 1};
	global.GemPrize[6][4] = {Class : ItemClass.FoodBag,		Index :	 0,						Amount : 1};
	global.GemPrize[6][5] = {Class : ItemClass.PendantBag,	Index :  0,						Amount : 1};
	global.GemPrize[6][6] = {Class : ItemClass.Bow,			Index :  0,						Amount : 1};
	
	global.GemPrize[7][0] = {Class : ItemClass.Potion,		Index :  Potion.Health,			Amount : 1};
	global.GemPrize[7][1] = {Class : ItemClass.HeartPiece,	Index :  0,						Amount : 1};
	global.GemPrize[7][2] = {Class : ItemClass.Rod,			Index :  Rod.Stone,				Amount : global.MaxRodCharge[Rod.Stone]};
	global.GemPrize[7][3] = {Class : ItemClass.Rod,			Index :  Rod.Fire,				Amount : global.MaxRodCharge[Rod.Fire]};
	global.GemPrize[7][4] = {Class : ItemClass.Rod,			Index :  Rod.Heart,				Amount : global.MaxRodCharge[Rod.Heart]};
	global.GemPrize[7][5] = {Class : ItemClass.Rod,			Index :  Rod.Wealth,			Amount : global.MaxRodCharge[Rod.Wealth]};
	global.GemPrize[7][6] = {Class : ItemClass.GemBag,		Index :  0,						Amount : 1};
	global.GemPrize[7][7] = {Class : ItemClass.Boomerang,	Index :  0,						Amount : 1};
	
	
	global.GemPrize[8][0] = {Class : ItemClass.Potion,		Index :  Potion.HealthMagic,	Amount : 1};
	global.GemPrize[8][1] = {Class : ItemClass.Lamp,		Index :  0,						Amount : 1};
	global.GemPrize[8][2] = {Class : ItemClass.Rod,			Index :  Rod.Ice,				Amount : global.MaxRodCharge[Rod.Ice]};
	global.GemPrize[8][3] = {Class : ItemClass.Rod,			Index :  Rod.Bomb,				Amount : global.MaxRodCharge[Rod.Bomb]};
	global.GemPrize[8][4] = {Class : ItemClass.Gloves,		Index :  0,						Amount : 1};
	global.GemPrize[8][5] = {Class : ItemClass.Tunic,		Index :  0,						Amount : 1};
	global.GemPrize[8][6] = {Class : ItemClass.Shield,		Index :  0,						Amount : 1};
	global.GemPrize[8][7] = {Class : ItemClass.Cape,		Index :  0,						Amount : 1};
	global.GemPrize[8][8] = {Class : ItemClass.Hookshot,	Index :  0,						Amount : 1};
	
	global.GemPrize[9][0] = {Class : ItemClass.Rupee,		Index :  0,						Amount : 1};
	global.GemPrize[9][1] = {Class : ItemClass.Pendant,		Index :  Pendant.Immunity,		Amount : 1};
	global.GemPrize[9][2] = {Class : ItemClass.Pendant,		Index :  Pendant.Direction,		Amount : 1};
	global.GemPrize[9][3] = {Class : ItemClass.Pendant,		Index :  Pendant.Secrets,		Amount : 1};
	global.GemPrize[9][4] = {Class : ItemClass.Pendant,		Index :  Pendant.Wealth,		Amount : 1};
	global.GemPrize[9][5] = {Class : ItemClass.Pendant,		Index :  Pendant.Magic,			Amount : 1};
	global.GemPrize[9][6] = {Class : ItemClass.Pendant,		Index :  Pendant.Revival,		Amount : 1};
	global.GemPrize[9][7] = {Class : ItemClass.Pendant,		Index :  Pendant.Health,		Amount : 1};
	global.GemPrize[9][8] = {Class : ItemClass.Pendant,		Index :  Pendant.Protection,	Amount : 1};
	global.GemPrize[9][9] = {Class : ItemClass.Sword,		Index :  0,						Amount : 1};
	
}

function GemsInPond(_PondInst){
	//Returns gem count in pond
	var _GemCount = 0;
	for(var i = 0; i < GemCount; i++){
		_GemCount += _PondInst.GemsInWater[i];
	}
	
	return _GemCount;
}

function GetGemCombo(_PondInst){
	
	//returns an array of 2 elements for the 2 gems in the pond
	var _GemCount = 0;
	GemCombo = array_create(2);
	for(var i = 0; i < GemCount; i++){
		if(_PondInst.GemsInWater[i] > 0){
			GemCombo[_GemCount++] = i;
			_PondInst.GemsInWater[i]--;
			
			//if there's still a gem of the same type, the decrease i by 1 so the same gem index is used for the combo
			if(_PondInst.GemsInWater[i] > 0) i--;
			
			if(_GemCount == 2){
				//if 1st element is larger than 0th, switch them as there isn't a combo prize where 1st element is larger. See __Gems script for prizes
				if(GemCombo[1] > GemCombo[0]){
					var _Combo0 = GemCombo[1];
					GemCombo[1] = GemCombo[0];
					GemCombo[0] = _Combo0;
				}
				return GemCombo;
			}
		}

	}
	
	return -1;
}