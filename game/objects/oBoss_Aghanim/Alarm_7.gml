TakeItems_ShowBag = true;
image_index = 1;
TakeItems_BagPosX = oLink.x;
TakeItems_BagPosY = oLink.y - 16;
with(oLink){
	if(instance_exists(ItemHolding)){	
		instance_destroy(ItemHolding);
		ItemHolding = noone;
		image_index = 0;
	}
}