
function Rupee_PickAmount(_From){

	var _Amount = 1;
	
	switch(_From){
			
		default:
			_Amount = choose(1,1,1,1,1,1,1,5,5,5,5,5,5,5,10,10,10,10,20,20);
			break;
		
		case ItemFrom.EnemyTiny:
			_Amount = choose(1, 1, 1, 1, 1, 1, 5, 5, 10);
			break;
			
		case ItemFrom.EnemySmall:
			_Amount = choose(1, 1, 1, 1, 1, 1, 5, 5, 5, 10, 10, 20);
			break;
			
		case ItemFrom.EnemyMedium:
			_Amount = choose(1, 1, 1, 1, 5, 5, 5, 5, 5, 5, 5, 10, 10, 10, 20, 20, 40);
			break;
			
		case ItemFrom.EnemyLarge:
			_Amount = choose(1, 1, 5, 5, 5, 5, 5, 5, 5, 10, 10, 10, 10, 10, 10, 10, 20, 20, 20, 40, 40);
			break;
			
		case ItemFrom.Treasure:
			_Amount = choose(
							1,
							5,5,
							10,10,10,
							20,20,20,20,20,
							25,25,25,25,25,25,25,
							30,30,30,30,30,30,30,30,30,
							40,40,40,40,40,40,40,40,40,40,40,40,
							50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,
							60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,
							75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,75,
							80,80,80,80,80,80,80,80,80,80,80,80,80,
							100,100,100,100,100,100,100,100,
							125,125,125,125,
							150,150,
							choose(150,150,150,175,175,175,200,200,225,250,275,300)			
						)
			
			
			if(global.Level.Index <= DungeonLevel.CastleBasement && _Amount > 150) _Amount = 150; //prevent super large rupees to appear on first level
			break;
			
		case ItemFrom.LargeTreasure:
			_Amount = choose(125, 150, 175, 200, 225, 250);
			break;
		
		case ItemFrom.KinstoneGreen:
			_Amount = choose(60, 75, 80);
			break;
		case ItemFrom.KinstoneBlue:
			_Amount = choose(80, 100);
			break;
		case ItemFrom.KinstoneRed:
			_Amount = choose(100, 125, 150);
			break;
		case ItemFrom.KinstoneGold:
			_Amount = choose(150, 150, 150, 150, 175, 175, 175, 200, 200, 225, 250, 275, 300);
			break;
			
		case ItemFrom.RupeeCane:
			_Amount = 1;
			break;
		
	}
	
	return _Amount
	
}

function Rupee_GetIndex(_Amount){

	if(_Amount < 5)								return 0; //green
	else if(_Amount >= 5 && _Amount < 20)		return 1; //blue
	else if(_Amount >= 20 && _Amount < 60)		return 2; //red
	else if(_Amount >= 60 && _Amount < 100)		return 3; //purple
	else if(_Amount >= 100 && _Amount < 200)	return 4; //silver
	else if(_Amount >= 200)						return 5; //gold
	
}

function Rupee_Init(_Amount){
	
	Amount = _Amount;
	ShowAmount = (Amount > 5);
	Index = Rupee_GetIndex(_Amount);
	
}

enum RupeeGroupSize{
	_1x1,
	_5x5,
	_3x7,	
}

function RupeePatterns_Init(){
	
	global.RupeePatternSizeID[1][1] = RupeeGroupSize._1x1;
	global.RupeePatternSizeID[5][5] = RupeeGroupSize._5x5;
	global.RupeePatternSizeID[3][7] = RupeeGroupSize._3x7;

	var i = 0;

	global.RupeePatterns[RupeeGroupSize._1x1, 0] = ["0"];
	
	//some patterns are duplicated to increase odds of getting that pattern.
	
#region 5x5

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".000.",
									"00000",
									"00000",
									"00000",
									".000."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"00000",
									"00000",
									"00000",
									"00000",
									"00000"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".000.",
									".000.",
									".000.",
									".000.",
									".000."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									"00000",
									"00000",
									"00000",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									".000.",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									".000.",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									".000.",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0.0.0",
									".0.0.",
									"0.0.0",
									".0.0.",
									"0.0.0"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".0.0.",
									"0.0.0",
									".0.0.",
									"0.0.0",
									".0.0."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"..0..",
									"..0..",
									"00000",
									"..0..",
									"..0.."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0.0.0",
									".000.",
									"00000",
									".000.",
									"0.0.0"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0.0.0",
									"0.0.0",
									"0.0.0",
									"0.0.0",
									"0.0.0"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"00000",
									".....",
									"00000",
									".....",
									"00000"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"00000",
									".000.",
									"00000",
									".000.",
									"00000"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0.0.0",
									"00000",
									"00000",
									"00000",
									"0.0.0"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									"00000",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									"00000",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									".000.",
									"00000",
									".000.",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"..0..",
									".000.",
									".000.",
									".000.",
									"..0.."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"..0..",
									".000.",
									".000.",
									".000.",
									"..0.."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"..0..",
									".000.",
									".000.",
									".000.",
									"..0.."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".000.",
									"00000",
									".000.",
									"00000",
									".000."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0...0",
									"00000",
									".000.",
									"00000",
									"0...0"];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									".....",
									"00000",
									".000.",
									"00000",
									"....."];

	global.RupeePatterns[RupeeGroupSize._5x5, i++] = [
									"0...0",
									".000.",
									".000.",
									".000.",
									"0...0"];

									

#endregion


#region 3x7
	
	i = 0;
	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									"000",
									"000",
									"000",
									"000",
									"000",
									".0."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"000",
									"000",
									"000",
									"000",
									"000",
									"000",
									"000"];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"0.0",
									"0.0",
									"0.0",
									"0.0",
									"0.0",
									"0.0",
									"0.0"];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"0.0",
									".0.",
									"0.0",
									".0.",
									"0.0",
									".0.",
									"0.0"];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									"0.0",
									".0.",
									"0.0",
									".0.",
									"0.0",
									".0."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									"000",
									"000",
									"000",
									"000",
									"000",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									".0.",
									"000",
									"000",
									"000",
									".0.",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									".0.",
									"000",
									"000",
									"000",
									".0.",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									".0.",
									"000",
									"000",
									"000",
									".0.",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"000",
									"000",
									"...",
									"...",
									"...",
									"000",
									"000"];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									"000",
									".0.",
									"...",
									".0.",
									"000",
									".0."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									".0.",
									".0.",
									".0.",
									".0.",
									".0.",
									".0."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"000",
									"...",
									"000",
									"...",
									"000",
									"...",
									"000"];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									"000",
									"...",
									"000",
									"...",
									"000",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									"000",
									"...",
									"000",
									"...",
									"000",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									"...",
									"000",
									"000",
									"000",
									"...",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									"...",
									"...",
									"000",
									"000",
									"000",
									"...",
									"..."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									".0.",
									".0.",
									"000",
									".0.",
									".0.",
									".0."];

	global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
									".0.",
									".0.",
									".0.",
									"000",
									".0.",
									".0.",
									".0."];

	//global.RupeePatterns[RupeeGroupSize._3x7, i++] = [
	//								"...",
	//								"...",
	//								"...",
	//								"...",
	//								"...",
	//								"...",
	//								"..."];


#endregion

}