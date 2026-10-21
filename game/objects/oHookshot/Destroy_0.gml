event_inherited();
audio_stop_sound(Sound_Hookshot);

if(CapturedItem == noone) exit
if(!instance_exists(CapturedItem)) exit;

//if(DistFromLink <= 4){
//	//check if it's an inventory item and check for space

//	if(Inventory_CanAdd(CapturedItem.Class, CapturedItem.Index, CapturedItem.Amount) != -1){
//		//bring item to Link so he can collide with it. Hide it behind him so you don't see the movement
//		//CapturedItem.depth = oLink.depth + 1;
//		//CapturedItem.x = oLink.x;
//		//CapturedItem.y = oLink.y;
//		//exit;
//	}
	
//}

//put item back on it's original layer 
with(CapturedItem){
	
	z = 0;
	
	switch(oLink.Facing){
		case UP:
			ObjSetY(oLink.y - 10);
			break;
		case DOWN:
			ObjSetY(oLink.y + 10);
			break;
		case LEFT:
			x = oLink.x - 10;	
			ObjSetY(oLink.y);
			break;
		case RIGHT:
			x = oLink.x + 10;
			ObjSetY(oLink.y);
			break;
	}
	
	//depth = oLink.depth + 1;
	
	layer = layer_get_id("Objs_" + GetFloorLevelString(oLink.FloorLevel));
	ShowShadow = true;
}
			

		

