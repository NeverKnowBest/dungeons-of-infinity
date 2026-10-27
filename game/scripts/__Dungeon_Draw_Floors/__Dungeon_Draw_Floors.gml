enum FloorDecor{
	Blood,
	BloodBones,
	Bones,
	Rocks,
	Grass
}

function Dungeon_Draw_Floors(_RoomIndex){

	var MainFloorType = Prob(0.85); //set first style as the dominant one, otherwise the floors clash too much because they change too often from Room to Room
	var FloorTileX_Upper = MainFloorType ? 42 : 46;
	var FloorTileX_Lower = MainFloorType ? 44 : 48;		
	var FloorTileY = LevelTilesY;
		
	if(Room.ForcedTheme_Floor_Upper != -1){ 
		FloorTileX_Upper = 42 + (Room.ForcedTheme_Floor_Upper * 2);
		FloorTileY = 4 + (Room.ForcedTheme_Floor * 6);
	}
	if(Room.ForcedTheme_Floor_Lower != -1){ 
		FloorTileX_Lower = 42 + (Room.ForcedTheme_Floor_Lower * 2);
		FloorTileY = 4 + (Room.ForcedTheme_Floor * 6);
	}

	
	var BossRoom = TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss);
	var IncreaseFloorDecor = BossRoom ? 5 : (Prob(0.1) ? choose(1.5,2,2.5) : 1);
	
	var _FloorDecor = false;
	switch(LevelDef.Theme){
		case DungeonLevel.Start:
			_FloorDecor = true;
			break;
		case DungeonLevel.CastleJails:
			_FloorDecor = Prob(0.4);
			break;
		case DungeonLevel.Sewers:
			_FloorDecor = Prob(0.3);
			break;		
		case DungeonLevel.LanmolasLair:
			if(BossRoom) FloorTileX_Upper = 42;
			if(FloorTileX_Upper < 46) Room.Sand = true;
			break;
		case DungeonLevel.Catacombs:		
		case DungeonLevel.MoldormsLair:
		case DungeonLevel.Aghanim1:
			_FloorDecor = Prob(0.6);
			break;


	}

	
	if(Room.TemplateClass == RoomTemplateClass.Special || TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "TMNT") || global.SaveLevel || global.HubLevel) _FloorDecor = false;

	
	if(LevelDef.Theme == DungeonLevel.Start){
		FloorTileX_Lower = 94;
		FloorTileX_Upper = 94;
		FloorTileY = VillageTilesY + 10;
	}else{
		switch(Room.TemplateName){
			case "Arcade":
				FloorTileX_Lower = 85;
				FloorTileX_Upper = 85;
				FloorTileY = VillageTilesY + 5;
				break;
						
			case "TMNT":
				FloorTileX_Lower = 19;
				FloorTileX_Upper = 19;
				FloorTileY = VillageTilesY + 17;
				break;
						
			case "FinalBossHall":
			case "FinalBoss":
				FloorTileX_Lower = 135;
				FloorTileX_Upper = 135;
				FloorTileY = VillageTilesY + 12;
				break;
						
			default:

				break;
		}
						
	}

	
	for(var _y = 0; _y < (Room.height / 16); _y++){
		for(var _x = 0; _x < (Room.width / 16); _x++){
			
			var PosX = Room.x + (_x * 16);
			var PosY = Room.y + (_y * 16);


			DrawTileBlock(global.TMID_Floor_Lower, PosX, PosY, FloorTileX_Lower, FloorTileY, 2, 2);			
			DrawTileBlock(global.TMID_Floor_Upper, PosX, PosY, FloorTileX_Upper, FloorTileY, 2, 2);	
			
				
			if(_FloorDecor || BossRoom){
				switch(LevelDef.Theme){
					case DungeonLevel.Start:
						if(Prob(0.16)) Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Grass);
						break;
						
					case DungeonLevel.CastleJails:
						
						if(!global.Gore) break;
						
						var _Decor = (BossRoom ? choose(FloorDecor.Blood, FloorDecor.Blood, FloorDecor.Bones, FloorDecor.BloodBones) : FloorDecor.Blood);
												
						if(Prob(0.03*IncreaseFloorDecor)) Dungeon_Draw_FloorDecor(PosX, PosY, _Decor);
						
						break;
						
					case DungeonLevel.Catacombs:
						if(Prob(0.05*IncreaseFloorDecor)) Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Bones)
						break;
						
					case DungeonLevel.Sewers:
						if(Prob(0.0085*IncreaseFloorDecor))	Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Bones);
						
						break;

					case DungeonLevel.MoldormsLair:
					case DungeonLevel.Aghanim1:
						if(Prob(0.05*IncreaseFloorDecor)){
							if(global.Gore){
								Dungeon_Draw_FloorDecor(PosX, PosY, choose(FloorDecor.Blood, FloorDecor.Blood, FloorDecor.Bones, FloorDecor.BloodBones));
							}else{
								Dungeon_Draw_FloorDecor(PosX, PosY, FloorDecor.Bones);
							}
						}
						
						break;

				}
			}
		}
	}
	
	
	//Clear Upper Floors colliding with 'LowerFloor' objects
	
	if(!variable_struct_exists(Room.Template, "LowerFloor")) exit; //some template classes don't have the LowerFloors layer, so exit
		
	var _LowerFloorArray = Room.Template.LowerFloor;
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
	
	var TileStartX, TileStartY, Tiles;
	switch(DecorType){
		case FloorDecor.Blood:
			TileStartX = 104;
			TileStartY = 0;
			Tiles = 3;
			break;
		
		case FloorDecor.Bones:
			TileStartX = 104;
			TileStartY = 2;
			Tiles = 4;
			break;	

		case FloorDecor.BloodBones:
			TileStartX = 110;
			TileStartY = 0;
			Tiles = 3;
			break;	

		case FloorDecor.Grass:
			TileStartX = 112;
			TileStartY = 2;
			Tiles = 4;
			break;	

			
	}
	
	var TileX = TileStartX + (irandom(Tiles - 1) * 2);
	var _Mirror = FlipCoin_Bool();
	DrawTileBlock(global.TMID_Water_Lower, _x, _y, TileX, TileStartY, 2, 2, _Mirror);
	DrawTileBlock(global.TMID_Water_Upper, _x, _y, TileX, TileStartY, 2, 2, _Mirror);
	
}