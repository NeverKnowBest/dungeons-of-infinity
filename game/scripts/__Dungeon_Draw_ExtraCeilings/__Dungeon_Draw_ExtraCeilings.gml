
function Dungeon_Draw_ExtraCeilings(_RoomIndex){
	
	if(!variable_struct_exists(Room.Template, "ExtraCeilings")) exit;
	
	var _TilesY = (global.Level.Index == DungeonLevel.Aghanim2 ? LevelTilesY_Aghanim2 : LevelTilesY);
	
	var _TMID;
	for(var ExtraCeilingIndex = 0; ExtraCeilingIndex < array_length(Room.Template.ExtraCeilings); ExtraCeilingIndex++){
		
		var _Obj = Room.Template.ExtraCeilings[ExtraCeilingIndex];
		var TLCornerX = Room.x + _Obj.x;
		var TLCornerY = Room.y + _Obj.y;
		var TileW = _Obj.width / 8;
		var TileH = _Obj.height / 8;
		var PropertiesArray = _Obj.properties;
		
		if(GetPropertyValue(PropertiesArray, "Boss") != -1){
			//clear the existing ceiling and place this ceiling at a lower layer so it doesn't cover the bosses who jump high and the crystal falling
			ClearTileBlock(global.TMID_Tiles_Ceiling, TLCornerX, TLCornerY, TileW, TileH);
			_TMID = global.TMID_Decor_Upper;
		}else if(GetPropertyValue(PropertiesArray, "Higher") != -1){
			_TMID = global.TMID_Tiles_Higher;
		}else{
			_TMID = global.TMID_Tiles_Ceiling;
		}
		
		for(var _y = 0; _y < TileH; _y++){
			for(var _x = 0; _x < TileW; _x++)
				DrawTileBlock(_TMID, TLCornerX + (_x * 8), TLCornerY + (_y * 8), 8, _TilesY + 2, 1, 1);
		}
		
	}
	
}