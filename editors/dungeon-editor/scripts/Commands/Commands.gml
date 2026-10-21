
function Save(){
	
	//set warp dest room indexes. Doing this here since room indexes can change as rooms get deleted. Using the absolute values of the WarpDest to figure out that room's index
	for(var _DungeonTypeIndex = 0; _DungeonTypeIndex < 7; _DungeonTypeIndex++){
	
		var _DungeonType = global.Data_Dungeons[_DungeonTypeIndex];
	
		var _Dungeons = array_length(_DungeonType);
	
		for(var _DungeonIndex = 0; _DungeonIndex < _Dungeons; _DungeonIndex++){
		
			var _Dungeon = _DungeonType[_DungeonIndex];

			var _Rooms = array_length(_Dungeon.Rooms);
			
			//reset all Warp variables first
			for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){
				var _Room = _Dungeon.Rooms[_RoomIndex];
				_Room.Warp_DestRoomIndex = -1;
				_Room.WarpDest_WarpRoomIndex = -1;
			}
			
			for(var _WarpRoomIndex = 0; _WarpRoomIndex < _Rooms; _WarpRoomIndex++){
			
				var _WarpRoom = _Dungeon.Rooms[_WarpRoomIndex];
				
				if(_WarpRoom.Warp_DestGridPosition != -1){
					
					var _WarpDestX = _WarpRoom.Warp_DestGridPosition mod 8;
					var _WarpDestY = _WarpRoom.Warp_DestGridPosition div 8;
					
					for(var _DestRoomIndex = 0; _DestRoomIndex < _Rooms; _DestRoomIndex++){
						var _DestRoom = _Dungeon.Rooms[_DestRoomIndex];
						if(_DestRoom.GridX == _WarpDestX && _DestRoom.GridY == _WarpDestY){
							_WarpRoom.Warp_DestRoomIndex = _DestRoomIndex;
							_DestRoom.WarpDest_WarpRoomIndex = _WarpRoomIndex;
							break;
						}
					}
					
				}
			
			}
		
		}
	
	}


	var file = file_text_open_write(TEMPLATESFILE);
	file_text_write_string(file, Convert_To_JSON(global.Data_Dungeons));
	file_text_close(file);
	
}
