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

	Test_Log("start scenario=" + string(global.Test.Name) + " seed=" + string(global.Test.Seed) + " level=" + string(global.Test.Level));
	random_set_seed(global.Test.Seed);
	DungeonSeq_Init(global.UserIndex);
	room_goto(Room_Dungeon);
}

/// Called from oGame's Create in place of the intro level
function Test_StartLevel(){
	if(!is_real(global.Test.Level) || global.Test.Level < DungeonLevel.Start || global.Test.Level > DungeonLevel.Aghanim2){
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
	Dungeon_InitLevel(_Level);
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
	return string(global.Level.Index) + " \"" + global.DungeonNames[global.Level.Index] + "\"";
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

	var _Pos = Test_RoomEntryPoint(_RoomIndex);
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
	with(oCamera) SetToRoomIndex(_RoomIndex, true);
	global.Level.Rooms[_RoomIndex].Visited = true;
	Map_UpdateExploredRooms();
	global.InWaterSprite = Link_GetInWaterSprite();
	return true;
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
			if(_Bad == "") Test_Log("expect ok");
			else Test_Fail("expect" + _Bad);
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
