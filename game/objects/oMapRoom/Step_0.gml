
//If camera is in the same room or transitioning to this room, make visible on map
if(!Visited){
	if(global.CurrentRoomIndex == RoomIndex || global.TransitionRoomIndex == RoomIndex){
		Visited = true;
		global.Dungeon_VisitedRooms[RoomIndex] = true;
	}
	if(Visited)	sprite_index = global.Data_RoomTemplates[RoomTemplate].RoomMapSpr_Visited;	
}

visible = (Visited || global.ItemData[oItem_Map].Owns[0]);
