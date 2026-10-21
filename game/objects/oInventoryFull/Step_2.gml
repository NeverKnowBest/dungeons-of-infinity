X = oLink.x - floor(W / 2);
Y = oLink.y - Y_Offset;
H = H_Min;

CanConsume = false;
CanPickup = false;


if(!instance_exists(ItemInst)) exit;

if(oLink.ItemHolding == noone && !oLink.StarActive){
	CanPickup = ItemInst.CanPickup;
	CanConsume = Item_CanConsume(ItemInst.Class, ItemInst.Index);
}


if(CanConsume || CanPickup){
	H = H_Min + 9;
	Y -= 8;
}
	