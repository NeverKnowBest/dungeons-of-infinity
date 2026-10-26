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
	if(_GridX >= 5) return "HallOfFame";
	return "Sanctuary";
}

/// Index of the hub room built from a template, or -1
function Hub_FindRoom(_TemplateName){
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		if(Room.TemplateName == _TemplateName) return _RoomIndex;
	}
	return -1;
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

/// Picture, collision, doors and statues of a hub room.
function Hub_CreateScenery(_RoomIndex){
	
	switch(Room.TemplateName){
		
		case "Sanctuary":
			
			instance_create_layer(Room.x, Room.y, "ObjsFloor_Upper", oHubBackdrop, {sprite_index : sHub_Sanctuary});
			instance_create_layer(Room.x, Room.y, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_Sanctuary_Over});
			Hub_CreateAltarFlames(Room.x, Room.y);
			Hub_CreateWalls(Room.x, Room.y, Hub_SanctuaryWalls());
			
			//front door, Link leaves when he reaches this line
			instance_create_layer(Room.x + 256, Room.y + 472, "System", oHubExit);
			
			//side door to the Hall of Fame (the hall is the next room in the layout)
			instance_create_layer(Room.x + 360, Room.y + 280, "System", oHubDoor, {
				TrigW: 40, TrigH: 32, DestTemplate: "HallOfFame", DestX: 50, DestY: 136, DestFacing: RIGHT
			});
			break;
			
		case "HallOfFame":
			
			instance_create_layer(Room.x, Room.y, "ObjsFloor_Upper", oHubBackdrop, {sprite_index : sHub_Hall});
			Hub_CreateWalls(Room.x, Room.y, Hub_HallWalls());
			
			//fire on the two lamps at the ends of the hall
			instance_create_layer(Room.x + 72, Room.y + 64, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
			instance_create_layer(Room.x + 424, Room.y + 64, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
			
			//door back to the Sanctuary, on the left wall
			instance_create_layer(Room.x + 12, Room.y + 112, "System", oHubDoor, {
				TrigW: 40, TrigH: 32, DestTemplate: "Sanctuary", DestX: 362, DestY: 300, DestFacing: LEFT
			});
			
			//the statues along the top wall, bronze to gold; talking to one opens the gallery on it
			for(var i = 0; i < array_length(global.Statues); i++){
				Hub_CreateStatue(Room.x + 136 + (i * 80), Room.y + 118, i);
			}
			break;
			
	}
	
}

/// Animated fire on the two altar lamps (animated tiles in the original game)
function Hub_CreateAltarFlames(_RoomX, _RoomY){
	instance_create_layer(_RoomX + 200, _RoomY + 128, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
	instance_create_layer(_RoomX + 296, _RoomY + 128, "ObjsHigher_Upper", oHubBackdrop, {sprite_index : sHub_SanctuaryFlame});
}

/// _Walls: [x, y, width in tiles, height in tiles] relative to the room
function Hub_CreateWalls(_RoomX, _RoomY, _Walls){
	for(var i = 0; i < array_length(_Walls); i++){
		var _Wall = _Walls[i];
		WallObj_Create("Objs_Upper", _RoomX + _Wall[0], _RoomY + _Wall[1], _Wall[2], _Wall[3]);
	}
}

/// Figure of a statue, without its pedestal: frame 0 revealed (bronze, silver or gold), frame 1 silhouette with a "?".
/// Origin at the bottom centre. The pedestals are sHall_Pedestal (one frame per tier).
function Statue_Figure(_StatueKey){
	switch(_StatueKey){
		case "Armos":	return sHall_Statue_Armos;
		case "Lanmola":	return sHall_Statue_Lanmola;
		case "Moldorm":	return sHall_Statue_Moldorm;
		case "Agahnim":	return sHall_Statue_Agahnim;
	}
	return sHall_Statue_Armos;
}

/// A statue of the Hall of Fame. (_X, _Y) is the bottom centre of its pedestal.
/// oHallStatue draws the pedestal and the bottom of the figure under Link, oHallStatueTop the rest over him,
/// so he can walk behind it.
function Hub_CreateStatue(_X, _Y, _Index){
	var _Statue = instance_create_layer(_X, _Y, "ObjsFloor_Upper", oHallStatue, {Index : _Index});
	instance_create_layer(_X, _Y, "ObjsHigher_Upper", oHallStatueTop, {Owner : _Statue});
	WallObj_Create("Objs_Upper", _X - 16, _Y - 72, 4, 9);	// pedestal and the space behind it, up to the wall
}

/// Draws the part of a statue figure above (_Upper) or below _SplitY. (_X, _Bottom) is the figure's bottom centre.
function Statue_DrawFigurePart(_Index, _X, _Bottom, _SplitY, _Upper){
	var _Statue = global.Statues[_Index];
	var _Spr = Statue_Figure(_Statue.Key);
	var _Frame = Statue_IsRevealed(_Statue.Key) ? 0 : 1;
	var _W = sprite_get_width(_Spr);
	var _H = sprite_get_height(_Spr);
	var _Top = _Bottom - _H;
	var _SplitRow = clamp(_SplitY - _Top, 0, _H);
	var _Row0 = _Upper ? 0 : _SplitRow;
	var _Rows = _Upper ? _SplitRow : _H - _SplitRow;
	if(_Rows <= 0) return;
	draw_sprite_part(_Spr, _Frame, 0, _Row0, _W, _Rows, _X - (_W / 2), _Top + _Row0);
}

/// Achievements of one statue, in list order
function Gallery_Achievements(_StatueKey){
	var _List = [];
	for(var i = 0; i < array_length(global.AchievementList); i++){
		if(global.AchievementList[i].Statue == _StatueKey) array_push(_List, global.AchievementList[i]);
	}
	return _List;
}

/// "New look: Fox", "Bonus item: Shield"..., or "" when it only counts for its statue
function Achievement_RewardText(_Ach){
	if(_Ach.Skin != -1) return "Reward: " + global.SkinNames[_Ach.Skin] + " look";
	if(_Ach.Gear != -1) return "Reward: " + global.GearInfo[_Ach.Gear].Label + " bonus item";
	return "";
}

/// Starts moving Link to another hub room (called by oHubTravel): activates the room, puts Link at the doorway and
/// returns [camera x, camera y] for that room, so oHubTravel can scroll the camera there like a dungeon room change.
function Hub_MoveLinkTo(_RoomIndex, _X, _Y, _Facing){
	Dungeon_RoomActivate(_RoomIndex);
	with(oLink){
		x = _X;
		y = _Y;
		Facing = _Facing;
		HitBox.x = x;
		HitBox.y = y;
		FallSpawnX = x;
		FallSpawnY = y;
		FallSpawnFacing = _Facing;
		UpdateSprites();
	}
	Dungeon_DestroyUnimportantObjs();
	var _Target = [0, 0];
	with(oCamera){
		var _OldX = X, _OldY = Y;
		SetCurrentRoom(_RoomIndex);
		Cam_UpdatePos();
		_Target = [X, Y];
		Cam_SetPos(_OldX, _OldY);
	}
	global.Level.Rooms[_RoomIndex].Visited = true;
	Map_UpdateExploredRooms();
	return _Target;
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
		[352, 80, 20, 25],	// right wall, above the door to the Hall of Fame
		[352, 312, 20, 25],	// right wall, below it
		[376, 280, 17, 4],	// back of that doorway
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
		[160, 240, 2, 3],	// flower pot above the Flute Boy's corner
		[160, 264, 5, 10],	// Flute Boy's corner: side counter against the left wall, he stands between the two
		[160, 344, 6, 21],
		[304, 344, 6, 21],
		[208, 448, 4, 8],
		[272, 448, 4, 8]
	];
}

/// Collision boxes of the Hall of Fame (512x256): walls 48px thick, door on the left wall (opening y 112..144),
/// lamps at both ends. The statues add their own.
function Hub_HallWalls(){
	return [
		[0, 0, 64, 6],		// top wall
		[0, 208, 64, 6],	// bottom wall
		[0, 48, 6, 8],		// left wall, above the door
		[0, 144, 6, 8],		// left wall, below it
		[0, 112, 3, 4],		// back of the doorway
		[464, 48, 6, 20],	// right wall
		[72, 48, 2, 6],		// lamps
		[424, 48, 2, 6],
		[60, 184, 2, 3],	// flower pots
		[436, 184, 2, 3]
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

/// Locked bonus items stay a secret: no hint about what unlocks them
function HubMenu_GearHint(_Row){
	return "";
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

/// Locked looks stay a secret: no hint about what unlocks them
function HubMenu_SkinHint(_Row){
	return "";
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


#region Title intro skip (oTitle)

/// True on the frame any key, mouse button or gamepad button is pressed
function Title_AnyButtonPressed(){
	if(keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any)) return true;
	static _Buttons = [gp_face1, gp_face2, gp_face3, gp_face4, gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb,
		gp_select, gp_start, gp_stickl, gp_stickr, gp_padu, gp_padd, gp_padl, gp_padr];
	for(var _Pad = 0; _Pad < gamepad_get_device_count(); _Pad++){
		if(!gamepad_is_connected(_Pad)) continue;
		for(var i = 0; i < array_length(_Buttons); i++){
			if(gamepad_button_check_pressed(_Pad, _Buttons[i])) return true;
		}
	}
	return false;
}

/// Puts the title screen in the state it reaches at the end of the intro: logo sequence at its last frame,
/// background shown, main theme playing, sparkles running and Start allowed. Runs inside oTitle.
function Title_SkipIntro(){
	
	// pending intro steps
	for(var i = 0; i <= 4; i++) alarm[i] = -1;
	
	if(!variable_instance_exists(id, "TitleSeq")) TitleSeq = layer_sequence_create("Instances", 0, 0, seqTitle);
	layer_sequence_headpos(TitleSeq, layer_sequence_get_length(TitleSeq) - 1);
	
	if(Music != noone) audio_stop_sound(Music);
	audio_stop_sound(Music_Title_Intro);
	if(!audio_is_playing(Music_Title_Main)) Music = audio_play_sound(Music_Title_Main, 1, false);
	
	ShowBG = false;
	_Contrast = 1;
	_Brightness = 1;
	fx_set_parameter(FX_Contrast, "g_ContrastIntensity", _Contrast);
	fx_set_parameter(FX_Contrast, "g_ContrastBrightness", _Brightness);
	
	if(alarm[5] < 0 || alarm[5] > SparkleDelay) alarm[5] = SparkleDelay;
	
	AllowStart = true;
	SkipCooldown = 20;
	
	input_clear_momentary(true);
	
}

#endregion
