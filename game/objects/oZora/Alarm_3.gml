Talking = true;

var _Gem1 = GemCombo[0];
var _Gem2 = GemCombo[1];
GemPrize = global.GemPrize[_Gem1][_Gem2];


//some items are not allowed based on max level, challenges, etc, replace with rupees

var _Rupees = false;

switch(global.ItemData[GemPrize.Class].Type){
	case ItemType.Inv_Bool:
	case ItemType.Inv_Chrg:
		if(global.Inventory.ItemData[GemPrize.Class].Owns[GemPrize.Index]) _Rupees = true;
		break;
	
	case ItemType.Inv_Upg:
		if(global.Inventory.ItemData[GemPrize.Class].Index >= global.Inventory.ItemData[GemPrize.Class].Index_Max) _Rupees = true;
		break;
	
}

switch(GemPrize.Class){
	
	case ItemClass.Rupee:
		_Rupees = true;
		break;	
		
	case ItemClass.HeartPiece:
		if(global.Inventory.ItemData[ItemClass.HeartPiece].Amount >= ChallengeMax_Hearts) _Rupees = true; 
		break;
		
	case ItemClass.Lamp:
		if(global.ChallengeOptions[ChallengeOption.Darkness] == ChallengeOption_Darkness.NoLights) _Rupees = true; 
		break;
		
	case ItemClass.Pendant:
		switch(GemPrize.Index){
			case Pendant.Direction:
				if(global.Challenges[Challenges.NoMap]) _Rupees = true; 
				break;
				
			case Pendant.Immunity:
				if(global.ChallengeOptions[ChallengeOption.Curses] > 0) _Rupees = true; 
				break;
			
		}
		break;
		
	case ItemClass.BagSlot:
		if(Inventory_FindLockedSlot() == -1) _Rupees = true; 
		break;
		
	case ItemClass.Sword:
		if(global.Swordless) _Rupees = true;
		break;
		
	case ItemClass.Tunic:
	case ItemClass.Shield:
		if(MaxDefensePointsThatExist() >= ChallengeMax_Defense) _Rupees = true
		break;
		
	case ItemClass.Gloves:
		if(global.Inventory.ItemData[ItemClass.Gloves].Index == -1 && MaxDefensePointsThatExist() >= ChallengeMax_Defense) _Rupees = true;
		break;

	case ItemClass.Food:
	case ItemClass.Pop:
	case ItemClass.FoodBag:
		if(global.Challenges[Challenges.NoFood]) _Rupees = true;
		break;
				
	case ItemClass.Potion:
		if(global.Challenges[Challenges.NoFood] && GemPrize.Index == Potion.Milk) _Rupees = true;
		break;
					

}

if(_Rupees){
	
	var _MinAmount = max((_Gem1 + 1) * (_Gem2 + 1), 25);
	var _MaxAmount = _MinAmount * 3;
	var _Amount = irandom_range(_MinAmount, _MaxAmount);
	var _RupeeAmount = round(_Amount / 5) * 5;
	GemPrize = {Class : ItemClass.Rupee, Index : 0, Amount : _RupeeAmount}
	
}


PrizeClass = GemPrize.Class;
PrizeIndex = GemPrize.Index;


switch(PrizeClass){
	case ItemClass.Food:
		PrizeIndex = Food_PickItem(PrizeIndex);	//using prize index for the food class, then PrizeIndex is the actual food index
		break;
	case ItemClass.Pop:
		PrizeIndex = irandom(global.PopFlavors - 1);		
		break;

}

MsgBox("Thank you for the gems.\\Here's an item.");