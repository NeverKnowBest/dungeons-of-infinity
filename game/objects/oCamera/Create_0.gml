
RoomTransition = NONE;
RoomTransitionInit = false;

global.CurrentRoomIndex = -1;
global.TransitionRoomIndex = -1;

TransitionEndX = 0;
TransitionEndY = 0;

OpenTransition = false; //set to true if in village with full-screen transition

X = 0;
Y = 0;
W_2 = CAM_W / 2;
H_2 = CAM_H / 2;
X2 = 0;
Y2 = 0;

DungeonGridX = -1;
DungeonGridY = -1;

MoveSpeed = 8;

ShakeAmount = 0;

Override = false;

ResetEnemies = false;

function SetToRoomIndex(_RoomIndex, _ActivateRoom = false, EnemyReset = true, _X = undefined, _Y = undefined){
	
	if(_ActivateRoom) Dungeon_RoomActivate(_RoomIndex);
	
	//optional: _X & _Y can set the camera at that location
	if(_X != undefined && _Y != undefined){
		X = _X;
		Y = _Y;
	}
	
	if(EnemyReset) Enemy_Reset(_RoomIndex);
	
	if(LevelDef.Special != LevelSpecial.Intro) Dungeon_RoomDeActivate(global.CurrentRoomIndex);
	
	SetCurrentRoom(_RoomIndex);
	
}


function SetCurrentRoom(_RoomIndex){
	
	global.CurrentRoom = DungeonRoom;
	global.CurrentRoomIndex = _RoomIndex;
	
	global.CurrentRoomX = global.CurrentRoom.x;
	global.CurrentRoomY = global.CurrentRoom.y;
	global.CurrentRoomW = global.CurrentRoom.width;
	global.CurrentRoomH = global.CurrentRoom.height;
	
}

function InView(_x, _y){
	return point_in_rectangle(_x, _y, X, Y, X2, Y2);	
}

function Cam_UpdatePos(){
	
	Cam_SetPos(oLink.x - W_2, oLink.y - H_2 - 22);
	
	if(DEBUG){
		if(!global.Clip){
			if(X < global.CurrentRoom.x) X = global.CurrentRoom.x;
			if(Y < global.CurrentRoom.y) Y = global.CurrentRoom.y;
			if(X + CAM_W > global.CurrentRoom.x + global.CurrentRoom.width) X = global.CurrentRoom.x + global.CurrentRoom.width - CAM_W;
			if(Y + CAM_H > global.CurrentRoom.y + global.CurrentRoom.height - 16) Y = global.CurrentRoom.y + global.CurrentRoom.height - CAM_H - 16;				
		}		
	}else{
		if(X < global.CurrentRoom.x) X = global.CurrentRoom.x;
		if(Y < global.CurrentRoom.y) Y = global.CurrentRoom.y;
		if(X + CAM_W > global.CurrentRoom.x + global.CurrentRoom.width) X = global.CurrentRoom.x + global.CurrentRoom.width - CAM_W;
		if(Y + CAM_H > global.CurrentRoom.y + global.CurrentRoom.height - 16) Y = global.CurrentRoom.y + global.CurrentRoom.height - CAM_H - 16;	
	}

	DungeonGridX = round(X / 256);
	DungeonGridY = round(Y / 256);
	
}

function Cam_InitTransitionRoom(_Dir, _Open = false){
	
	if(_Open){
		MoveSpeed = 8;
		oCamera.OpenTransition = true;
	}else{
		//allgin Link to nearest even number to prevent pixels from unlit rooms being seen while transitioning
		oLink.x = round(oLink.x / 2) * 2;
		oLink.y = round(oLink.y / 2) * 2;
		MoveSpeed = 4;
	}
	
	Cam_UpdatePos();
	
	var DirX = 0;
	var DirY = 0;
	
	switch(_Dir){
		case LEFT: DirX = -1; break;
		case RIGHT: DirX = 1; break;
		case UP: DirY = -1; break;
		case DOWN: DirY = 1; break;
	}
	
	TransitionEndX = X + (DirX * 256)
	TransitionEndY = Y + (DirY * 240);
	
	//screens of an area (roadmap F18): the room beyond Link's own cell (a 2x2 screen's camera may stand on its other
	//row, and the screen beside it is 1x1)
	var _Screens = (_Open && LevelDef.Layout == LevelLayout.Screens);
	if(_Screens){
		DungeonGridX = floor(oLink.x / 256);
		DungeonGridY = floor(oLink.y / 256);
	}
	DungeonGridX += DirX;
	DungeonGridY += DirY;
	
	oLink.AutoMoveDirX = DirX;
	oLink.AutoMoveDirY = DirY;
	
	RoomTransition = _Dir;
	
	//off the level's grid (the closed edge of an area's screen, roadmap F18): no room there
	if(DungeonGridX < 0 || DungeonGridY < 0 || DungeonGridX >= DungeonGridW || DungeonGridY >= DungeonGridW){
		RoomTransition = NONE;
		exit;
	}
	global.TransitionRoomIndex = global.Level.Map_RoomIndex[DungeonGridY][DungeonGridX];
	if(global.TransitionRoomIndex == -1){
		RoomTransition = NONE;
		exit;
	}
	global.TransitionRoom = global.Level.DungeonTemplate.Rooms[global.TransitionRoomIndex];
	if(_Screens && DirX != 0){
		//into a screen of another height: the camera also scrolls to where that screen lets it stand (8 px steps)
		var _Want = clamp(Y, global.TransitionRoom.y, global.TransitionRoom.y + global.TransitionRoom.height - CAM_H - 16);
		TransitionEndY = Y + round((_Want - Y) / MoveSpeed) * MoveSpeed;
	}
	
	with(oLink){
		StopStar();
		Link_SetAutoMove (DirX, DirY, AutoMoveSpeed);
	}
	
	
	var NextRoomSongIndex = global.Level.Rooms[global.TransitionRoomIndex].RoomSongIndex;
	if(oMusic.SongPlaying_Index != NextRoomSongIndex){
		Music_Fade(0, SongFadeLen_CameraTransition, NextRoomSongIndex);
	}
		
}

function Cam_SetPos(_X, _Y){

	X = _X;
	Y = _Y;
	X2 = X + CAM_W - 1;
	Y2 = Y + CAM_H - 1;
	
}