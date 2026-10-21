
function Dungeon_Draw_ExtraCeilings(_RoomIndex){

	var _RoomTemplate = TemplateRoom;
	
	for(var ExtraCeilingIndex = 0; ExtraCeilingIndex < array_length(TemplateRoom.ExtraCeilings); ExtraCeilingIndex++){
		
		var TLCornerX = Room.x + _RoomTemplate.ExtraCeilings[ExtraCeilingIndex].x;
		var TLCornerY = Room.y + _RoomTemplate.ExtraCeilings[ExtraCeilingIndex].y;
		var W = _RoomTemplate.ExtraCeilings[ExtraCeilingIndex].width / 8;
		var H = _RoomTemplate.ExtraCeilings[ExtraCeilingIndex].height / 8;
		
		for(var _y = 0; _y < H; _y++){
			for(var _x = 0; _x < W; _x++)
				DrawTileBlock(global.TMID_Ceiling, TLCornerX + (_x * 8), TLCornerY + (_y * 8), 8, LevelTilesY + 2, 1, 1);
		}
		
	}
	
}