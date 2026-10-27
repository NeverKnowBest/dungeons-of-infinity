// Automated test mode (roadmap F3), driven by tools/test/run.py.
// Off unless the game is started with "-test <file>" or with the environment variable DOI_TEST=<file>, where <file>
// is a scenario in the save folder (%LOCALAPPDATA%\Zelda). In test mode the title and menus are skipped, nothing is
// saved, Link follows the scenario's steps, everything worth knowing goes to test/out/log.txt (and to the run output
// as "[Test] ...") and the game closes itself. The scenario format is in tools/README.md ("test/").

#macro TEST_OUT "test/out/"
#macro TEST_SHEET_WAIT 3	// frames to wait after moving the camera before capturing a contact sheet shot

global.TestMode = false;
global.Test = undefined;
global.TestFrame = 0;
global.TestKills = 0;
global.TestDumps = 0;		// level dumps written so far (scenario "dump": true)
global.TestDumpFile = "";
global.TestBuildSeed = 0;
global.TestExitDest = -1;	// level the exit of the last "exit" step leads to (expect "exit_level")

// Verbs a scenario may hold or press (see __input_config_verbs)
global.TestVerbs = ["up", "down", "left", "right", "sword", "action", "item", "map", "strafe", "inventory", "menu_access", "hud"];

/// Called from oInit's Create. Returns true when the game runs in test mode.
function Test_Init(){
	var _File = "";
	for(var i = 0; i < parameter_count() - 1; i++){
		if(parameter_string(i) == "-test") _File = parameter_string(i + 1);
	}
	if(_File == "") _File = environment_get_variable("DOI_TEST");
	if(_File == "") return false;

	global.TestMode = true;
	directory_create("test");
	directory_create(TEST_OUT);
	if(file_exists(TEST_OUT + "log.txt")) file_delete(TEST_OUT + "log.txt");
	exception_unhandled_handler(Test_OnCrash);

	var _Scenario = undefined;
	if(file_exists(_File)){
		var _Buffer = buffer_load(_File);
		try{
			_Scenario = json_parse(buffer_read(_Buffer, buffer_string));
		}catch(_e){
			_Scenario = undefined;
		}
		buffer_delete(_Buffer);
	}

	global.Test = {
		Name: "?",
		Seed: 1,
		Level: DungeonLevel.Castle,
		Cheats: [],
		Items: [],
		Steps: [],
		MaxFrames: 36000,
		Sound: false,
		Speed: 60,
		Dump: false,
		Levels: [],
		Failures: 0,
		Finished: false
	};

	if(!is_struct(_Scenario)){
		Test_Log("error scenario missing or not valid JSON: " + _File);
		Test_Finish("error");
		return true;
	}

	global.Test.Name = _Scenario[$ "name"] ?? "test";
	global.Test.Seed = _Scenario[$ "seed"] ?? 1;
	global.Test.Level = _Scenario[$ "level"] ?? DungeonLevel.Castle;
	global.Test.Cheats = _Scenario[$ "cheats"] ?? [];
	global.Test.Items = _Scenario[$ "items"] ?? [];
	global.Test.Steps = _Scenario[$ "steps"] ?? [];
	global.Test.MaxFrames = _Scenario[$ "max_frames"] ?? 36000;
	global.Test.Sound = _Scenario[$ "sound"] ?? false;
	global.Test.Speed = _Scenario[$ "speed"] ?? 60;
	global.Test.Dump = _Scenario[$ "dump"] ?? false;
	global.Test.Levels = _Scenario[$ "levels"] ?? [];

	// Windowed, and no pause or mute when the window loses focus (the input library is told the same in
	// INPUT_ALLOW_OUT_OF_FOCUS), so a test keeps running while someone uses the PC
	global.Fullscreen = false;
	global.AltTabPause = false;
	game_set_speed(global.Test.Speed, gamespeed_fps);

	instance_create_depth(-10000, -10000, 0, oTest);
	return true;
}

/// Called from oInit instead of going to the title screen: a throwaway user (never saved) and straight to the level
function Test_Begin(){
	global.Users = [new User_Create()];
	global.UserIndex = 0;
	User_VerifyIntegrity();

	var _User = global.Users[0];
	_User.Name = "TEST";
	for(var i = 0; i < array_length(global.Test.Cheats); i++){
		var _Key = global.Test.Cheats[i];
		if(variable_struct_exists(_User.Cheats, _Key)){
			_User.Cheats[$ _Key] = true;
		}else{
			Test_Fail("unknown cheat " + string(_Key));
		}
	}

	global.ChallengeOptions = array_create(array_length(global.ChallengeOptionInfo), 0);
	global.Challenges = array_create(array_length(global.ChallengeInfo), false);

	if(!global.Test.Sound) audio_set_master_gain(0, 0);
	
	// A ghost player takes input only from input_verb_set (the steps), never from the real keyboard or gamepad.
	// Without it the player has no source until someone presses a key, and then its verbs are not updated at all.
	input_player_ghost_set(true);

	if(is_string(global.Test.Level) && global.Test.Level == "Hub") global.HubPending = true;
	
	Test_ChangeLevels();

	Test_Log("start scenario=" + string(global.Test.Name) + " seed=" + string(global.Test.Seed) + " level=" + string(global.Test.Level));
	random_set_seed(global.Test.Seed);
	DungeonSeq_Init(global.UserIndex);
	room_goto(Room_Dungeon);
}

/// Scenario "levels": temporary changes to the level sheet for this test only, such as a branch of the run that no
/// level has yet (roadmap F4b). Each entry is {level, <field>: value, ...}; tools/test/scenario.py checks the fields.
function Test_ChangeLevels(){
	for(var i = 0; i < array_length(global.Test.Levels); i++){
		var _Change = global.Test.Levels[i];
		var _Def = Level_Get(_Change[$ "level"] ?? -1);
		if(_Def == undefined){
			Test_Fail("levels: bad level " + string(_Change[$ "level"]));
			continue;
		}
		var _Names = variable_struct_get_names(_Change);
		array_sort(_Names, true);
		for(var j = 0; j < array_length(_Names); j++){
			var _Field = _Names[j];
			if(_Field == "level") continue;
			if(!variable_struct_exists(_Def, _Field)){
				Test_Fail("levels: no field " + _Field);
				continue;
			}
			_Def[$ _Field] = _Change[$ _Field];
			Test_Log("levels " + string(_Def.Index) + " \"" + _Def.Name + "\" " + _Field + "=" + json_stringify(_Change[$ _Field]));
		}
	}
}

/// Called from oGame's Create in place of the intro level
function Test_StartLevel(){
	if(!is_real(global.Test.Level) || global.Test.Level < 0 || global.Test.Level >= array_length(global.LevelDefs)){
		Test_Fail("bad level " + string(global.Test.Level));
		global.Test.Level = DungeonLevel.Castle;
	}
	Test_BuildLevel(global.Test.Level, global.Test.Seed);
}

/// Builds a level that depends only on the seed: the user's dungeon layout order (normally shuffled once per new
/// user and then followed run after run) is shuffled again from the seed
function Test_BuildLevel(_Level, _Seed){
	random_set_seed(_Seed);
	DungeonSeq_Init(global.UserIndex);
	global.SaveLevel = false;
	global.TestBuildSeed = _Seed;
	Dungeon_InitLevel(_Level);
	Test_DumpGlobals();
}

#region Log

function Test_Log(_Text){
	var _Line = "f" + string(global.TestFrame) + " " + _Text;
	show_debug_message("[Test] " + _Line);
	var _File = file_text_open_append(TEST_OUT + "log.txt");
	if(_File == -1) exit;
	file_text_write_string(_File, _Line);
	file_text_writeln(_File);
	file_text_close(_File);
}

/// Logs only in test mode; for hooks in the game code
function Test_Event(_Text){
	if(global.TestMode) Test_Log(_Text);
}

function Test_Fail(_Text){
	global.Test.Failures++;
	Test_Log("FAIL " + _Text);
}

/// Called from Enemy_Destroy
function Test_OnKill(){
	if(!global.TestMode) exit;
	global.TestKills++;
	Test_Log("kill " + object_get_name(object_index) + " room=" + string(global.CurrentRoomIndex));
}

function Test_OnCrash(_Exception){
	Test_Log("crash " + string_replace_all(string(_Exception.message), "\n", " | "));
	if(is_array(_Exception.stacktrace)){
		for(var i = 0; i < array_length(_Exception.stacktrace); i++) Test_Log("  at " + string(_Exception.stacktrace[i]));
	}
	Test_Log("end crash");
	return 0;
}

function Test_Finish(_Result){
	if(global.Test.Finished) exit;
	global.Test.Finished = true;
	Test_Log("end " + _Result + " failures=" + string(global.Test.Failures) + " kills=" + string(global.TestKills));
	game_end();
}

function Test_LevelName(){
	if(global.HubLevel) return "hub";
	return string(global.Level.Index) + " \"" + LevelDef.Name + "\"";
}

function Test_RoomStr(_RoomIndex){
	var _R = global.Level.Rooms[_RoomIndex];
	var _Template = _R[$ "Template"];
	var _Id = is_struct(_Template) ? _Template[$ "id"] : undefined;
	return string(_RoomIndex) + " grid=" + string(_R.GridX) + "," + string(_R.GridY) + " size=" + string(_R.GridW) + "x" + string(_R.GridH)
		+ " template=" + string(_R.TemplateClass) + "/" + string(_R.TemplateSubClass) + "/" + string(_R.TemplateName) + "#" + string(_Id);
}

function Test_LogState(){
	Test_Log("state level=" + Test_LevelName() + " room=" + string(global.CurrentRoomIndex) + " x=" + string(round(oLink.x)) + " y=" + string(round(oLink.y))
		+ " hp=" + string(LinkHealth) + "/" + string(global.Inventory.ItemData[ItemClass.HeartPiece].Amount)
		+ " enemies=" + string(instance_number(oEnemy)) + " kills=" + string(global.TestKills) + " linkstate=" + string(oLink.State));
}

#endregion

#region Debug cheats (also usable outside tests)

/// Moves Link into the room at grid (_GridX, _GridY) of the current level, next to one of its doors
function Test_GotoRoom(_GridX, _GridY){
	if(_GridX < 0 || _GridY < 0 || _GridX >= DungeonGridW || _GridY >= DungeonGridW) return false;
	var _RoomIndex = global.Level.Map_RoomIndex[_GridY][_GridX];
	if(_RoomIndex == -1) return false;

	Test_PlaceLink(_RoomIndex, Test_RoomEntryPoint(_RoomIndex));
	return true;
}

/// Moves Link to _Pos [x, y] in a room of the current level and points the camera at it
function Test_PlaceLink(_RoomIndex, _Pos){
	with(oLink){
		x = _Pos[0];
		y = _Pos[1];
		HitBox.x = x;
		HitBox.y = y;
		FloorLevel = GetFloorLevelID(x, y);
		layer = (FloorLevel == UPPER ? global.LayerID_Objs_Upper : global.LayerID_Objs_Lower);
		FallSpawnX = x;
		FallSpawnY = y;
		FallSpawnFloorLevel = FloorLevel;
		FallSpawnFacing = Facing;
		UpdateState(LinkState.Standing);
	}
	//SetToRoomIndex activates the new room and then deactivates the current one: for the same room that would put
	//Link and everything else to sleep
	if(_RoomIndex != global.CurrentRoomIndex) with(oCamera) SetToRoomIndex(_RoomIndex, true);
	global.Level.Rooms[_RoomIndex].Visited = true;
	Map_UpdateExploredRooms();
	global.InWaterSprite = Link_GetInWaterSprite();
}

/// Moves Link into the room of the main exit (_Extra false) or of the extra exit (roadmap F4b), 40 px in front of the
/// exit door. Returns the verb that walks into it ("up" or "down"), or "" when the level has no such exit.
function Test_GotoExit(_Extra){
	var _Exits = global.Level.Exits;
	var _RoomIndex = _Extra ? _Exits.ExtraRoom : global.Level.RoomIndex_BossAdjacent;
	if(_RoomIndex == -1) return "";
	var _R = global.Level.Rooms[_RoomIndex];
	for(var i = 0; i < array_length(_R.Doors); i++){
		var _Door = _R.Doors[i];
		if(_Door.Status != DoorStatus.Exit || (_Door.Location != "Top" && _Door.Location != "Bottom") || (_Extra && _Door.Position != _Exits.ExtraPosition)) continue;
		var _Top = (_Door.Location == "Top");
		Test_PlaceLink(_RoomIndex, [_R.x + _Door.x + 16, _R.y + _Door.y + 16 + (_Top ? 40 : -40)]);
		global.TestExitDest = _Extra ? _Door.ExitDest : (global.SaveLevel ? Level_NextIndex() : _Exits.Dest);
		Test_Log("exit " + (_Extra ? "extra" : "main") + " room=" + string(_RoomIndex) + " " + _Door.Location + " -> level " + string(global.TestExitDest));
		return _Top ? "up" : "down";
	}
	return "";
}

/// A spot just inside one of the room's doors: [x, y]
function Test_RoomEntryPoint(_RoomIndex){
	var _R = global.Level.Rooms[_RoomIndex];
	var _RSI = global.RoomSizeIndex[_R.GridW][_R.GridH];
	for(var i = 0; i < array_length(_R.Doors); i++){
		var _Door = _R.Doors[i];
		if(_Door.Status == DoorStatus.Unused) continue;
		var _Coord = global.DoorCoordinates[_RSI][_Door.Position];
		var _X = _R.x + _Coord.x + 16;
		var _Y = _R.y + _Coord.y + 16;
		switch(_Coord.Location){
			case "Top":		_Y += 32; break;
			case "Bottom":	_Y -= 32; break;
			case "Left":	_X += 32; break;
			case "Right":	_X -= 32; break;
		}
		return [_X, _Y];
	}
	return [_R.x + _R.width / 2, _R.y + _R.height / 2];
}

/// Creates an enemy (object name) _Dist pixels in front of Link. Returns the instance or noone.
function Test_SpawnEnemy(_ObjName, _Dist = 48){
	var _Obj = asset_get_index(_ObjName);
	if(_Obj == -1 || !object_exists(_Obj)) return noone;
	var _DX = 0;
	var _DY = 0;
	switch(oLink.Facing){
		case UP:	_DY = -1; break;
		case DOWN:	_DY = 1; break;
		case LEFT:	_DX = -1; break;
		case RIGHT:	_DX = 1; break;
	}
	var _RoomIndex = global.CurrentRoomIndex;
	return instance_create_layer(oLink.x + _DX * _Dist, oLink.y + _DY * _Dist, "Objs_" + GetFloorLevelString(oLink.FloorLevel), _Obj,
		{FloorLevel: oLink.FloorLevel, ItemHolding: -1, SectionID: global.Level.Rooms[_RoomIndex].Section_ID, RoomIndex: _RoomIndex});
}

/// Gives Link an item like a pickup would: Test_GiveItem(ItemClass.Sword, Swords.Master)
function Test_GiveItem(_ItemClass, _Index = 0, _Amount = 1){
	var _Got = Item_Get(_ItemClass, _Index, _Amount);
	Inventory_Update();
	Link_UpdateAttackDefence();
	return _Got;
}

#endregion

#region Steps (run by oTest in its End Step)

/// Logs level and room changes, damage and death
function Test_Watch(){
	if(global.Level != LastLevel){
		LastLevel = global.Level;
		LastRoom = -1;
		Test_Log("level " + Test_LevelName() + " rooms=" + string(global.Level.RoomCount) + " dungeon=" + string(global.Level.DungeonTemplate_Index));
	}
	if(global.CurrentRoomIndex >= 0 && global.CurrentRoomIndex != LastRoom){
		LastRoom = global.CurrentRoomIndex;
		Test_Log("room " + Test_RoomStr(LastRoom));
	}
	var _Health = LinkHealth;
	if(LastHealth >= 0 && _Health < LastHealth) Test_Log("damage " + string(LastHealth - _Health) + " hp=" + string(_Health));
	LastHealth = _Health;
	if(global.LinkDead && !Dead){
		Dead = true;
		Test_Log("dead room=" + string(global.CurrentRoomIndex));
	}
}

function Test_HoldVerbs(_Verbs){
	if(!is_array(_Verbs)) _Verbs = [_Verbs];
	for(var i = 0; i < array_length(_Verbs); i++){
		if(array_contains(global.TestVerbs, _Verbs[i])) input_verb_set(_Verbs[i], 1);
	}
}

/// Runs the current step; returns true when it is done
function Test_DoStep(_S){
	var _Do = _S[$ "do"] ?? "";
	switch(_Do){

		case "wait":
			return StepFrames >= (_S[$ "frames"] ?? 1);

		case "hold":	// keys held together for "frames", then one frame released
		case "press":	// one key held for "frames" (default 8), then 4 frames released
			var _Keys = _S[$ "keys"] ?? [_S[$ "key"] ?? ""];
			var _Frames = _S[$ "frames"] ?? (_Do == "press" ? 8 : 1);
			if(StepFrames == 1){
				for(var i = 0; i < array_length(_Keys); i++){
					if(!array_contains(global.TestVerbs, _Keys[i])) Test_Fail("unknown key " + string(_Keys[i]));
				}
			}
			if(StepFrames <= _Frames) Test_HoldVerbs(_Keys);
			return StepFrames >= _Frames + (_Do == "press" ? 4 : 1);

		case "shot":
			ShotName = string(_S[$ "name"] ?? ("shot" + string(Step)));
			return true;

		case "room":
			if(!Test_GotoRoom(_S[$ "x"] ?? -1, _S[$ "y"] ?? -1)) Test_Fail("no room at " + string(_S[$ "x"]) + "," + string(_S[$ "y"]));
			return true;

		case "exit":	// Link in front of the main or the extra exit, then walking into it ("frames", default 60)
			if(StepFrames == 1){
				ExitVerb = Test_GotoExit((_S[$ "which"] ?? "main") == "extra");
				if(ExitVerb == ""){
					Test_Fail("no " + string(_S[$ "which"] ?? "main") + " exit");
					return true;
				}
			}
			if(ExitVerb == "" || StepFrames > (_S[$ "frames"] ?? 60)) return true;
			Test_HoldVerbs([ExitVerb]);
			return false;

		case "level":
			// Dungeon_Clear only removes active instances: wake every room first (oTest Step), build in the next End Step
			if(StepFrames == 1){
				ActivateAll = true;
				return false;
			}
			Test_BuildLevel(_S[$ "level"] ?? global.Level.Index, _S[$ "seed"] ?? global.Test.Seed);
			return true;

		case "spawn":
			var _Inst = Test_SpawnEnemy(_S[$ "enemy"] ?? "", _S[$ "dist"] ?? 48);
			if(_Inst == noone) Test_Fail("unknown object " + string(_S[$ "enemy"]));
			else Test_Log("spawned " + object_get_name(_Inst.object_index) + " x=" + string(round(_Inst.x)) + " y=" + string(round(_Inst.y)));
			return true;

		case "give":
			if(!is_real(_S[$ "item"])) Test_Fail("bad item " + string(_S[$ "item"]));
			else Test_GiveItem(_S.item, _S[$ "index"] ?? 0, _S[$ "amount"] ?? 1);
			return true;

		case "state":
			Test_LogState();
			return true;

		case "log":
			Test_Log("note " + string(_S[$ "text"] ?? ""));
			return true;

		case "expect":
			var _Bad = "";
			if(variable_struct_exists(_S, "alive") && _S.alive == global.LinkDead) _Bad += " alive";
			if(variable_struct_exists(_S, "level") && _S.level != global.Level.Index) _Bad += " level(" + string(global.Level.Index) + ")";
			if(variable_struct_exists(_S, "room")){
				var _GX = _S.room[0];
				var _GY = _S.room[1];
				if(global.Level.Map_RoomIndex[_GY][_GX] != global.CurrentRoomIndex) _Bad += " room(" + string(global.CurrentRoomIndex) + ")";
			}
			if(variable_struct_exists(_S, "enemies") && instance_number(oEnemy) != _S.enemies) _Bad += " enemies(" + string(instance_number(oEnemy)) + ")";
			if(variable_struct_exists(_S, "kills_min") && global.TestKills < _S.kills_min) _Bad += " kills(" + string(global.TestKills) + ")";
			if((_S[$ "exit_level"] ?? false) && (global.SaveLevel || global.Level.Index != global.TestExitDest)) _Bad += " exit_level(" + string(global.Level.Index) + (global.SaveLevel ? " rest stop" : "") + ")";
			if(_Bad == "") Test_Log("expect ok");
			else Test_Fail("expect" + _Bad);
			return true;

		case "probe":	// creates each enemy in front of Link, logs its variables and removes it
			var _Enemies = _S[$ "enemies"] ?? [];
			for(var i = 0; i < array_length(_Enemies); i++){
				var _Probe = Test_SpawnEnemy(_Enemies[i], _S[$ "dist"] ?? 48);
				if(_Probe == noone){
					Test_Fail("unknown object " + string(_Enemies[i]));
					continue;
				}
				Test_Log("probe " + Test_InstLine(_Probe));
				instance_destroy(_Probe);	// with its Destroy event, which removes what it made (weapons, lights, lists)
			}
			return true;

		case "sheet":
			Test_SheetStart(_S[$ "level"] ?? global.Level.Index, _S[$ "seeds"] ?? [global.Test.Seed]);
			return true;

		case "end":
			Test_Finish("ok");
			return true;

		default:
			Test_Fail("unknown step " + string(_Do));
			return true;
	}
}

#endregion

#region Level dumps (reference scenarios, tools/test/baseline.py)

/// Called from Dungeon_InitLevel once every room is built and before the rooms are put to sleep. With "dump": true
/// in the scenario, writes everything the generator produced to dump_<n>_<level>_s<seed>.txt: the level and room
/// structs, every instance with its variables and an MD5 of each tile layer per room. Two versions of the code that
/// build the same level give the same file. Test_DumpGlobals adds the global variables once the build is over.
function Test_OnLevelBuilt(){
	if(!global.TestMode || !global.Test.Dump) exit;
	global.TestDumps++;
	global.TestDumpFile = "dump_" + string(global.TestDumps) + "_" + LevelDef.Name + "_s" + string(global.TestBuildSeed) + ".txt";
	var _B = buffer_create(1 << 16, buffer_grow, 1);
	buffer_write(_B, buffer_text, "level " + string(global.Level.Index) + " seed=" + string(global.TestBuildSeed) + "\n");
	buffer_write(_B, buffer_text, "levelstruct " + Test_VarsLine(global.Level) + "\n");
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		buffer_write(_B, buffer_text, "room " + Test_RoomStr(_RoomIndex) + "\n");
		buffer_write(_B, buffer_text, "roomstruct " + string(_RoomIndex) + " " + Test_VarsLine(global.Level.Rooms[_RoomIndex]) + "\n");
	}

	// Tile layers: one MD5 per room and layer
	var _Layers = layer_get_all();
	var _Tiles = buffer_create(4096, buffer_grow, 4);
	for(var i = 0; i < array_length(_Layers); i++){
		var _Layer = _Layers[i];
		buffer_write(_B, buffer_text, "layer " + layer_get_name(_Layer) + " depth=" + string(layer_get_depth(_Layer)) + " visible=" + string(layer_get_visible(_Layer)) + "\n");
		var _TM = layer_tilemap_get_id(_Layer);
		if(_TM == -1) continue;
		var _TW = tilemap_get_tile_width(_TM);
		var _TH = tilemap_get_tile_height(_TM);
		buffer_write(_B, buffer_text, "tilemap " + layer_get_name(_Layer) + " tileset=" + tileset_get_name(tilemap_get_tileset(_TM)) + " x=" + string(tilemap_get_x(_TM)) + " y=" + string(tilemap_get_y(_TM)) + "\n");
		for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
			var _R = global.Level.Rooms[_RoomIndex];
			buffer_seek(_Tiles, buffer_seek_start, 0);
			var _Used = 0;
			for(var _Y = _R.y; _Y < _R.y + _R.height; _Y += _TH){
				for(var _X = _R.x; _X < _R.x + _R.width; _X += _TW){
					var _T = tilemap_get_at_pixel(_TM, _X, _Y);
					if(_T > 0) _Used++;
					buffer_write(_Tiles, buffer_u32, _T == -1 ? 0 : _T);
				}
			}
			if(_Used > 0) buffer_write(_B, buffer_text, "tiles " + layer_get_name(_Layer) + " room=" + string(_RoomIndex) + " used=" + string(_Used) + " md5=" + buffer_md5(_Tiles, 0, buffer_tell(_Tiles)) + "\n");
		}
	}
	buffer_delete(_Tiles);

	with(all){
		if(object_index == oTest) continue;
		buffer_write(_B, buffer_text, "inst " + Test_InstLine(id) + "\n");
	}
	buffer_save_ext(_B, TEST_OUT + global.TestDumpFile, 0, buffer_tell(_B));
	buffer_delete(_B);
}

/// Called after Dungeon_InitLevel (Test_BuildLevel): adds the global variables to the level dump
function Test_DumpGlobals(){
	if(!global.TestMode || !global.Test.Dump || global.TestDumpFile == "") exit;
	var _Names = variable_instance_get_names(global);
	array_sort(_Names, true);
	var _Text = "";
	for(var i = 0; i < array_length(_Names); i++){
		var _Name = _Names[i];
		if(string_char_at(_Name, 1) == "_" || string_pos("Test", _Name) == 1 || string_pos("Time_", _Name) == 1) continue;	// libraries, test mode, clocks
		var _Value = Test_ValueStr(variable_global_get(_Name));
		if(_Value != undefined) _Text += "global " + _Name + "=" + _Value + "\n";
	}
	var _File = file_text_open_append(TEST_OUT + global.TestDumpFile);
	if(_File == -1) exit;
	file_text_write_string(_File, _Text);
	file_text_close(_File);
	Test_Log("dump " + global.TestDumpFile);
	global.TestDumpFile = "";
}

/// Text of a plain value, or of an array of plain values (up to 256 items, two levels deep); undefined for anything else
/// (structs, methods)
function Test_ValueStr(_V, _Depth = 0){
	if(is_real(_V) || is_bool(_V) || is_int64(_V) || is_int32(_V)) return string(_V);
	if(is_string(_V)) return "\"" + string_replace_all(_V, "\n", "\\n") + "\"";
	if(is_undefined(_V)) return "undefined";
	if(typeof(_V) == "ref") return string(_V);
	if(is_array(_V)){
		var _N = array_length(_V);
		if(_N > 256 || _Depth >= 2) return "[" + string(_N) + " items]";
		var _Out = "[";
		for(var i = 0; i < _N; i++){
			var _Item = Test_ValueStr(_V[i], _Depth + 1);
			_Out += (i > 0 ? "," : "") + (_Item ?? "?");
		}
		return _Out + "]";
	}
	return undefined;
}

/// name=value for every plain variable of a struct or instance, sorted by name
function Test_VarsLine(_Owner){
	var _Names = is_struct(_Owner) ? variable_struct_get_names(_Owner) : variable_instance_get_names(_Owner);
	array_sort(_Names, true);
	var _Out = "";
	for(var i = 0; i < array_length(_Names); i++){
		var _Value = Test_ValueStr(is_struct(_Owner) ? _Owner[$ _Names[i]] : variable_instance_get(_Owner, _Names[i]));
		if(_Value != undefined) _Out += " " + _Names[i] + "=" + _Value;
	}
	return _Out;
}

/// One line about an instance: object, position, sprite, layer and its own variables
function Test_InstLine(_Inst){
	with(_Inst){
		return object_get_name(object_index) + " x=" + string(x) + " y=" + string(y) + " depth=" + string(depth)
			+ " layer=" + (layer == -1 ? "-" : layer_get_name(layer)) + " sprite=" + (sprite_index == -1 ? "-" : sprite_get_name(sprite_index))
			+ " image=" + string(image_index) + " xs=" + string(image_xscale) + " ys=" + string(image_yscale) + " visible=" + string(visible)
			+ " |" + Test_VarsLine(id);
	}
}

#endregion

#region Screenshots and contact sheets

/// Copies what the game view shows (view 1, drawn at 4x into application_surface) into _Surface at 1x. Post Draw only.
function Test_CaptureView(_Surface, _X, _Y){
	var _VX = view_get_xport(1);
	var _VY = view_get_yport(1);
	var _VW = view_get_wport(1);
	var _VH = view_get_hport(1);
	surface_set_target(_Surface);
	gpu_set_colorwriteenable(true, true, true, false);	// keep the target opaque
	draw_surface_part_ext(application_surface, _VX, _VY, _VW, _VH, _X, _Y, CAM_W / _VW, CAM_H / _VH, c_white, 1);
	gpu_set_colorwriteenable(true, true, true, true);
	surface_reset_target();
}

function Test_SaveShot(_Name){
	var _Surface = surface_create(CAM_W, CAM_H);
	surface_set_target(_Surface);
	draw_clear(c_black);
	surface_reset_target();
	Test_CaptureView(_Surface, 0, 0);
	surface_save(_Surface, TEST_OUT + _Name + ".png");
	surface_free(_Surface);
	Test_Log("shot " + _Name + ".png room=" + string(global.CurrentRoomIndex));
}

/// Contact sheet: builds the level once per seed and pictures every room. Saves sheet_<level>_<seed>.png per seed
/// and sheet_<level>.png with all of them side by side at half size, in seed order.
function Test_SheetStart(_Level, _Seeds){
	Sheet = {Level: _Level, Seeds: _Seeds, SeedIndex: -1, Shots: [], ShotIndex: 0, Wait: 0, Ready: false, NextSeed: true, Activated: false, Surface: -1, MinX: 0, MinY: 0, Done: []};
	oCamera.Override = true;
}

function Test_SheetNextSeed(){
	Sheet.SeedIndex++;
	if(Sheet.SeedIndex >= array_length(Sheet.Seeds)){
		Test_SheetFinish();
		exit;
	}
	var _Seed = Sheet.Seeds[Sheet.SeedIndex];
	Test_BuildLevel(Sheet.Level, _Seed);
	global.Paused = true;
	oLink.visible = false;
	oHUD.ShowLevelName = false;	// the level name banner is drawn in the view

	// Bounding box of the level and the camera positions that cover every room (the view is 256x224, rooms are 256 multiples)
	var _MinX = 99999;
	var _MinY = 99999;
	var _MaxX = 0;
	var _MaxY = 0;
	Sheet.Shots = [];
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		var _R = global.Level.Rooms[_RoomIndex];
		_MinX = min(_MinX, _R.x);
		_MinY = min(_MinY, _R.y);
		_MaxX = max(_MaxX, _R.x + _R.width);
		_MaxY = max(_MaxY, _R.y + _R.height);
		for(var _X = _R.x; _X < _R.x + _R.width; _X += CAM_W){
			var _Y = _R.y;
			while(true){
				array_push(Sheet.Shots, [_RoomIndex, _X, min(_Y, _R.y + _R.height - CAM_H)]);
				if(_Y + CAM_H >= _R.y + _R.height) break;
				_Y += CAM_H;
			}
		}
		Test_Log("sheet seed=" + string(_Seed) + " room " + Test_RoomStr(_RoomIndex));
	}
	Sheet.MinX = _MinX;
	Sheet.MinY = _MinY;
	Sheet.Surface = surface_create(_MaxX - _MinX, _MaxY - _MinY);
	surface_set_target(Sheet.Surface);
	draw_clear(c_black);
	surface_reset_target();
	Sheet.ShotIndex = 0;
	Sheet.Ready = false;
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++) Dungeon_RoomDeActivate(_RoomIndex);
	instance_activate_object(oLink);	// oCamera and oTest need him, even hidden
}

/// End Step: builds the next level or points the camera at the next shot
function Test_SheetStep(){
	if(Sheet.NextSeed){
		if(!Sheet.Activated){	// same as the "level" step: every room active before the next level is built
			Sheet.Activated = true;
			ActivateAll = true;
			exit;
		}
		Sheet.Activated = false;
		Sheet.NextSeed = false;
		Test_SheetNextSeed();
		exit;
	}
	if(Sheet.Ready){
		if(Sheet.Wait > 0) Sheet.Wait--;
		exit;
	}
	var _Shot = Sheet.Shots[Sheet.ShotIndex];
	var _RoomIndex = _Shot[0];
	if(_RoomIndex != global.CurrentRoomIndex){
		if(global.CurrentRoomIndex >= 0) Dungeon_RoomDeActivate(global.CurrentRoomIndex);
		Dungeon_RoomActivate(_RoomIndex);
		instance_activate_object(oLink);
		with(oCamera) SetCurrentRoom(_RoomIndex);
	}
	oCamera.X = _Shot[1];
	oCamera.Y = _Shot[2];
	Sheet.Wait = TEST_SHEET_WAIT;
	Sheet.Ready = true;
}

/// Post Draw: takes the shot once the camera has settled
function Test_SheetCapture(){
	if(!Sheet.Ready || Sheet.Wait > 0 || !surface_exists(Sheet.Surface)) exit;
	var _Shot = Sheet.Shots[Sheet.ShotIndex];
	Test_CaptureView(Sheet.Surface, _Shot[1] - Sheet.MinX, _Shot[2] - Sheet.MinY);
	Sheet.Ready = false;
	Sheet.ShotIndex++;
	if(Sheet.ShotIndex < array_length(Sheet.Shots)) exit;

	var _Name = "sheet_" + string(Sheet.Level) + "_" + string(Sheet.Seeds[Sheet.SeedIndex]) + ".png";
	surface_save(Sheet.Surface, TEST_OUT + _Name);
	Test_Log("shot " + _Name + " rooms=" + string(global.Level.RoomCount));
	array_push(Sheet.Done, Sheet.Surface);
	Sheet.Surface = -1;
	Sheet.NextSeed = true;
}

function Test_SheetFinish(){
	// All seeds side by side at half size
	var _Gap = 8;
	var _W = 0;
	var _H = 0;
	for(var i = 0; i < array_length(Sheet.Done); i++){
		_W += surface_get_width(Sheet.Done[i]) / 2 + _Gap;
		_H = max(_H, surface_get_height(Sheet.Done[i]) / 2);
	}
	var _All = surface_create(max(1, _W - _Gap), max(1, _H));
	surface_set_target(_All);
	draw_clear(c_dkgray);
	var _X = 0;
	for(var i = 0; i < array_length(Sheet.Done); i++){
		draw_surface_ext(Sheet.Done[i], _X, 0, 0.5, 0.5, 0, c_white, 1);
		_X += surface_get_width(Sheet.Done[i]) / 2 + _Gap;
		surface_free(Sheet.Done[i]);
	}
	surface_reset_target();
	var _Name = "sheet_" + string(Sheet.Level) + ".png";
	surface_save(_All, TEST_OUT + _Name);
	surface_free(_All);
	Test_Log("shot " + _Name + " seeds=" + string(array_length(Sheet.Done)));

	Sheet = undefined;
	global.Paused = false;
	oLink.visible = true;
	oCamera.Override = false;
	Link_SetStartingPos();
}

#endregion
