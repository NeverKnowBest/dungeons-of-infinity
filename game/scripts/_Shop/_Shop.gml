#macro ShopKeeperIDs 15

enum ShopTypes{
	Various,
	Weapons,
	Foods,
	Potions,
	Treasures
}


function Shop_CreateItem(_Slot){
	
	var ItemIndex = -1;

	switch(ShopType){
		case ShopTypes.Various:
			var ObjectIndex = PickRandomItem(ItemFrom.Shop);
			break;
		case ShopTypes.Weapons: 
			var ObjectIndex = PickRandomItem(ItemFrom.WeaponStore); 
			if(ObjectIndex == oItem_Orb) ItemIndex = choose(Orb.Fire, Orb.Ice);
			break;
		case ShopTypes.Foods: 
			var ObjectIndex = choose(oItem_Food, oItem_Food, oItem_Food, oItem_Food, oItem_Food, oItem_Pop, oItem_Potion);
			if(ObjectIndex == oItem_Potion) ItemIndex = Potion.Milk;
			break;
		case ShopTypes.Potions: 
			var ObjectIndex = choose(oItem_Potion, oItem_Potion, oItem_Potion, oItem_Potion, oItem_Magic_Large); 
			//custom index list with milk removed, since that will appear in the food store
			ItemIndex = choose(Potion.Health, Potion.HealthMagic, Potion.Magic, Potion.Antidote); 
			break;	
		case ShopTypes.Treasures: 
			var ObjectIndex = PickRandomItem(ItemFrom.TreasureStore); 
			if(ObjectIndex == oItem_Orb) ItemIndex = Orb.Treasure;
			break;
	}


	switch(ObjectIndex){
		case oItem_Treasure:
			var ItemInst = Treasure_Create(x, y, RandomItem, false, ShopType == ShopTypes.Various); //temporarily create item at shop's x/y. Will reposition after
			break;
		default:
			var ItemInst = instance_create_layer(x, y, "Objs_" + FloorLevelStr, ObjectIndex);
		
	}
	
	if(ItemIndex != -1) with(ItemInst) Item_SetIndex(ItemIndex);
	ItemInst.Name = Item_Name(ItemInst.object_index, ItemInst.Index);
	ItemInst.Price = Item_NewPrice(ItemInst.object_index, ItemInst.Index);
	ItemInst.Price_Max = Item_NewPrice(ItemInst.object_index, ItemInst.Index, true);
	ItemInst.ShopItem = true;
	ItemInst.ShowValue = true;
	ItemInst.ShowPrice = true;
	ItemInst.From = ItemFrom.Shop;	
	ItemInst.FloorLevel = GetFloorLevelID(FloorLevelStr);
	
	Inventory[_Slot] = ItemInst;
	
	Item_AddToNonDuplicatableList(ItemInst.object_index, ItemInst.Index);
	
	return ItemInst;
	
}

function Shop_DestroyItem(_Slot){
	
	instance_destroy(Inventory[_Slot]);
	Inventory[_Slot] = -1;
	
}

function Shop_GetSlotCount(){
	return min(floor(TileW / 3.5), 5)
}

function Shop_SpaceItems(){
	
	//Space the items on the shop floor evenly
	
	//Get width of all items plus spacing
	var ItemsW = 0;
	var ItemSpacing = 10;
	for(var SlotIndex = 0; SlotIndex < Slots; SlotIndex++){
		var ItemInst = Inventory[SlotIndex];
		var ItemSprW = 16;//sprite_get_width(ItemInst.sprite_index);
		//if(ItemSprW < 8) ItemSprW = 16; //if no item in spot, use default width of 16
		ItemsW += (ItemSprW + ItemSpacing);
	}
	ItemsW -= ItemSpacing;
	
	var ItemsX = x + ((ShopW - ItemsW) / 2);
	var ItemX = ItemsX;
	for(var SlotIndex = 0; SlotIndex < Slots; SlotIndex++){
		var ItemInst = Inventory[SlotIndex];
		var ItemSprW = 16;//sprite_get_width(ItemInst.sprite_index);
		//if(ItemSprW < 8) ItemSprW = 16; //if no item in spot, use default width of 16
		var _x = ItemX + (ItemSprW / 2);
		var _y = ShopType == ShopTypes.Various ? y + 42 : y + 10;
		if(ItemInst != noone){
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
	}
	
	return ShopTypes.Various
	
}