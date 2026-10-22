#macro ShopKeeperIDs 23

#macro ShopPriceMaxMultiplier 2

enum ShopTypes{
	Various,
	Weapons,
	Foods,
	Potions,
	Treasures,
	Magic,
	Bombs
}

function Shop_CreateItem(_Slot){
	
	var _ItemIndex = -1;
	
	var _ItemFrom = ItemFrom.Shop;
	
	var _ItemClass;
	switch(ShopType){
		
		case ShopTypes.Various:
		
			_ItemClass = Probs_RandomItemClass(ItemFrom.Shop);
			
			if(global.Swordless){
				if(_ItemClass != ItemClass.Bow && Item_Allowed(ItemClass.Bow)){
					if(Prob(Chance_SpawnShopBowSwordless)) _ItemClass = ItemClass.Bow;
				}
			}else{
				if(_ItemClass != ItemClass.Sword && Item_Allowed(ItemClass.Sword)){
					if(Prob(Chance_SpawnShopSword)) _ItemClass = ItemClass.Sword;
				}				
			}

			break;
			
		case ShopTypes.Weapons: 
			_ItemFrom = ItemFrom.WeaponStore;
			_ItemClass = Probs_RandomItemClass(ItemFrom.WeaponStore); 
			break;
		case ShopTypes.Foods: 
			_ItemFrom = ItemFrom.FoodStore;
			_ItemClass = Probs_RandomItemClass(ItemFrom.FoodStore); 
			if(_ItemClass == ItemClass.Potion) _ItemIndex = Potion.Milk;
			break;
		case ShopTypes.Potions:
			_ItemClass = Prob(0.85) ? ItemClass.Potion : ItemClass.MagicLarge;
			if(_ItemClass == ItemClass.Potion) _ItemIndex = choose(Potion.Health, Potion.HealthMagic, Potion.Magic, Potion.Antidote); 
			break;	
		case ShopTypes.Treasures: 
			_ItemFrom = ItemFrom.TreasureStore;
			_ItemClass = Probs_RandomItemClass(_ItemFrom); 
			break;
		case ShopTypes.Magic: 
			_ItemFrom = ItemFrom.MagicStore;
			_ItemClass = Probs_RandomItemClass(_ItemFrom); 
			break;
		case ShopTypes.Bombs: 
			
			_ItemClass = ItemClass.Bombs;
			
			if(Prob(0.2) && Item_Allowed(ItemClass.BombBag, 0, _ItemFrom)){
				_ItemClass = ItemClass.BombBag;				
			}else if(Prob(0.2) && Item_Allowed(ItemClass.Ring, Ring.Bombs, _ItemFrom)){
				_ItemClass = ItemClass.Ring;	
				_ItemIndex = Ring.Bombs;
			}

			break;
	}


	var ItemInst;
	switch(_ItemClass){
		case ItemClass.Treasure:
			ItemInst = Treasure_Create(RoomIndex, x, y, RandomItem, false, ShopType == ShopTypes.Various,, _ItemFrom); //temporarily create item at shop's x/y. Will reposition after
			break;
		default:
			ItemInst = instance_create_layer(x, y, "Objs_" + FloorLevelStr, ObjIndexFromItemClass(_ItemClass), {From : _ItemFrom});
		
	}
	
	switch(_ItemClass){

		case ItemClass.BagSlot:
			global.Level.ShopBagSlotsCreated++;
			break;
		case ItemClass.HeartPiece:
			global.Level.ShopHeartPiecesCreated++;
			break;
		case ItemClass.MagicLarge:
			global.Level.ShopLargeMagicCreated++;
			break;
		case ItemClass.Key:
			global.Level.ShopKeysCreated++;
			break;
		case ItemClass.Arrows:
			global.Level.ShopArrowsCreated++;
			ItemInst.Setup = false;
			ItemInst.Amount = Arrows_PickAmount(_ItemFrom);
			break;
		case ItemClass.Bombs:
			global.Level.ShopBombsCreated++;
			ItemInst.Setup = false;
			ItemInst.Amount = Bombs_PickAmount(_ItemFrom);			
			if(ItemInst.Amount == 3) ItemInst.image_index = 1;
			break;			
		case ItemClass.Orb:
			global.Level.ShopOrbsCreated++;
			break;
		case ItemClass.Pop:
			global.Level.ShopPopsCreated++;
			break;

	}

	
	if(_ItemIndex != -1) with(ItemInst) Item_SetIndex(_ItemIndex);
	ItemInst.Name = Item_Name(ItemInst.Class, ItemInst.Index, ItemInst.Amount);

	
	var _ItemPriceBase =	Item_Price(ItemInst.Class, ItemInst.Index, ItemInst.Amount);
	ItemInst.Price =		Item_Price_RoundToNearest(_ItemPriceBase * global.Level.Rooms[RoomIndex].ShopPriceMultiplier, 5);
	ItemInst.Price_Max =	Item_Price_RoundToNearest(_ItemPriceBase * ShopPriceMaxMultiplier, 5);
	ItemInst.ShopItem = true;
	ItemInst.ShowValue = true;
	ItemInst.ShowPrice = true;
	ItemInst.FloorLevel = FloorLevel;
	
	Inventory[_Slot] = ItemInst;
	
	if(Item_IsNonDuplicatableClassType(_ItemClass)) Item_NonDuplicatableList_Add(_ItemClass, ItemInst.Index);
	
	return ItemInst;
	
}

function Shop_DestroyItem(_Slot){
	
	instance_destroy(Inventory[_Slot]);
	Inventory[_Slot] = -1;
	
}

function Shop_GetSlotCount(){
	
	if(global.Challenges[Challenges.NoFood] && ShopType == ShopTypes.Foods) return 0
	
	return min(floor(TileW / 3.25), 6)
}

function Shop_SpaceItems(){
	
	//Space the items on the shop floor evenly
	
	//Get width of all items plus spacing
	var ItemsW = 0;
	var ItemSpacing = 11;
	for(var SlotIndex = 0; SlotIndex < Slots; SlotIndex++){
		var ItemInst = Inventory[SlotIndex];
		var ItemSprW = 16; //all items should be 16 wide
		ItemsW += (ItemSprW + ItemSpacing);
	}
	ItemsW -= ItemSpacing;
	
	var ItemsX = x + ((ShopW - ItemsW) / 2);
	var ItemX = ItemsX;
	for(var SlotIndex = 0; SlotIndex < Slots; SlotIndex++){
		var ItemInst = Inventory[SlotIndex];
		var ItemSprW = 16;
		var _x = ItemX + (ItemSprW / 2);
		var _y = ShopType == ShopTypes.Various ? y + 42 : y + 10;
		if(ItemInst != noone){
			if(ItemInst.object_index == oItem_Sword) _x += 0.5; //since origin isn't centred for sword
			ItemInst.x = _x;
			
			with(ItemInst) ObjSetY(_y);		
		}
		ItemX += (ItemSprW + ItemSpacing);

	}
	
}

function ResetUnusedShopKeeperList(){
	
	ds_list_clear(global.UnusedShopKeepers);
	for(var i = 0; i < ShopKeeperIDs; i++){ 
		ds_list_add(global.UnusedShopKeepers, i);
	}
	ds_list_shuffle(global.UnusedShopKeepers);
	
}

function GetShopType(_Str){
	
	switch(_Str){
		case "Various": return ShopTypes.Various;
		case "Weapons": return ShopTypes.Weapons;
		case "Potions": return ShopTypes.Potions;
		case "Foods": return ShopTypes.Foods;
		case "Treasures": return ShopTypes.Treasures;		
		case "Magic": return ShopTypes.Magic;
		case "Bombs": return ShopTypes.Bombs;		
	}
	
	return ShopTypes.Various
	
}
