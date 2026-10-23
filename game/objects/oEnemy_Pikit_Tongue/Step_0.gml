if(!instance_exists(ParentInst)){
	instance_destroy(id);
	exit;
}

PauseObj

if(ParentInst.State != EnemyState.Shooting){
	if(alarm[0] > -1) alarm[0]++;
	if(alarm[1] > -1) alarm[1]++;
	exit;
}

with(ItemInst){
	x = other.x;
	y = other.y + 8;
}

if(oLink.Invincible || oLink.Cape || oLink.State == LinkState.Falling) exit;

if(ItemGrabbed || Dist < GrabDist) exit;

if(!place_meeting(x, y, oLink)) exit;

	
//Pick an item from Link's inventory
	
var ItemChoices_Class = -1;
var ItemChoices_Index = 0;
var ItemChoices_Amount = 1;

var _RupeesAllowed = global.Inventory.ItemData[ItemClass.Rupee].Amount > 0;
// Inf. Bombs / Inf. Arrows cheats
var _BombsAllowed = global.Inventory.ItemData[ItemClass.Bombs].Amount[0] > 0 && !Cheat_On("Cheat_Inf_Bombs");
var _ArrowsAllowed = global.Inventory.ItemData[ItemClass.Arrows].Amount[0] > 0 && !Cheat_On("Cheat_Inf_Arrows");
	
		
var TookInventoryItem = false;
	
var _InventorySlotsWithItems = ds_list_create();
	
for(var _BagIndex = 0; _BagIndex < Inventory_Bags; _BagIndex++){
		
	var _Bag =  global.Inventory.Bags[_BagIndex];
		
	if(!_Bag.Owns) continue;
		
	for(var _SlotIndex = 0; _SlotIndex < _Bag.SlotCount; _SlotIndex++){

		var _Slot = _Bag.Slots[_SlotIndex];
		
		if(_Slot.Locked || _Slot.Ignore) continue;
			
		switch(_Slot.ItemClass){
			case -1:
			case ItemClass.Sword:
			case ItemClass.Lamp:
			case ItemClass.Tunic:
				continue;
			case ItemClass.Bombs:
			case ItemClass.Arrows:
				if(Cheat_On(_Slot.ItemClass == ItemClass.Bombs ? "Cheat_Inf_Bombs" : "Cheat_Inf_Arrows")) continue;
				break;
				
		}
			
		ds_list_add(_InventorySlotsWithItems, [_BagIndex, _SlotIndex]);
						
	}
		
}
		
if( ds_list_size(_InventorySlotsWithItems) > 0 && (Prob(0.4) || (!_RupeesAllowed && !_BombsAllowed && !_ArrowsAllowed) )){

	ds_list_shuffle(_InventorySlotsWithItems);
				
	var _InventorySlot = _InventorySlotsWithItems[| 0];
		
	var _Slot = global.Inventory.Bags[_InventorySlot[0]].Slots[_InventorySlot[1]];		
		
	ItemChoices_Class = _Slot.ItemClass;
	ItemChoices_Index = _Slot.ItemIndex;
		
	switch(global.ItemData[ItemChoices_Class].Type){
		case ItemType.Inv_Chrg:
			ItemChoices_Amount = _Slot.Amount;
			break;
		default:
			ItemChoices_Amount = 1;
			break;
	}
		
		
	TookInventoryItem = true;
		
}
	
ds_list_destroy(_InventorySlotsWithItems);


if(!TookInventoryItem){
		
	var _ItemList = ds_list_create();
		
	if(_RupeesAllowed) ds_list_add(_ItemList, ItemClass.Rupee, ItemClass.Rupee, ItemClass.Rupee);
	if(_BombsAllowed) ds_list_add(_ItemList, ItemClass.Bombs);
	if(_ArrowsAllowed) ds_list_add(_ItemList, ItemClass.Arrows);			
		
	if(ds_list_size(_ItemList) == 0){
		ds_list_destroy(_ItemList);
		exit;
	}
		
	ds_list_shuffle(_ItemList);
		
	ItemChoices_Class = _ItemList[| 0];
	ItemChoices_Index = 0;
		
	switch(ItemChoices_Class){
		case ItemClass.Rupee:
			ItemChoices_Amount = choose(1,1,5,5,10,20,40);
			if(ItemChoices_Amount > global.Inventory.ItemData[ItemClass.Rupee].Amount) ItemChoices_Amount = 1;
			break;
		case ItemClass.Bombs:
			ItemChoices_Amount = choose(1,2,3);
			if(ItemChoices_Amount > global.Inventory.ItemData[ItemClass.Bombs].Amount[0]) ItemChoices_Amount = 1;
			break;
		case ItemClass.Arrows:
			ItemChoices_Amount = choose(1,1,2,2,3,5,8,10);
			if(ItemChoices_Amount > global.Inventory.ItemData[ItemClass.Arrows].Amount[0]) ItemChoices_Amount = 1;
			break;
			
	}
		
	ds_list_destroy(_ItemList);
		
}

if(ItemChoices_Class == -1) exit;
	
	
ItemInst = ItemSpawn(ItemChoices_Class, x, y + 8, ItemFrom.Enemy, ItemSpawnType.None, oLink.FloorLevel, false);
ItemInst.Amount = ItemChoices_Amount;
	
switch(global.ItemData[ItemChoices_Class].Type){
		
	case ItemType.Pickup:
		switch(ItemChoices_Class){
			case ItemClass.Rupee:
				with(ItemInst){
					Setup = false;
					Rupee_Init(Amount);
					RupeesAdd(-Amount, false);
				}					
				break;	
					
			case ItemClass.Arrows: //arrows are a pickup item if quiver is owned
				ItemInst.Setup = false;
				Item_Consume(ItemChoices_Class, 0, -ItemChoices_Amount);
				break;
					
		}
		break;
			
	case ItemType.Inv_NoStk:
	case ItemType.Inv_Stk:

		switch(ItemChoices_Class){
			
			case ItemClass.Arrows: //arrows are a stack item if quiver is not owned
				ItemInst.Setup = false;
				Inventory_Add(ItemChoices_Class, 0, -ItemChoices_Amount, Inventory_FindItem(ItemChoices_Class));
				break;
				
			default:

				Inventory_Add(ItemChoices_Class, ItemChoices_Index, -1, Inventory_FindItem(ItemChoices_Class, ItemChoices_Index));
				with(ItemInst){
					Item_SetIndex(ItemChoices_Index);
				}

				break;
				


		}
		break;
					
	case ItemType.Inv_Bool:
	case ItemType.Inv_Chrg:
		with(ItemInst){
			Item_SetIndex(ItemChoices_Index);
		}
		Inventory_DeleteItemIndex(ItemChoices_Class, ItemChoices_Index);
		break;
			
	case ItemType.Inv_Upg:
		with(ItemInst){
			Item_SetIndex(ItemChoices_Index);
		}
		Inventory_DeleteItemClass(ItemChoices_Class);
		break;
}

ItemInst.ShowShadow = false;
ItemInst.Get_WhenLinkCollides = false;

ItemGrabbed = true;
