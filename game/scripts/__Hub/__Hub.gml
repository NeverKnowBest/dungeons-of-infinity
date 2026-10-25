// Feather disable GM2064

// The Sanctuary hub.
// After picking "Start" in the menu (and after "New Game" from the pause or game over menus) Link wakes up in the
// Sanctuary instead of going straight into a run. Walking out through the front door starts the run.
//
// The hub is built like the save tent level: a fixed dungeon layout (data_d, Special class) whose rooms use
// Other/Unique room templates (data_r) for their NPCs and objects. global.Level.Index stays on DungeonLevel.Castle
// so the level tables stay valid, and global.HubLevel tells the rest of the code that this is not a real level.
//
// Unlike dungeon rooms, hub rooms are not drawn with the tileset: each one is a pre-rendered picture of the original
// A Link to the Past room (oHubBackdrop, one sprite under Link and one over him) with oWall collision boxes
// taken from that room's tile attributes.

#macro HUB_DUNGEON_TEMPLATE 5	// index of the hub layout in the Special dungeon templates (data_d)
#macro HUB_LEVEL_INDEX DungeonLevel.Castle
#macro HUB_SONG SongIndex.Sanctuary

/// Room template used by each room of the hub layout.
function Hub_RoomTemplateName(_GridX, _GridY){
	return "Sanctuary";
}

/// Builds the hub. Called from oGame when global.HubPending is set.
function Dungeon_InitHubLevel(){

	Dungeon_Clear();

	global.HubLevel = true;
	global.SaveLevel = false;
	
	// the skin and bonus item this user picked last time (only unlocked ones)
	global.LinkCharacterIndex = User_GetSkin();
	global.StartingGear = User_GetBonusItem();
	with(oLink){
		Link_LoadCharacterIndex();
		UpdateSprites();
	}

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

		Dungeon_CreateDoors(_RoomIndex);

		Dungeon_Draw_SpecialObjs_Forced(_RoomIndex);

		Hub_CreateScenery(_RoomIndex);

	}

	Map_Init();

	Dungeon_InitDoors();

	Link_SetStartingPos();

	input_clear_momentary(true);

	Music_Play(HUB_SONG);

}

/// Picture, collision and exit of a hub room.
function Hub_CreateScenery(_RoomIndex){
	
	switch(Room.TemplateName){
		
		case "Sanctuary":
			
			instance_create_layer(Room.x, Room.y, "ObjsFloor_Upper", oHubBackdrop, {sprite_index : sHub_Sanctuary});
			instance_create_layer(Room.x, Room.y, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_Sanctuary_Over});
			
			//animated fire on the two altar lamps (animated tiles in the original game)
			instance_create_layer(Room.x + 200, Room.y + 128, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
			instance_create_layer(Room.x + 296, Room.y + 128, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
			
			var _Walls = Hub_SanctuaryWalls();
			for(var i = 0; i < array_length(_Walls); i++){
				var _Wall = _Walls[i];
				WallObj_Create("Objs_Upper", Room.x + _Wall[0], Room.y + _Wall[1], _Wall[2], _Wall[3]);
			}
			
			//front door, Link leaves when he reaches this line
			instance_create_layer(Room.x + 256, Room.y + 472, "System", oHubExit);
			break;
			
	}
	
}

/// Collision boxes of the Sanctuary (ALttP room 0x12): [x, y, width in tiles, height in tiles], 8px tiles.
/// Generated from the room's tile attributes (minus the chest on the altar); the passage behind the altar is closed for now and the
/// front doorway is 4 tiles wide (instead of 2) so Link does not have to line up exactly to walk out.
function Hub_SanctuaryWalls(){
	return [
		[0, 0, 64, 10],
		[0, 80, 20, 54],
		[192, 80, 1, 11],
		[312, 80, 1, 11],
		[352, 80, 20, 54],
		[200, 136, 2, 4],
		[296, 136, 2, 4],
		[232, 152, 1, 2],
		[272, 152, 1, 2],
		[216, 160, 2, 1],
		[280, 160, 2, 1],
		[176, 200, 6, 3],
		[288, 200, 6, 3],
		[176, 240, 6, 3],
		[288, 240, 6, 3],
		[160, 240, 2, 3],	// keg above the Flute Boy's corner
		[160, 264, 5, 10],	// Flute Boy's corner: side counter against the left wall, he stands between the two
		[288, 280, 6, 3],
		[160, 344, 6, 21],
		[304, 344, 6, 21],
		[208, 448, 4, 8],
		[272, 448, 4, 8]
	];
}

/// Places Link inside the Sanctuary, just past the front door.
/// Called from Link_SetStartingPos while global.HubLevel is true.
function Hub_SetStartingPos(_RoomX, _RoomY, _EntranceDoorX, _EntranceDoorY){

	with(oLink){
		x = _EntranceDoorX + 16;
		y = _EntranceDoorY - 32;
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
	
	if(!Gear_IsUnlocked(global.StartingGear)) global.StartingGear = StartingGear.None;
	if(!Skin_IsUnlocked(global.LinkCharacterIndex)) global.LinkCharacterIndex = LinkCharacter.Link;

	global.HubLevel = false;
	global.HubPending = false;
	global.SaveLevel = false;

	room_goto(Room_Dungeon);

}


#region Sanctuary menus (oMenu_Game with Mode "Depart" or "Wardrobe")

// States of the front door (oHubExit)
enum HubExitState{
	Idle,		// waiting for Link to reach the door
	Menu,		// Depart menu open
	Back,		// Link chose to stay, waiting for him to step away from the door
	Leaving		// walking out and fading to black
}

enum HubMenuPage{
	Main,
	Gear,
	Challenges,
	Wardrobe
}

/// Builds the pages of a Sanctuary menu. Runs inside oMenu_Game's Create event.
function HubMenu_Create(_Mode){
	
	var _Close = function(_Sound){ GameMenu_Close(); };
	var _BackToMain = function(_Sound){ GameMenu_Open(HubMenuPage.Main, _Sound); };
	
	switch(_Mode){
		
		case "Depart":
			
			global.HubDepart = false;
			
			Menu_Create(HubMenuPage.Main, "Leave the Sanctuary?", [
				Menu_Item("Set out", HubMenu_Depart),
				Menu_Item("Bonus Item", function(){ GameMenu_Open(HubMenuPage.Gear); }, { ValueFn: function(){ return global.GearInfo[global.StartingGear].Label; } }),
				Menu_Item("Challenges", function(){ GameMenu_Open(HubMenuPage.Challenges); }, { ValueFn: function(){ return Achievements_AnyChallengeActive() ? "On" : "Off"; } }),
				Menu_BackItem("{s}Stay")
			], { TileW: 26, Top: 30, TitleY: 10, YSpace: 20, OnBack: _Close });
			
			// Bonus items: locked ones read "???" and say what unlocks them
			var _GearRows = [Menu_BackItem()];
			for(var i = 0; i < array_length(global.GearInfo); i++){
				array_push(_GearRows, Menu_Item("", HubMenu_PickGear, {
					Gear: i,
					LabelFn: function(_Row){ return Gear_IsUnlocked(_Row.Gear) ? global.GearInfo[_Row.Gear].Label : "???"; },
					LockedFn: function(_Row){ return !Gear_IsUnlocked(_Row.Gear); },
					ValueFn: function(_Row){ return global.StartingGear == _Row.Gear ? "*" : ""; },
					HintFn: HubMenu_GearHint,
					OnDraw: HubMenu_DrawGearIcon
				}));
			}
			Menu_Create(HubMenuPage.Gear, "Bonus Item", _GearRows, { TileW: 26, Top: 28, TitleY: 8, YSpace: 16, VisibleRows: 6, OnBack: _BackToMain });
			
			// Challenges: the title menu's page as it was (small font, level bars and checkboxes; the page title shows the selected level)
			var _ChallengeRows = [Menu_BackItem("BACK")];
			for(var i = 0; i < array_length(global.ChallengeOptionInfo); i++){
				array_push(_ChallengeRows, Menu_Item(global.ChallengeOptionInfo[i].Label, Menu_CycleChallengeOption, { Option: i, Title: Menu_ChallengeOptionTitle, OnDraw: Menu_DrawChallengeOption }));
			}
			for(var i = 0; i < array_length(global.ChallengeInfo); i++){
				array_push(_ChallengeRows, Menu_Item(global.ChallengeInfo[i].Label, Menu_ToggleChallenge, { Challenge: i, Title: Menu_ChallengeTitle, OnDraw: Menu_DrawChallengeCheckbox }));
			}
			Menu_Create(HubMenuPage.Challenges, "Challenges", _ChallengeRows, {
				TileW: 19, FrameH: 176, Top: 28, TitleY: 8, YSpace: 10, LabelX: 24,
				Font: global.Font_Small, TextOffsetY: 4, OnBack: _BackToMain
			});
			
			GameMenu_Open(HubMenuPage.Main);
			break;
			
		case "Wardrobe":
			
			HubMenu_BuildCharacterPreviews();
			
			var _SkinRows = [Menu_BackItem()];
			for(var i = 0; i < LinkCharacters; i++){
				array_push(_SkinRows, Menu_Item("", HubMenu_PickSkin, {
					Skin: i,
					LabelFn: function(_Row){ return Skin_IsUnlocked(_Row.Skin) ? global.SkinNames[_Row.Skin] : "???"; },
					LockedFn: function(_Row){ return !Skin_IsUnlocked(_Row.Skin); },
					HintFn: HubMenu_SkinHint,
					OnDraw: HubMenu_DrawSkinPreview
				}));
			}
			Menu_Create(HubMenuPage.Wardrobe, "New Look", _SkinRows, { TileW: 24, Top: 28, TitleY: 8, YSpace: 16, VisibleRows: 6, OnBack: _Close });
			
			GameMenu_Open(HubMenuPage.Wardrobe);
			break;
	}
	
}

function HubMenu_Depart(){
	global.HubDepart = true;
	GameMenu_Close();
}

function HubMenu_PickGear(_Row){
	if(!Gear_IsUnlocked(_Row.Gear)){
		audio_play_sound(Sound_Error, 1, false);
		return;
	}
	Gear_Set(_Row.Gear);
	GameMenu_Open(HubMenuPage.Main);
}

function HubMenu_GearHint(_Row){
	if(Gear_IsUnlocked(_Row.Gear)) return "";
	var _Ach = Gear_UnlockAchievement(_Row.Gear);
	return _Ach == undefined ? "" : "Unlock: " + _Ach.Desc;
}

function HubMenu_DrawGearIcon(_Row, _FrameX, _Y, _Right){
	if(!Gear_IsUnlocked(_Row.Gear) || _Row.Gear == StartingGear.None) return;
	var _Gear = global.GearInfo[_Row.Gear];
	Menu_DrawGear(_Row.Gear, _Right - 22 + _Gear.OffsetX, _Y + 17 + _Gear.OffsetY);
}

function HubMenu_PickSkin(_Row){
	if(!Skin_IsUnlocked(_Row.Skin)){
		audio_play_sound(Sound_Error, 1, false);
		return;
	}
	Skin_Set(_Row.Skin);
	audio_play_sound(Sound_ItemGet, 1, false);
	GameMenu_Close();
}

function HubMenu_SkinHint(_Row){
	if(Skin_IsUnlocked(_Row.Skin)) return "";
	var _Ach = Skin_UnlockAchievement(_Row.Skin);
	return _Ach == undefined ? "" : "Unlock: " + _Ach.Desc;
}

/// Big preview of the selected skin on the right of the frame (a black silhouette while locked)
function HubMenu_DrawSkinPreview(_Row, _FrameX, _Y, _Right){
	if(Menu[Menu_ActiveIndex][SelectorPos] != _Row) return;
	if(!sprite_exists(CharPreview)) return;
	var _X = _Right - 40;
	var _PY = FrameY + 40;
	var _Col = Skin_IsUnlocked(_Row.Skin) ? c_white : c_black;
	draw_sprite_ext(CharPreview, _Row.Skin, _X, _PY, 2, 2, 0, _Col, draw_get_alpha());
	if(Skin_IsUnlocked(_Row.Skin)){
		draw_set_font(global.Font_Small);
		draw_set_halign(fa_center);
		draw_set_color(#AAAAAA);
		draw_text(_X + 16, _PY + 52, global.LinkCharacterIndex == _Row.Skin ? "WEARING" : "TRY ON");
		draw_set_halign(fa_left);
		draw_set_color(#FFFFFF);
		draw_set_font(global.MenuFont);
	}else{
		draw_set_font(global.MenuFont);
		draw_set_halign(fa_center);
		draw_text(_X + 16, _PY + 16, "?");
		draw_set_halign(fa_left);
	}
}

/// Front-facing picture of every skin (same as the old character select), kept in CharPreview
function HubMenu_BuildCharacterPreviews(){
	var _W = 16;
	var _H = 24;
	var _Surf = surface_create(_W, _H);
	CharPreview = -1;
	for(var i = 0; i < LinkCharacters; i++){
		surface_set_target(_Surf);
		draw_clear_alpha(c_black, 0.0);
		draw_sprite_part(global.LinkCharacterSpr[i], 0, 48, 16, 16, 16, 0, 8);	//body
		draw_sprite_part(global.LinkCharacterSpr[i], 0, 16, 0, 16, 16, 0, 0);	//head
		surface_reset_target();
		if(i == 0) CharPreview = sprite_create_from_surface(_Surf, 0, 0, _W, _H, false, false, 0, 0);
		else sprite_add_from_surface(CharPreview, _Surf, 0, 0, _W, _H, false, false);
	}
	surface_free(_Surf);
}

#endregion
