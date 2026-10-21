function DrawFloorTrim(_WallLevel, _x, _y, _TileX, _TileY){
	
	if(_WallLevel == 0){
		var _FloorLayer = global.TMID_Floor_Upper;
		var _WaterLayer = global.TMID_Water_Upper;
	}else{
		var _FloorLayer = global.TMID_Floor_Lower;
		var _WaterLayer = global.TMID_Water_Lower;		
	}
	
	if(tilemap_get_at_pixel(_FloorLayer, _x, _y) != 0){		
		tilemap_set_at_pixel(_FloorLayer, GetTileID(_TileX, _TileY), _x, _y);
		//clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
		tilemap_set_at_pixel(_WaterLayer, 0, _x, _y);		
	}	
}


function Dungeon_Draw_Walls(_RoomIndex){
	
	var CreateUpperWallObjs = false;
	//if it's all lower doors, no need to create the upper walls. 
	
	var _DoorCount = array_length(DungeonRoom.Doors);		
	for(var _DoorIndex = 0; _DoorIndex < _DoorCount; _DoorIndex++){	
		var _Door = Room.Doors[_DoorIndex];			
		if(_Door.Position <= 12){
			CreateUpperWallObjs = true;
			break;
		}
	}	

	//Don't draw lower walls if obstacle class or sections class with sectionid being < 25, which sometimes have holes where the lower walls don't need wall objs
	//var CreateUpperWallObjs = Room.TemplateClass != RoomTemplateClass.Main_Lower;
	var CreateLowerWallObjs = (Room.TemplateClass != RoomTemplateClass.Obstacles && !(Room.TemplateClass == RoomTemplateClass.Sections && Room.Section_ID < 25));	

	
	//Do both upper and lower walls. 
	for(var WallLevel = 0; WallLevel < 2; WallLevel++){
		
		if(WallLevel == 1 && !variable_struct_exists(Room.Template, "WallsLower")) break; //some template classes don't have the WallsLower layer, so exit
		
		switch(WallLevel){

			case 0: //Upper
				var WallArray = Room.Template.WallsUpper;
				var LevelStr = "Upper";
				var TMID_Walls = global.TMID_Walls_Upper;
				break;
				
			case 1: //Lower
				var WallArray = Room.Template.WallsLower;
				var LevelStr = "Lower";
				var TMID_Walls = global.TMID_Walls_Lower;
				break;
			
		}

		var Walls = array_length(WallArray);

		var FloorTrimTileX = 42;
		var FloorTrimTileY = LevelTilesY;
		
		var TilesThemeX = 0;
		var TilesThemeY = LevelTilesY;
		
		//some templates have a forced level tileset for walls and floors
		switch(global.Level.Index){
			case DungeonLevel.Start:
				TilesThemeY = 4; //can't be LevelTilesY for Start since that's -1, so set it to Level 0's tileY which is 4;
				break;
			case DungeonLevel.Aghanim2:
				FloorTrimTileY = LevelTilesY_Aghanim2;
				TilesThemeX = 118;
				TilesThemeY = LevelTilesY + 12;
				break;
		}

		if(Room.ForcedTheme != -1){
			var TilesThemeX = Room.ForcedTheme > 11 ? 101 : 0;
			var TilesThemeY = 4 + (Room.ForcedTheme * 6);
		}

		
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
				var TilesX = 84;
				var TilesY = VillageTilesY + 18;
			}else{
				var TilesX = TilesThemeX;
				var TilesY = TilesThemeY;	
			}
		
			switch(GID){
				
				case TemplateObjGID.WallLowerSideT: 
				case TemplateObjGID.WallSideT: 				
					
					for(var i = 0; i < WallTileW; i++){
						var TileX = TLCornerX + (i * 8);
						DrawTileBlock(TMID_Walls, TileX, TLCornerY, TilesX + 6 + (TileX mod 16 == 0 ? 1 : 0) + (WallLevel * 17), TilesY, 1, 3); 
						DrawFloorTrim(WallLevel, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
					}		
					
					if((GID == TemplateObjGID.WallLowerSideT && CreateLowerWallObjs) || (GID == TemplateObjGID.WallSideT && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH, TOP, GID);

					break;	


				
				case TemplateObjGID.WallLowerSideB: 				
				case TemplateObjGID.WallSideB: 				

					for(var i = 0; i < WallTileW; i++){
						var TileX = TLCornerX + (i * 8);
						DrawTileBlock(TMID_Walls, TileX, TLCornerY, TilesX + 9 + (TileX mod 16 == 0 ? 1 : 0) + (WallLevel * 17), TilesY + 2, 1, 3); 
						DrawFloorTrim(WallLevel, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
					}
					
					if((GID == TemplateObjGID.WallLowerSideB && CreateLowerWallObjs) || (GID == TemplateObjGID.WallSideB && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH, BOTTOM, GID);
					
					break;
				
				
				
				case TemplateObjGID.WallLowerSideL: 
				case TemplateObjGID.WallSideL: 				
					
					for(var i = 0; i < WallTileH; i++){
						var TileY = TLCornerY + (i * 8);
						DrawTileBlock(TMID_Walls, TLCornerX, TileY, TilesX + 6 + (WallLevel * 17), TilesY + 3 + (TileY mod 16 == 0 ? 1 : 0), 3, 1); 
						DrawFloorTrim(WallLevel, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					
					if((GID == TemplateObjGID.WallLowerSideL && CreateLowerWallObjs) || (GID == TemplateObjGID.WallSideL && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH, LEFT, GID);
					
					break;	
				
				
				case TemplateObjGID.WallLowerSideR: 				
				case TemplateObjGID.WallSideR: 
				
					for(var i = 0; i < WallTileH; i++){
						var TileY = TLCornerY + (i * 8);
						DrawTileBlock(TMID_Walls, TLCornerX, TileY, TilesX + 8 + (WallLevel * 17), TilesY + (TileY mod 16 == 0 ? 1 : 0), 3, 1); 
						DrawFloorTrim(WallLevel, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					
					if((GID == TemplateObjGID.WallLowerSideR && CreateLowerWallObjs) || (GID == TemplateObjGID.WallSideR && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, WallTileW, WallTileH, RIGHT, GID);
					
					break;
		
			}
		
			
	
		}
	
	
	
		//all Corner types + inner corner trims
		for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
			
			var WallObj = WallArray[WallIndex];
			var TLCornerX = Room.x + WallObj.x;
			var TLCornerY = Room.y + WallObj.y;
			var GID = WallObj.gid;
			var PropertiesArray = WallObj.properties;
			
			if(GetPropertyValue(PropertiesArray, "LavaPit") != -1){
				var TilesX = 84;
				var TilesY = VillageTilesY + 18;
			}else{
				var TilesX = TilesThemeX;
				var TilesY = TilesThemeY;					
			}
			
			switch(GID){	
			
				
				case TemplateObjGID.WallLowerCornerTL: 
				case TemplateObjGID.WallCornerTL: 
				
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3); 
					//DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY + 24, FloorTrimTileX, FloorTrimTileY + 2 + (WallLevel * 2));
					if((GID == TemplateObjGID.WallLowerCornerTL && CreateLowerWallObjs) || (GID == TemplateObjGID.WallCornerTL && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, TOPLEFT, GID);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerTR: 
				case TemplateObjGID.WallCornerTR: 
					
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 3 + (WallLevel * 17), TilesY, 3, 3); 
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, false, false, true); 
					DrawTileBlockRotate(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, 270); 
					//DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY + 24, FloorTrimTileX + 1, FloorTrimTileY + 2 + (WallLevel * 2));
					if((GID == TemplateObjGID.WallLowerCornerTR && CreateLowerWallObjs) || (GID == TemplateObjGID.WallCornerTR && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, TOPRIGHT, GID);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerBL:
				case TemplateObjGID.WallCornerBL: 
				
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY + 3, 3, 3); 
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, false, true, false); 
					DrawTileBlockRotate(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, 90); 
					//DrawFloorTrim(TMID_Floors, TLCornerX + 24, TLCornerY - 8, FloorTrimTileX, FloorTrimTileY + 3 + (WallLevel * 2));
					if((GID == TemplateObjGID.WallLowerCornerBL && CreateLowerWallObjs) || (GID == TemplateObjGID.WallCornerBL && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, BOTTOMLEFT, GID);		
					break;
				
				
				case TemplateObjGID.WallLowerCornerBR: 
				case TemplateObjGID.WallCornerBR: 
					
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 3 + (WallLevel * 17), TilesY + 3, 3, 3); 
					//DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, true, true, false); 
					DrawTileBlockRotate(TMID_Walls, TLCornerX, TLCornerY, TilesX + (WallLevel * 17), TilesY, 3, 3, 180); 
					//DrawFloorTrim(TMID_Floors, TLCornerX - 8, TLCornerY - 8, FloorTrimTileX + 1, FloorTrimTileY + 3 + (WallLevel * 2));	
					if((GID == TemplateObjGID.WallLowerCornerBR && CreateLowerWallObjs) || (GID == TemplateObjGID.WallCornerBR && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, BOTTOMRIGHT, GID);		
					break;
		
				case TemplateObjGID.WallInnerTL: 
				case TemplateObjGID.WallLowerInnerTL: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 11 + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(WallLevel, TLCornerX + 24, TLCornerY + 24, FloorTrimTileX + 6, FloorTrimTileY + 2 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(WallLevel, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
						DrawFloorTrim(WallLevel, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));					
					}
					if((GID == TemplateObjGID.WallLowerInnerTL && CreateLowerWallObjs) || (GID == TemplateObjGID.WallInnerTL && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, TOPLEFT, GID);
					break;
				
				case TemplateObjGID.WallInnerTR: 
				case TemplateObjGID.WallLowerInnerTR: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 14 + (WallLevel * 17), TilesY, 3, 3); 
					DrawFloorTrim(WallLevel, TLCornerX - 8, TLCornerY + 24, FloorTrimTileX + 7, FloorTrimTileY + 2 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(WallLevel, TileX, TLCornerY + 24, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 2 + (WallLevel * 2));
						DrawFloorTrim(WallLevel, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					if((GID == TemplateObjGID.WallLowerInnerTR && CreateLowerWallObjs) || (GID == TemplateObjGID.WallInnerTR && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, TOPRIGHT, GID);
					break;
				
				case TemplateObjGID.WallInnerBL: 
				case TemplateObjGID.WallLowerInnerBL: 
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 11 + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(WallLevel, TLCornerX + 24, TLCornerY - 8, FloorTrimTileX + 6, FloorTrimTileY + 3 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(WallLevel, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
						DrawFloorTrim(WallLevel, TLCornerX + 24, TileY, FloorTrimTileX + 4, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));					
					}
					if((GID == TemplateObjGID.WallLowerInnerBL && CreateLowerWallObjs) || (GID == TemplateObjGID.WallInnerBL && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, BOTTOMLEFT, GID);
					break;
				
				case TemplateObjGID.WallInnerBR: 
				case TemplateObjGID.WallLowerInnerBR:
					
					DrawTileBlock(TMID_Walls, TLCornerX, TLCornerY, TilesX + 14 + (WallLevel * 17), TilesY + 3, 3, 3); 
					DrawFloorTrim(WallLevel, TLCornerX - 8, TLCornerY - 8, FloorTrimTileX + 7, FloorTrimTileY + 3 + (WallLevel * 2));
					for(var i = 0; i < 3; i++){
						var TileX = TLCornerX + (i * 8);
						var TileY = TLCornerY + (i * 8);
						DrawFloorTrim(WallLevel, TileX, TLCornerY - 8, FloorTrimTileX + 2 + ((TileX / 8) mod 2), FloorTrimTileY + 3 + (WallLevel * 2));
						DrawFloorTrim(WallLevel, TLCornerX - 8, TileY, FloorTrimTileX + 5, FloorTrimTileY + 2 + (WallLevel * 2) + ((TileY / 8) mod 2));
					}
					if((GID == TemplateObjGID.WallLowerInnerBR && CreateLowerWallObjs) || (GID == TemplateObjGID.WallInnerBR && CreateUpperWallObjs)) WallObj_Create("Objs_" + LevelStr, TLCornerX, TLCornerY, 3, 3, BOTTOMRIGHT, GID);
					break;
		
			}
	
		}
		
		//corner trims only
		for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
			var TLCornerX = Room.x + WallArray[WallIndex].x;
			var TLCornerY = Room.y + WallArray[WallIndex].y;
			var GID = WallArray[WallIndex].gid;

			switch(GID){	
			
				
				case TemplateObjGID.WallLowerCornerTL: 
				case TemplateObjGID.WallCornerTL: 
					DrawFloorTrim(WallLevel, TLCornerX + 24, TLCornerY + 24, FloorTrimTileX, FloorTrimTileY + 2 + (WallLevel * 2));	
					break;
				
				
				case TemplateObjGID.WallLowerCornerTR: 
				case TemplateObjGID.WallCornerTR: 
					DrawFloorTrim(WallLevel, TLCornerX - 8, TLCornerY + 24, FloorTrimTileX + 1, FloorTrimTileY + 2 + (WallLevel * 2));
					break;
				
				
				case TemplateObjGID.WallLowerCornerBL:
				case TemplateObjGID.WallCornerBL: 
					DrawFloorTrim(WallLevel, TLCornerX + 24, TLCornerY - 8, FloorTrimTileX, FloorTrimTileY + 3 + (WallLevel * 2));
					break;
				
				
				case TemplateObjGID.WallLowerCornerBR: 
				case TemplateObjGID.WallCornerBR: 
					DrawFloorTrim(WallLevel, TLCornerX - 8, TLCornerY - 8, FloorTrimTileX + 1, FloorTrimTileY + 3 + (WallLevel * 2));		
					break;
		
			}
	
		}
		
	}

	if(variable_struct_exists(Room.Template, "WallsCommon")){
	
		var WallsCommonArray = Room.Template.WallsCommon;
	
		for(var WallsCommonIndex = 0; WallsCommonIndex < array_length(Room.Template.WallsCommon); WallsCommonIndex++){
		
			var Wall = WallsCommonArray[WallsCommonIndex];
		
			var WallX = Room.x + Wall.x;
			var WallY = Room.y + Wall.y;
			var WallTileW = Wall.width / 8;
			var WallTileH = Wall.height / 8;
			
			var Properties = Wall.properties;
			var FloorLevelProperty = GetPropertyValue(Properties, "FloorLevel");
			var FloorLevel = FloorLevelProperty != -1 ? FloorLevelProperty : GetFloorLevelID(WallX, WallY);
			var FloorLevelStr = GetFloorLevelString(FloorLevel);
			var TMID = FloorLevel == UPPER ? global.TMID_Walls_Upper : global.TMID_Walls_Lower;
			var ObjLayer = "Objs_" + FloorLevelStr;		
			var WallType = Wall[$ "type"];

			
			if(!struct_exists(Wall, "gid")){
				var WallInst = WallObj_Create(ObjLayer, WallX, WallY, WallTileW, WallTileH);
				continue;
			}
			
			switch(Wall.gid){
					
				case TemplateObjGID.Rail: 
					
					var _TilesY = (Room.ForcedTheme == -1 ? LevelTilesY : 4 + (Room.ForcedTheme * 6));

					var RailEndID = GetTileID(113, _TilesY);
					var RailVID = GetTileID(113, _TilesY + 1);
					var RailHID = GetTileID(113, _TilesY + 2);
						
					//if these properties art set, don't draw the end tiles(it just extends the rail part further)
					var NoEnd_T = GetPropertyValue(Properties, "NoEnd_T") != -1;
					var NoEnd_B = GetPropertyValue(Properties, "NoEnd_B") != -1;
					var NoEnd_L = GetPropertyValue(Properties, "NoEnd_L") != -1;
					var NoEnd_R = GetPropertyValue(Properties, "NoEnd_R") != -1;
				
					tilemap_set_at_pixel(TMID, RailEndID, WallX, WallY);
					tilemap_set_at_pixel(TMID, RailEndID, WallX + (WallTileW * 8) - 8, WallY + (WallTileH * 8) - 8);			
					if(WallTileW > 1){
						for(var j = NoEnd_L ? 0 : 1; j < WallTileW - (NoEnd_R ? 0 : 1); j++)
							tilemap_set_at_pixel(TMID, RailHID, WallX + (j * 8), WallY);
					}
					if(WallTileH > 1){
						for(var j = NoEnd_T ? 0 : 1; j < WallTileH - (NoEnd_B ? 0 : 1); j++)		
							tilemap_set_at_pixel(TMID, RailVID, WallX, WallY + (j * 8));
					}
					var WallInst = WallObj_Create(ObjLayer, WallX, WallY, WallTileW, WallTileH);
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
			
				case TemplateObjGID.Block:
				case TemplateObjGID.SpikeBlock:
					
					var SpikeBlocks = ObstacleClassCheck(_RoomIndex, RoomObstacleClass.SpikeBlocks) || global.Level.Index == DungeonLevel.Aghanim2;
					
					if(Wall.gid == TemplateObjGID.SpikeBlock && !SpikeBlocks) break;;
					
					var IsSwitch = (GetPropertyValue(Properties, "Switch") != -1);					
					
					for(var _BlockY = 0; _BlockY < floor(WallTileH / 2); _BlockY++){
						for(var _BlockX = 0; _BlockX < floor(WallTileW / 2); _BlockX++){
							
							var _BlockPosX = WallX + (_BlockX * 16);
							var _BlockPosY = WallY + (_BlockY * 16);
							
							if(SpikeBlocks){
								var _BlockInst = instance_create_layer(_BlockPosX, _BlockPosY, ObjLayer, oSpikeBlock);
								_BlockInst.BlockProjectiles = false;
								_BlockInst.BlockItems = false;
							}else{
								
								DrawTileBlock(TMID, _BlockPosX, _BlockPosY, 1, 0, 2, 2);
								
								if(IsSwitch){
									Room.Switch.Inst = instance_create_layer(_BlockPosX, _BlockPosY, ObjLayer, oPushBlock);
									Room.Switch.Inst.Moved = true;
									Room.Switch.Inst.TMID = TMID;
								}
								
							}

						}					
					}
				
					if(!IsSwitch && !SpikeBlocks){
						var WallInst = WallObj_Create(ObjLayer, WallX, WallY, WallTileW, WallTileH);
						WallInst.BlockProjectiles = false;
						WallInst.BlockItems = false;
						if(!SpikeBlocks) global.SpawnedBlocks = true;
					}					
				
					break;
			
			}
	
		}
	}
	

	
	if(Room[$ "Section_WallType"] != SectionWallType.Rail) exit;
	
	var SectionID = Room[$ "Section_ID"];
	if(SectionID == 0) exit;	
	
	var SectionWallsArray = Room.Template[$ "Sections"][SectionID][$ "SectionWalls"];
	var SectionWalls = array_length(SectionWallsArray);
	if(SectionWalls == 0) exit;
	var SectionWallGID = SectionWallsArray[0].gid;
	
	var Passes = SectionWallGID == TemplateObjGID.Rail ? 1 : 2; //2 passes for large rail, 1st for corners, then 2nd for sides which fixes overlapping issues
	
	for(var PassIndex = 0; PassIndex < Passes; PassIndex++){
		
		for(var SectionWallIndex = 0; SectionWallIndex < SectionWalls; SectionWallIndex++){
		
			var _Section = SectionWallsArray[SectionWallIndex];
			var TLCornerX = Room.x + _Section.x;
			var TLCornerY = Room.y + _Section.y;
			var RailW = _Section.width;
			var RailH = _Section.height;
			var RailTileW = RailW / 8;
			var RailTileH = RailH / 8;
			
			switch(SectionWallGID){
			
				case TemplateObjGID.Rail:

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
		
					break;
				
				case TemplateObjGID.RailLarge: 

					var ShiftString = GetPropertyValue(_Section[$ "properties"], "SB");
				
					if(RailTileW > 3){  //horizontal

					
						switch(PassIndex){
							case 0:
								//ends
								DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY, 114, LevelTilesY + 3, 2, 3);
								DrawTileBlock(global.TMID_Walls_Upper, TLCornerX + RailW - 16, TLCornerY, 114, LevelTilesY + 3, 2, 3);
								break;
							
							case 1:
								//Mid Sections
								var MidSections = RailTileW - 4;
								for(var MidSectionIndex = 0; MidSectionIndex < MidSections; MidSectionIndex++){
									DrawTileBlock(global.TMID_Walls_Upper, TLCornerX + 16 + (MidSectionIndex * 8), TLCornerY, 113, LevelTilesY + 3, 1, 3);
								}
								break;
								
						}
				

					}else{

						RailTileW = 2;
						if(ShiftString == "R") TLCornerX += 8;

						switch(PassIndex){
							case 0:
								//Top
								DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY, 114, LevelTilesY + 3, 2, 2);
								//Bottom
								DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY + RailH - 24, 114, LevelTilesY + 3, 2, 3);
								break;
							
							case 1:
								//Mid Sections
								var MidSections = RailTileH - 5;
								for(var MidSectionIndex = 0; MidSectionIndex < MidSections; MidSectionIndex++){
									DrawTileBlock(global.TMID_Walls_Upper, TLCornerX, TLCornerY + 16 + (MidSectionIndex * 8), 114, LevelTilesY + 2, 2, 1);
								}	
								break;
								
						}
					
					}
					break;
			}


			if(PassIndex == 0){
				var WallInst = WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, RailTileW, RailTileH);
				if(SectionWallGID == TemplateObjGID.Rail){
					WallInst.BlockProjectiles = false;
					WallInst.BlockItems = false;
				}
			}
		

		}
	
	}

}