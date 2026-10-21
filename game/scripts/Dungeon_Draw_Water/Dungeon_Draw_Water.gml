

function Dungeon_Draw_Water(_RoomIndex){
	
	Room.Water = false;
	
	var RandomWater = true; //if false then all the water in the template is used
	
	switch(global.Level.Index){

		case DungeonLevel.Sewers:
		case DungeonLevel.Ruins2:
		case DungeonLevel.Aghanim3:
			Room.Water = Prob(Chance_WaterInRoom);
			break;		
	}

	if(Room.Type == RoomType.Village || Room.Name == "Fairy"){
		RandomWater = false;
		Room.Water = true;
	}
	
	if(!Room.Water) exit;

	
	var WaterArray = TemplateRoom.Water;	
			
	for(var WaterIndex = 0; WaterIndex < array_length(WaterArray); WaterIndex++){

		//If it's a regular Room, some of the time don't draw the water block based on prob. 
		//There's several to choose from for each template, so picking random ones with yield different water patterns
		if(!RandomWater || (RandomWater && Prob(Chance_WaterSection))){

			var Water = WaterArray[WaterIndex];
			var WaterX = Room.x + Water.x;
			var WaterY = Room.y + Water.y;
			var WaterW = Water.width;
			var WaterH = Water.height;
			var WaterTileW = WaterW / 8;
			var WaterTileH = WaterH / 8;

			var WaterTMID = GetFloorLevelTMID("Tiles_Water", WaterX, WaterY);
		
			for(var _y = 0; _y < WaterTileH; _y++){
				for(var _x = 0; _x < WaterTileW; _x++){
					var TileX = WaterX + (_x * 8);
					var TileY = WaterY + (_y * 8);
					DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + (_x mod 2), (TileY / 8) mod 2, 1, 1);	
				}
			}
			
		}
		
	}
	
	Dungeon_Draw_Water_Borders(_RoomIndex);

}

function Dungeon_Draw_Water_Borders(_RoomIndex){
	
	var RoomTilesW = Room.width / 8;
	var RoomTilesH = Room.height / 8;

	var WaterBorderTiles = ds_grid_create(RoomTilesW, RoomTilesH);
	ds_grid_clear(WaterBorderTiles, 0);
	
	for(var _y = 0; _y < RoomTilesH; _y++){
		for(var _x = 0; _x < RoomTilesW; _x++){
			var TileX = Room.x + (_x * 8);
			var TileY = Room.y + (_y * 8);
			var WaterTMID = GetFloorLevelTMID("Tiles_Water", TileX, TileY);
			if(OnWaterTile(WaterTMID, TileX, TileY)){	
				//check surrounding tiles and add border tile to ds_grid based on the other tiles	
							
				var TL = OnWaterTile(WaterTMID, TileX - 8, TileY - 8);
				var T = OnWaterTile(WaterTMID, TileX, TileY - 8);
				var TR = OnWaterTile(WaterTMID, TileX + 8, TileY - 8);
				var L = OnWaterTile(WaterTMID, TileX - 8, TileY);
				var R = OnWaterTile(WaterTMID, TileX + 8, TileY);
				var BL = OnWaterTile(WaterTMID, TileX - 8, TileY + 8);
				var B = OnWaterTile(WaterTMID, TileX, TileY + 8);
				var BR = OnWaterTile(WaterTMID, TileX + 8, TileY + 8);
							
				if(!L && !T) WaterBorderTiles[# _x, _y] = 1; //Top Left
				if(!T && L && R) WaterBorderTiles[# _x, _y] = 2; //Top
				if(!T && !R) WaterBorderTiles[# _x, _y] = 3; //Top Right
				if(!L && T && B) WaterBorderTiles[# _x, _y] = 4; //Left
				if(!R && T && B) WaterBorderTiles[# _x, _y] = 5; //Right
				if(!L && !B) WaterBorderTiles[# _x, _y] = 6; //BL
				if(!B && L && R) WaterBorderTiles[# _x, _y] = 7; //B
				if(!R && !B) WaterBorderTiles[# _x, _y] = 8; //BR
				if(!TL && T && L) WaterBorderTiles[# _x, _y] = 9; //InnerTL
				if(!TR && T && R) WaterBorderTiles[# _x, _y] = 10; //InnerTR
				if(!BL && B && L) WaterBorderTiles[# _x, _y] = 11; //InnerBL
				if(!BR && B && R) WaterBorderTiles[# _x, _y] = 12; //InnerBR
			}
							
		}
	}	
		

	for(var _y = 0; _y < RoomTilesH; _y++){
		for(var _x = 0; _x < RoomTilesW; _x++){
			var TileX = Room.x + (_x * 8);
			var TileY = Room.y + (_y * 8);
			var WaterTMID = GetFloorLevelTMID("Tiles_Water", TileX, TileY);
			if(WaterBorderTiles[# _x, _y] != 0) tilemap_set_at_pixel(WaterTMID, 0, TileX, TileY); //put back the floor tile
			switch(WaterBorderTiles[# _x, _y]){
				case 1: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS, 2, 1, 1); break; //TL
				case 2: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 2, 2, 1, 1); break; //T
				case 3: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 1, 2, 1, 1); break; //TR
				case 4: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 2, 3, 1, 1); break; //L
				case 5: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 3, 2, 1, 1); break; //R
				case 6: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS, 3, 1, 1); break; //BL
				case 7: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 3, 3, 1, 1); break; //B
				case 8: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 1, 3, 1, 1); break; //BR
				case 9: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 4, 2, 1, 1); break; //ITL
				case 10: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 5, 2, 1, 1); break; //ITR
				case 11: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 4, 3, 1, 1); break; //IBL
				case 12: DrawTileBlock(WaterTMID, TileX, TileY, WaterTileS + 5, 3, 1, 1); break; //IBR
							
			}
							
		}
	}	
	
	ds_grid_destroy(WaterBorderTiles);
	
}