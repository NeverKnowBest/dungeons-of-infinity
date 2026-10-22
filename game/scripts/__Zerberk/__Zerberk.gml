enum GridDir{
	N,S,E,W	
}

enum MiniArcadeState{
	Title,
	Start,
	GameOver
}

global.GridDirX = [0, 0, 1, -1];
global.GridDirY = [-1, 1, 0, 0];
global.GridDirOpposite = [GridDir.S, GridDir.N, GridDir.W, GridDir.E];

global.ZerberkRobotPhraseArray = [Sound_Zerberk_Robot_Phrase_Alert,
								  Sound_Zerberk_Robot_Phrase_Charge,
								  Sound_Zerberk_Robot_Phrase_FightHuman,
								  Sound_Zerberk_Robot_Phrase_HumanDetected,
								  Sound_Zerberk_Robot_Phrase_HumanEscape,
								  Sound_Zerberk_Robot_Phrase_IntruderDetected,
								  Sound_Zerberk_Robot_Phrase_IntruderEscape,
								  Sound_Zerberk_Robot_Phrase_KillHuman,
								  Sound_Zerberk_Robot_Phrase_KillIntruder,
								  Sound_Zerberk_Robot_Phrase_ShootIntruder];

#macro ZerberkRobotPhrases 10

global.ZerberkRobotPhraseIndexes = [];

function Zerberk_Level_Reset(){
	
	Zerberk_Level_Destroy();
	
	LevelGrid = array_create(3);
	for(var _GridY = 0; _GridY < 3; _GridY++){
		LevelGrid[_GridY] = array_create(3);
	}

	var _SpawnArcade = (!SpawnedArcade && Score >= SpawnArcadeScore);
	
	if(State == ArcadeState.AttractScreen || _SpawnArcade){

		WallStatusX = array_create(12);
		WallStatusY = array_create(12);
		
		WallStatusX[0] = 1;	WallStatusX[1] = 1;	WallStatusX[2] = 1;	WallStatusX[9] = 1;	WallStatusX[10] = 1; WallStatusX[11] = 1;
		WallStatusY[0] = 1;	WallStatusY[3] = 1;	WallStatusY[4] = 1;	WallStatusY[7] = 1;	WallStatusY[8] = 1; WallStatusY[11] = 1;
	
	}else{
		Zerberk_Level_Create(irandom(2), irandom(2), LevelGrid);
	
		WallStatusX = array_create(12, 1);
		WallStatusY = array_create(12, 1);
	
		for(var _GridY = 0; _GridY < 3; _GridY++){
			for(var _GridX = 0; _GridX < 3; _GridX++){
			
				var _Walls = LevelGrid[_GridY][_GridX];
				var _WallN = (_Walls & 1) != 1;
				var _WallS = (_Walls & 2) != 2;
				var _WallE = (_Walls & 4) != 4;
				var _WallW = (_Walls & 8) != 8;
			
				var _GridIndex = (_GridY * 3) + _GridX;
			
				WallStatusX[_GridIndex] =				_WallN ? 1 : 0;
				WallStatusX[_GridIndex + 3] =			_WallS ? 1 : 0;
				WallStatusY[_GridIndex + _GridY] =		_WallW ? 1 : 0;
				WallStatusY[_GridIndex + _GridY + 1] =	_WallE ? 1 : 0;
			
			}
		
		
		}	
	
		//sometimes remove some centre walls for variety, creates more space
		var _ProbKeepWall = 0.8;
		WallStatusX[4] = (WallStatusX[4] == 1 ? (Prob(_ProbKeepWall) ? 1 : 0): 0);
		WallStatusX[7] = (WallStatusX[7] == 1 ? (Prob(_ProbKeepWall) ? 1 : 0): 0);
		WallStatusY[5] = (WallStatusY[5] == 1 ? (Prob(_ProbKeepWall) ? 1 : 0): 0);
		WallStatusY[6] = (WallStatusY[6] == 1 ? (Prob(_ProbKeepWall) ? 1 : 0): 0);

	}
	
	DoorStart = NextDoorStart;
	DoorEnd = Zerberk_Level_PickEndDoor(DoorStart);
	
	Zerberk_Level_SetDoors(DoorStart, DoorEnd);
	
	NextDoorStart = Zerberk_Level_GetOppositeDoor(DoorEnd);
	
	StartWallData = Zerberk_Level_GetWallIndex(DoorStart);
	EndWallData = Zerberk_Level_GetWallIndex(DoorEnd);
	
	Hero = instance_create_layer(0, 0, "System", oZerberk_Hero);
	Zerberk_SetHeroStartPos(Hero, DoorStart);
	
	if(_SpawnArcade){
		MiniArcade = instance_create_layer(LevelCornersX[1] + (WallWidth[1] / 2), CamH / 2, "System", oZerberk_MiniArcade);
		EndWallData[0][EndWallData[1]] = 0;
		SpawnedArcade = true;		
	}else if(State != ArcadeState.AttractScreen){
		
		Level++;
		
		var _SectionList = ds_list_create_sequence_shuffled(0, 8);
		var _HeroSection = Zerberk_GetSection(Hero.x, Hero.y);
		var _Robots = min(2 + ceil(Level / 4), 8);
		while(_Robots > 0){
			
			var _SectionIndex = _SectionList[| 0];
			ds_list_delete(_SectionList, 0);
			
			if(_SectionIndex == _HeroSection) continue;
			
			var _XIndex = _SectionIndex mod 3;
			var _YIndex = _SectionIndex div 3;

			var _PosX = LevelCornersX[_XIndex] + irandom_range(16, WallWidth[_XIndex] - 16);
			var _PosY = LevelCornersY[_YIndex] + irandom_range(24, WallHeight[_YIndex] - 12);

			var RobotInst = instance_create_layer(_PosX, _PosY, "System", oZerberk_Robot);
			RobotInst.alarm[0] = irandom_range(100, 200);
			RobotInst.alarm[1] = irandom_range(50, 70);
			
			_Robots--;

		}
		ds_list_destroy(_SectionList);
		
		if(array_length(global.ZerberkRobotPhraseIndexes) == 0){
			global.ZerberkRobotPhraseIndexes = array_create_sequence_shuffled(0, ZerberkRobotPhrases - 1);
		}
		var _PhraseIndex = array_pop(global.ZerberkRobotPhraseIndexes);
		audio_play_sound(global.ZerberkRobotPhraseArray[_PhraseIndex], 1, false);
		
	}
	
}

function Zerberk_Level_Create(GridX_Current, GridY_Current, _LevelGrid){

	
	var DirList = ds_list_create();
	ds_list_add(DirList, 0, 1, 2, 3);
	ds_list_shuffle(DirList);
	
	for(var _DirIndex = 0; _DirIndex < 4; _DirIndex++){
		
		var _Dir = DirList[| _DirIndex];
		
		var _GridX_Next = GridX_Current + global.GridDirX[_Dir];
		var _GridY_Next = GridY_Current + global.GridDirY[_Dir];

	    if(_GridX_Next >= 0 && _GridX_Next < 3 && _GridY_Next >= 0 && _GridY_Next < 3 && _LevelGrid[_GridY_Next][_GridX_Next] == 0){
		    _LevelGrid[GridY_Current][GridX_Current] |= power(2, _Dir);
			_LevelGrid[_GridY_Next][_GridX_Next] |= power(2, global.GridDirOpposite[_Dir]);
			Zerberk_Level_Create(_GridX_Next, _GridY_Next, _LevelGrid);
		}
	}

	ds_list_destroy(DirList);
	
}

function Zerberk_Level_PickEndDoor(_StartDoor){
	
	var _MinDoor = _StartDoor + 3;
	var _MaxDoor = _MinDoor + 6;
	return ((irandom_range(_MinDoor, _MaxDoor) - 1) mod 12) + 1;
	
}

function Zerberk_Level_SetDoors(_PositionStart, _PositionEnd){
	
	Positions[0] = _PositionStart;
	Positions[1] = _PositionEnd;
	
	for(var _PositionIndex = 0; _PositionIndex < 2; _PositionIndex++){
		
		WallData = Zerberk_Level_GetWallIndex(Positions[_PositionIndex]);
		WallData[0][WallData[1]] = 2;
		
	}
}

function Zerberk_SetHeroStartPos(_HeroInst, _StartPos){

	var _CornerIndexX, _CornerIndexY, _WallX, _WallY, _WallW, _WallH;
	switch(_StartPos){
		case 11:
		case 12:
		case 1:
			_CornerIndexX = StartWallData[1] mod 3;
			_CornerIndexY = StartWallData[1] div 3;
			_WallX = LevelCornersX[_CornerIndexX];
			_WallY = LevelCornersY[_CornerIndexY];
			_WallW = WallWidth[_CornerIndexX];
			_HeroInst.x = _WallX + (_WallW / 2) - 1;
			_HeroInst.y = _WallY + 26;
			break;
		
		case 5:
		case 6:
		case 7:
			_CornerIndexX = StartWallData[1] mod 3;
			_CornerIndexY = StartWallData[1] div 3;
			_WallX = LevelCornersX[_CornerIndexX];
			_WallY = LevelCornersY[_CornerIndexY];
			_WallW = WallWidth[_CornerIndexX];
			_HeroInst.x = _WallX + (_WallW / 2) - 1;
			_HeroInst.y = _WallY - 6;		
			break;

		case 2:
		case 3:
		case 4:
			_CornerIndexX = StartWallData[1] mod 4;
			_CornerIndexY = StartWallData[1] div 4;
			_WallX = LevelCornersX[_CornerIndexX];
			_WallY = LevelCornersY[_CornerIndexY];
			_WallH = WallHeight[_CornerIndexY];
			_HeroInst.x = _WallX - 12;
			_HeroInst.y = _WallY + (_WallH / 2) + 4;
			_HeroInst.Dir = -1;
			break;

		case 8:
		case 9:
		case 10:
			_CornerIndexX = StartWallData[1] mod 4;
			_CornerIndexY = StartWallData[1] div 4;
			_WallX = LevelCornersX[_CornerIndexX];
			_WallY = LevelCornersY[_CornerIndexY];
			_WallH = WallHeight[_CornerIndexY];
			_HeroInst.x = _WallX + 13;
			_HeroInst.y = _WallY + (_WallH / 2) + 4;
			_HeroInst.Dir = 1;
			break;

	}
	
}

function Zerberk_Hero_Death(){
	with(oZerberk_Hero){
		sprite_index = sZerberk_Hero_Dead;
		Dead = true;
	}
	global.Arcade_ActiveInst.alarm[2] = 150;
	audio_play_sound(Sound_Zerberk_Hero_Dead, 1, false);
	
}

function Zerberk_Level_GetWallIndex(_Position){
	
	//return an aray containing the wall status array and index to use for the given position
	switch(_Position){
		case 1: return [WallStatusX, 2]
		case 2: return [WallStatusY, 3]
		case 3: return [WallStatusY, 7]
		case 4: return [WallStatusY,11]
		case 5: return [WallStatusX,11]
		case 6: return [WallStatusX,10]
		case 7: return [WallStatusX, 9]
		case 8: return [WallStatusY, 8]
		case 9: return [WallStatusY, 4]
		case 10: return [WallStatusY,0]
		case 11: return [WallStatusX,0]
		case 12: return [WallStatusX,1]
		
	}
	
}

function Zerberk_Level_GetOppositeDoor(_DoorPosition){
	
	switch(_DoorPosition){
		case 1: return 5
		case 2: return 10
		case 3: return 9
		case 4: return 8
		case 5: return 1
		case 6: return 12
		case 7: return 11
		case 8: return 4
		case 9: return 3
		case 10: return 2
		case 11: return 7
		case 12: return 6
		
	}
	
}

function Zerberk_Level_Destroy(){
	
	with(oZerberk_Hero) instance_destroy(id);
	with(oZerberk_Robot) instance_destroy(id);
	with(oZerberk_Robot_Destroyed) instance_destroy(id);
	with(oZerberk_Laser) instance_destroy(id);
	with(oZerberk_MiniArcade) instance_destroy(id);
	audio_stop_sound(Sound_Zerberk_Hero_Dead);
	alarm[2] = -1;
}

function Zerberk_InLevel(_x, _y){
	return point_in_rectangle(_x, _y, global.Arcade_ActiveInst.CamX, global.Arcade_ActiveInst.CamY, global.Arcade_ActiveInst.CamX + global.Arcade_ActiveInst.CamW, global.Arcade_ActiveInst.CamY + global.Arcade_ActiveInst.CamH)	
}

function Zerberk_GetSection(_x, _y){

	var _SectionIndex = 0;
	
	for(var _SectionY = 0; _SectionY < 3; _SectionY++){
		for(var _SectionX = 0; _SectionX < 3; _SectionX++){
		
			var _SectionX1 = LevelCornersX[_SectionX];
			var _SectionY1 = LevelCornersY[_SectionY];
			var _SectionX2 = _SectionX1 + WallWidth[_SectionX] - 1;
			var _SectionY2 = _SectionY1 + WallHeight[_SectionY] - 1;
			
			if(point_in_rectangle(_x, _y, _SectionX1, _SectionY1, _SectionX2, _SectionY2)) return _SectionIndex;
			
			_SectionIndex++;
			
		}		
		
	}	
	
	return -1;
	
}

function Zerberk_WallCollisionX(_Inst){
	
	for(var _WallX = 0; _WallX < 12; _WallX++){
	
		if(global.Arcade_ActiveInst.WallStatusX[_WallX] == 0) continue;

		var _CornerIndexX = _WallX mod 3;
		var _CornerIndexY = _WallX div 3;
	
		var _WallX1 = global.Arcade_ActiveInst.LevelCornersX[_CornerIndexX];
		var _WallY1 = global.Arcade_ActiveInst.LevelCornersY[_CornerIndexY];
		var _WallX2 = _WallX1 + global.Arcade_ActiveInst.WallWidth[_CornerIndexX] - 1;
		var _WallY2 = _WallY1 + 3;
		
		if(collision_rectangle(_WallX1, _WallY1, _WallX2, _WallY2, _Inst, false, false) != noone) return true;
	
	}
	
	return false;
	
}
function Zerberk_WallCollisionY(_Inst){
	
	for(var _WallY = 0; _WallY < 12; _WallY++){
	
		if(global.Arcade_ActiveInst.WallStatusY[_WallY] == 0) continue;

		var _CornerIndexX = _WallY mod 4;
		var _CornerIndexY = _WallY div 4;

		var _WallX1 = global.Arcade_ActiveInst.LevelCornersX[_CornerIndexX];
		var _WallY1 = global.Arcade_ActiveInst.LevelCornersY[_CornerIndexY];
		var _WallX2 = _WallX1 + 3;
		var _WallY2 = _WallY1 + global.Arcade_ActiveInst.WallHeight[_CornerIndexY] - 1;

		if(collision_rectangle(_WallX1, _WallY1, _WallX2, _WallY2, _Inst, false, false) != noone) return true;

			
	}
	
	return false;
	
}
