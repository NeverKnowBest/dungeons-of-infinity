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

