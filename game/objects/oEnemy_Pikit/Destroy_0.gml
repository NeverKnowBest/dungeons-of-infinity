event_inherited();

//destroy item if tongue is still holding on to it while starting a room transition
with(TongueInst){
	if(ItemGrabbed && instance_exists(ItemInst)){
		other.SwallowedItem_Class = ItemInst.Class;
		other.SwallowedItem_Index = ItemInst.Index;
		other.SwallowedItem_Amount = ItemInst.Amount;
		instance_destroy(ItemInst);		
	}
}
