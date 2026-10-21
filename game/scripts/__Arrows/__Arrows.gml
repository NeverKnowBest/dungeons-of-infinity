function Arrows_PickAmount(_From){

	switch(_From){
			
		case ItemFrom.Pot:
		case ItemFrom.PotSimple:
		case ItemFrom.EnemySmall:
			return choose(1,2,2,3,3,3,4,4,4,5,5,5,5,8,10);
			break;

		case ItemFrom.EnemyTiny:
			return choose(1, 1, 1, 2, 2, 3, 3, 4, 5);
			break;
			
		case ItemFrom.EnemyMedium:
			return choose(3, 4, 4, 5, 5, 5, 5, 8, 8, 10, 10, 10);
			break;
			
		case ItemFrom.EnemyLarge:
			return choose(5, 5, 8, 8, 10, 10, 10, 10, 20);
			break;
			
		case ItemFrom.Treasure:
		case ItemFrom.KinstoneGreen:
			return choose(15,20,20,25,25,30,30,40);
			break;
			
		case ItemFrom.Shop:
		case ItemFrom.WeaponStore:
			return choose(20,25,30,40,50);
			break;
		
	}
	
	return 10;
	
}