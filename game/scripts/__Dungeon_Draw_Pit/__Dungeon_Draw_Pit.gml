

function Dungeon_Draw_Pit(_RoomIndex){
	
	if(!variable_struct_exists(Room.Template, "Pit")) exit;
	
	var WallArray = Room.Template.Pit;

	var Walls = array_length(WallArray);
	
	//Sides first
	for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
		
		var WallObj = WallArray[WallIndex];
		var TLCornerX = Room.x + WallObj.x;
		var TLCornerY = Room.y + WallObj.y;
		var GID = WallObj.gid;
		var WallTileW = WallObj.width / 8;
		var WallTileH = WallObj.height / 8;
		var PropertiesArray = WallObj.properties;
		
		if(GetPropertyValue(PropertiesArray, "LavaPit") != -1){
			var TilesX = 122;
			var TilesY = VillageTilesY + 18;
		}else{
			var TilesX = 38;
			var TilesY = LevelTilesY;
		}
	
		switch(GID){
			
			//Top Side
			case TemplateObjGID.WallPitSideT: 
				for(var i = 0; i < WallTileW; i++){
					var TileX = TLCornerX + (i * 8);
					DrawTileBlock(global.TMID_Pit, TileX, TLCornerY, TilesX + (i mod 2), TilesY, 1, 2); 
				}
				break;				
			
			//Bottom Side
			case TemplateObjGID.WallPitSideB: 
				for(var i = 0; i < WallTileW; i++){
					var TileX = TLCornerX + (i * 8);
					DrawTileBlock(global.TMID_Pit, TileX, TLCornerY, TilesX + 2 + (i mod 2), TilesY + 2, 1, 2); 
				}
				break;				
			
			//Left Side
			case TemplateObjGID.WallPitSideL: 
				for(var i = 0; i < WallTileH; i++){
					var TileY = TLCornerY + (i * 8);
					DrawTileBlock(global.TMID_Pit, TLCornerX, TileY, TilesX, TilesY + 2 + (i mod 2), 2, 1); 
				}
				break;
				
			//Right Side
			case TemplateObjGID.WallPitSideR: 
				for(var i = 0; i < WallTileH; i++){
					var TileY = TLCornerY + (i * 8);
					DrawTileBlock(global.TMID_Pit, TLCornerX, TileY, TilesX + 2, TilesY + (i mod 2), 2, 1); 
				}					
				break;
	
		}
		
	}
	
	
	
	//Corners
	for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
		
		var WallObj = WallArray[WallIndex];
		var TLCornerX = Room.x + WallObj.x;
		var TLCornerY = Room.y + WallObj.y;
		var GID = WallObj.gid;
		var PropertiesArray = WallObj.properties;
		
		if(GetPropertyValue(PropertiesArray, "LavaPit") != -1){
			var TilesX = 118;
			var TilesY = VillageTilesY + 18;
		}else{
			var TilesX = 34;
			var TilesY = LevelTilesY;
		}
		
		switch(GID){	
			
			//Top Left Corner
			case TemplateObjGID.WallPitCornerTL: 
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX, TilesY, 2, 2);
				break;	
								
			//Top Right Corner
			case TemplateObjGID.WallPitCornerTR: 
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX + 2, TilesY, 2, 2); 
				break;
				
			////Bottom Left Corner
			case TemplateObjGID.WallPitCornerBL:
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX, TilesY + 2, 2, 2); 
				break;

			////Bottom Right Corner
			case TemplateObjGID.WallPitCornerBR: 
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX + 2, TilesY + 2, 2, 2); 	
				break;
			
			////InnerTL Corner
			case TemplateObjGID.WallPitInnerTL:
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX, TilesY + 4, 2, 2);
				break;
				
			//InnerTR Corner
			case TemplateObjGID.WallPitInnerTR:
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX + 2, TilesY + 4, 2, 2);
				break;

			//InnerBL Corner
			case TemplateObjGID.WallPitInnerBL:
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX + 4, TilesY + 4, 2, 2);
				break;
				
			//InnerBR Corner
			case TemplateObjGID.WallPitInnerBR:
				DrawTileBlock(global.TMID_Pit, TLCornerX, TLCornerY, TilesX + 6, TilesY + 4, 2, 2);
				break;
				
		}

		
	
	}
	
}

