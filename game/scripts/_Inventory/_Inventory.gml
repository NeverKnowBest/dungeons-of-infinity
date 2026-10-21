#macro MaxArrows 40
#macro MaxBombs 8

function Inventory_InitData(){
	
	global.Inventory_SlotLimit = Inventory_MaxSlots(3);
	global.InventoryInst = noone;
	global.Inventory_SlotSelected = 0;
	global.Inventory_Item = -1;
	global.VillageSpecialItem = noone;
	
	global.Inventory = Array_Create2D(2, global.Inventory_SlotLimit, -1);  //object_index, item index.
	
	
	
	//Drop angles when dropping inventory items. The index will increment every item drop until the end of the array while inventory is active, then switch to random angles.
	//Index goes to 0 when Link moves again.
	global.Inventory_DropAngle[0] = 90;
	global.Inventory_DropAngle[1] = 120;
	global.Inventory_DropAngle[2] = 60;
	global.Inventory_DropAngle[3] = 135;
	global.Inventory_DropAngle[4] = 45;
	global.Inventory_DropAngle[5] = 150;
	global.Inventory_DropAngle[6] = 30;
	global.Inventory_DropIndex = 0;
	global.Inventory_DropAngles = array_length(global.Inventory_DropAngle);	

}

function Inventory_MaxSlots(BagIndex = global.ItemData[oItem_Bag].Index){
	
	switch(BagIndex){
		case 0: return 7
		case 1: return 12
		case 2: return 18
		case 3: return 28
		
	}

}

function Inventory_SlotsPerRow(BagIndex = global.ItemData[oItem_Bag].Index){

	switch(BagIndex){
		case 0: return 7
		case 1: return 6
		case 2: return 6
		case 3: return 7
		
	}
	
}

function Inventory_MaxArrows(){
	return (global.ItemData[oItem_ArrowQuiver].Owns[0] ? MaxArrows * 2 : MaxArrows)	
}

function Inventory_MaxBombs(){
	return (global.ItemData[oItem_BombBag].Owns[0] ? MaxBombs * 2 : MaxBombs)	
}

function Inventory_PickSlot(_ObjectIndex, _ItemIndex){
	
	//return the slot number the item will take based on certain conditions.
	//-1 means no slots are found(inv full)
	//-2 means item doesn't take up an inventory slot
	//-3 means special village item that doesn't take space in the inventory but drawn at the top
	
	switch(_ObjectIndex){
		case oItem_Book:	
		case oItem_Key_Special:	
		case oItem_Mirror:	
		case oItem_Mushroom:
			return -3;
	}
	
	if(!global.ItemData[_ObjectIndex].UsesInvSlot) return -2;
		
	var ObjExists = Inventory_ObjExists(_ObjectIndex);
	var ItemExists = Inventory_ItemExists(_ObjectIndex, _ItemIndex);
	var Slot = Inventory_FindEmptySlot();
	
	switch(global.ItemData[_ObjectIndex].Type){
		
		case ItemType.SingleInv:
		case ItemType.Upgradeable:
			if(ObjExists != -1) Slot = ObjExists;
			break;

		case ItemType.Boolean:
			if(ItemExists != -1) Slot = ItemExists;	
			break;
	}
	
	return Slot;
	
}


function Inventory_FindEmptySlot(){
	for(var i = 0; i < Inventory_MaxSlots(); i++){	
		if(global.Inventory[i][0] == -1) return i;
	}
	return -1;
}

function Inventory_ObjExists(_ObjectIndex){
	
	//returns inventory slot index if _ObjectIndex exists in inventory
	
	for(var i = global.Inventory_SlotLimit - 1; i >= 0; i--){		
		var Obj = global.Inventory[i][0];		
		if(Obj == _ObjectIndex) return i;
	}	
	
	return -1;
	
}

function Inventory_ItemExists(_ObjectIndex, _ItemIndex){
	
	//return the slot index if both the _ObjectIndex with _ItemIndex is found in inventory
	
	for(var i = global.Inventory_SlotLimit - 1; i >= 0; i--){		
		if(global.Inventory[i][0] == _ObjectIndex && global.Inventory[i][1] == _ItemIndex) return i;
	}	
	
	return -1;
	
}

function Inventory_Add(_ObjectIndex, _ItemIndex, _Slot){

	if(_Slot == -3){
		global.VillageSpecialItem = _ObjectIndex;
	}else{
		switch(global.ItemData[_ObjectIndex].Type){
			case ItemType.Boolean: global.ItemData[_ObjectIndex].Owns[_ItemIndex] = true; break;		
			case ItemType.Upgradeable: global.ItemData[_ObjectIndex].Index = _ItemIndex; break;
		}

		global.Inventory[_Slot][0] = _ObjectIndex;
		global.Inventory[_Slot][1] = _ItemIndex;
	}
	
}

function Inventory_DeleteSlot(_Slot){
	
	var ObjIndex = global.Inventory[_Slot][0];
	var ItemIndex = global.Inventory[_Slot][1];
	
	switch(global.ItemData[ObjIndex].Type){
		case ItemType.Boolean:	global.ItemData[ObjIndex].Owns[ItemIndex] = false; break;
		case ItemType.Upgradeable: global.ItemData[ObjIndex].Index = global.ItemData[ObjIndex].Index_Min; break;
	}
	
	global.Inventory[_Slot][0] = -1;
	global.Inventory[_Slot][1] = -1;
	
	if(global.Inventory_Item == _Slot) global.Inventory_Item = -1;
	
}

function Inventory_DeleteObj(_ObjectIndex){
	
	//Finds the first _ObjectIndex in inventory starting from last slot going down, then deletes it
	
	var Slot = Inventory_ObjExists(_ObjectIndex);
	if(Slot != -1) Inventory_DeleteSlot(Slot);
	
}

function Inventory_DeleteItem(_ObjectIndex, _ItemIndex){
	
	//Finds the first _ObjectIndex with index _ItemIndex in inventory starting from last slot going down, then deletes it
	
	var Slot = Inventory_ItemExists(_ObjectIndex, _ItemIndex);
	if(Slot != -1) Inventory_DeleteSlot(Slot);
	
}


function Inventory_GetPosOffset(_SpriteIndex, _ItemIndex){
	
	//Inventory sprites have all sorts of sizes and x/y offsets, so this function sends back how much we wish to offset the sprite when drawing it on the inventory sprite.
	//Default is just sprite_get_x/yoffset(), most sprites this will already work. Some others we shift some more
	
	Offset[0] = sprite_get_xoffset(_SpriteIndex);
	Offset[1] = sprite_get_yoffset(_SpriteIndex);
	
	
	switch(_SpriteIndex){
		
		case sItem_Shield:
			if(_ItemIndex == 0) Offset[1]-=1;
			break;
			
		case sItem_Orb:
			Offset[0]+=1;
			Offset[1]+=2;			
			break;
			
		case sItem_Boomerang: 
		case sItem_Letter:
			Offset[0]+=1;
			Offset[1]+=3;
			break;	
			
		case sItem_Bow:
		case sItem_BowArrow:
		case sItem_Potion:
		case sItem_Mirror:
		case sItem_Book:
			Offset[0]+=1;
			Offset[1]+=1;
			break;
		
		case sItem_Arrows:
			Offset[0] -= (oLink.Arrows > 99 ? 4 : (oLink.Arrows > 9 ? 2 : 0))
			Offset[1] +=1;
			break;

		case sItem_Bombs:
			Offset[0] -= (oLink.Bombs > 9 ? 2 : 0)
			break;
			
		case sItem_ArrowQuiver: 
		case sItem_BombBag: 
		case sItem_Map: 
		case sItem_Compass: 
		case sItem_Cape: 
		case sItem_Magic_Large: 
		case sItem_Rod: 
		case sItem_Medallion: 
		case sItem_Hookshot: 
		case sItem_Gloves:
		case sItem_Lamp:
		case sItem_Sword_Inventory:
		case sItem_Pendant:
		case sItem_Pop:
		case sItem_Skill:
		case sItem_Key_Master:
		case sItem_Key_Special:
		case sItem_MoonPearl:
		case sItem_Mushroom:
		
			Offset[1]+=1;
			break;

		case sItem_Tunic:
		case sItem_Powder:
			Offset[1]+=2;
			break;
		
		case sItem_Kinstone:
			Offset[0]+=2;
			Offset[1]+=1;
			break;

	}
	
	return Offset;
	
}