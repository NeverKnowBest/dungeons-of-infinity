#macro TEMPLATESFILE "C:\\Omnitron\\Zelda\\Project Files\\datafiles\\Data\\data_d"

Data_InitDoorCoordinates();

global.SectionObjCoordinates = json_parse(buffer_read(buffer_load("SectionObjCoordinates.json"), buffer_string));


global.DungeonGridX = 360;
global.DungeonGridY = 90;
global.DungeonGridX_2 = global.DungeonGridX / 2;
global.DungeonGridY_2 = global.DungeonGridY / 2;
global.DungeonGridW = 512;
global.DungeonGridH = 512;
view_xport[1] = global.DungeonGridX;
view_yport[1] = global.DungeonGridY;

global.DungeonRoomX = 480;
global.DungeonRoomY = 24;


instance_create_layer(0, camera_get_view_y(view_camera[1]), "UI", oDungeonGrid);

instance_create_layer(global.DungeonRoomX, global.DungeonRoomY, "UI", oDungeonRoom);

//global.Data_Dungeons = array_create(1, new init_Dungeon());
global.Data_Dungeons = json_parse(buffer_read(buffer_load(TEMPLATESFILE), buffer_string));

//for(var _DungeonTypeIndex = 0; _DungeonTypeIndex < 7; _DungeonTypeIndex++){
	
//	var _DungeonType = global.Data_Dungeons[_DungeonTypeIndex];
	
//	var _Dungeons = array_length(_DungeonType);
	
//	for(var _DungeonIndex = 0; _DungeonIndex < _Dungeons; _DungeonIndex++){
		
//		var _Dungeon = _DungeonType[_DungeonIndex];

//		var _Rooms = array_length(_Dungeon.Rooms);
		
//		for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){
			
//			var _Room = _Dungeon.Rooms[_RoomIndex];
	
//			//struct_set(_Room, "Warp_DestGridPosition", -1);			
//			//struct_set(_Room, "Warp_DestRoomIndex", -1);			
//			//struct_set(_Room, "WarpDest_WarpRoomIndex", -1);
//			struct_remove(_Room, "Warps");
//			//for(var _WarpIndex = 0; _WarpIndex < 64; _WarpIndex++){
				
//			//	var _Warp = _Room.Warps[_WarpIndex];
				
//			//	if(_Warp != 0){
					
//			//		var _WarpRoom = _Dungeon.Rooms[_WarpIndex];
					
//			//		_Room.Warp_DestGridPosition = (_WarpRoom.GridY * 8) + _WarpRoom.GridX;
					
//			//	}
//			//}
			
//		}
		
//	}
	
//}


//Save()
//game_end();



global.DungeonClass = DungeonClass.Castle
global.DungeonIndex = 0;
global.ActiveRoom = 0;
RoomButtons_LoadFromDungeon();


	
pal_swap_init_system(shdPalSwapper, noone, noone)

FPS = 0;
FPS_UpdateCounter = 0;
FPS_Updates = 0;
FPS_AverageAddition = 0;
FPS_Average = 0;

global.MsgBoxFlag = false;


//window_set_position(2560, 0);