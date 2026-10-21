

function Dungeon_Draw_Walls_Common(){

	//#macro Room global.Dungeon[$ "Rooms"][global.RoomIndex]
	
	var WallsCommonArray = global.Data_RoomTemplates[global.RoomTemplate].WallsCommon;
	
	for(var WallsCommonIndex = 0; WallsCommonIndex < array_length(global.Data_RoomTemplates[global.RoomTemplate].WallsCommon); WallsCommonIndex++){

		var TLCornerX = Room.x + WallsCommonArray[WallsCommonIndex].x;
		var TLCornerY = Room.y + WallsCommonArray[WallsCommonIndex].y;
		var WallCommonGID = WallsCommonArray[WallsCommonIndex].gid;
		var UpperFloorCheck = tilemap_get_at_pixel(global.TMID_Tiles_Floor_Upper, TLCornerX, TLCornerY);
		var PropertiesArray = WallsCommonArray[WallsCommonIndex].properties;
		
		switch(WallCommonGID){

			case TemplateObjGID.Rail: 
				var RailTileW = WallsCommonArray[WallsCommonIndex].width / 8;
				var RailTileH = WallsCommonArray[WallsCommonIndex].height / 8;
				var RailEndID = GetTileID(139, LevelTilesY);
				var RailVID = GetTileID(139, LevelTilesY + 1);
				var RailHID = GetTileID(139, LevelTilesY + 2);
				var TMID = UpperFloorCheck ? global.TMID_Tiles_UpperRails : global.TMID_Tiles_Walls_Lower;
				
				tilemap_set_at_pixel(TMID, RailEndID, TLCornerX, TLCornerY);
				tilemap_set_at_pixel(TMID, RailEndID, TLCornerX + (RailTileW * 8) - 8, TLCornerY + (RailTileH * 8) - 8);			
				if(RailTileW > 1){
					for(var j = 1; j < RailTileW - 1; j++)
						tilemap_set_at_pixel(TMID, RailHID, TLCornerX + (j * 8), TLCornerY);
				}
				if(RailTileH > 1){
					for(var j = 1; j < RailTileH - 1; j++)		
						tilemap_set_at_pixel(TMID, RailVID, TLCornerX, TLCornerY + (j * 8));
				}
				var WallInst = WallObj_Create(UpperFloorCheck ? "Objs_Upper" : "Objs_Lower", TLCornerX, TLCornerY, RailTileW, RailTileH);
				WallInst.BlockProjectiles = false;
				WallInst.BlockItems = false;
				break;
			
			case TemplateObjGID.Block:
				

				if(global.Switch_Add && GetPropertyValue(PropertiesArray, "Switch")){
					global.Switch_Type = SwitchType.Block;
					global.Switch_Inst = instance_create_layer(TLCornerX, TLCornerY, UpperFloorCheck ? "Objs_Upper" : "Objs_Lower", oPushBlock);
					if(global.SpecialObj == SpecialDungeonObj.DoorSwitch) global.Switch_Add = false; //If it's revealing a key, don't set to false, that'll be done in SpecialObjs section
				}else{
					DrawTileBlock(UpperFloorCheck ? global.TMID_Tiles_Walls_Upper : global.TMID_Tiles_Walls_Lower, TLCornerX, TLCornerY, 1, 0, 2, 2);
					WallObj_Create(UpperFloorCheck ? "Objs_Upper" : "Objs_Lower", TLCornerX, TLCornerY, 2, 2);
				}
				
				break;
			
			case TemplateObjGID.Monument:

				var TileX = 142;
			
				DrawTileBlockMirror(UpperFloorCheck ? global.TMID_Tiles_Walls_Upper : global.TMID_Tiles_Walls_Lower, TLCornerX, TLCornerY, TileX, LevelTilesY, 4, 4);							
				WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, 4, 4);
				
				break;
				
			//case TemplateObjGID.Railing_Large: 
			//	var RailW = global.Data_RoomTemplates[RoomTemplate].WallsCommon[WallsCommonIndex].width / 8;
			//	var RailH = global.Data_RoomTemplates[RoomTemplate].WallsCommon[WallsCommonIndex].height / 8;
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

}