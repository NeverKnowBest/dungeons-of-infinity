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

/// Painted rooms (roadmap F12b): a room template with a Region ({tileset, w, h, base, open}, 8x8 tiles row by row,
/// written by tools/templates/convert.py from the Region and RegionOpen tile layers) is painted with the level's
/// region tileset instead of the generated walls. A tile is index | flags << 16, flags as Tiled applies them:
/// 1 mirrored, 2 flipped, 4 diagonal (diagonal first, then mirror, then flip); 0 is no tile. The room's transform
/// (Template.Transform, kept by RoomTemplates_PickFrom) moves and turns every tile the way TransformObjArray moves
/// the objects. base holds the room with every door closed; for each door in use, the tiles of open connected to the
/// door cell are painted over it (the passage). The walls are oWall made from the solid tiles (data/tiles "solid").

/// Matrix [a, b, c, d] (x' = a x + b y, y' = c x + d y) of a tile's flags
function RegionTiles_FlagsMatrix(_Flags){
	var _M = ((_Flags & 4) != 0) ? [0, 1, 1, 0] : [1, 0, 0, 1];
	if((_Flags & 1) != 0) _M = [-_M[0], -_M[1], _M[2], _M[3]];
	if((_Flags & 2) != 0) _M = [_M[0], _M[1], -_M[2], -_M[3]];
	return _M;
}

/// Flags of a tile turned by a room transform (ObjTransformation)
function RegionTiles_TransformFlags(_Flags, _Transform){
	static _T = [[1, 0, 0, 1], [-1, 0, 0, 1], [1, 0, 0, -1], [-1, 0, 0, -1], [0, -1, 1, 0], [0, 1, -1, 0], [0, -1, -1, 0], [0, 1, 1, 0]];
	var _A = _T[_Transform];
	var _B = RegionTiles_FlagsMatrix(_Flags);
	var _M0 = _A[0] * _B[0] + _A[1] * _B[2];
	var _M1 = _A[0] * _B[1] + _A[1] * _B[3];
	var _M2 = _A[2] * _B[0] + _A[3] * _B[2];
	var _M3 = _A[2] * _B[1] + _A[3] * _B[3];
	if(_M1 == 0) return (_M0 < 0 ? 1 : 0) | (_M3 < 0 ? 2 : 0);
	return 4 | (_M1 < 0 ? 1 : 0) | (_M2 < 0 ? 2 : 0);
}

/// Where cell i, j of a W x H grid goes when the grid is turned by a room transform (as TransformObjArray moves objects)
function RegionTiles_TransformCell(i, j, _W, _H, _Transform){
	switch(_Transform){
		case ObjTransformation.FlipH:			return [_W - 1 - i, j];
		case ObjTransformation.FlipV:			return [i, _H - 1 - j];
		case ObjTransformation.FlipHV:			return [_W - 1 - i, _H - 1 - j];
		case ObjTransformation.RotateCW:		return [_H - 1 - j, i];
		case ObjTransformation.RotateCCW:		return [j, _W - 1 - i];
		case ObjTransformation.FlipHRotateCW:	return [_H - 1 - j, _W - 1 - i];
		case ObjTransformation.FlipHRotateCCW:	return [j, i];
	}
	return [i, j];
}

/// GameMaker tile data of a region tile value: GameMaker rotates 90 clockwise before it mirrors and flips, and that
/// rotation is the diagonal plus a mirror, so a diagonal tile has the mirror bit the other way round
function RegionTiles_TileData(_Value){
	var _Flags = _Value >> 16;
	var _Data = _Value & 0xFFFF;
	var _Diagonal = (_Flags & 4) != 0;
	_Data = tile_set_rotate(_Data, _Diagonal);
	_Data = tile_set_mirror(_Data, ((_Flags & 1) != 0) != _Diagonal);
	return tile_set_flip(_Data, (_Flags & 2) != 0);
}

/// True when the room was painted with a region tileset
function RegionRoom_Is(_RoomIndex){
	return global.Level.Rooms[_RoomIndex][$ "RegionGrid"] != undefined;
}

/// Paints a painted room's template (nothing for the others) and makes its walls. Returns true when painted.
function RegionRoom_Paint(_RoomIndex){
	var _R = global.Level.Rooms[_RoomIndex];
	var _Reg = _R.Template[$ "Region"];
	if(_Reg == undefined) return false;
	if(_Reg.tileset != LevelDef.RegionTiles){
		Error("Level " + LevelDef.Name + ": room template " + string(_R.Template[$ "name"]) + " is painted with " + _Reg.tileset + " but the level's RegionTiles is \"" + LevelDef.RegionTiles + "\"", true);
		return false;
	}
	var _Tr = _R.Template[$ "Transform"] ?? ObjTransformation.None;
	var _W = _Reg.w;
	var _H = _Reg.h;
	var _Turn = (_Tr >= ObjTransformation.RotateCW);
	var _RW = _Turn ? _H : _W;
	var _RH = _Turn ? _W : _H;
	var _Base = array_create(_RW * _RH, 0);
	var _Open = array_create(_RW * _RH, 0);
	for(var j = 0; j < _H; j++){
		for(var i = 0; i < _W; i++){
			var _Cell = RegionTiles_TransformCell(i, j, _W, _H, _Tr);
			var _V = _Reg.base[j * _W + i];
			if(_V != 0) _Base[_Cell[1] * _RW + _Cell[0]] = (_V & 0xFFFF) | (RegionTiles_TransformFlags(_V >> 16, _Tr) << 16);
			_V = _Reg.open[j * _W + i];
			if(_V != 0) _Open[_Cell[1] * _RW + _Cell[0]] = (_V & 0xFFFF) | (RegionTiles_TransformFlags(_V >> 16, _Tr) << 16);
		}
	}
	_R.RegionGrid = {W : _RW, H : _RH, Tiles : _Base, Open : _Open};
	var _TM = RegionTiles_Tilemap(UPPER);
	for(var k = 0; k < _RW * _RH; k++){
		tilemap_set_at_pixel(_TM, _Base[k] == 0 ? 0 : RegionTiles_TileData(_Base[k]), _R.x + (k mod _RW) * 8, _R.y + (k div _RW) * 8);
	}
	// the passages of the doors in use (a secret door opens its own when bombed, Door_OpenSecretDoor)
	for(var d = 0; d < array_length(_R.Doors); d++){
		var _Door = _R.Doors[d];
		if(_Door.Status == DoorStatus.Unused || _Door.Status == DoorStatus.Secret_Closed) continue;
		RegionRoom_OpenPassage(_RoomIndex, _Door.x, _Door.y, false);
	}
	RegionRoom_Walls(_RoomIndex);
	return true;
}

/// Paints the passage of the door whose 32x32 cell is at _DX, _DY of the room: the open tiles connected to that cell
function RegionRoom_OpenPassage(_RoomIndex, _DX, _DY, _RemakeWalls = true){
	var _R = global.Level.Rooms[_RoomIndex];
	var _G = _R[$ "RegionGrid"];
	if(_G == undefined) return 0;
	var _TM = RegionTiles_Tilemap(UPPER);
	var _Todo = [];
	for(var j = max(0, _DY div 8); j < min(_G.H, (_DY + 32) div 8); j++){
		for(var i = max(0, _DX div 8); i < min(_G.W, (_DX + 32) div 8); i++){
			if(_G.Open[j * _G.W + i] != 0) array_push(_Todo, j * _G.W + i);
		}
	}
	var _Seen = array_create(_G.W * _G.H, false);
	var _Count = 0;
	while(array_length(_Todo) > 0){
		var _K = array_pop(_Todo);
		if(_Seen[_K] || _G.Open[_K] == 0) continue;
		_Seen[_K] = true;
		_Count++;
		_G.Tiles[_K] = _G.Open[_K];
		tilemap_set_at_pixel(_TM, RegionTiles_TileData(_G.Open[_K]), _R.x + (_K mod _G.W) * 8, _R.y + (_K div _G.W) * 8);
		var _X = _K mod _G.W;
		if(_X > 0) array_push(_Todo, _K - 1);
		if(_X < _G.W - 1) array_push(_Todo, _K + 1);
		if(_K >= _G.W) array_push(_Todo, _K - _G.W);
		if(_K + _G.W < _G.W * _G.H) array_push(_Todo, _K + _G.W);
	}
	if(_RemakeWalls) RegionRoom_Walls(_RoomIndex);
	return _Count;
}

/// The room's walls from its solid tiles, as few oWall as rows of equal runs allow (made again after a passage opens)
function RegionRoom_Walls(_RoomIndex){
	var _R = global.Level.Rooms[_RoomIndex];
	var _G = _R.RegionGrid;
	var _Solid = RegionTiles_Get(LevelDef.RegionTiles).solid;
	with(oWall) if(variable_instance_exists(id, "RegionRoom") && RegionRoom == _RoomIndex) instance_destroy();
	var _Open = {};		// runs still growing down: "x0,x1" -> [x0, y0, x1]
	for(var j = 0; j <= _G.H; j++){
		var _Runs = {};
		var i = 0;
		while(j < _G.H && i < _G.W){
			var _T = _G.Tiles[j * _G.W + i];
			if(_T == 0 || _Solid[_T & 0xFFFF] == 0){
				i++;
				continue;
			}
			var _I0 = i;
			while(i < _G.W){
				_T = _G.Tiles[j * _G.W + i];
				if(_T == 0 || _Solid[_T & 0xFFFF] == 0) break;
				i++;
			}
			_Runs[$ string(_I0) + "," + string(i)] = true;
		}
		var _Keys = variable_struct_get_names(_Open);
		for(var k = 0; k < array_length(_Keys); k++){
			if(_Runs[$ _Keys[k]] != undefined) continue;
			var _Run = _Open[$ _Keys[k]];
			var _Wall = WallObj_Create("Objs_Upper", _R.x + _Run[0] * 8, _R.y + _Run[1] * 8, _Run[2] - _Run[0], j - _Run[1]);
			_Wall.RegionRoom = _RoomIndex;
			variable_struct_remove(_Open, _Keys[k]);
		}
		_Keys = variable_struct_get_names(_Runs);
		for(var k = 0; k < array_length(_Keys); k++){
			if(_Open[$ _Keys[k]] != undefined) continue;
			var _Parts = string_split(_Keys[k], ",");
			_Open[$ _Keys[k]] = [real(_Parts[0]), j, real(_Parts[1])];
		}
	}
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

