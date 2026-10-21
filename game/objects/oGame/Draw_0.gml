
if(DEBUG){
	
	if(global.ShowUsedSpaces){
		draw_set_color(#FFFFFF);
		var _Rooms = array_length(global.Level.Rooms);

		for(var _RoomIndex = 0; _RoomIndex < _Rooms; _RoomIndex++){

			for(var _SpaceIndex = 0; _SpaceIndex < array_length(Room.UsedSpace); _SpaceIndex++){
		
				var _Space = Room.UsedSpace[_SpaceIndex];
				draw_rectangle(_Space.x1, _Space.y1, _Space.x2, _Space.y2, true);	
		
			}

		}
	}

	//draw_set_font(global.MenuFont);
	//draw_text(oLink.x + 8, oLink.y - 6, Time_Str(global.TempTimeAvg));
	
	//draw_sprite(global.MothulaSlot_ReelSprite, 0, oLink.x, oLink.y);
	
}
	

