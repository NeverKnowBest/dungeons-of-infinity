enum Food{Cherries, Blueberries, Strawberry, Kiwi, Candy, Lollypop, Mushroom, Apple, Orange, Pear, 
		  Banana, Carrot, Potato, Avocado, Corn, Watermelon, Bananas, Nuts, Egg, Cookie, Milk,
		  ChocolateMilk, Muffin, Croissant, Cheese, Drumstick, DonutPink, DonutBrown, Popsicle, IceCreamBar,
		  EnergyBar, LemonTart, CakeSlicePink, CakeSliceBrown, BaconEggs, Sushi, Fish,
		  Sandwich, Broth, Soup, Salad, Ramen, Chili, Pizza, HeroSandwich,
		  Burger, Spaghetti, Ham, CakePink, CakeBrown, Chicken, GoldenEgg}
		  
global.FoodNames = ["Cherries", "Blueberries", "Strawberry", "Kiwi", "Candy", "Lollypop", "Mushroom", "Apple", "Orange", "Pear", "Banana", 
					"Carrot", "Potato", "Avocado", "Corn", "Watermelon", "Bananas", "Nuts", "Egg", "Cookie", "Milk",
					"Chocolate Milk", "Muffin", "Croissant", "Cheese", "Drumstick", "Pink Donut", "Chocolate Donut", "Popsicle", "Ice Cream Bar",
					"Energy Bar", "Lemon Tart", "Strawberry Cake Slice", "Chocolate Cake Slice", "Bacon & Eggs", "Sushi", "Fish", 
					"Sandwich", "Broth", "Tomato Soup", "Salad", "Ramen", "Chili", "Pizza", "Hero Sandwich",
					"Burger", "Spaghetti", "Ham", "Strawberry Cake", "Chocolate Cake", "Chicken", "Golden Egg"];

global.FoodNames_Plural =	["Cherries", "Blueberries", "Strawberries", "Kiwis", "Candies", "Lollypops", "Mushrooms", "Apples", "Oranges", "Pears", "Bananas", 
							"Carrots", "Potatoes", "Avocados", "Corns", "Watermelons", "Bananas", "Nuts", "Eggs", "Cookies", "Milks",
							"Chocolate Milks", "Muffins", "Croissants", "Cheeses", "Drumsticks", "Pink Donuts", "Chocolate Donuts", "Popsicles", "Ice Cream Bars",
							"Energy Bars", "Lemon Tarts", "Strawberry Cake Slices", "Chocolate Cake Slices", "Bacon & Eggs", "Sushi", "Fish", 
							"Sandwiches", "Broths", "Tomato Soups", "Salads", "Ramen", "Chili", "Pizzas", "Hero Sandwiches",
							"Burgers", "Spaghetti", "Hams", "Strawberry Cakes", "Chocolate Cakes", "Chickens", "Golden Eggs"];
					
global.PopNames = ["Popsi", "Kitty Cola", "Gator Gush", "Grape Rush", "Alien NRG", "Mangoba", "Pinky Drinky", 
					"Blue Goo", "Power Thirst", "Crantastic", "Omega Juice", "Berry Blast", "Brute Beer", 
					"Orange Burst", "Tropic Sip", "Creamy Crush", "Dr.Drank", "Island Fizz", "Melon Slurp", 
					"Bug Chug", "Kwench", "Burple", "Brite", "Quick Buzz", "Buzz Ale", "Korok Delight", "Minish Mix"];
					
global.PopFlavors = array_length(global.PopNames);


#macro PopHearts 3
#macro GoldenEggRupees 200

global.FoodClasses = [  [Food.Cherries, Food.Blueberries, Food.Strawberry, Food.Kiwi, Food.Mushroom, Food.Candy, Food.Lollypop], //2 hearts
						[Food.Apple, Food.Orange, Food.Pear, Food.Banana, Food.Carrot, Food.Potato, Food.Avocado, Food.Nuts, Food.Egg, Food.Cookie, Food.Milk, Food.Broth], //3 hearts
						[Food.Bananas, Food.Watermelon, Food.Corn, Food.ChocolateMilk, Food.Muffin, Food.Croissant, Food.Cheese, Food.Drumstick, Food.DonutPink, Food.DonutBrown, Food.Popsicle, Food.IceCreamBar, Food.LemonTart, Food.Soup, Food.Salad], //4 hearts
						[Food.EnergyBar, Food.CakeSlicePink, Food.CakeSliceBrown, Food.BaconEggs, Food.Sushi, Food.Fish, Food.Sandwich, Food.Ramen, Food.Chili, Food.Pizza], //5 hearts
						[Food.HeroSandwich, Food.Burger, Food.Spaghetti, Food.Ham, Food.CakePink, Food.CakeBrown, Food.Chicken] //6 hearts
					 ]

function FoodHearts(_ItemIndex){
	
	//returns the heart value for given food index.
	//Searches the food classes array until it finds it, then it's 2 hearts plus class index the food is part of. Possible heart values: (2, 3, 4, 5, 6)
	
	switch(_ItemIndex){
		default:
			for(var _FoodClassIndex = 0; _FoodClassIndex < 5; _FoodClassIndex++){
				var _FoodArray = global.FoodClasses[_FoodClassIndex];
				if(array_contains(_FoodArray, _ItemIndex)) return 2 + _FoodClassIndex;		
			}
			break;
			
		case Food.GoldenEgg:
			return ChallengeMax_Hearts
	}
	
}

function Food_PickItem(_FoodClassIndex){
	
	var _FoodArray = global.FoodClasses[_FoodClassIndex];
	var _FoodItems = array_length(_FoodArray);
	return global.FoodClasses[_FoodClassIndex][irandom(_FoodItems - 1)];

}

function Food_PickClass(_From){
	
	switch(_From){
		
		case ItemFrom.Treasure:
			return choose(1,2,3,4);
			
		case ItemFrom.Shop:
		case ItemFrom.FoodStore:
			return choose(1,2,2,3,3,4,4);

		case ItemFrom.KinstoneGreen:
			return choose(2,3);
		
		case ItemFrom.KinstoneBlue:
			return choose(3,4);
		
		//in case fail safe food item is generated
		case ItemFrom.KinstoneRed:
		case ItemFrom.KinstoneGold:
		case ItemFrom.LargeTreasure:
			return 4;
		
		case ItemFrom.Pot:
		case ItemFrom.EnemyTiny:
		case ItemFrom.EnemySmall:
			return 0;
		
		case ItemFrom.EnemyMedium:
			return choose(0,0,0,0,1);
		
		case ItemFrom.EnemyLarge:
			return choose(0,0,1,1,2);
	}
	
	return choose(0,0,1);
	
}
