enum FloorDecor{
	Blood,
	Bones,
	Rocks,
	Grass
}

function Dungeon_Draw_Floors(_RoomIndex){
	
	var MainFloorType = Prob(0.85); //set first style as the dominant one, otherwise the floors clash too much because they change too often from Room to Room
	var FloorTile_Lower = MainFloorType ? 44 : 48;
	var FloorTile_Upper = MainFloorType ? 42 : 46;
	
	var BossRoom = RoomID(_RoomIndex, RoomType.Boss);
	var IncreaseFloorDecor = BossRoom ? 5 : (Prob(0.1) ? choose(1.5,2,2.5,3) : 1);
	
	
	var _FloorDecor = false;
	switch(global.Level.Index){
		case DungeonLevel.Start:
			_FloorDecor = true;
			break;
		case DungeonLevel.CastleJails:
			_FloorDecor = Prob(0.4);
			break;
		
		case DungeonLevel.LanmolasLair:
			if(FloorTile_Upper < 46) Room.Sand = true;
			break;
			
		case DungeonLevel.MoldormsLair:
		case DungeonLevel.Catacombs:
			_FloorDecor = Prob(0.5);
			break;
		case DungeonLevel.Aghanim3:
			_FloorDecor = Prob(0.75);
			break;
		case DungeonLevel.Sewers:
			_FloorDecor = Prob(0.3);
			break;
	}
			
	
	for(var _y = 0; _y < (Room.height / 16); _y++){
		for(var _x = 0; _x < (Room.width / 16); _x++){
			
			var PosX = Room.x + (_x * 16);
			var PosY = Room.y + (_y * 16);
			
			if(global.Level.Index == DungeonLevel.Start){
				DrawTileBlock(global.TMID_Floor_Upper, PosX, PosY, 100, VillageTilesY, 1, 1);	
				DrawTileBlock(global.TMID_Floor_Upper, PosX + 8, PosY, 100, VillageTilesY, 1, 1);	
				DrawTileBlock(global.TMID_Floor_Upper, PosX, PosY + 8, 100, VillageTilesY, 1, 1);	
				DrawTileBlock(global.TMID_Floor_Upper, PosX + 8, PosY + 8, 100, VillageTilesY, 1, 1);	
			}else{
				if(Room.Name == "Arcade")
					DrawTileBlock(global.TMID_Floor_Upper, PosX, PosY, 85, VillageTilesY + 5, 2, 2);
				else{
					DrawTileBlock(global.TMID_Floor_Lower, PosX, PosY, FloorTile_Lower, LevelTilesY, 2, 2);			
					DrawTileBlock(global.TMID_Floor_Upper, PosX, PosY, FloorTile_Upper, LevelTilesY, 2, 2);			
				}
			}
			
			if(_FloorDecor || BossRoom){
				switch(global.Level.Index){
					case DungeonLevel.Start:
						if(Prob(0.16)){
							Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Grass);
						}
						break;
					case DungeonLevel.CastleJails:
						if(Prob(0.03*IncreaseFloorDecor)) Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Blood);
						break;
					case DungeonLevel.Catacombs:
						if(Prob(0.03*IncreaseFloorDecor)) Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Bones)
						break;
					case DungeonLevel.Sewers:
						if(Prob(0.0075*IncreaseFloorDecor))	Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Bones);
						
						break;
					case DungeonLevel.Ruins3:
						if(Prob(0.05*IncreaseFloorDecor)){
							Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Rocks);
						}
						break;
					case DungeonLevel.MoldormsLair:
						if(Prob(0.04*IncreaseFloorDecor)){
							Dungeon_Draw_FloorDecor(PosX, PosY, choose(FloorDecor.Blood, FloorDecor.Bones, FloorDecor.Rocks));
						}
						break;
					case DungeonLevel.Aghanim3:
						if(Prob(0.12*IncreaseFloorDecor)){
							Dungeon_Draw_FloorDecor(PosX, PosY, choose(FloorDecor.Blood, FloorDecor.Bones));
						}
						break;

				}
			}
		}
	}
	
	//Clear Upper Floors colliding with 'LowerFloor' objects

	
	var RoomTemplate = TemplateRoom;
		
	var _LowerFloorArray = RoomTemplate.LowerFloor;
	var LowerSections = array_length(_LowerFloorArray);
	
	for(var LowerSectionIndex = 0; LowerSectionIndex < LowerSections; LowerSectionIndex++){	
		var SectionX =  Room.x + _LowerFloorArray[LowerSectionIndex].x;
		var SectionY = Room.y + _LowerFloorArray[LowerSectionIndex].y;
		var SectionW = _LowerFloorArray[LowerSectionIndex].width;
		var SectionH = _LowerFloorArray[LowerSectionIndex].height;
		for(var _y = 0; _y < SectionH / 8; _y++){
			for(var _x = 0; _x < SectionW / 8; _x++){
				tilemap_set_at_pixel(global.TMID_Water_Upper, 0, SectionX + (_x * 8), SectionY + (_y * 8)); //clear floor decor
				tilemap_set_at_pixel(global.TMID_Floor_Upper, 0, SectionX + (_x * 8), SectionY + (_y * 8));
			}		
		}
	}
	
}

function Dungeon_Draw_FloorDecor(_x, _y, DecorType){
	
	switch(DecorType){
		case FloorDecor.Blood:
			var TileStartX = 98;
			var TileStartY = 0;
			break;
		
		case FloorDecor.Bones:
			var TileStartX = 98;
			var TileStartY = 2;
			break;	
			
		case FloorDecor.Rocks:
			var TileStartX = 106;
			var TileStartY = 0;
			break;	
			
		case FloorDecor.Grass:
			var TileStartX = 106;
			var TileStartY = 2;
			break;	
			
	}
	
	var TileX = TileStartX + (irandom(3) * 2);
	var _Mirror = choose(true, false);
	DrawTileBlock(global.TMID_Water_Lower, _x, _y, TileX, TileStartY, 2, 2, _Mirror);
	DrawTileBlock(global.TMID_Water_Upper, _x, _y, TileX, TileStartY, 2, 2, _Mirror);
	
}