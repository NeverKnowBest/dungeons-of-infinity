function DrawFloorTrim(TMID, _x, _y, _TileX, _TileY){
	
	if(tilemap_get_at_pixel(TMID, _x, _y) != 0){
		//clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
		tilemap_set_at_pixel(global.TMID_Water_Upper, 0, _x, _y);
		tilemap_set_at_pixel(global.TMID_Water_Lower, 0, _x, _y);
		
		tilemap_set_at_pixel(TMID, GetTileID(_TileX, _TileY), _x, _y);

	
	}	
}


function Dungeon_Draw_Walls(_RoomIndex){
	
	//Do both upper and lower walls. 
	for(var WallLevel = 0; WallLevel < 2; WallLevel++){
		
		switch(WallLevel){
			case 0: //Upper
				var WallArray = TemplateRoom.WallsUpper;
				var LevelStr = "Upper";
				var TMID_Walls = global.TMID_Walls_Upper;
				var TMID_Floors = global.TMID_Floor_Upper;
				break;
				
			case 1: //Lower
				var WallArray = TemplateRoom.WallsLower;
				var LevelStr = "Lower";
				var TMID_Walls = global.TMID_Walls_Lower;
				var TMID_Floors = global.TMID_Floor_Lower;
				break;
			
		}

		var Walls = array_length(WallArray);
		
		//some templates have a forced level tileset for walls and floors
		var TilesX = global.Level.Index == DungeonLevel.Village && global.ForceWallTheme != -1 ? 101 : 0;
		var TilesY = global.Level.Index == DungeonLevel.Village && global.ForceWallTheme != -1 ? VillageTilesY + (global.ForceWallTheme * 6) : LevelTilesY;
		var FloorTrimTileX = 42;
		var FloorTrimTileY = LevelTilesY;
		
		//Sides first
		for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
			var TLCornerX = Room.x + WallArray[WallIndex].x;
			var TLCornerY = Room.y + WallArray[WallIndex].y;
			var GID = WallArray[WallIndex].gid;
			var WallTileW = WallArray[WallIndex].width / 8;
			var WallTileH = WallArray[WallIndex].height / 8;
			
			switch(GID){
				
				case TemplateObjGID.WallLowerSideT: 			
				case TemplateObjGID.WallSideT: 				
					
					for(var i = 0; i < WallTileW; i++){
						var TileX = TLCornerX + (i * 8);
						DrawTileBlock(TMID_Walls, TileX, TLCornerY, TilesX + 6 + (TileX mod 16 == 0 ? 1 : 0) + (WallLevel * 17), TilesY, 1, 3); 
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH);
					break;	


				
				case TemplateObjGID.WallLowerSideB: 				
				case TemplateObjGID.WallSideB: 				
					
					for(var i = 0; i < WallTileW; i++){
						var TileX = TLCornerX + (i * 8);
						DrawTileBlock(TMID_Walls, TileX, TLCornerY, TilesX + 9 + (TileX mod 16 == 0 ? 1 : 0) + (WallLevel * 17), TilesY + 2, 1, 3); 
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH);
					break;
				
				
				
				case TemplateObjGID.WallLowerSideL: 
				case TemplateObjGID.WallSideL: 				
					
					for(var i = 0; i < WallTileH; i++){
						var TileY = TLCornerY + (i * 8);
						DrawTileBlock(TMID_Walls, TLCornerX, TileY, TilesX + 6 + (WallLevel * 17), TilesY + 3 + (TileY mod 16 == 0 ? 1 : 0), 3, 1); 
						DrawFloorTrim(TMID_Floors, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH);
					break;	
				
				
				case TemplateObjGID.WallLowerSideR: 				
				case TemplateObjGID.WallSideR: 
				
					for(var i = 0; i < WallTileH; i++){
						var TileY = TLCornerY + (i * 8);
						DrawTileBlock(TMID_Walls, TLCornerX, TileY, TilesX + 8 + (WallLevel * 17), TilesY + (TileY mod 16 == 0 ? 1 : 0), 3, 1); 
						DrawFloorTrim(TMID_Floors, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH);
					break;
		
			}
		
			
	
		}
	
	
	
		//Corners
		for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
			var TLCornerX = Room.x + WallArray[WallIndex].x;
			var TLCornerY = Room.y + WallArray[WallIndex].y;
			var GID = WallArray[WallIndex].gid;

			switch(GID){	
			
				
				case TemplateObjGID.WallLowerCornerTL: 
				case TemplateObjGID.WallCornerTL: 
				
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY + 24, FloorTrimTileX, FloorTrimTileY + 2 + (WallLevel * 2));
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerTR: 
				case TemplateObjGID.WallCornerTR: 
				
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 3 + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY + 24, FloorTrimTileX + 1, FloorTrimTileY + 2 + (WallLevel * 2));
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerBL:
				case TemplateObjGID.WallCornerBL: 
				
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY - 8, FloorTrimTileX, FloorTrimTileY + 3 + (WallLevel * 2));
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerBR: 
				case TemplateObjGID.WallCornerBR: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 3 + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY - 8, FloorTrimTileX + 1, FloorTrimTileY + 3 + (WallLevel * 2));	
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);		
					break;
		
				case TemplateObjGID.WallInnerTL: 
				case TemplateObjGID.WallLowerInnerTL: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 11 + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY + 24, FloorTrimTileX + 6, FloorTrimTileY + 2 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
						DrawFloorTrim(TMID_Floors, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));					
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);
					break;
				
				case TemplateObjGID.WallInnerTR: 
				case TemplateObjGID.WallLowerInnerTR: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 14 + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY + 24, FloorTrimTileX + 7, FloorTrimTileY + 2 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
						DrawFloorTrim(TMID_Floors, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);
					break;
				
				case TemplateObjGID.WallInnerBL: 
				case TemplateObjGID.WallLowerInnerBL: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 11 + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY - 8, FloorTrimTileX + 6, FloorTrimTileY + 3 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
						DrawFloorTrim(TMID_Floors, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));					
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);
					break;
				
				case TemplateObjGID.WallInnerBR: 
				case TemplateObjGID.WallLowerInnerBR:
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 14 + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY - 8, FloorTrimTileX + 7, FloorTrimTileY + 3 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(TMID_Floors, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
						DrawFloorTrim(TMID_Floors, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3);
					break;
		
			}
	
		}
	
	}


	var WallsCommonArray = TemplateRoom.WallsCommon;
	
	for(var WallsCommonIndex = 0; WallsCommonIndex < array_length(TemplateRoom.WallsCommon); WallsCommonIndex++){
		
		var Wall = WallsCommonArray[WallsCommonIndex];
		
		var WallX = Room.x + Wall.x;
		var WallY = Room.y + Wall.y;
		var WallCommonGID = Wall.gid;
		var FloorLevel = GetFloorLevelID(WallX, WallY);
		var FloorLevelStr = GetFloorLevelString(WallX, WallY);
		var PropertiesArray = Wall.properties;
		
		switch(WallCommonGID){

			case TemplateObjGID.Rail: 
				var RailTileW = Wall.width / 8;
				var RailTileH = Wall.height / 8;
				var RailEndID = GetTileID(113, LevelTilesY);
				var RailVID = GetTileID(113, LevelTilesY + 1);
				var RailHID = GetTileID(113, LevelTilesY + 2);
				var TMID = FloorLevel == UPPER ? global.TMID_Walls_Upper : global.TMID_Walls_Lower;
				
				//if these properties art set, don't draw the end tiles(it just extends the rail part further)
				var NoEnd_T = GetPropertyValue(PropertiesArray, "NoEnd_T") != -1;
				var NoEnd_B = GetPropertyValue(PropertiesArray, "NoEnd_B") != -1;
				var NoEnd_L = GetPropertyValue(PropertiesArray, "NoEnd_L") != -1;
				var NoEnd_R = GetPropertyValue(PropertiesArray, "NoEnd_R") != -1;
				
				tilemap_set_at_pixel(TMID, RailEndID, WallX, WallY);
				tilemap_set_at_pixel(TMID, RailEndID, WallX + (RailTileW * 8) - 8, WallY + (RailTileH * 8) - 8);			
				if(RailTileW > 1){
					for(var j = NoEnd_L ? 0 : 1; j < RailTileW - (NoEnd_R ? 0 : 1); j++)
						tilemap_set_at_pixel(TMID, RailHID, WallX + (j * 8), WallY);
				}
				if(RailTileH > 1){
					for(var j = NoEnd_T ? 0 : 1; j < RailTileH - (NoEnd_B ? 0 : 1); j++)		
						tilemap_set_at_pixel(TMID, RailVID, WallX, WallY + (j * 8));
				}
				var WallInst = WallObj_Create("Objs_" + FloorLevelStr, WallX, WallY, RailTileW, RailTileH);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				break;

				
			//case TemplateObjGID.Railing_Large: 
			//	var RailW = global.Templates_Room[RoomTemplate].WallsCommon[WallsCommonIndex].width / 8;
			//	var RailH = global.Templates_Room[RoomTemplate].WallsCommon[WallsCommonIndex].height / 8;
			//	var IsVertical = RailH > RailW
			//	var LargeRailTileX = global.Theme_Decor_Rails_Large * 2;
				
			//	if(IsVertical){
			//		//Top End
			//		DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX, TLCornerY, 4 + LargeRailTileX, 1, 2, 2);
					
			//		//Mid Sections
			//		var MidSections = RailH - 5;
			//		for(var MidSectionIndex = 0; MidSectionIndex < MidSections; MidSectionIndex++){
			//			DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX, TLCornerY + 16 + (MidSectionIndex * 8), 4 + LargeRailTileX, 3, 2, 1);
			//		}
					
			//		//Bottom
			//		DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX, TLCornerY + ((RailH - 3) * 8), 4 + LargeRailTileX, 4, 2, 3);
					
			//	}else{ //horizontal
					
			//		//Left and Right ends
			//		DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX, TLCornerY, 4 + LargeRailTileX, 4, 2, 3);
			//		DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX + ((RailW - 2) * 8), TLCornerY, 4 + LargeRailTileX, 4, 2, 3);
					
			//		//Mid Sections
			//		var MidSections = RailW - 4;
			//		for(var MidSectionIndex = 0; MidSectionIndex < MidSections; MidSectionIndex++){
			//			DrawTileBlock(global.TMID_Walls_Common_Upper, TLCornerX + 16 + (MidSectionIndex * 8), TLCornerY, 4 + global.Theme_Decor_Rails_Large, 7, 1, 3);
			//		}					
					
			//	}
			//	break;
		}
	
	}


	if(Room[$ "Section_WallType"] != SectionWallType.Rail) exit;
	
	var SectionID = Room[$ "Section_ID"];
	if(SectionID == 0 || SectionID > 24) exit;	
	
	var SectionWallsArray = TemplateRoom[$ "Sections"][SectionID][$ "SectionWalls"];
	
	for(var SectionWallIndex = 0; SectionWallIndex < array_length(SectionWallsArray); SectionWallIndex++){
		
		var TLCornerX = Room.x + SectionWallsArray[SectionWallIndex].x;
		var TLCornerY = Room.y + SectionWallsArray[SectionWallIndex].y;
		
		var RailTileW = SectionWallsArray[SectionWallIndex].width / 8;
		var RailTileH = SectionWallsArray[SectionWallIndex].height / 8;
		var RailEndTileID = GetTileID(113, LevelTilesY);
		var RailTileVID = GetTileID(113, LevelTilesY + 1);
		var RailTileHID = GetTileID(113, LevelTilesY + 2);			
			
		if(RailTileW > 1){
			tilemap_set_at_pixel(global.TMID_Walls_Upper, RailEndTileID, TLCornerX, TLCornerY);
			for(var j = 1; j < RailTileW - 1; j++)		
				tilemap_set_at_pixel(global.TMID_Walls_Upper, RailTileHID, TLCornerX + (j * 8), TLCornerY);
			tilemap_set_at_pixel(global.TMID_Walls_Upper, RailEndTileID, TLCornerX + ((RailTileW - 1) * 8), TLCornerY);
		}
		if(RailTileH > 1){
			tilemap_set_at_pixel(global.TMID_Walls_Upper, RailEndTileID, TLCornerX, TLCornerY);
			for(var j = 1; j < RailTileH - 1; j++)		
				tilemap_set_at_pixel(global.TMID_Walls_Upper, RailTileVID, TLCornerX, TLCornerY + (j * 8));
			tilemap_set_at_pixel(global.TMID_Walls_Upper, RailEndTileID, TLCornerX, TLCornerY + ((RailTileH - 1) * 8));
		}
		
		var WallInst = WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, RailTileW, RailTileH);
		WallInst.BlockProjectiles = false;
		WallInst.BlockItems = false;
	}

}