function GetTileID(TileX, TileY){
	return (TileY * TilesetW) + TileX;	
}


function DrawTileBlock(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockTileW, BlockTileH, Mirror = false, Flip = false, RotateCW = false){
	
	for(var _y = 0; _y < BlockTileH; _y++){
		for(var _x = 0; _x < BlockTileW; _x++){
			
			var _OffsetX = _x;
			var _OffsetY = _y;
			
			var Tile = (GetTileID(TopLeftTileX, TopLeftTileY) + (_y * TilesetW) + _x);
			
			Tile = tile_set_mirror(Tile, Mirror);
			Tile = tile_set_flip(Tile, Flip);
			Tile = tile_set_rotate(Tile, RotateCW);
			
			if(Mirror){
				_OffsetX = (BlockTileW - _x - 1);
			}
			
			if(Flip){
				_OffsetY = (BlockTileH - _y - 1);
			}
			
			if(RotateCW){
				
				if(Mirror && !Flip){
					_OffsetX = (BlockTileH - _y - 1);
					_OffsetY = (BlockTileW - _x - 1);
				}else if(Flip && !Mirror){
					_OffsetX = _y;
					_OffsetY = _x;	
				}else if(Flip && Mirror){	
					_OffsetX = _y;
					_OffsetY = (BlockTileW - _x - 1);
				}else{
					_OffsetX = (BlockTileH - _y - 1);
					_OffsetY = _x;		

				}
				
			}
			
			tilemap_set_at_pixel(TMID, Tile, PosX + (_OffsetX * 8), PosY + (_OffsetY * 8));		

		}
	}
}

function DrawTileBlockRotate(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockTileW, BlockTileH, Angle = 0){
	
	var _Mirror = false;
	var _Flip = false;
	var _RotateCW = false;
	
	switch(Angle){
		case 90:
			_Flip = true;
			break;
		case 180:
			_Mirror = true;
			_Flip = true;	
			break;
		case 270:
			_RotateCW = true;
			break;
		
	}
	
	return DrawTileBlock(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockTileW, BlockTileH, _Mirror, _Flip, _RotateCW)
	
}

function ClearTileBlock(TMID, PosX, PosY, BlockTileW, BlockTileH, _TileID = 0){
	for(var _y = 0; _y < BlockTileH; _y++){
		for(var _x = 0; _x < BlockTileW; _x++)
			tilemap_set_at_pixel(TMID, _TileID, PosX + (_x * 8), PosY + (_y * 8));
	}
}

function CollideTileBlock(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockW, BlockH){
	
	var _TLTile = GetTileID(TopLeftTileX, TopLeftTileY);
	
	for(var _y = 0; _y < BlockH; _y++){
		for(var _x = 0; _x < BlockW; _x++)
			if(tilemap_get_at_pixel(TMID, PosX, PosY) == _TLTile + (_y * TilesetW) + _x) return true;	
	}
	return false;
}

function OnSpikeTile(_TMID, _x, _y){
	
	var TileIndex = tilemap_get_at_pixel(_TMID, _x, _y);

	return  (	(TileIndex >= global.SpikeTileID[0] && TileIndex <= global.SpikeTileID[0] + 4) || 
				(TileIndex >= global.SpikeTileID[1] && TileIndex <= global.SpikeTileID[1] + 4)  )	
}

function OnWaterTile(_TMID, _x, _y){
	
	var TileIndex = tilemap_get_at_pixel(_TMID, _x, _y);

	return  (	(TileIndex >= global.WaterTileStart1 && TileIndex <= global.WaterTileStart1 + 5) || 
				(TileIndex >= global.WaterTileStart2 && TileIndex <= global.WaterTileStart2 + 5) ||
				(TileIndex >= global.WaterTileStart3 && TileIndex <= global.WaterTileStart3 + 5) ||
				(TileIndex >= global.WaterTileStart4 && TileIndex <= global.WaterTileStart4 + 5) ||
				(TileIndex >= global.WaterTileStart5 && TileIndex <= global.WaterTileStart5 + 5) ||
				(TileIndex >= global.WaterTileStart6 && TileIndex <= global.WaterTileStart6 + 5)  )	
}

function OnSandTile(_TMID, _x, _y){
	
	var TileIndex = tilemap_get_at_pixel(_TMID, _x, _y);
	
	for(var i = 0; i < 8; i++){
		if(TileIndex == global.SandTile[i]) return true;
	}
	
	return false;
	
}

function GetFloorLevelString(){
	
	//return the string for floor level based either on macro ID value, or x/y position
	
	if(argument_count == 1){
		
		//Argument is floor level macro ID (UPPER, UPPERLOWER, LOWER)
		var FloorLevel = argument[0];
		return FloorLevel == LOWER ? "Lower" : "Upper";
		
	}else if(argument_count == 2){
		
		//Arguments are x/y position
		var _x = argument[0];
		var _y = argument[1];
		
		//return either "Upper" or "Lower" depending if floor tile exists on upper floor at x,y
		if(tilemap_get_at_pixel(global.TMID_Floor_Upper, _x, _y) != 0)
			return "Upper";
		else
			return "Lower"	
		
	}

	
}

function GetFloorLevelID(){
	//returns the FloorLevel value from the string or position

	if(argument_count == 1){
		
		//Argument is floor level str
		var FloorLevel = argument[0];
		return FloorLevel == "Upper" ? UPPER : LOWER;
		
	}else if(argument_count == 2){
		
		//Arguments are x/y position
		var _x = argument[0];
		var _y = argument[1];
		
		//return either "Upper" or "Lower" depending if floor tile exists on upper floor at x,y
		if(tilemap_get_at_pixel(global.TMID_Floor_Upper, _x, _y) != 0)
			return UPPER;
		else
			return LOWER;	
		
	}

	
}

function GetFloorLevelTMID(TMString, _x, _y){
	
	//returns the Upper or Lower TMID for a point x,y for TM string name.
	
	var FloorLevelStr = GetFloorLevelString(_x, _y);

	return layer_tilemap_get_id(layer_get_id(TMString + "_" + FloorLevelStr));

}


/// Tile bands (roadmap F6b): a region's own band of sTiles, 156 x 6 tiles laid out like a theme band, sits below the
/// original rows (100 and up). tools/import/import_region.py writes it from incoming/<region>/tileset.png and adds its
/// line here (band name: first tile row); a level paints its walls and floors with it through TilesBand in the level
/// sheet (LevelTilesY, scripts/__Levels). Region tilesets are loaded on first use (RegionTiles_Get).
function TileBands_Init(){
	global.TileBands = {};
	global.RegionTiles = {};
	// end of the imported bands
}


/// Region tilesets (roadmap F6b): a tileset of a region's own (ts_<Name>, imported from incoming/<region>/tiles/),
/// painted tile by tile in blocks of 16x16 like the map16 of ALttP, with a class for every tile (floor, solid,
/// deep_water, ledge_s, bush, stairs...) that is the collision source of the outdoor rooms (roadmap F12b).
/// data/tiles/<Name>.json (written by the importer) holds the classes and the blocks; the level sheet names the
/// tileset with RegionTiles. Its tiles go on two tile layers of their own, made when first painted: Tiles_Region_Upper
/// over the upper floor (under the water) and Tiles_Region_Lower over the lower floor. Dungeon_Clear empties them.
/// They have no layer script, so the lighting shader of the dungeon layers (PixelRender) does not darken them yet.
#macro REGIONTILES_DEPTH_UPPER 1350
#macro REGIONTILES_DEPTH_LOWER 2150

function RegionTiles_Get(_Name){
	if(_Name == "") return undefined;
	if(variable_struct_exists(global.RegionTiles, _Name)) return global.RegionTiles[$ _Name];
	var _Buffer = buffer_load(GAMEDIR_TILES + _Name + ".json");
	if(_Buffer == -1){
		show_debug_message("Region tileset not found: " + _Name);
		return undefined;
	}
	var _Data = json_parse(buffer_read(_Buffer, buffer_string));
	buffer_delete(_Buffer);
	_Data.Tileset = asset_get_index(_Data.tileset);
	// each block becomes four tile data values (index with the mirror and flip bits): top left, top right, bottom left, bottom right
	var _Blocks = _Data.blocks;
	for(var i = 0; i < array_length(_Blocks); i++){
		for(var k = 0; k < 4; k++){
			var _T = _Blocks[i][k];
			var _Tile = tile_set_mirror(_T[0], (_T[1] & 1) != 0);
			_Blocks[i][k] = tile_set_flip(_Tile, (_T[1] & 2) != 0);
		}
	}
	global.RegionTiles[$ _Name] = _Data;
	show_debug_message("Region tileset loaded: " + _Name + " (" + string(array_length(_Data.class) - 1) + " tiles, " + string(array_length(_Blocks)) + " blocks)");
	return _Data;
}

function RegionTiles_LayerName(_FloorLevel){
	return _FloorLevel == UPPER ? "Tiles_Region_Upper" : "Tiles_Region_Lower";
}

/// The region tile layer of a floor with the level's tileset on it, made the first time
function RegionTiles_Tilemap(_FloorLevel){
	var _Tiles = RegionTiles_Get(LevelDef.RegionTiles);
	if(_Tiles == undefined) return -1;
	var _Layer = layer_get_id(RegionTiles_LayerName(_FloorLevel));
	if(_Layer == -1) _Layer = layer_create(_FloorLevel == UPPER ? REGIONTILES_DEPTH_UPPER : REGIONTILES_DEPTH_LOWER, RegionTiles_LayerName(_FloorLevel));
	var _TM = layer_tilemap_get_id(_Layer);
	if(_TM == -1){
		_TM = layer_tilemap_create(_Layer, 0, 0, _Tiles.Tileset, 256, 256);
	}else if(tilemap_get_tileset(_TM) != _Tiles.Tileset){
		tilemap_clear(_TM, 0);
		tilemap_tileset(_TM, _Tiles.Tileset);
	}
	return _TM;
}

/// Empties the region tile layers (a new level)
function RegionTiles_Clear(){
	for(var _Floor = LOWER; _Floor <= UPPER; _Floor++){
		var _Layer = layer_get_id(RegionTiles_LayerName(_Floor));
		if(_Layer == -1) continue;
		var _TM = layer_tilemap_get_id(_Layer);
		if(_TM != -1) tilemap_clear(_TM, 0);
	}
}

/// Paints block _Block of the level's region tileset with its top left corner at _X, _Y (pixels, 8 px grid).
/// _Mirror and _Flip turn the whole block. Returns false when the level has no region tileset or no such block.
function RegionTiles_PaintBlock(_Block, _X, _Y, _FloorLevel = UPPER, _Mirror = false, _Flip = false){
	var _Tiles = RegionTiles_Get(LevelDef.RegionTiles);
	if(_Tiles == undefined || _Block < 0 || _Block >= array_length(_Tiles.blocks)) return false;
	var _TM = RegionTiles_Tilemap(_FloorLevel);
	var _Quad = _Tiles.blocks[_Block];
	for(var k = 0; k < 4; k++){
		var _CX = k mod 2;
		var _CY = k div 2;
		var _Tile = _Quad[k];
		if(_Mirror){
			_CX = 1 - _CX;
			_Tile = tile_set_mirror(_Tile, !tile_get_mirror(_Tile));
		}
		if(_Flip){
			_CY = 1 - _CY;
			_Tile = tile_set_flip(_Tile, !tile_get_flip(_Tile));
		}
		tilemap_set_at_pixel(_TM, _Tile, _X + (_CX * 8), _Y + (_CY * 8));
	}
	return true;
}

/// Class of the region tile at a pixel ("" where none is painted): what the outdoor rooms will collide with (F12b)
function RegionTiles_ClassAt(_X, _Y, _FloorLevel = UPPER){
	var _Tiles = RegionTiles_Get(LevelDef.RegionTiles);
	if(_Tiles == undefined) return "";
	var _Layer = layer_get_id(RegionTiles_LayerName(_FloorLevel));
	if(_Layer == -1) return "";
	var _TM = layer_tilemap_get_id(_Layer);
	if(_TM == -1) return "";
	var _Data = tilemap_get_at_pixel(_TM, _X, _Y);
	if(_Data == -1) return "";
	var _Index = tile_get_index(_Data);
	return (_Index > 0 && _Index < array_length(_Tiles.class)) ? _Tiles.class[_Index] : "";
}

