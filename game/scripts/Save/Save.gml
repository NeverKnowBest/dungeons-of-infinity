function Save(){
	
	var SaveStruct = {
		
		Dungeon : global.Dungeon,
		DungeonIndex : global.Dungeon_Index,
		Depth	: global.Dungeon_Level,
		
		Tilemap_Higher : array_create_ext(256, F_TilemapSize),
		Tilemap_Ceiling : array_create_ext(256, F_TilemapSize),
		Tilemap_Decor_Upper : array_create_ext(256, F_TilemapSize),
		Tilemap_Walls_Upper : array_create_ext(256, F_TilemapSize),
		Tilemap_Water_Upper : array_create_ext(256, F_TilemapSize),
		Tilemap_Floor_Upper : array_create_ext(256, F_TilemapSize),
		Tilemap_Decor_Lower : array_create_ext(256, F_TilemapSize),
		Tilemap_Walls_Lower : array_create_ext(256, F_TilemapSize),
		Tilemap_Water_Lower : array_create_ext(256, F_TilemapSize),
		Tilemap_Floor_Lower : array_create_ext(256, F_TilemapSize),
		Tilemap_Pit : array_create_ext(256, F_TilemapSize),
		
	}
	
	//Tilemaps

	for(var _TileY = 0; _TileY < 256; _TileY++){
		for(var _TileX = 0; _TileX < 256; _TileX++){
			SaveStruct.Tilemap_Higher[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Higher, _TileX, _TileY);
			SaveStruct.Tilemap_Ceiling[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Ceiling, _TileX, _TileY);
			SaveStruct.Tilemap_Decor_Upper[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Decor_Upper, _TileX, _TileY);
			SaveStruct.Tilemap_Walls_Upper[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Walls_Upper, _TileX, _TileY);
			SaveStruct.Tilemap_Water_Upper[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Water_Upper, _TileX, _TileY);
			SaveStruct.Tilemap_Floor_Upper[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Floor_Upper, _TileX, _TileY);
			SaveStruct.Tilemap_Decor_Lower[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Decor_Lower, _TileX, _TileY);
			SaveStruct.Tilemap_Walls_Lower[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Walls_Lower, _TileX, _TileY);
			SaveStruct.Tilemap_Water_Lower[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Water_Lower, _TileX, _TileY);
			SaveStruct.Tilemap_Floor_Lower[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Floor_Lower, _TileX, _TileY);
			SaveStruct.Tilemap_Pit[_TileY][_TileX] = tilemap_get(global.TMID_Tiles_Pit, _TileX, _TileY);
		}		
	}
	
	var JSONStr = json_stringify(SaveStruct);
	var Buffer = buffer_create( string_byte_length(JSONStr) + 1, buffer_fixed, 1);
	buffer_write(Buffer, buffer_string, JSONStr);
	buffer_save(Buffer, "test.sav");
	buffer_delete(Buffer);
	
}

function F_TilemapSize(){
	return array_create(256)	
}

function Load(){
	
	if(file_exists("test.sav")){
		
		var Buffer = buffer_load("test.sav");
		var JSONStr = buffer_read(Buffer, buffer_string);
		buffer_delete(Buffer);
		
		var LoadStruct = json_parse(JSONStr);
		
		for(var _TileY = 0; _TileY < 256; _TileY++){
			for(var _TileX = 0; _TileX < 256; _TileX++){
				tilemap_set(global.TMID_Tiles_Higher, LoadStruct.Tilemap_Higher[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Ceiling, LoadStruct.Tilemap_Ceiling[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Decor_Upper, LoadStruct.Tilemap_Decor_Upper[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Walls_Upper, LoadStruct.Tilemap_Walls_Upper[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Water_Upper, LoadStruct.Tilemap_Water_Upper[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Floor_Upper, LoadStruct.Tilemap_Floor_Upper[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Decor_Lower, LoadStruct.Tilemap_Decor_Lower[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Walls_Lower, LoadStruct.Tilemap_Walls_Lower[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Water_Lower, LoadStruct.Tilemap_Water_Lower[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Floor_Lower, LoadStruct.Tilemap_Floor_Lower[_TileY][_TileX], _TileX, _TileY);
				tilemap_set(global.TMID_Tiles_Pit, LoadStruct.Tilemap_Pit[_TileY][_TileX], _TileX, _TileY);
			}		
		}		
		
	}
}