
function Dungeon_ClearFloorsAboveLowerSections(){
	
	//Clear Upper Floors colliding with 'LowerFloor' objects
	
	//#macro Room global.Dungeon[$ "Rooms"][global.RoomIndex]

	var LowerSections = array_length(global.Data_RoomTemplates[global.RoomTemplate][$ "LowerFloor"]);
	
	for(var LowerSectionIndex = 0; LowerSectionIndex < LowerSections; LowerSectionIndex++){	
		var SectionX = Room.x + global.Data_RoomTemplates[global.RoomTemplate][$ "LowerFloor"][LowerSectionIndex].x;
		var SectionY = Room.y + global.Data_RoomTemplates[global.RoomTemplate][$ "LowerFloor"][LowerSectionIndex].y;
		var SectionW = global.Data_RoomTemplates[global.RoomTemplate][$ "LowerFloor"][LowerSectionIndex].width;
		var SectionH = global.Data_RoomTemplates[global.RoomTemplate][$ "LowerFloor"][LowerSectionIndex].height;
		for(var _y = 0; _y < SectionH / 8; _y++){
			for(var _x = 0; _x < SectionW / 8; _x++){
				tilemap_set_at_pixel(global.TMID_Tiles_Floor_Upper, 0, SectionX + (_x * 8), SectionY + (_y * 8));
			}		
		}
	}
			
}