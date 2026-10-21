

function Dungeon_Draw_Walls_Sections(){
		
	//#macro Room global.Dungeon[$ "Rooms"][global.RoomIndex]
	
	if(Room[$ "Section_WallType"] != SectionWallType.Rail) exit;
	
	var SectionID = Room[$ "Section_ID"];
	if(SectionID == 0 || SectionID > 24) exit;	
	
	var SectionWallsArray = global.Templates_Room[global.RoomTemplate][$ "Sections"][SectionID][$ "SectionWalls"];
	
	for(var SectionWallIndex = 0; SectionWallIndex < array_length(SectionWallsArray); SectionWallIndex++){
		
		var TLCornerX = Room.x + SectionWallsArray[SectionWallIndex].x;
		var TLCornerY = Room.y + SectionWallsArray[SectionWallIndex].y;
		
		var RailTileW = SectionWallsArray[SectionWallIndex].width / 8;
		var RailTileH = SectionWallsArray[SectionWallIndex].height / 8;
		var RailEndTileID = GetTileID(139, LevelTilesY);
		var RailTileVID = GetTileID(139, LevelTilesY + 1);
		var RailTileHID = GetTileID(139, LevelTilesY + 2);			
			
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
		
		WallObj_Create("Objs_Upper", TLCornerX, TLCornerY, RailTileW, RailTileH);

	}


}