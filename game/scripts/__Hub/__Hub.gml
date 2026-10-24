// Feather disable GM2064

// The Sanctuary hub.
// After picking "Start" in the menu (and after "New Game" from the pause or game over menus) Link wakes up in the
// Sanctuary instead of going straight into a run. Walking through the passage behind the altar starts the run.
//
// The hub is built like the save tent level: a fixed dungeon layout (data_d, Special class) whose rooms use
// Other/Unique room templates (data_r). global.Level.Index stays on DungeonLevel.Castle so the castle tiles,
// palettes and music tables are used, and global.HubLevel tells the rest of the code that this is not a real level.

#macro HUB_DUNGEON_TEMPLATE 5	// index of the hub layout in the Special dungeon templates (data_d)
#macro HUB_LEVEL_INDEX DungeonLevel.Castle
#macro HUB_SONG SongIndex.Fairy

/// Room template used by each room of the hub layout.
function Hub_RoomTemplateName(_GridX, _GridY){
	return "Sanctuary";
}

/// Builds the hub. Called from oGame when global.HubPending is set.
function Dungeon_InitHubLevel(){

	Dungeon_Clear();

	global.HubLevel = true;
	global.SaveLevel = false;

	global.Level = new Dungeon_CreateStruct_Level(HUB_LEVEL_INDEX);

	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){

		global.Level.Map_RoomIndex[DungeonRoom.GridY][DungeonRoom.GridX] = _RoomIndex;
		if(DungeonRoom.GridW == 2) global.Level.Map_RoomIndex[DungeonRoom.GridY][DungeonRoom.GridX + 1] = _RoomIndex;
		if(DungeonRoom.GridH == 2) global.Level.Map_RoomIndex[DungeonRoom.GridY + 1][DungeonRoom.GridX] = _RoomIndex;
		if(DungeonRoom.GridW == 2 && DungeonRoom.GridH == 2) global.Level.Map_RoomIndex[DungeonRoom.GridY + 1][DungeonRoom.GridX + 1] = _RoomIndex;

		Room = new Dungeon_CreateStruct_Room(_RoomIndex);

		for(var _DoorIndex = 0; _DoorIndex < Room.DoorCount; _DoorIndex++){
			var _Door = Room.Doors[_DoorIndex];
			if(_Door.Status == DoorStatus.Unused) continue;
			Room.DoorCode = Room.DoorCode | power(2, _Door.Position - 1);
		}

	}

	global.CarpetTileBase = GetTileID(111, LevelTilesY + 2);
	global.CarpetTileTrim = GetTileID(110, LevelTilesY + 4);

	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){

		Room.Template = RoomTemplates_Pick(_RoomIndex);

		if(Room.Template == -1){
			Error("Sanctuary room template '" + string(Room.TemplateName) + "' not found in data_r", true);
			exit;
		}

		Map_GenerateRoomSprite(_RoomIndex);

		Room.TemplateName = Room.Template[$ "name"];
		Room.Lighting = Lighting_GetRoomStatus(_RoomIndex);
		Room.RoomSongIndex = HUB_SONG;

		var _Properties = Room.Template[$ "properties"];
		if(is_array(_Properties)){
			Room.ForcedTheme = GetPropertyValue(_Properties, "ForceWallTheme");
			Room.ForcedTheme_Floor = GetPropertyValue(_Properties, "ForceFloorTheme");
			Room.ForcedTheme_Floor_Upper = GetPropertyValue(_Properties, "ForceFloorTheme_Upper");
			Room.ForcedTheme_Floor_Lower = GetPropertyValue(_Properties, "ForceFloorTheme_Lower");
		}

		Dungeon_Draw_Floors(_RoomIndex);

		Dungeon_Draw_Walls(_RoomIndex);

		Dungeon_Draw_Ceiling(GetTileID(8, LevelTilesY + 2), Room.TileX, Room.TileY, Room.TileX, Room.TileY, Room.TileX + Room.TileW, Room.TileY + Room.TileH);

		Dungeon_Draw_ExtraCeilings(_RoomIndex);

		Dungeon_CreateDoors(_RoomIndex);

		Dungeon_Draw_FloorObjs(_RoomIndex);

		Dungeon_Draw_SpecialObjs_Forced(_RoomIndex);

	}

	Map_Init();

	Dungeon_InitDoors();

	Link_SetStartingPos();

	input_clear_momentary(true);

	Music_Play(HUB_SONG);

}

/// Places Link inside the Sanctuary, just past the front door, and keeps that door shut.
/// Called from Link_SetStartingPos while global.HubLevel is true.
function Hub_SetStartingPos(_RoomX, _RoomY, _EntranceDoorX, _EntranceDoorY){

	with(oLink){
		x = _EntranceDoorX + 16;
		y = _EntranceDoorY - 16;
		Facing = UP;
		HitBox.x = x;
		HitBox.y = y;
		UpdateSprites();
	}

	with(oDoor){
		if(Status == DoorStatus.Entrance){
			Status = DoorStatus.Closed;
			UpdateStatus = true;
		}
	}

}

/// Leaves the hub and starts a new run (the rainy night outside the castle).
/// Called from oLink's End Step when Link walks through the exit passage.
function Hub_StartRun(){

	audio_stop_all();

	User_SaveStats();

	Inventory_ClearAll();

	TreasureLimiter_Reset();

	global.HubLevel = false;
	global.HubPending = false;
	global.SaveLevel = false;

	room_goto(Room_Dungeon);

}
