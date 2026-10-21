

function Dungeon_Draw_Pit(_RoomIndex){
	

	var WallArray = TemplateRoom.Pit;

	var Walls = array_length(WallArray);
		
	//Sides first
	for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
		var TLCornerX = Room.x + WallArray[WallIndex].x;
		var TLCornerY = Room.y + WallArray[WallIndex].y;
		var GID = WallArray[WallIndex].gid;
		var WallTileW = WallArray[WallIndex].width / 8;
		var WallTileH = WallArray[WallIndex].height / 8;
		
		switch(GID){
			
			//Top Side
			case TemplateObjGID.WallLowerSideT: 
				for(var i = 0; i < WallTileW; i++){
					var TileX = TLCornerX + (i * 8);
					DrawTileBlock(global.TMID_Walls_Lower, TileX, TLCornerY, 23 + (i mod 2), LevelTilesY, 1, 3); 
					DrawTileBlock(global.TMID_Pit, TileX, TLCornerY + 24, 38 + (i mod 2), LevelTilesY, 1, 2); 
				}
				break;				
			
			//Bottom Side
			case TemplateObjGID.WallLowerSideB: 
				for(var i = 0; i < WallTileW; i++){
					var TileX = TLCornerX + (i * 8);
					DrawTileBlock(global.TMID_Walls_Lower, TileX, TLCornerY, 26 + (i mod 2), LevelTilesY + 2, 1, 3); 
					DrawTileBlock(global.TMID_Pit, TileX, TLCornerY - 16, 40 + (i mod 2), LevelTilesY + 2, 1, 2); 
				}
				break;				
			
			//Left Side
			case TemplateObjGID.WallLowerSideL: 
				for(var i = 0; i < WallTileH; i++){
					var TileY = TLCornerY + (i * 8);
					DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TileY, 23, LevelTilesY + 3 + (i mod 2), 3, 1); 
					DrawTileBlock(global.TMID_Pit, TLCornerX + 24, TileY, 38, LevelTilesY + 2 + (i mod 2), 2, 1); 
				}
				break;
				
			//Right Side
			case TemplateObjGID.WallLowerSideR: 
				for(var i = 0; i < WallTileH; i++){
					var TileY = TLCornerY + (i * 8);
					DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TileY, 25, LevelTilesY + (i mod 2) , 3, 1); 
					DrawTileBlock(global.TMID_Pit, TLCornerX - 16, TileY, 40, LevelTilesY + (i mod 2), 2, 1); 
				}					
				break;
	
		}
		
	}
	
	
	
	//Corners
	for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
		var TLCornerX = Room.x + WallArray[WallIndex].x;
		var TLCornerY = Room.y + WallArray[WallIndex].y;
		var GID = WallArray[WallIndex].gid;

		switch(GID){	
			
			//Top Left Corner
			case TemplateObjGID.WallLowerCornerTL: 
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 17, LevelTilesY, 3, 3); 
				DrawTileBlock(global.TMID_Pit, TLCornerX + 24, TLCornerY + 24, 34, LevelTilesY, 2, 2);
				break;	
								
			//Top Right Corner
			case TemplateObjGID.WallLowerCornerTR: 
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 20, LevelTilesY, 3, 3); 
				DrawTileBlock(global.TMID_Pit, TLCornerX - 16, TLCornerY + 24, 36, LevelTilesY, 2, 2); 
				break;
				
			//Bottom Left Corner
			case TemplateObjGID.WallLowerCornerBL:
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 17, LevelTilesY + 3, 3, 3); 
				DrawTileBlock(global.TMID_Pit, TLCornerX + 24, TLCornerY - 16, 34, LevelTilesY + 2, 2, 2); 
				break;

			//Bottom Right Corner
			case TemplateObjGID.WallLowerCornerBR: 
				DrawTileBlock(global.TMID_Walls_Lower, TLCornerX, TLCornerY, 20, LevelTilesY + 3, 3, 3); 
				DrawTileBlock(global.TMID_Pit, TLCornerX - 16, TLCornerY - 16, 36, LevelTilesY + 2, 2, 2); 	
				break;

		
		}

		
	
	}
	
}

