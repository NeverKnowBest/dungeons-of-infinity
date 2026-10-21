function Dungeon_CreateMapRoomInst(){

	var MapRoomX = oHUD.MapX + (Room.x / 8);
	var MapRoomY = Room.y / 8;
	var MapRoomInst = instance_create_layer(MapRoomX, MapRoomY, "System", oMapRoom);
	MapRoomInst.sprite_index = global.Data_RoomTemplates[global.RoomTemplate].RoomMapSpr
	MapRoomInst.RoomIndex = global.RoomIndex;
	MapRoomInst.RoomTemplate = global.RoomTemplate;
	MapRoomInst.GridX = Room.GridX;
	MapRoomInst.GridY = Room.GridY;
	MapRoomInst.GridW = Room.GridW;
	MapRoomInst.GridH = Room.GridH;
	
	return MapRoomInst;
			
}