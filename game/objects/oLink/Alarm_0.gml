/// @description Holding Item Timer

var _FromAnyStore = FromAnyStore(ItemHolding.From);



var _GetDialogue = Item_GetDialogueClass(ItemHolding.Class) && !FromAnyStore(ItemHolding.From);

if(_GetDialogue) Item_GetDialogue(ItemHolding.Class, ItemHolding.Index, ItemHolding.Amount);


var ItemGot = (ItemHolding.Class == ItemClass.Treasure || Item_Get(ItemHolding.Class, ItemHolding.Index, ItemHolding.Amount));

if(_FromAnyStore){
	Curse_CheckTask(CurseTasks.Buy);
}

if(ItemGot){
	Curse_GetItemUncurseMsg(ItemHolding.Class, ItemHolding.Index);
}else{

	if(ItemHolding.Class != ItemClass.Rupee){
		//If there's no inventory space, then drop it behind Link
		var _DropPos = Item_DropPos();
		var _DroppedItemInst = ItemDrop(_DropPos[0], _DropPos[1], ItemHolding.Class, ItemHolding.Index, ItemHolding.Amount, ItemHolding.From);
		_DroppedItemInst.Get_ShowDialogue = false;
		if(_FromAnyStore) _DroppedItemInst.ShopItem = false;
	}
	
}

	
if(_FromAnyStore || ItemHolding.From == ItemFrom.WishPond){
	TreasureLimiter_Update(ItemHolding.Class, false);
}

instance_destroy(ItemHolding);

ItemHolding = noone;

if(!instance_exists(oDialogueBox)){
	UpdateState(LinkState.Standing);
	global.Paused = false;
}

UpdateSprites();