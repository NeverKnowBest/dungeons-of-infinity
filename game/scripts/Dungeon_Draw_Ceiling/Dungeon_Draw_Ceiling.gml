
function Dungeon_Draw_Ceiling(TileID, TileX, TileY, MinTileX, MinTileY, MaxTileX, MaxTileY){

	//fill-in ceiling using recursive flood fill algorithm. 3rd and 4th arguments are boundaries where filling stops.

	tilemap_set_at_pixel(global.TMID_Ceiling, TileID, TileX * 8, TileY * 8);
	
	tilemap_set_at_pixel(global.TMID_Walls_Lower, 0, TileX * 8, TileY * 8);
	tilemap_set_at_pixel(global.TMID_Walls_Upper, 0, TileX * 8, TileY * 8);
	
	if(TileX + 1 < MaxTileX && tilemap_get_at_pixel(global.TMID_Walls_Upper, (TileX + 1) * 8, TileY * 8) == 0 && tilemap_get_at_pixel(global.TMID_Ceiling, (TileX + 1) * 8, TileY * 8) == 0) 
		Dungeon_Draw_Ceiling(TileID, TileX + 1, TileY, MinTileX, MinTileY, MaxTileX, MaxTileY);

	if(TileX - 1 > MinTileX && tilemap_get_at_pixel(global.TMID_Walls_Upper, (TileX - 1) * 8, TileY * 8) == 0 && tilemap_get_at_pixel(global.TMID_Ceiling, (TileX - 1) * 8, TileY * 8) == 0) 
	Dungeon_Draw_Ceiling(TileID, TileX - 1, TileY, MinTileX, MinTileY, MaxTileX, MaxTileY);

	if(TileY + 1 < MaxTileY && tilemap_get_at_pixel(global.TMID_Walls_Upper, TileX * 8, (TileY + 1) * 8) == 0 && tilemap_get_at_pixel(global.TMID_Ceiling, TileX * 8, (TileY + 1) * 8) == 0)
		Dungeon_Draw_Ceiling(TileID, TileX, TileY + 1, MinTileX, MinTileY, MaxTileX, MaxTileY);	

	if(TileY - 1 > MinTileY && tilemap_get_at_pixel(global.TMID_Walls_Upper, TileX * 8, (TileY - 1) * 8) == 0 && tilemap_get_at_pixel(global.TMID_Ceiling, TileX * 8, (TileY - 1) * 8) == 0)
		Dungeon_Draw_Ceiling(TileID, TileX, TileY - 1, MinTileX, MinTileY, MaxTileX, MaxTileY);	


}