

function Dungeon_RoomActivate(_RoomIndex){
	
	if(!global.DeactivateObjs) exit;

	instance_activate_region(Room.x + 0.25, Room.y + 0.25, Room.width - 0.5, Room.height - 0.5, true);

}

function Dungeon_RoomDeActivate(_RoomIndex){
	
	if(!global.DeactivateObjs) exit;

	instance_deactivate_region(Room.x + 0.25, Room.y + 0.25, Room.width - 0.5, Room.height - 0.5, true, true);	

	//make sure important objects are kept activated
	
	instance_activate_object(oSwitchBlock); //these should remain active in the entire dungeon so they can still toggle even in a deactivated Room
	instance_activate_object(oShop); //shops need to stay active in order to setup items before being deactivated.
	instance_activate_object(oStarfield);

}