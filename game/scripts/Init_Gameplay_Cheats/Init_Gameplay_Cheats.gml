// Every cheat available in the cheats menu. Adding an entry here adds it to both the menu and to user saves.
// Entries with a Group go on a sub-page named after it, linked under the ungrouped cheats in the order groups first appear here.
// Entries with an Item are given to Link when a new game starts (Index defaults to the highest level for upgradeable items like
// swords, otherwise 0). The rest are handled in the game code by checking Cheat_On(Key).
global.CheatList = [
	{ Key: "Cheat_Inf_Health",	Label: "Inf. HP" },
	{ Key: "Cheat_Inf_Magic",		Label: "Inf. Magic" },
	{ Key: "Cheat_Inf_Rupees",	Label: "Inf. Rupees" },
	{ Key: "Cheat_Inf_Arrows",	Label: "Inf. Arrows" },
	{ Key: "Cheat_Inf_Keys",		Label: "Inf. Keys" },
	{ Key: "Cheat_Inf_Bombs",	Label: "Inf. Bombs" },
	{ Key: "Cheat_Max_Tunic",	Label: "Max Tunic", Item: ItemClass.Tunic },
	{ Key: "Cheat_Max_Sword",	Label: "Max Sword", Item: ItemClass.Sword },
	{ Key: "Cheat_Max_Glove",	Label: "Max Glove", Item: ItemClass.Gloves },
	{ Key: "Cheat_Max_Shield",	Label: "Max Shield", Item: ItemClass.Shield },
	{ Key: "Cheat_Equipment_PendOfHealth",	Label: "Pendant of Health", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Health },
	{ Key: "Cheat_Equipment_PendOfMagic",	Label: "Pendant of Magic", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Magic },
	{ Key: "Cheat_Equipment_PendOfProtection",	Label: "Pendant of Protection", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Protection },
	{ Key: "Cheat_Equipment_PendOfRevival",	Label: "Pendant of Revival", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Revival },
	{ Key: "Cheat_Equipment_PendOfDirection",	Label: "Pendant of Direction", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Direction },
	{ Key: "Cheat_Equipment_PendOfSecrets",	Label: "Pendant of Secrets", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Secrets },
	{ Key: "Cheat_Equipment_PendOfImmunity",	Label: "Pendant of Immunity", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Immunity },
	{ Key: "Cheat_Equipment_PendOfWealth",	Label: "Pendant of Wealth", Group: "Equipment Codes", Item: ItemClass.Pendant, Index: Pendant.Wealth },
	{ Key: "Cheat_Equipment_MoonPearl",	Label: "Moon Pearl", Group: "Equipment Codes", Item: ItemClass.MoonPearl },
	{ Key: "Cheat_Equipment_MasterKey",	Label: "Master Key", Group: "Equipment Codes", Item: ItemClass.MasterKey },
	{ Key: "Cheat_Equipment_Quiver",	Label: "Quiver", Group: "Equipment Codes", Item: ItemClass.ArrowQuiver },
	{ Key: "Cheat_Equipment_OilLamp",	Label: "Oil Lamp", Group: "Equipment Codes", Item: ItemClass.Lamp },
	{ Key: "Cheat_Equipment_FoodBag",	Label: "Food Bag", Group: "Equipment Codes", Item: ItemClass.FoodBag },
	{ Key: "Cheat_Equipment_BombBag",	Label: "Bomb Bag", Group: "Equipment Codes", Item: ItemClass.BombBag },
	{ Key: "Cheat_Equipment_PendantBag",	Label: "Pendant Bag", Group: "Equipment Codes", Item: ItemClass.PendantBag },
	{ Key: "Cheat_Equipment_TreasureBag",	Label: "Treasure Bag", Group: "Equipment Codes", Item: ItemClass.GemBag },
];

#macro CHEAT_INF_RUPEES 9999

/// @description Checks whether a cheat is enabled for the current user.
/// @param {String} _Key Cheat key to check.
/// @returns {Bool} Whether the cheat is enabled.
function Cheat_On(_Key){
	return global.Users[global.UserIndex].Cheats[$ _Key] == true;
}

/// @description Checks whether any cheats are enabled or not.
/// @param {Bool} _IsMidGame Determines if we're checking cheats in the middle of a playthrough or not
/// @returns {Bool} Whether any cheat is enabled or not.
function Cheats_Enabled(_IsMidGame) {
	// If we're trying to turn off cheats mid-game and they're already enabled, cheats need to remain enabled.
	if (_IsMidGame && global.CheatsEnabled)
		return true;
		
	var _NumCheats = array_length(global.CheatList);
	
	for(var i = 0; i < _NumCheats; i++){
		var _Cheat = global.CheatList[i].Key;
		if (Cheat_On(_Cheat))
			return true;
	}
	
	return false;
}

/// @description Checks whether an item is a container that affects inventory organization, such as the arrow quiver or bomb bag.
/// @param {ItemClass} _ItemClass Item class to check.
/// @returns {Bool} Whether the item is a container.
function Cheat_IsContainer(_ItemClass){
	return _ItemClass == ItemClass.ArrowQuiver || ItemClassToInventoryBag(_ItemClass) != -1;
}

/// @description Gives Link an item specified by a cheat definition, handling upgrades, ownership, and container items. Skips items that Link already owns or has already received.
/// @param {Struct} _Cheat Cheat definition containing the item class, key, and optional index.
function Cheat_GiveItem(_Cheat){
	var _ItemClass = _Cheat.Item;
	var _Data = global.Inventory.ItemData[_ItemClass];
	var _IsUpgrade = global.ItemData[_ItemClass].Type == ItemType.Inv_Upg;
	var _Index = _Cheat[$ "Index"] ?? (_IsUpgrade ? _Data.Index_Max : 0);
	
	// Already owned (e.g. a continued game where the cheat was applied before)
	if(_IsUpgrade ? _Data.Index >= _Index : _Data.Owns[_Index]) return;
	
	switch(_ItemClass){
		case ItemClass.ArrowQuiver: Cheat_GiveContainer(ItemClass.ArrowQuiver, ItemClass.Arrows); break;
		case ItemClass.BombBag: Cheat_GiveContainer(ItemClass.BombBag, ItemClass.Bombs); break;
		default:
			if(Item_Get(_ItemClass, _Index)) break;
			
			// No free slot. Items like the Moon Pearl, Master Key and pendants only work by being owned, so they're
			// owned without taking a slot (shops/treasures check ownership, so no duplicates will show up either)
			if(global.ItemData[_ItemClass].Type == ItemType.Inv_Bool){
				_Data.Owns[_Index] = true;
				if(_ItemClass == ItemClass.Pendant && _Index == Pendant.Secrets) oHUD.CheckPendentSecret = true;
			}
			break;
	}
}

/// @description Gives Link the quiver or bomb bag, moving matching ammunition from inventory slots into the container up to its capacity. Arrows that do not fit remain in their slots; excess bombs are removed to prevent Inventory_Update from overwriting the existing stack.
/// @param {ItemClass} _ContainerClass Item class of the container to give.
/// @param {ItemClass} _AmmoClass Item class of the ammunition to move into the container.
function Cheat_GiveContainer(_ContainerClass, _AmmoClass){
	var _IsQuiver = _ContainerClass == ItemClass.ArrowQuiver;
	var _Capacity = _IsQuiver ? MaxArrowsQuiver : MaxBombsBag;
	var _Moved = 0;
	
	for(var _BagIndex = 0; _BagIndex < Inventory_Bags; _BagIndex++){
		var _Bag = global.Inventory.Bags[_BagIndex];
		for(var i = 0; i < _Bag.SlotCount; i++){
			var _Slot = _Bag.Slots[i];
			if(_Slot.ItemClass != _AmmoClass) continue;
			
			var _Take = _IsQuiver ? min(_Slot.Amount, _Capacity - _Moved) : _Slot.Amount;
			_Moved += _Take;
			_Slot.Amount -= _Take;
			if(_Slot.Amount <= 0) Inventory_DeleteSlot([_BagIndex, i]);
		}
	}
	_Moved = min(_Moved, _Capacity);
	
	// Zeroed so the quiver doesn't convert the arrows itself (it would delete one of the slots kept above)
	global.Inventory.ItemData[_AmmoClass].Amount[0] = 0;
	Item_Get(_ContainerClass);
	
	if(_IsQuiver) global.Inventory.ItemData[ItemClass.Arrows].Amount[0] = _Moved;
	else if(_Moved > 0) Inventory_Add(ItemClass.Bombs, 0, _Moved);
}

/// @description Fills ammunition to its maximum amount for the infinite arrows or infinite bombs cheats. If no ammunition stack exists and no free inventory slot is available, gives Link the corresponding container.
/// @param {ItemClass} _AmmoClass Item class of the ammunition to fill.
/// @param {ItemClass} _ContainerClass Item class of the container that stores the ammunition.
function Cheat_FillAmmo(_AmmoClass, _ContainerClass){
	if(!global.Inventory.ItemData[_ContainerClass].Owns[0]){
		var _Slot = Inventory_FindAvailableSlot(_AmmoClass, 0);
		if(_Slot[0] == -1 || _Slot[1] == -1) Cheat_GiveContainer(_ContainerClass, _AmmoClass);
	}
	Item_Get(_AmmoClass, 0, Inventory_MaxAmount(_AmmoClass));
}

/// @description Applies all enabled gameplay cheats to Link's inventory when starting a new game or continuing a saved game. Handles already-owned items, gives containers before other items, and applies infinite health, magic, rupees, keys, arrows, and bombs.
function Init_Gameplay_Cheats(){
	
	/// Item cheats
	// Containers first, then everything else in list order
	for(var _Pass = 0; _Pass < 2; _Pass++){
		for(var i = 0; i < array_length(global.CheatList); i++){
			var _Cheat = global.CheatList[i];
			if(_Cheat[$ "Item"] == undefined || !Cheat_On(_Cheat.Key)) continue;
			if(Cheat_IsContainer(_Cheat.Item) == (_Pass == 0)) Cheat_GiveItem(_Cheat);
		}
	}
	
	// Inf. Health
	if (Cheat_On("Cheat_Inf_Health")){
		global.Inventory.ItemData[ItemClass.HeartPiece].Amount = 16;
		LinkHealth = global.Inventory.ItemData[ItemClass.HeartPiece].Amount;
	}
	
	// Inf. Magic
	if (Cheat_On("Cheat_Inf_Magic")){
		global.Inventory.ItemData[ItemClass.Magic].Amount = MAGICAMOUNT_MAX;
	}
	
	/// Inf. Rupees
	// Transactions still happen, but RupeesAdd keeps the total here
	if (Cheat_On("Cheat_Inf_Rupees")){
		global.Inventory.ItemData[ItemClass.Rupee].Amount = CHEAT_INF_RUPEES;
		oHUD.AddRupees = 0;
	}
	
	/// Inf. Keys
	// Using a key is skipped in Item_Consume
	if (Cheat_On("Cheat_Inf_Keys")){
		global.Inventory.ItemData[ItemClass.Key].Amount = MaxKeys;
	}
	
	/// Inf. Arrows / Bombs
	// Done after the item cheats, since they may need a free slot.
	// Shooting (LinkState.Bow) and placing bombs (Inventory_UseItem) don't use any, and Pikits can't steal them.
	if (Cheat_On("Cheat_Inf_Arrows")) Cheat_FillAmmo(ItemClass.Arrows, ItemClass.ArrowQuiver);
	if (Cheat_On("Cheat_Inf_Bombs")) Cheat_FillAmmo(ItemClass.Bombs, ItemClass.BombBag);
}

/// @description Initializes a user's Cheats struct with any missing entries from the global cheat list, defaulting them to off. Supports older saves and newly added cheats without overwriting existing cheat settings.
/// @param {Struct} _User User struct whose Cheats field should be initialized.
function Init_Cheats_Struct(_User) {
	if(!variable_struct_exists(_User, "Cheats")) variable_struct_set(_User, "Cheats", {});
	var _CheatsStruct = _User.Cheats;
	
	for(var i = 0; i < array_length(global.CheatList); i++){
		var _Key = global.CheatList[i].Key;
		if(!variable_struct_exists(_CheatsStruct, _Key)) variable_struct_set(_CheatsStruct, _Key, false);
	}
}
