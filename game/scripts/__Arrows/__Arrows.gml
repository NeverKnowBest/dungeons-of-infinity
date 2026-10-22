function Arrows_PickAmount(_From){

	switch(_From){
			
		case ItemFrom.Pot:
		case ItemFrom.PotSimple:
		case ItemFrom.EnemySmall:
			return choose(1,2,2,3,3,3,4,4,4,5,5,5,5,8,10);

		case ItemFrom.EnemyTiny:
			return choose(1, 1, 1, 2, 2, 3, 3, 4, 5);
			
		case ItemFrom.EnemyMedium:
			return choose(3, 4, 4, 5, 5, 5, 5, 8, 8, 10, 10, 10);
			
		case ItemFrom.EnemyLarge:
			return choose(5, 5, 8, 8, 10, 10, 10, 10, 20);
			
		case ItemFrom.Treasure:
		case ItemFrom.KinstoneGreen:
			return choose(15,20,20,25,25,30,30,40);
			
		case ItemFrom.Shop:
		case ItemFrom.WeaponStore:
			return choose(20,25,30,40,50);
		
	}
	
	return 10;
	
}