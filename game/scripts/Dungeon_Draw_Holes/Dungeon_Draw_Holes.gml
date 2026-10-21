enum HoleEdgeID{
	//T = Top, B = Bottom, L = Left, R = Right, M = Middle, I = Inner
	Empty,
	TL,
	TM,
	TR,
	ML,
	MR,
	BL,
	BM,
	BR,
	ITL,
	ITR,
	IBL,
	IBR	
}

function Dungeon_Draw_Holes(_RoomIndex){
	
	if(_RoomIndex == global.Level.RoomIndex_BossAdjacent) exit; //Don't draw if next to boss Room, since holes might take away entrance tiles

	var HoleArray = TemplateRoom.Holes;
	
	var RoomTilesW = Room.width / 8;
	var RoomTilesH = Room.height / 8;

	var HoleGrid = ds_grid_create(RoomTilesW, RoomTilesH);
	ds_grid_clear(HoleGrid, -1);
			
	for(var HoleIndex = 0; HoleIndex < array_length(HoleArray); HoleIndex++){
		
		var Hole = HoleArray[HoleIndex];
		var HoleX = Room.x + Hole.x;
		var HoleY = Room.y + Hole.y;
		var HoleW = Hole.width;
		var HoleH = Hole.height;
		var HoleTileW = HoleW / 8;
		var HoleTileH = HoleH / 8;		

		//Instead of drawing them right away, we set values in a grid where edges are, etc.
		//This is because hole tiles are determined by their neighbors, so if we draw each tile one by one, it then affects the new neighbors and doesn't produce the correct tile.

				
		//Add empty tile IDs to hole grid. 
		var HoleGridX = (HoleX - Room.x) / 8;
		var HoleGridY = (HoleY - Room.y) / 8;
		for(var _y = 0; _y < HoleTileH; _y++){
			var GridY = clamp(HoleGridY + _y, 0, RoomTilesH-1);
			for(var _x = 0; _x < HoleTileW; _x++){
				var GridX = clamp(HoleGridX + _x, 0, RoomTilesW-1); 
				//var Check
				//if(tilemap_get_at_pixel(global.TMID_Floor_Upper, Room.x + (GridX * 8), Room.x + (GridX * 8)))
				HoleGrid[# GridX, GridY] = HoleEdgeID.Empty;
			}
					
		}

		//invisible wall to block enemies
		var UpperFloorCheck = tilemap_get_at_pixel(global.TMID_Floor_Upper, HoleX, HoleY);
		var FloorLevelStr = (UpperFloorCheck ? "Upper" : "Lower");
		var inst = instance_create_layer(HoleX, HoleY, "Objs_" + FloorLevelStr, oWall);
		inst.image_xscale = HoleTileW;
		inst.image_yscale = HoleTileH;
		inst.FloorLevel = GetFloorLevelID(FloorLevelStr);
		inst.BlockLink = false;
		inst.BlockProjectiles = false;
		inst.BlockItems = false;
	
	}

	//figure out hole edges. 
	for(var _y = 0; _y < RoomTilesH; _y++){
		for(var _x = 0; _x < RoomTilesW; _x++){
			var TileX = Room.x + (_x * 8);
			var TileY = Room.y + (_y * 8);
			var TileID = HoleGrid[# _x, _y];

			if(TileID == 0){
					
				//clear floor decor
				tilemap_set_at_pixel(global.TMID_Water_Upper, 0, TileX, TileY);
				tilemap_set_at_pixel(global.TMID_Water_Lower, 0, TileX, TileY);
					
				tilemap_set_at_pixel(global.TMID_Floor_Upper, 0, TileX, TileY);
				tilemap_set_at_pixel(global.TMID_Floor_Lower, 0, TileX, TileY);
						
				var FloorTileTL = (_x - 1 < 0 || _y - 1 < 0 ? 0 : HoleGrid[# _x - 1, _y - 1]); //add edge checks
				var FloorTileTM = (_y - 1 < 0 ? 0 : HoleGrid[# _x, _y - 1]);
				var FloorTileTR = (_x + 1 >= RoomTilesW || _y - 1 < 0 ? 0 : HoleGrid[# _x + 1, _y - 1]);
				var FloorTileML = (_x - 1 < 0? 0 : HoleGrid[# _x - 1, _y]);
				var FloorTileMR = (_x + 1 >= RoomTilesW ? 0 : HoleGrid[# _x + 1, _y]);
				var FloorTileBL = (_x - 1 < 0 || _y + 1 >= RoomTilesH ? 0 : HoleGrid[# _x - 1, _y + 1]);
				var FloorTileBM = (_y + 1 >= RoomTilesH ? 0 : HoleGrid[# _x, _y + 1]);
				var FloorTileBR = (_x + 1 >= RoomTilesW || _y + 1 >= RoomTilesH ? 0 : HoleGrid[# _x + 1, _y + 1]);
	
				var ID = -1;
	
				if(FloorTileTL == -1 && FloorTileTM == -1 && FloorTileML == -1) ID = HoleEdgeID.TL;
				else if(FloorTileTR == -1 && FloorTileTM == -1 && FloorTileMR == -1) ID = HoleEdgeID.TR;
				else if(FloorTileBL == -1 && FloorTileBM == -1 && FloorTileML == -1) ID = HoleEdgeID.BL;
				else if(FloorTileBR == -1 && FloorTileBM == -1 && FloorTileMR == -1) ID = HoleEdgeID.BR;
				else if(FloorTileTM == -1) ID = HoleEdgeID.TM;
				else if(FloorTileML == -1) ID = HoleEdgeID.ML;
				else if(FloorTileMR == -1) ID = HoleEdgeID.MR;
				else if(FloorTileBM == -1) ID = HoleEdgeID.BM;
				else if(FloorTileTL == -1) ID = HoleEdgeID.ITL;
				else if(FloorTileTR == -1) ID = HoleEdgeID.ITR;
				else if(FloorTileBL == -1) ID = HoleEdgeID.IBL;
				else if(FloorTileBR == -1) ID = HoleEdgeID.IBR;

				//else continue;
					
				if(ID > 0) HoleGrid[# _x, _y] = ID;
				
			}			
			
		}		
		
	}		
		
	//draw tiles from hole grid
	for(var _y = 0; _y < RoomTilesH; _y++){
		for(var _x = 0; _x < RoomTilesW; _x++){
			var TileX = Room.x + (_x * 8);
			var TileY = Room.y + (_y * 8);
			var TileID = HoleGrid[# _x, _y];
			var Tile = -1;
			switch(TileID){

				case HoleEdgeID.TL: Tile = GetTileID(102, LevelTilesY + 4); break;
				case HoleEdgeID.TM: Tile = GetTileID(104, LevelTilesY + 4); break;
				case HoleEdgeID.TR: Tile = GetTileID(103, LevelTilesY + 4); break;
					
				case HoleEdgeID.ML: Tile = GetTileID(104, LevelTilesY + 5); break;
				case HoleEdgeID.MR: Tile = GetTileID(105, LevelTilesY + 4); break;
					
				case HoleEdgeID.BL: Tile = GetTileID(102, LevelTilesY + 5); break;
				case HoleEdgeID.BM: Tile = GetTileID(105, LevelTilesY + 5); break;
				case HoleEdgeID.BR: Tile = GetTileID(103, LevelTilesY + 5); break;
					
				case HoleEdgeID.ITL: Tile = GetTileID(106, LevelTilesY + 4); break;
				case HoleEdgeID.ITR: Tile = GetTileID(107, LevelTilesY + 4); break;
				case HoleEdgeID.IBL: Tile = GetTileID(106, LevelTilesY + 5); break;
				case HoleEdgeID.IBR: Tile = GetTileID(107, LevelTilesY + 5); break;
			}
			if(Tile > 0){
				//clear floor decor
				tilemap_set_at_pixel(global.TMID_Water_Upper, 0, TileX, TileY);
				tilemap_set_at_pixel(global.TMID_Water_Lower, 0, TileX, TileY);
					
				tilemap_set_at_pixel(global.TMID_Floor_Upper, Tile, TileX, TileY);
					
			}
			
		}		
		
	}
		
	ds_grid_destroy(HoleGrid);	
	
}