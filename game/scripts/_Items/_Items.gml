

enum Item {ArrowQuiver, Arrows, Bag, Book, BombBag, Bombs, Boomerang, Bow, Cape, Compass, Food, Gloves, Heart, HeartPiece, Hookshot, Key, MasterKey, SpecialKey, Kinstone,
		   Lamp, Letter, Magic, MagicLarge, Map, Medallion, Mirror, MoonPearl, Mushroom, Orb, Pendant, Pop, Potion, Powder, Rod, Rupee, Shield, Skill, Stopwatch, Sword, Treasure, Tunic}

//boolean:(Compass, Map, MoonPearl...) , single:(heart, rupee..) , SingleInv:(Arrows, Bombs), Multiple:(Potion, food..) , Upgradeable:(Sword, Tunic, Gloves..)
enum ItemType {Boolean, Single, SingleInv, Multiple, Upgradeable} 

enum ItemFrom {Pot, PotSimple, Treasure, TreasureRupees, LargeTreasure, Shop, Enemy, Inventory, KinstoneGreen, KinstoneBlue, KinstoneRed, KinstoneGold, WeaponStore, TreasureStore}

enum ItemSpawnType {None, DropShort, DropHigh, DropVeryHigh, DropScatter, DropSky, DropInventory, DropTreasure, Float}



#macro RandomItem -99


global.Font_ItemValues = font_add_sprite_ext(sFont_ItemValues, "0123456789", true, 0);

//Stores shop and dropped items that exist in the current dungeon level that can't have duplicates.
//Example, if a shop has a level 3 sword, or there's a dropped map somewhere, then those items should be in this list and shouldn't be picked for opened treasures
//Clear this list at the beginning of each level init
global.NonDuplicatableItemsThatExist = ds_grid_create(2, 0); 

//stores any heart pieces that exist, so that none get created if after adding all existing pieces, and adding the value to Link's health, would go over the max heart limit.
global.HeartPiecesThatExist = 0; 

function ItemDataInit(_ObjectIndex, _Type, _LimitMin, _LimitStart, _ProbPot, _ProbPotSimple, _ProbTreasure, _ProbLargeTreasure, _ProbShop, _ProbKinstoneGreen, _ProbKinstoneBlue, _ProbKinstoneRed, _ProbKinstoneGold, _ProbWeaponStore, _ProbTreasureStore) {
	
	global.ItemData[_ObjectIndex] = {};
	
	
	switch(_ObjectIndex){
		default: global.ItemData[_ObjectIndex][$ "Indexes"] = 1; break;
		case oItem_Bag:
		case oItem_Food:		
		case oItem_Gloves:			
		case oItem_Kinstone:
		case oItem_Lamp:
		case oItem_Orb:
		case oItem_Pendant:
		case oItem_Pop:
		case oItem_Potion:
		case oItem_Rod:
		case oItem_Shield:
		case oItem_Skill:
		case oItem_Sword:
		case oItem_Tunic:
			global.ItemData[_ObjectIndex][$ "Indexes"] = sprite_get_number(object_get_sprite(_ObjectIndex));
			break;
	}
	
			
	global.ItemData[_ObjectIndex][$ "ProbIndex_Pot"] = _ProbPot;
	global.ItemData[_ObjectIndex][$ "ProbIndex_PotSimple"] = _ProbPotSimple;
	global.ItemData[_ObjectIndex][$ "ProbIndex_Treasure"] = _ProbTreasure;
	global.ItemData[_ObjectIndex][$ "ProbIndex_LargeTreasure"] = _ProbLargeTreasure;
	global.ItemData[_ObjectIndex][$ "ProbIndex_Shop"] = _ProbShop;
	global.ItemData[_ObjectIndex][$ "ProbIndex_KinstoneGreen"] = _ProbKinstoneGreen;
	global.ItemData[_ObjectIndex][$ "ProbIndex_KinstoneBlue"] = _ProbKinstoneBlue;
	global.ItemData[_ObjectIndex][$ "ProbIndex_KinstoneRed"] = _ProbKinstoneRed;
	global.ItemData[_ObjectIndex][$ "ProbIndex_KinstoneGold"] = _ProbKinstoneGold;
	global.ItemData[_ObjectIndex][$ "ProbIndex_WeaponStore"] = _ProbWeaponStore;
	global.ItemData[_ObjectIndex][$ "ProbIndex_TreasureStore"] = _ProbTreasureStore;


	
	//Have to do these manually, used to be function arguments but GM only allows 16 args so I ran out

	//Inventory slots
	switch(_ObjectIndex){
		
		
		default: global.ItemData[_ObjectIndex][$ "UsesInvSlot"] = true; break;
		
		//items that don't take up a slot
		case oItem_Bag:
		case oItem_Heart:
		case oItem_HeartPiece:
		case oItem_Key:
		case oItem_Magic:
		case oItem_Rupee:
		case oItem_Stopwatch:
		case oItem_Treasure:
		case oItem_ArrowQuiver:
		case oItem_BombBag:
		case oItem_Book:
		case oItem_Key_Special:
		case oItem_Mirror:
		case oItem_Mushroom:
			global.ItemData[_ObjectIndex][$ "UsesInvSlot"] = false; 
			break;
	}
	

	//If item can be used from the inventory(potion, food, etc).
	switch(_ObjectIndex){
		default: global.ItemData[_ObjectIndex][$ "Useable"] = false; break;
		case oItem_Food:
		case oItem_Magic_Large:
		case oItem_Orb:
		case oItem_Potion:
		case oItem_Pop:
			global.ItemData[_ObjectIndex][$ "Useable"] = true; break;
	}
	//If item can be equiped from the inventory (hookshot, potion, etc)
	switch(_ObjectIndex){
		default: global.ItemData[_ObjectIndex][$ "CanEquip"] = false; break;
		case oItem_Bombs:
		case oItem_Boomerang:
		case oItem_Bow:
		case oItem_Cape:
		case oItem_Food:
		case oItem_Hookshot:
		case oItem_Magic_Large:
		case oItem_Medallion:
		case oItem_Orb:
		case oItem_Potion:
		case oItem_Pop:
		case oItem_Powder:
		case oItem_Rod:
			global.ItemData[_ObjectIndex][$ "CanEquip"] = true; break;
	}


	//The Limiter variables prevent certain items from appearing in treasures. Once one of those items
	//get collected, the corresponding variable has a number added, let's say 10.
	//Every treasure that is collected these get counted down by 1.
	//If the item that is picked is at 0, then it's allowed. If not, then don't pick that item.
	//This prevents, let's say, a pendant being collected in a treasure right after getting another one.
	global.ItemData[_ObjectIndex][$ "LimitMin"] = _LimitMin; //the min amount of limitcount. Some items need more than others
	global.ItemData[_ObjectIndex][$ "LimitCount"] = _LimitStart;//Set the limit count to _LimitStart at the start of the game. This prevents rare items of being collected right away
	
	global.ItemData[_ObjectIndex][$ "Type"] = _Type;
	switch(_Type){
		case ItemType.Boolean:
			global.ItemData[_ObjectIndex][$ "Owns"] = array_create(global.ItemData[_ObjectIndex].Indexes, false);			
			break;
		
		case ItemType.Upgradeable: 
			
			switch(_ObjectIndex){
				
				//these upgradeable items start at index 0 since Link starts with them and can't get rid of them
				case oItem_Bag:
				case oItem_Tunic:
				case oItem_Lamp:
					global.ItemData[_ObjectIndex][$ "Index_Min"] = 0;
					break;
					
				default: global.ItemData[_ObjectIndex][$ "Index_Min"] = -1; break;	
			}
			
			global.ItemData[_ObjectIndex][$ "Index"] = global.ItemData[_ObjectIndex][$ "Index_Min"];
			
			global.ItemData[_ObjectIndex][$ "Index_Max"] = global.ItemData[_ObjectIndex].Indexes - 1;
			
			break;

	}

	
}

enum ItemProb {_0, _001, _0025, _005, _01, _015, _02, _025, _03, _035, _04, _045, _05, _055, _06, _065, _07, _075, _08, _085, _09, _095, _1, Always} //always is temp for testing

function Items_InitData(){

	//For places that need to iterate through all item types.
	//Another way to get the object index is with the enum name of the item: global.ItemObjIndexList[Item.Boots] : returns oItem_Boots.
	//These have to be in the same order as enum Item
	global.ItemObjIndexList = ds_list_create();
	ds_list_add(global.ItemObjIndexList, oItem_ArrowQuiver, oItem_Arrows, oItem_Bag, oItem_Book, oItem_BombBag, oItem_Bombs, oItem_Boomerang, oItem_Bow, oItem_Cape, oItem_Compass, oItem_Food, oItem_Gloves, 
										oItem_Heart, oItem_HeartPiece, oItem_Hookshot, oItem_Key, oItem_Key_Master, oItem_Kinstone, oItem_Lamp, oItem_Letter,
										oItem_Magic, oItem_Magic_Large, oItem_Map, oItem_Medallion, oItem_MoonPearl, oItem_Orb, oItem_Pendant, oItem_Pop, oItem_Potion, oItem_Rod,
										oItem_Rupee, oItem_Shield, oItem_Skill, oItem_Stopwatch, oItem_Sword, oItem_Treasure, oItem_Tunic);
	global.ItemObjIndexes = ds_list_size(global.ItemObjIndexList);
	
	
	global.Probs = [0, 0.01, 0.025, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 100000];

															//	 Limit	Limit	Pot Prob,	 Pot Simple Prob	Treasure Prob,	Large Treasure, Shop Prob,		KSGreenProb	   KSBlueProb		KSRedProb		KSGoldProb		WeaponStore		TreasureStore
															//   Min	Start														Prob
	ItemDataInit(oItem_ArrowQuiver,		ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._065,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Arrows,			ItemType.SingleInv,		2,		0,		ItemProb._035,	ItemProb._035,	ItemProb._075,	ItemProb._0,	ItemProb._08,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Bag,				ItemType.Upgradeable,	12,		12,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_BombBag,			ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._065,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Bombs,			ItemType.SingleInv,		2,		0,		ItemProb._025,	ItemProb._025,	ItemProb._07,	ItemProb._0,	ItemProb._075,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Boomerang,		ItemType.Boolean,		10,		5,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._065,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Bow,				ItemType.Boolean,		10,		2,		ItemProb._0,	ItemProb._0,	ItemProb._02,	ItemProb._1,	ItemProb._065,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Cape,			ItemType.Boolean,		10,		15,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._05,	ItemProb._0,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Compass,			ItemType.Boolean,		3,		0,		ItemProb._0,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._075,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Food,			ItemType.Multiple,		4,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._075,	ItemProb._0,	ItemProb._08,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Gloves,			ItemType.Upgradeable,	8,		8,		ItemProb._0,	ItemProb._0,	ItemProb._005,	ItemProb._1,	ItemProb._075,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Heart,			ItemType.Single,		0,		0,		ItemProb._075,	ItemProb._075,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_HeartPiece,		ItemType.Single,		5,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._06,	ItemProb._1,	ItemProb._08,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Hookshot,		ItemType.Boolean,		10,		10,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._06,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Key,				ItemType.Single,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._04,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Key_Master,		ItemType.Boolean,		20,		20,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._01,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._02);
	ItemDataInit(oItem_Kinstone,		ItemType.Multiple,		5,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._075,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Lamp,			ItemType.Upgradeable,	15,		10,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._075,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Magic,			ItemType.Single,		0,		0,		ItemProb._07,	ItemProb._07,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Magic_Large,		ItemType.Multiple,		3,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._075,	ItemProb._0,	ItemProb._075,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Map,				ItemType.Boolean,		3,		0,		ItemProb._0,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._075,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_MoonPearl,		ItemType.Boolean,		20,		20,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._01,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._02);
	ItemDataInit(oItem_Orb,				ItemType.Multiple,		4,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._07,	ItemProb._0,	ItemProb._065,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._1);
	ItemDataInit(oItem_Pendant,			ItemType.Boolean,		8,		6,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._08,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Potion,			ItemType.Multiple,		4,		0,		ItemProb._0,	ItemProb._0,	ItemProb._065,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Pop,				ItemType.Multiple,		4,		0,		ItemProb._0025,	ItemProb._0,	ItemProb._075,	ItemProb._0,	ItemProb._075,	ItemProb._1,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);	
	ItemDataInit(oItem_Rod,				ItemType.Boolean,		10,		15,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._06,	ItemProb._0,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Rupee,			ItemType.Single,		1,		0,		ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Shield,			ItemType.Upgradeable,	10,		6,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Stopwatch,		ItemType.Single,		0,		0,		ItemProb._005,	ItemProb._005,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Sword,			ItemType.Upgradeable,	10,		8,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Skill,			ItemType.Boolean,		8,		8,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._075,	ItemProb._0,	ItemProb._05,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	ItemDataInit(oItem_Treasure,		ItemType.Single,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._1);
	ItemDataInit(oItem_Tunic,			ItemType.Upgradeable,	8,		8,		ItemProb._0,	ItemProb._0,	ItemProb._015,	ItemProb._1,	ItemProb._08,	ItemProb._0,	ItemProb._0,	ItemProb._1,	ItemProb._1,	ItemProb._1,	ItemProb._0);
	
	//Village items
	ItemDataInit(oItem_Book,			ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Key_Special,		ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Letter,			ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Medallion,		ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Mirror,			ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Mushroom,		ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);
	ItemDataInit(oItem_Powder,			ItemType.Boolean,		0,		0,		ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0,	ItemProb._0);

	global.ProbList = ds_list_create();
	global.ProbListExclude = ds_list_create();
	
}


function Item_Name(_ObjIndex, _ItemIndex){
	
	switch(_ObjIndex){

		case oItem_ArrowQuiver: return "Arrow Quiver";
		case oItem_Arrows: return "Arrows";
		case oItem_Bag: return "Lvl " + string(_ItemIndex + 1) + " Inventory Bag";
		case oItem_BombBag: return "Bomb Bag";
		case oItem_Bombs: return "Bombs";
		case oItem_Boomerang: return "Boomerang";
		case oItem_Bow: 
			switch(_ItemIndex){
				case 0:	return "Wooden Bow";
				case 1:	return "Silver Bow";
				case 2:	return "Golden Bow";
			}
			break;
		case oItem_Cape: return "Magic Cape";
		case oItem_Compass: return "Compass";
		case oItem_Food: return global.FoodNames[_ItemIndex];
		case oItem_Gloves: return "Lvl " + string(_ItemIndex + 1) + " Power Gloves";
		case oItem_HeartPiece: return "Heart Container";
		case oItem_Hookshot: return "Hookshot";	
		case oItem_Key: return "Extra Key";
		case oItem_Key_Master: return "Master Key";
		case oItem_Kinstone:
			switch(_ItemIndex){
				case 0:	return "Green Kinstone Piece";
				case 1:	return "Blue Kinstone Piece";
				case 2:	return "Red Kinstone Piece";
				case 3:	return "Gold Kinstone Piece";
			}
			break;
		case oItem_Lamp: 
			switch(_ItemIndex){
				case 1:	return "Basic Lamp";
				case 2:	return "Deluxe Lamp";
				case 3:	return "Lamp Master 3000";
			}
			break;
		case oItem_Magic: return "Small Magic Refill";
		case oItem_Magic_Large: return "Large Magic Refill";
		case oItem_Map: return "Map";
		case oItem_MoonPearl: return "Moon Pearl";
		case oItem_Orb: return global.OrbNames[_ItemIndex] + " Orb";
		case oItem_Pendant: return global.PendantNames[_ItemIndex];
		case oItem_Pop: return "Can of " + global.PopNames[_ItemIndex];
		case oItem_Potion: return global.PotionNames[_ItemIndex];
		case oItem_Rod: return global.RodNames[_ItemIndex];
		case oItem_Shield: return "Lvl " + string(_ItemIndex + 1) + " Shield";
		case oItem_Skill: return global.SkillNames[_ItemIndex] + " Sword Skill";
		
		case oItem_Sword: 
			switch(_ItemIndex){
				case Swords.Basic: return "Basic Sword";
				case Swords.Steel: return "Steel Sword";
				case Swords.Long: return "Long Sword";
				case Swords.Dragon: return "Dragon Sword";
				case Swords.Blood: return "Blood Sword";
				case Swords.Master: return "Master Sword";				
			}
			break;
		case oItem_Treasure: return "Treasure Chest";
		case oItem_Tunic: return "Lvl " + string(_ItemIndex + 1) + " Tunic";
		
		//village items
		case oItem_Book: return "Book";
		case oItem_Mirror: return "Mirror";
		case oItem_Mushroom: return "Mushroom";
		case oItem_Powder: return "Magic Powder";
		case oItem_Medallion: return "Bombos Medallion";
		case oItem_Key_Special: return "Mystery Key";
		case oItem_Letter: return "Pezo's Letter";
		
		
		default: return "";		
		
	}	
}

function Item_Info(_ObjIndex, _ItemIndex){
	
	switch(_ObjIndex){

		case oItem_ArrowQuiver: return "Increases your arrow capacity\\from " + string(MaxArrows) + " to " + string(MaxArrows * 2) + " arrows.";
		case oItem_BombBag: return "Increases your bomb capacity\\from " + string(MaxBombs) + " to " + string(MaxBombs * 2) + " bombs.";
		
		case oItem_Bag: return "Holds up to " + string(Inventory_MaxSlots(_ItemIndex)) + " items."; 
		
		case oItem_Boomerang: return "Stuns enemies, shoots in 8 directions.";
		case oItem_Hookshot: return "Stuns enemies, can pick up items.";
		
		case oItem_Map: return "Reveals all unexplored Rooms on the\\map. You will lose the map when\\descending to a new floor.";
		
		case oItem_Compass: return "Reveals doors and important\\locations on the map. You will lose the\\compass when descending to a new\\floor.";
		
		case oItem_Cape: return "You are invisible when you wear it.\\Watch your magic meter!";
		
		case oItem_Food: 
			var _FoodHearts = FoodHearts(_ItemIndex);
			return "Replenishes " + string(_FoodHearts) + " hearts." + Item_HealthBonusStr(_FoodHearts);
		case oItem_Pop: return "Replenishes " + string(PopHearts) + " hearts." + Item_HealthBonusStr(PopHearts);
			
		case oItem_Magic_Large: return "Fills up 50% of your magic meter.";
		
		case oItem_Treasure: return "Contains a random item inside.\\Could be good, could be bad.\\Take a risk and find out.";
		
		case oItem_Key: return "Handy when you don't feel like\\looking for that locked door's key.";
		
		case oItem_Key_Master: return "Unlocks any locked doors while\\you're carrying it.";
		
		case oItem_MoonPearl: return "Colored gates will automatically\\lower when you walk up to them.\\No need to activate the crystal\\switches anymore.";		
		
		case oItem_Skill:
			switch(_ItemIndex){
				case Skill.PotBreaker: return "Break pots with your sword.";
				case Skill.MagicBeam: return "Shoot a beam from your sword\\when you're at max health.";
				case Skill.Resistance: return "Hit electric enemies with your\\sword without getting hurt.";
			}
			break;
			
		case oItem_Sword: 
			var Str = "+" + string(_ItemIndex + 1) + " Attack";
			switch(_ItemIndex){
					case Swords.Basic: return Str;
					case Swords.Steel: return Str;
					case Swords.Long: return Str;
					case Swords.Blood: return Str;
					case Swords.Dragon: return Str;
					case Swords.Master: return Str;					
			}
			break;
			
		
		case oItem_Tunic: return "+" + string(_ItemIndex) + " Defense";
		case oItem_Shield: return "+" + string(_ItemIndex + 1) + " Defense";

		case oItem_Kinstone: return "Find the other half of this\\kinstone and fuse them together.\\Something good will happen."
		case oItem_Letter: return "Deliver this to his friend who\\lives in the rebel village."
			
		case oItem_Lamp:
			switch(_ItemIndex){
				case 1:	return "Shines brighter than the candle.";
				case 2:	return "Shines brighter than the basic\\lamp.";
				case 3:	return "Wear some shades, this lamp lights\\up everything. No more stumbling\\around in the dark.";
			}
		
		case oItem_Gloves:
			switch(_ItemIndex){
				case 0:	return "+1 Defense";
				case 1:	return "+1 Attack, +1 Defense";
				case 2:	return "+2 Attack, +1 Defense";
			}
		
		case oItem_Orb:
			switch(_ItemIndex){
				case Orb.Fire:			return "";
				case Orb.Ice:			return "";
				case Orb.Treasure:		return "";	
			}			
			break;
			
		case oItem_Pendant:
			switch(_ItemIndex){
				case Pendant.Health:	 return "+25% bonus for items that\\replenish your health.";
				case Pendant.Magic:		 return "Items that use magic will now\\only use 1/2 as much."; 
				case Pendant.Protection: return "Protects you against spikes and\\bombs."; 
				case Pendant.Secrets:	 return "You will be alerted when a hidden\\door is in the Room.";
				case Pendant.Vision:	 return "Monsters will be more visible\\in the dark.";
				case Pendant.Immunity:	 return "Blocks all curses."; 
				case Pendant.Wealth:	 return "+" + string((WEALTHMULTIPLIER * 100) - 100) + "% bonus added to all\\collected rupees."; 
				case Pendant.Revival:	 return "You will be revived if you die.\\You will lose this pendant afterwards."; 
			
			}
			break;
		
		case oItem_Potion:
			switch(_ItemIndex){
				case Potion.Health:			return "Restores all of your health.";
				case Potion.Magic:			return "Restores all of your magic.";
				case Potion.HealthMagic:	return "Restores all of your health and\\magic.";
				case Potion.Antidote:		return "Cancels the effect of curses.";
				case Potion.Milk:			return "Restores " + string(MILKHEARTS) + " hearts." + Item_HealthBonusStr(MILKHEARTS);
			}
			break;

		
	}
	
	return "No Info Available";
	
}

function Item_HealthBonusStr(_OriginalAmount, _AddNextLine = true){
	//returns a string that says how many bonus hearts you get because of the pendant of health. Used in Item Info dialogues
	var BonusAmount = _OriginalAmount * 0.25;
	var Str = Pendant_Check(Pendant.Health) ? "(+" + string_format(BonusAmount, 1, frac(BonusAmount) != 0 ? 1 : 0) + " Pendant of Health bonus)" : "";
	return (_AddNextLine ? "\\" : "") + Str;
}

function Item_GetRandomPrice(_BasePrice, _Increment, _MaximumPrice){
	return _BasePrice + (irandom((_MaximumPrice - _BasePrice) / _Increment) * _Increment);
}

function Item_CheckCursePrice(_ItemInst){
	return Curse_Check(CurseEffects.ShopsMaxPrice) ? _ItemInst.Price_Max : _ItemInst.Price
}

function Item_NewPrice(_ObjIndex, _ItemIndex, _Highest = false, _Amount = 1){
	
	//these prices are temporary
	
	//_Highest is optional, will return the highest price if true. This is used for curse
	
	var BasePrice = 0;
	
	switch(_ObjIndex){

		case oItem_Arrows:
			BasePrice = 10 + (floor(_Amount / 10) * 5);
			break;

		case oItem_Bombs:
			BasePrice = 10 + (floor(_Amount / 5) * 5);
			break;

		case oItem_Pop:
			BasePrice = 10;
			break;

		case oItem_Compass:
		case oItem_Map:
		case oItem_Magic_Large:
		case oItem_Key:
			BasePrice = 15;
			break;

		case oItem_Food:
			var Thirds = floor(_ItemIndex / 3);
			BasePrice = 10 + (Thirds * 5);
			break;

		case oItem_HeartPiece:
		case oItem_Treasure:
			BasePrice = 30;
			break;
		
		case oItem_Boomerang: 
		case oItem_Bow: 
		case oItem_Hookshot:  
			BasePrice = 40 + (_ItemIndex * 25);
			break;
		
		
		case oItem_Lamp: 
		case oItem_Shield: 
		case oItem_Sword: 
		case oItem_Tunic: 
		case oItem_Gloves: 
			BasePrice = 50 + (_ItemIndex * 25);
			break;
		
		
		case oItem_Bag: 
			BasePrice = 75 + (_ItemIndex * 50);
			break;
			
		case oItem_Cape:
		case oItem_Pendant:
		case oItem_Rod:
		case oItem_Skill: 
		case oItem_ArrowQuiver: 
		case oItem_BombBag: 
			BasePrice = 80; 
			break;

			
		case oItem_Medallion: 
			BasePrice = 150;
			break;
			
		case oItem_Kinstone:
			switch(_ItemIndex){
				case KinstoneColor.Green: BasePrice = 20; break;
				case KinstoneColor.Blue: BasePrice = 40; break;
				case KinstoneColor.Red: BasePrice = 80; break;
				case KinstoneColor.Gold: BasePrice = 120; break;
			}
			break;
		
		case oItem_Orb:
			switch(_ItemIndex){
				case Orb.Fire:			BasePrice = 15; break;
				case Orb.Ice:			BasePrice = 15; break;
				case Orb.Treasure:		BasePrice = 60; break;
			
			}			
			break;
			
		case oItem_Potion:
			switch(_ItemIndex){
				case Potion.Health:			BasePrice = 40; break;
				case Potion.Magic:			BasePrice = 30; break;
				case Potion.HealthMagic:	BasePrice = 60; break;
				case Potion.Antidote:		BasePrice = 50; break;
				case Potion.Milk:			BasePrice = 25; break; 
			
			}
			break;
		
		case oItem_MoonPearl: 
		case oItem_Key_Master: 
			BasePrice = 500; break;
		
	}
	
	var MaxPrice = min(floor((BasePrice * 2.5) / 5) * 5, 999);
	
	return _Highest ? MaxPrice : Item_GetRandomPrice(BasePrice, 5, MaxPrice);
	
}


function Item_ShouldConsume(_ObjIndex, _ItemIndex){
	
	//returns true if item should be consumed (instead of adding to inventory)
	
	var Consume = false;
	
	switch(_ObjIndex){
		
		case oItem_Food:
		case oItem_Pop:
		case oItem_Magic_Large:			
			
			switch(global.Users[global.UserIndex].Prefs.FoodMagic){
				case Pref_FoodMagic.Consume:
					switch(_ObjIndex){
						case oItem_Food:
						case oItem_Pop:
							if(oLink.Health < oLink.HealthMax) Consume = true;
							break;
						case oItem_Magic_Large:	
							if(oLink.Magic < oLink.MagicMax) Consume = true;
							break;
					}
					break;
							
				case Pref_FoodMagic.ConsumeNoWaste:
					var Waste = false;
					var WasteValue_Health = oLink.HealthMax - oLink.Health;
					var WasteValue_Magic = oLink.MagicMax - oLink.Magic;
					switch(_ObjIndex){
						case oItem_Food:
							if(FoodHearts(_ItemIndex) > WasteValue_Health) Waste = true;
							break;
						case oItem_Pop:
							if(PopHearts > WasteValue_Health) Waste = true;
							break;
						case oItem_Magic_Large:	
							if(LARGEMAGICAMOUNT > WasteValue_Magic) Waste = true;
							break;
					}
							
					Consume = !Waste;
					break;
						
			}
			
	}
	
	return Consume;
	
}


function ItemGet(_Inst){
	
	var AddToInventory = true;
	

	if(Item_ShouldConsume(_Inst.object_index, _Inst.Index)){
		AddToInventory = false;
		ItemUse(_Inst.object_index, _Inst.Index);
		_Inst.Get_Sound = Sound_ItemGet;	
	}
	
	
	if(AddToInventory){
		
		var Slot = Inventory_PickSlot(_Inst.object_index, _Inst.Index);
	
		Item_RemoveFromNonDuplicatableList(_Inst.object_index, _Inst.Index);
	
		switch(Slot){
		
			default:
				
				Inventory_Add(_Inst.object_index, _Inst.Index, Slot);
				
				switch(_Inst.object_index){
				
					case oItem_Bombs:
						BombsAdd(_Inst.Amount); 
						break;
				
					case oItem_Arrows: 
						ArrowsAdd(_Inst.Amount); 
						break;
						
					case oItem_Pendant:
						switch(_Inst.Index){
							case Pendant.Immunity:
								if(global.Cursed){
								
									MsgBox("You are now uncursed!");

									global.Cursed = false;
						
								}
						}
						break;
				


				}

				break;
		
			case -1: return false;
		
			case -2:
				//these items don't go in inventory
				switch(_Inst.object_index){
					case oItem_Rupee: 
					
						var RupeeMultiplier = Pendant_Check(Pendant.Wealth) ? WEALTHMULTIPLIER : 1; //add 20% if own pendant of wealth
					
						if(global.Cursed){
							switch(global.CurseEffect){
								case CurseEffects.RupeesNoValue: RupeeMultiplier = 0; break;
							}
						}
					
						var RupeeAmount = ceil(_Inst.Amount * RupeeMultiplier);
					
						Curse_CheckTask(CurseTasks.Collect, oItem_Rupee, RupeeAmount);
						oHUD.AddRupees += RupeeAmount; 
					
						global.StatsToAdd[Stat.Rupees] += RupeeAmount;
					
						break; 
					
				
					case oItem_Heart: 
						Curse_CheckTask(CurseTasks.Collect, oItem_Heart);
						HealthAdd(Curse_Check(CurseEffects.HeartsReduceHealth) ? -1 : 1); 
						break;
					
					case oItem_HeartPiece:
						global.HeartPiecesThatExist--;
						HeartPieceAdd(); 
						break;
					
					case oItem_Key: 
						KeyAdd(1); 
						break;
				
					case oItem_Magic:
						MagicAdd(_Inst.Amount);
						break;
					
					case oItem_Stopwatch:
						with(oEnemy){
							if(State == EnemyState.Frozen || State == EnemyState.OnFire) continue;
							Enemy_UpdateState(EnemyState.StopWatch);
						}
						break;
						
					case oItem_Treasure: 
						if(_Inst.From != ItemFrom.Shop) 
							exit; 
						break;
						
					case oItem_Bag: 
						global.ItemData[_Inst.object_index].Index = _Inst.Index; 
						break;
		
					case oItem_ArrowQuiver: 
					case oItem_BombBag: 
						global.ItemData[_Inst.object_index].Owns[0] = true; 
						break;
		
				}	
				break;
			
			case -3: //special village items that don't take a regular slot, but a spot at the top of the inventory
				Inventory_Add(_Inst.object_index, _Inst.Index, Slot);
				break;
		}
	
	}
	
	
	if(_Inst.From == ItemFrom.Shop) Curse_CheckTask(CurseTasks.Buy);

	if(_Inst.Get_Sound != noone) audio_play_sound(_Inst.Get_Sound, 1, false);
	instance_destroy(_Inst);
	
	Link_UpdateAttackDefence();
	
	return true;
	
}

function ItemUse(_ObjectIndex, _ItemIndex){
	
	//When using an item from the inventory or from the selected L/R item
	
	switch(_ObjectIndex){
		
		case oItem_Food:
			HealthAdd(FoodHearts(_ItemIndex));
			break;
		case oItem_Pop:
			HealthAdd(PopHearts);
			break;

		case oItem_Orb:
			
			if(instance_exists(global.InventoryInst)) global.InventoryInst.Close = true;
			
			switch(oLink.Facing){
				case LEFT: var Inst = instance_create_layer(oLink.x - 14, oLink.y, "Objs_Upper", oOrb, {Index : _ItemIndex}); break;
				case RIGHT: var Inst = instance_create_layer(oLink.x + 14, oLink.y, "Objs_Upper", oOrb, {Index : _ItemIndex}); break;
				case UP: var Inst = instance_create_layer(oLink.x, oLink.y - 12, "Objs_Upper", oOrb, {Index : _ItemIndex}); break;
				case DOWN: var Inst = instance_create_layer(oLink.x, oLink.y + 12, "Objs_Upper", oOrb, {Index : _ItemIndex}); break;
			}

			with(oLink){
				PickupItem(Inst);
			}
			break;		

		case oItem_Potion:
			switch(_ItemIndex){
				case Potion.Health:
					HealthAdd(MaxHearts);
					break;
				case Potion.Magic:
					MagicAdd(oLink.MagicMax);
					break;
				case Potion.HealthMagic:
					HealthAdd(MaxHearts);
					MagicAdd(oLink.MagicMax);
					break;
				case Potion.Milk:
					HealthAdd(MILKHEARTS);
					break;
				case Potion.Antidote:
					audio_play_sound(Sound_Antidote, 1, false);
					MsgBox("Oof, tastes awful. You are now\\uncursed!");
					global.Cursed = false;
					break;					

			}
			break;
		
		case oItem_Magic_Large:
			MagicAdd(LARGEMAGICAMOUNT);
			break;
		
	}
	
	audio_play_sound(Sound_TextDone, 1, false);
	
}

function Item_CanUse(_ObjIndex, _ItemIndex){
	
	switch(_ObjIndex){
		
		case oItem_Food:
		case oItem_Pop:
		
			if(oLink.Health == oLink.HealthMax) return false;
			break;
		
		case oItem_Magic_Large:
			if(oLink.Magic == oLink.MagicMax) return false;
			break;
		
		case oItem_Potion:
			switch(_ItemIndex){
				case Potion.Health:	
				case Potion.Milk:	
					if(oLink.Health == oLink.HealthMax) return false;
					break;
				
				case Potion.Magic:
					if(oLink.Magic == oLink.MagicMax) return false;
					break;
				
				case Potion.HealthMagic:
					if(oLink.Health == oLink.HealthMax && oLink.Magic == oLink.MagicMax) return false;
					break;
			}
			break;
	}
	
	return true;
	
}

function ItemSpawn(_ObjectIndex, _x, _y, _From, _SpawnType, _FloorLevel){
	
	switch(_SpawnType){
		default: var Layer = "ObjsHigher_" + GetFloorLevelString(_FloorLevel); break;
		case ItemSpawnType.DropInventory:
		case ItemSpawnType.DropScatter: var Layer = "Objs_" + GetFloorLevelString(_FloorLevel); break;
	}
	
	var Inst = instance_create_layer(_x, _y, Layer, _ObjectIndex);
	Inst.From = _From;
	Inst.FloorLevel = _FloorLevel;
	Inst.SpawnType = _SpawnType;
	Inst.Spawning = true;
	Inst.SpawnAnimationInit = true;	
	
	//Update and decrease treasure limiters
	if(FromAnyTreasure(_From)){
		TreasureLimiter_Update(_ObjectIndex);
		Item_AddToNonDuplicatableList(_ObjectIndex, Inst.Index);
	}
	
	return Inst;
	
}

function TreasureLimiter_Update(_ObjectIndex){
	
	//decrease any limit counts
	for(var i = 0; i < global.ItemObjIndexes; i++){
		var ObjIndex = global.ItemObjIndexList[| i];
		global.ItemData[ObjIndex].LimitCount = max(--global.ItemData[ObjIndex].LimitCount, 0);
	}
	//Pick a new limit count for chosen object index
	if(global.ItemData[_ObjectIndex].LimitMin > 0) global.ItemData[_ObjectIndex].LimitCount = irandom_range(global.ItemData[_ObjectIndex].LimitMin, global.ItemData[_ObjectIndex].LimitMin * 2);	
	
}

function ItemExplosion(_x, _y){
	
	var _FloorLevel = GetFloorLevelID(_x, _y);
	
	repeat(irandom_range(5, 8)){
		var Item = choose(oItem_Rupee, oItem_Rupee, oItem_Rupee, oItem_Magic, oItem_Arrows, oItem_Bombs);
		ItemSpawn(Item, _x, _y, ItemFrom.Pot, ItemSpawnType.DropScatter, _FloorLevel);
	}
	
	repeat(choose(1,2,3)){
		ItemSpawn(PickRandomItem(ItemFrom.Treasure), _x, _y, ItemFrom.Treasure, ItemSpawnType.DropScatter, _FloorLevel);
	}
	
	//audio_play_sound(Sound_PotShatter, 1, false);
	//audio_play_sound(Sound_Hookshot, 1, false);
	//audio_play_sound(Sound_RupeeGetRegister, 1, false);

}

function ItemDrop(_ObjectIndex, _ItemIndex, _SpawnType){
	
	switch(oLink.Facing){
		case UP: var _x = oLink.x; var _y = oLink.y - 6; break;
		case DOWN: var _x = oLink.x; var _y =  oLink.y; break;
		case LEFT: var _x = oLink.x - 6; var _y =  oLink.y; break;
		case RIGHT: var _x = oLink.x + 6; var _y =  oLink.y; break;
	}
	if(_SpawnType == ItemSpawnType.DropTreasure){
		var _SpawnFrom = ItemFrom.Treasure;
		_y = oLink.y;
	}

	if(_SpawnType == ItemSpawnType.DropInventory) var _SpawnFrom = ItemFrom.Inventory;
	var DroppedInst = ItemSpawn(_ObjectIndex, _x, _y, _SpawnFrom, _SpawnType, oLink.FloorLevel);
	DroppedInst.Index = _ItemIndex;
	DroppedInst.image_index = _ItemIndex;
	DroppedInst.layer = layer_get_id("Objs_" + GetFloorLevelString(oLink.FloorLevel));
	DroppedInst.Dropped = true;

	
	switch(_ObjectIndex){

		case oItem_Shield:
			//fix shadows here. since upgradeable items have their index increased in the create event, and here it resets it back to the original index after drop, some shadows are the wrong ones.
			//A solution would be to have a function that sets the shadow for any object with any index
			DroppedInst.ShadowSpr = (DroppedInst.Index == 0 ? sShadow_Medium : sShadow_Large);
			break;
			
		case oItem_Arrows:
			DroppedInst.Amount = oLink.Arrows;
			oLink.Arrows -= DroppedInst.Amount; 
			DroppedInst.ShowAmount = (DroppedInst.Amount > 1);
			DroppedInst.Setup = false;
			break;	
			
		case oItem_Bombs: 
			DroppedInst.Amount = oLink.Bombs;
			oLink.Bombs -= DroppedInst.Amount; 
			DroppedInst.ShowAmount = (DroppedInst.Amount != 1 && DroppedInst.Amount != 3);
			DroppedInst.Setup = false;
			break;	
			
	}
	
	Item_AddToNonDuplicatableList(_ObjectIndex, _ItemIndex);

	Link_UpdateAttackDefence();
	
	return DroppedInst;
	
}

function Item_AddToNonDuplicatableList(_ObjIndex, _ItemIndex){

	//if item is upgradeable or boolean, add to the NonDuplicatableItemsThatExist grid list
	if(global.ItemData[_ObjIndex].Type == ItemType.Boolean || global.ItemData[_ObjIndex].Type == ItemType.Upgradeable){
		var Grid = global.NonDuplicatableItemsThatExist;
		var GridH = ds_grid_height(Grid);
		
		//search for identical item
		//if(Item_FindInNonDuplicatableList(_ObjIndex, _ItemIndex) != -1) exit;

		ds_grid_resize(Grid, 2, GridH + 1);
		ds_grid_add(Grid, 0, GridH, _ObjIndex);
		ds_grid_add(Grid, 1, GridH, _ItemIndex);		
	}

	if(_ObjIndex == oItem_HeartPiece) global.HeartPiecesThatExist++;
	
}

function Item_RemoveFromNonDuplicatableList(_ObjIndex, _ItemIndex){

	//if item is upgradeable or boolean, remove from the NonDuplicatableItemsThatExist grid list if it exists
	if(global.ItemData[_ObjIndex].Type == ItemType.Boolean || global.ItemData[_ObjIndex].Type == ItemType.Upgradeable){

		//find if item is in list, if so remove it
		var ItemRow = Item_FindInNonDuplicatableList(_ObjIndex, _ItemIndex);
		if(ItemRow != -1) ds_grid_delete_row(global.NonDuplicatableItemsThatExist, ItemRow);
	
	}
	
}

function Item_FindInNonDuplicatableList(_ObjIndex, _ItemIndex = -1){
	
	//return row # if Obj/Index is in NonDuplicatableList
	
	var Grid = global.NonDuplicatableItemsThatExist;
	var GridH = ds_grid_height(Grid);
		
	for(var i = 0; i < GridH; i++){
		if(_ItemIndex == -1){
			//if itemindex not specified, just look for objindex
			if(_ObjIndex == Grid[# 0, i]) return i;
		}else{
			if(_ObjIndex == Grid[# 0, i] && _ItemIndex == Grid[# 1, i]) return i;
		}
	}
	
	return -1;
	
}


function ItemAllowed(_ObjectIndex, _From){
	
	//returns false if that item should not be found in any shop or treasure
	
	//Limit items from small treasures if their limit count is above 0. If we're in the village, ignore limits since there's so many items that get generated in all the stores, so don't limit anything for the treasures
	if( FromAnySmallTreasure(_From) && global.Level.Index != DungeonLevel.Village && global.ItemData[_ObjectIndex].LimitCount > 0) return false;

	//if(_From == ItemFrom.Treasure && global.ItemData[_ObjectIndex].UsesInvSlot && Inventory_PickSlot(_ObjectIndex, global.ItemData[_ObjectIndex].Index) == -1) return false;

	switch(global.ItemData[_ObjectIndex].Type){
		
		case ItemType.Boolean:
			
			//Check if item doesn't exist and isn't owned 
			var AvailableItem = false;
			for(var i = 0; i < array_length(global.ItemData[_ObjectIndex].Owns); i++){
			
				if(Item_FindInNonDuplicatableList(_ObjectIndex, i) == -1 && !global.ItemData[_ObjectIndex].Owns[i]){
					AvailableItem = true;
					break;
				}
			}
			if(!AvailableItem) return false;
			
			break;
		
		case ItemType.Upgradeable:
			
			if(global.ItemData[_ObjectIndex].Index == global.ItemData[_ObjectIndex].Index_Max) return false;
			
			//if the upgradeable already exists(on-screen/active), then don't allow. This would cause a duplicate of the same item
			if(Item_FindInNonDuplicatableList(_ObjectIndex) != -1) return false;
			
			break;

	
	}
	
	switch(_ObjectIndex){
		
		case oItem_Map:
		case oItem_Compass:
			if(global.Level.Index == DungeonLevel.Village) return false;
			break;
			
		case oItem_HeartPiece:
			if(MaxHearts - oLink.HealthMax - global.HeartPiecesThatExist - 1 < 0) return false;
			break;
		
		case oItem_Key:
			if(oLink.Keys == oLink.MaxKeys) return false;
			break;
		
		case oItem_Pendant:
			//special case: don't pick the pendant of vision until after the Sewers, I don't want player to get it right off the bat and wonder why all the enemies are lit up. Let them experience the darkness first
			//So here we have to check if all but that one is owned, since if Link has others he doesn't own, you can still pick the pendant, and when it picks an index it also has code to skip the vision pendant.
			if(global.Level.Index <= DungeonLevel.Sewers){
				if(!global.ItemData[oItem_Pendant].Owns[Pendant.Vision]){
					if( (global.ItemData[oItem_Pendant].Owns[Pendant.Health] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Health) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Immunity] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Immunity) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Magic] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Magic) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Protection] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Protection) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Revival] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Revival) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Secrets] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Secrets) != -1) &&
						(global.ItemData[oItem_Pendant].Owns[Pendant.Wealth] || Item_FindInNonDuplicatableList(oItem_Pendant, Pendant.Wealth) != -1)
					  )	return false;
					  
				}
				
			}
			break;
			
	}
	
	return true;
	
}


function PickAvailableItem(_ObjectIndex){
	
	//for objects that have different indexes and can have only 1 of each(pendants, medallions, skills, rods, etc),
	//this figures out the available items left from the owns array, then returns a random one from that list
	
	var AvailableItems = ds_list_create();
	var ItemCount = array_length(global.ItemData[_ObjectIndex].Owns);
	for(var i = 0; i < ItemCount; i++){
		var GridIndex = Item_FindInNonDuplicatableList(_ObjectIndex, i);
		if(GridIndex != -1) continue;
		
		if(!global.ItemData[_ObjectIndex].Owns[i]){
			
			//special case: don't pick the pendant of vision until after the Sewers, I don't want player to get it right off the bat and wonder why all the enemies are lit up. Let them experience the darkness first
			if(_ObjectIndex == oItem_Pendant && i == Pendant.Vision && global.Level.Index <= DungeonLevel.Sewers) continue;
		
			ds_list_add(AvailableItems, i);
		}
		
	}
	
	ds_list_shuffle(AvailableItems);
	var _Index = AvailableItems[| 0];
	ds_list_destroy(AvailableItems);
	
	return _Index;

}


function PickRandomItem(_From){
	
	//returns random Object Index after calculating the probs, and then adding to global.ProbList each allowed item with a higher prob than 0.
	//List format: [ObjIndex, Prob, ObjIndex, Prob...]
	
	//extra arguments are items that should be excluded

	//Calculate real prob for each item based on how many prob indexes are used in total for each index.
	//So if 10 items are using a prob index which equals 1, then each of those items probs should be 1/10 = 0.1;
	
	//First tally each prob index:
		
	var ProbsCount = array_length(global.Probs);
	var ProbIndexTally = array_create(ProbsCount, 0);
	var NewProbs = array_create(ProbsCount, 0);

	for(var i = 0; i < global.ItemObjIndexes; i++){
		var ObjIndex = global.ItemObjIndexList[| i];
		switch(_From){
			case ItemFrom.Pot: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_Pot; break;
			case ItemFrom.PotSimple: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_PotSimple; break;
			case ItemFrom.Treasure: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_Treasure; break;			
			case ItemFrom.LargeTreasure: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_LargeTreasure; break;
			case ItemFrom.Shop: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_Shop; break;	
			case ItemFrom.KinstoneGreen: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_KinstoneGreen; break;	
			case ItemFrom.KinstoneBlue: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_KinstoneBlue; break;	
			case ItemFrom.KinstoneRed: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_KinstoneRed; break;	
			case ItemFrom.KinstoneGold: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_KinstoneGold; break;	
			case ItemFrom.WeaponStore: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_WeaponStore; break;	
			case ItemFrom.TreasureStore: var ProbIndex = global.ItemData[ObjIndex].ProbIndex_TreasureStore; break;	
		}
		ProbIndexTally[ProbIndex]++;
	}

	//Calculate new probs
	for(var i = 0; i < ProbsCount; i++){
		NewProbs[i] = ProbIndexTally[i] > 0 ? global.Probs[i] / ProbIndexTally[i] : 0;
	}
	
	//Add to list all object indexes that have a higher than 0 prob and is allowed. Keep track of the sum of probs
	ds_list_clear(global.ProbList);
	var Sum = 0;
	for(var i = 0; i < global.ItemObjIndexes; i++){
		
		var ObjIndex = global.ItemObjIndexList[| i];
		
		//Check if ObjIndex is in ProListExclude or not allowed. If so continue to next item. Example, Shops add created items to exclude list as they get created so they don't get picked twice.
		if(ds_list_find_index(global.ProbListExclude, ObjIndex) != -1) continue;
		
		if(!ItemAllowed(ObjIndex, _From)) continue;
		
		switch(_From){
			case ItemFrom.Pot: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_Pot]; break;
			case ItemFrom.PotSimple: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_PotSimple]; break;
			case ItemFrom.Treasure: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_Treasure]; break;
			case ItemFrom.LargeTreasure: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_LargeTreasure]; break;
			case ItemFrom.Shop: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_Shop]; break;
			case ItemFrom.KinstoneGreen: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_KinstoneGreen]; break;
			case ItemFrom.KinstoneBlue: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_KinstoneBlue]; break;
			case ItemFrom.KinstoneRed: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_KinstoneRed]; break;
			case ItemFrom.KinstoneGold: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_KinstoneGold]; break;
			case ItemFrom.WeaponStore: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_WeaponStore]; break;
			case ItemFrom.TreasureStore: var NewProb = NewProbs[global.ItemData[ObjIndex].ProbIndex_TreasureStore]; break;
		}
		if(NewProb != 0){
			ds_list_add(global.ProbList, ObjIndex, NewProb);
			Sum += NewProb;
		}

	}

	var RandomNum = random(Sum);
	var CurrentChance = 0;
	for(var i = 0; i < (ds_list_size(global.ProbList) / 2); i++){
	    CurrentChance += global.ProbList[| (i*2)+1];
	    if(RandomNum < CurrentChance){
			
			var _ObjIndex = global.ProbList[| i*2];
			
			return global.ProbList[| i*2];
		}
	}
	
	return oItem_Arrows; //fail-safe, should be an item that can be in either pot, treasure, or shop
	
}

function PickPotItem(Force, SimpleItems = true){
	
	var _Item = noone;
	if(Force || Prob(Chance_PotHasItem)){
		_Item = PickRandomItem(SimpleItems || global.Level.Index == DungeonLevel.Village ? ItemFrom.PotSimple : ItemFrom.Pot);
	}
	
	return _Item
}


function PickRandomVal(){
	//Returns random value based on percentages given (0-1)
	//(return,chance, return,chance, ... default)
	
	var _Default = 0;
	
	if(argument_count % 2 != 0) _Default = argument[argument_count - 1];
	
	var RandomNum = random(1);
	var CurrentChance = 0;
	for(var i = 1; i < argument_count; i+=2){
	    CurrentChance+=argument[i];
	    if(RandomNum < CurrentChance) return argument[i-1];
	}
	return _Default;
	
}


function Item_SetIndex(_NewIndex){
	Index = _NewIndex;
	image_index = Index;
}

function Item_SetUpgradeableIndex(){
	Item_SetIndex(global.ItemData[object_index].Index + 1);
}

function FromAnyTreasure(_From){	
	return _From == ItemFrom.Treasure || _From == ItemFrom.LargeTreasure || _From == ItemFrom.KinstoneGreen || _From == ItemFrom.KinstoneBlue || _From == ItemFrom.KinstoneRed || _From == ItemFrom.KinstoneGold;
}

function FromAnySmallTreasure(_From){	
	return _From == ItemFrom.Treasure || _From == ItemFrom.KinstoneGreen || _From == ItemFrom.KinstoneBlue || _From == ItemFrom.KinstoneRed;
}

function Item_GetID(_ObjIndex){
	//returns the item ID based on the object index
	
	switch(_ObjIndex){
		case oItem_ArrowQuiver: return Item.ArrowQuiver;
		case oItem_Arrows: return Item.Arrows;		   
		case oItem_Bag: return Item.Bag;
		case oItem_BombBag: return Item.BombBag;
		case oItem_Bombs: return Item.Bombs;
		case oItem_Boomerang: return Item.Boomerang;
		case oItem_Bow: return Item.Bow;
		case oItem_Compass: return Item.Compass;
		case oItem_Food: return Item.Food;
		case oItem_Gloves: return Item.Gloves;
		case oItem_Heart: return Item.Heart;
		case oItem_HeartPiece: return Item.HeartPiece;
		case oItem_Hookshot: return Item.Hookshot;
		case oItem_Key: return Item.Key;
		case oItem_Key_Master: return Item.MasterKey;
		case oItem_Kinstone: return Item.Kinstone;
		case oItem_Lamp: return Item.Lamp;
		case oItem_Magic: return Item.Magic;
		case oItem_Magic_Large: return Item.MagicLarge;
		case oItem_Map: return Item.Map;
		case oItem_MoonPearl: return Item.MoonPearl;
		case oItem_Orb: return Item.Orb;
		case oItem_Pendant: return Item.Pendant;
		case oItem_Potion: return Item.Potion;
		case oItem_Rod: return Item.Rod;
		case oItem_Rupee: return Item.Rupee;
		case oItem_Shield: return Item.Shield;
		case oItem_Skill: return Item.Skill;
		case oItem_Stopwatch: return Item.Stopwatch;
		case oItem_Sword: return Item.Sword;
		case oItem_Treasure: return Item.Treasure;
		case oItem_Tunic: return Item.Tunic;
		
		//village items
		case oItem_Book: return Item.Book;
		case oItem_Mirror: return Item.Mirror;
		case oItem_Mushroom: return Item.Mushroom;
		case oItem_Powder: return Item.Powder;
		case oItem_Medallion: return Item.Medallion;
		case oItem_Key_Special: return Item.SpecialKey;
		case oItem_Letter: return Item.Letter;
	}
}

function Item_GetObjIndexFromID(_ItemID){
	//returns the item ID based on the object index
	
	switch(_ItemID){
		case Item.ArrowQuiver: return oItem_ArrowQuiver;
		case Item.Arrows: return oItem_Arrows;
		case Item.Bag: return oItem_Bag;
		case Item.BombBag: return oItem_BombBag;
		case Item.Bombs: return oItem_Bombs;
		case Item.Boomerang: return oItem_Boomerang;
		case Item.Bow: return oItem_Bow;
		case Item.Compass: return oItem_Compass;
		case Item.Food: return oItem_Food;
		case Item.Gloves: return oItem_Gloves;
		case Item.Heart: return oItem_Heart;
		case Item.HeartPiece: return oItem_HeartPiece;
		case Item.Hookshot: return oItem_Hookshot;
		case Item.Key: return oItem_Key;
		case Item.MasterKey: return oItem_Key_Master;
		case Item.Kinstone: return oItem_Kinstone;
		case Item.Lamp: return oItem_Lamp;
		case Item.Magic: return oItem_Magic;
		case Item.MagicLarge: return oItem_Magic_Large;
		case Item.Map: return oItem_Map;
		case Item.MoonPearl: return oItem_MoonPearl;
		case Item.Orb: return oItem_Orb;
		case Item.Pendant: return oItem_Pendant;
		case Item.Potion: return oItem_Potion;
		case Item.Rod: return oItem_Rod;
		case Item.Rupee: return oItem_Rupee;
		case Item.Shield: return oItem_Shield;
		case Item.Skill: return oItem_Skill;
		case Item.Stopwatch: return oItem_Stopwatch;
		case Item.Sword: return oItem_Sword;
		case Item.Treasure: return oItem_Treasure;
		case Item.Tunic: return oItem_Tunic;
		
		//village items
		case Item.Book: return oItem_Book;
		case Item.Mirror: return oItem_Mirror;
		case Item.Mushroom: return oItem_Mushroom;
		case Item.Powder: return oItem_Powder;
		case Item.Medallion: return oItem_Medallion;
		case Item.SpecialKey: return oItem_Key_Special;
		case Item.Letter: return oItem_Letter;		
	}
}

function Item_GetStr(_ObjIndex){
	//returns the item ID based on the object index
	
	switch(_ObjIndex){
		case oItem_ArrowQuiver: return "ArrowQuiver";		   
		case oItem_Arrows: return "Arrows";		   
		case oItem_Bag: return "Bag";
		case oItem_BombBag: return "BombBag";
		case oItem_Bombs: return "Bombs";
		case oItem_Boomerang: return "Boomerang";
		case oItem_Bow: return "Bow";
		case oItem_Compass: return "Compass";
		case oItem_Food: return "Food";
		case oItem_Gloves: return "Gloves";
		case oItem_Heart: return "Heart";
		case oItem_HeartPiece: return "Heart Container";
		case oItem_Hookshot: return "Hookshot";
		case oItem_Key: return "Key";
		case oItem_Key_Master: return "Master Key";
		case oItem_Kinstone: return "Kinstone";
		case oItem_Lamp: return "Lamp";
		case oItem_Magic: return "Magic";
		case oItem_Magic_Large: return "Magic Large";
		case oItem_Map: return "Map";
		case oItem_MoonPearl: return "Moon Pearl";
		case oItem_Orb: return "Orb";
		case oItem_Pendant: return "Pendant";
		case oItem_Potion: return "Potion";
		case oItem_Rod: return "Rod";
		case oItem_Rupee: return "Rupee";
		case oItem_Shield: return "Shield";
		case oItem_Skill: return "Skill";
		case oItem_Stopwatch: return "Stopwatch";
		case oItem_Sword: return "Sword";
		case oItem_Treasure: return "Treasure";
		case oItem_Tunic: return "Tunic";
		
		//village items
		case oItem_Book: return "Book";
		case oItem_Mirror: return "Mirror";
		case oItem_Mushroom: return "Mushroom";
		case oItem_Powder: return "Powder";
		case oItem_Medallion: return "Medallion";
		case oItem_Key_Special: return "SpecialKey";
		
	}
}