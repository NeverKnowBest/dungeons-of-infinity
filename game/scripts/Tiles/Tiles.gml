function GetTileID(TileX, TileY){
	return (TileY * TilesetW) + TileX;	
}


function DrawTileBlock(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockTileW, BlockTileH, Mirror = false){
	for(var _y = 0; _y < BlockTileH; _y++){
		for(var _x = 0; _x < BlockTileW; _x++){
			var Tile = (GetTileID(TopLeftTileX, TopLeftTileY) + (_y * TilesetW) + _x);
			if(Mirror){
				tilemap_set_at_pixel(TMID, tile_set_mirror(Tile, 90), PosX + ((BlockTileW - _x - 1) * 8), PosY + (_y * 8));
			}else{
				tilemap_set_at_pixel(TMID, Tile, PosX + (_x * 8), PosY + (_y * 8));
			}
		}
	}
}

function ClearTileBlock(TMID, PosX, PosY, BlockTileW, BlockTileH){
	for(var _y = 0; _y < BlockTileH; _y++){
		for(var _x = 0; _x < BlockTileW; _x++)
			tilemap_set_at_pixel(TMID, 0, PosX + (_x * 8), PosY + (_y * 8));
	}
}

function CollideTileBlock(TMID, PosX, PosY, TopLeftTileX, TopLeftTileY, BlockW, BlockH){
	for(var _y = 0; _y < BlockH; _y++){
		for(var _x = 0; _x < BlockW; _x++)
			if(tilemap_get_at_pixel(TMID, PosX, PosY) == GetTileID(TopLeftTileX, TopLeftTileY) + (_y * TilesetW) + _x) return true;	
	}
	return false;
}

function OnWaterTile(_TMID, _x, _y){
	
	var TileIndex = tilemap_get_at_pixel(_TMID, _x, _y);

	return  (	(TileIndex >= global.WaterTileStart1 && TileIndex <= global.WaterTileStart1 + 5) || 
				(TileIndex >= global.WaterTileStart2 && TileIndex <= global.WaterTileStart2 + 5) ||
				(TileIndex >= global.WaterTileStart3 && TileIndex <= global.WaterTileStart3 + 5) ||
				(TileIndex >= global.WaterTileStart4 && TileIndex <= global.WaterTileStart4 + 5)  )	
}
