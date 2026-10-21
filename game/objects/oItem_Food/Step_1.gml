if(InitWaterSpr){
	switch(Index){
		
		default:
			InWaterSprW = 18;
			break;
		
		case Food.Candy:
		case Food.Carrot:
			InWaterSprW = 16;
			InWaterSprXOffset = -2;
			break;
		
		case Food.Corn:
		case Food.Lollypop:
		case Food.Drumstick:
		case Food.Popsicle:
		case Food.IceCreamBar:
			InWaterSprW = 14;
			InWaterSprXOffset = -2;			
			break;

		case Food.EnergyBar:
		case Food.LemonTart:
			InWaterSprW = 16;
			InWaterSprXOffset = -1;
			break;
			
		case Food.Mushroom:
			InWaterSprW = 16;
			break;
		
		case Food.Spaghetti:
			InWaterSprW = 20;
			break;
		
		case Food.Potato:
		case Food.Chicken:
		case Food.Sandwich:
		case Food.HeroSandwich:
			InWaterSprXOffset = -1;
			break;
		
		case Food.CakeBrown:
		case Food.CakePink:
			InWaterSprW = 20;
			InWaterSprYOffset = -5;		
			break;
			
		case Food.CakeSlicePink:
		case Food.CakeSliceBrown:
			InWaterSprYOffset = -5;			
			InWaterSprXOffset = 2;	
			break;
	}
	InitWaterSpr = false;
}