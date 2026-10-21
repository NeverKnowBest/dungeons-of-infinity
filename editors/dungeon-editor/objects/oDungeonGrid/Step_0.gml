var _ResetView = false;


if(btnDungeon_New.ClickedL){
	NewDungeon();
	_ResetView = true;
}

if(btnDungeon_Del.ClickedL){
	MsgBox_DungeonDel = MsgBox_Create("Are you sure you want to delete this dungeon?", true);
}

switch(MsgBox_Check(MsgBox_DungeonDel)){
	
	case MsgBox.No:
		instance_destroy(MsgBox_DungeonDel);
		break;
	case MsgBox.Yes:
		instance_destroy(MsgBox_DungeonDel);
		array_delete(global.Data_Dungeons[global.DungeonClass], global.DungeonIndex, 1);
		var _Dungeons = array_length(global.Data_Dungeons[global.DungeonClass]);
		if(_Dungeons == 0){
			NewDungeon();		
		}else{
			if(global.DungeonIndex == _Dungeons) global.DungeonIndex--;
			RoomButtons_LoadFromDungeon();	
		}
		_ResetView = true;
		break;
	
}


var _OldDungeonIndex = global.DungeonIndex;
var _OldDungeonClass = global.DungeonClass;
var _SetDungeonIndex = _OldDungeonIndex;
var _SetDungeonClass = _OldDungeonClass;

var _LastDungeon = array_length(global.Data_Dungeons[global.DungeonClass]) - 1;

if(chkDungeonClass[DungeonClass.Castle].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.Castle;
}
if(chkDungeonClass[DungeonClass.CastleBasement].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.CastleBasement;
}
if(chkDungeonClass[DungeonClass.CastleJails].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.CastleJails;
}
if(chkDungeonClass[DungeonClass.CatacombsSewers].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.CatacombsSewers;
}
if(chkDungeonClass[DungeonClass.BossesRuins].ClickedL){
	_SetDungeonIndex = 0;	
	_SetDungeonClass = DungeonClass.BossesRuins;
}
if(chkDungeonClass[DungeonClass.Aghanim].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.Aghanim;
}
if(chkDungeonClass[DungeonClass.Special].ClickedL){
	_SetDungeonIndex = 0;
	_SetDungeonClass = DungeonClass.Special;
}

if(btnDungeon_Start.ClickedL){
	_SetDungeonIndex = 0;
}
if(btnDungeon_Prev10.ClickedL){
	_SetDungeonIndex -= 10;
	_SetDungeonIndex = clamp(_SetDungeonIndex, 0, _LastDungeon);	
}
if(btnDungeon_Prev1.ClickedL){
	_SetDungeonIndex = clamp(--_SetDungeonIndex, 0, _LastDungeon);	
}
if(btnDungeon_Next1.ClickedL){
	_SetDungeonIndex = clamp(++_SetDungeonIndex, 0, _LastDungeon);	
}
if(btnDungeon_Next10.ClickedL){
	_SetDungeonIndex += 10;
	_SetDungeonIndex = clamp(_SetDungeonIndex, 0, _LastDungeon);	
}
if(btnDungeon_End.ClickedL){
	_SetDungeonIndex = _LastDungeon;
}



if(_SetDungeonIndex != _OldDungeonIndex || _SetDungeonClass != _OldDungeonClass){
	global.DungeonIndex = _SetDungeonIndex;
	global.DungeonClass = _SetDungeonClass;
	chkDungeonClass[DungeonClass.Castle].ChkStatus = false;
	chkDungeonClass[DungeonClass.CastleBasement].ChkStatus = false;
	chkDungeonClass[DungeonClass.CastleJails].ChkStatus = false;
	chkDungeonClass[DungeonClass.CatacombsSewers].ChkStatus = false;
	chkDungeonClass[DungeonClass.BossesRuins].ChkStatus = false;
	chkDungeonClass[DungeonClass.Aghanim].ChkStatus = false;
	chkDungeonClass[DungeonClass.Special].ChkStatus = false;
	chkDungeonClass[global.DungeonClass].ChkStatus = true;
	RoomButtons_LoadFromDungeon();
	DungeonObjRefresh();
	_ResetView = true;
}


for(var btnRoomSizeX = 1; btnRoomSizeX <= 2; btnRoomSizeX++){
	for(var btnRoomSizeY = 1; btnRoomSizeY <= 2; btnRoomSizeY++){
		if(btnRoom[btnRoomSizeX][btnRoomSizeY].ClickedL){
			btnRoom[btnRoom_LastActiveX][btnRoom_LastActiveY].Active = false;
			btnRoom[btnRoomSizeX][btnRoomSizeY].Active = true;
			btnRoom_LastActiveX = btnRoomSizeX; btnRoom_LastActiveY = btnRoomSizeY;
			RoomSetGridW = btnRoomSizeX; 
			RoomSetGridH = btnRoomSizeY;
		}
	}
}


if(btnRoomDel.ClickedL){
	
	var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms
	var Rooms = array_length(RoomArray);
	if(Rooms == 0) exit;
	
	var RoomButtonIndex = GetRoomButtonIndex_FromRoomIndex(global.ActiveRoom);

	//delete all connected doors
	var DoorArray = RoomArray[global.ActiveRoom].Doors;
	var Doors = array_length(DoorArray);
	for(var DoorIndex = 0; DoorIndex < Doors; DoorIndex++){
		
		var Door = DoorArray[DoorIndex];
		var ConnectedRoomIndex = Door.ConnectedRoomIndex;
		
		if(ConnectedRoomIndex == -1) continue;
		
		var ConnectedRoomDoorArray = RoomArray[ConnectedRoomIndex].Doors;
		var ConnectedDoors = array_length(ConnectedRoomDoorArray);

		for(var ConnectedDoorIndex = 0; ConnectedDoorIndex < ConnectedDoors; ConnectedDoorIndex++){
			var ConnectedDoor = ConnectedRoomDoorArray[ConnectedDoorIndex];
			if(ConnectedDoor.Position == Door.ConnectedDoorPos){
				var DIndex = GetDoorIndex(ConnectedRoomIndex, ConnectedDoor.Position);
				if(DIndex != -1) array_delete(ConnectedRoomDoorArray, DIndex, 1);
				break;
			}
		}
		
	}
	
	//All ConnectedRoomIndex of doors need to have their ConnectedRoomIndex subtracted by 1 if it's larger than the deleted room
	for(var RoomIndex = 0; RoomIndex < Rooms; RoomIndex++){
		var DoorArray = RoomArray[RoomIndex].Doors;
		var Doors = array_length(DoorArray);
		for(var DoorIndex = 0; DoorIndex < Doors; DoorIndex++){
			if(DoorArray[DoorIndex].ConnectedRoomIndex > global.ActiveRoom)
				DoorArray[DoorIndex].ConnectedRoomIndex--;
		}
		
	}
	

	var RX = RoomButtons[RoomButtonIndex].GridX;
	var RY = RoomButtons[RoomButtonIndex].GridY;
	var RW = RoomButtons[RoomButtonIndex].GridW;
	var RH = RoomButtons[RoomButtonIndex].GridH;
	
	RoomButton_Delete(RoomButtonIndex);

	if(RW == 1 && RH == 1){
		RoomButton_Create(-1, RX, RY, 1, 1);
	}else if(RW == 1 && RH == 2){
		RoomButton_Create(-1, RX, RY, 1, 1);
		RoomButton_Create(-1, RX, RY + 1, 1, 1);
	}else if(RW == 2 && RH == 1){
		RoomButton_Create(-1, RX, RY, 1, 1);
		RoomButton_Create(-1, RX + 1, RY, 1, 1);
	}else if(RW == 2 && RH == 2){
		RoomButton_Create(-1, RX, RY, 1, 1);
		RoomButton_Create(-1, RX + 1, RY, 1, 1);			
		RoomButton_Create(-1, RX, RY + 1, 1, 1);			
		RoomButton_Create(-1, RX + 1, RY + 1, 1, 1);			
	}

	//All room buttons with index above active room index must be subtracted by 1
	var Buttons = array_length(RoomButtons)	;
	for(var ButtonIndex = 0; ButtonIndex < Buttons; ButtonIndex++){
		if(RoomButtons[ButtonIndex].RoomIndex > global.ActiveRoom) RoomButtons[ButtonIndex].RoomIndex--;
	}
	
	global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[global.ActiveRoom].Doors = 0;
	
	Doors_Refresh();
	
	array_delete(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms, global.ActiveRoom, 1);
	
	global.ActiveRoom = 0;
	
	RoomButton_Activate();
	
}

var Buttons = array_length(RoomButtons)	;	 
for(var ButtonIndex = 0; ButtonIndex < Buttons; ButtonIndex++){
	
	if(RoomButtons[ButtonIndex].ButtonInst.ClickedL){
		
		var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms;
		var Rooms = array_length(RoomArray);
		
		
		//Check if clicking on an existing room
		var AddRoom = true;
		if(RoomButtons[ButtonIndex].RoomIndex != -1){ 
			//Button has a room index, so there's a room associated with it.			
			AddRoom = false;
			global.ActiveRoom = RoomButtons[ButtonIndex].RoomIndex;
			
		}else{
			
			//no room exists in that button, so check to see if it's possible to create one
			
			var Bx = RoomButtons[ButtonIndex].GridX; var By = RoomButtons[ButtonIndex].GridY;
			
			 //check if new room would go out of bounds
			if(Bx + RoomSetGridW > DungeonGridMax || By + RoomSetGridH > DungeonGridMax){
				break;				
			}else{
				//room is in bound, so perform more checks
				for(var RoomIndex = 0; RoomIndex < Rooms; RoomIndex++){
			
					var Rx = RoomArray[RoomIndex].GridX; var Ry = RoomArray[RoomIndex].GridY; var Rw = RoomArray[RoomIndex].GridW; var Rh = RoomArray[RoomIndex].GridH; 
			
					if(point_in_rectangle(Bx, By, Rx, Ry, Rx + Rw - 1, Ry + Rh - 1)){
						//Clicked on a room, set active room to this one, don't create new room
						global.ActiveRoom = RoomIndex;
						AddRoom = false;
						break;				
					}
			
					if(rectangle_in_rectangle(Bx, By, Bx + RoomSetGridW - 1, By + RoomSetGridH - 1, Rx, Ry, Rx + Rw - 1, Ry + Rh - 1)){
						//new room would overlap, don't create new room
						AddRoom = false;
						break;
					}
				}
			}
		}
				
		if(AddRoom){
			RoomButton_AddRoom(Rooms, true, Bx, By, RoomSetGridW, RoomSetGridH);
			global.ActiveRoom = Rooms;
		}

		RoomButton_Activate();
		
		if(WarpSet){
			var _FromRoom = RoomArray[WarpRoomIndex];
			var _ToRoom = RoomArray[RoomButtons[ButtonIndex].RoomIndex];
			_FromRoom.Warp_DestGridPosition = (_ToRoom.GridY * 8) + _ToRoom.GridX;
			WarpSet = false;
		}
		
		break;
		
	}
	

	
}

if(array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"]) > 0){
	
	var ActiveRoom = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"][global.ActiveRoom];
	
	//Section Buttons
	for(var i = 1; i <= 30; i++){
		if(btnSection[i].ClickedL){
			
			ActiveRoom[$ "Section_ID"] = i;
			
			global.SectionActive = true;
			
			SectionButtonsRefresh();
		
			break;
		}
	}	

	//Selected Section buttons
	if(ActiveRoom[$ "Section_ID"] > 0){
	
		if(btnSection_Rail.ClickedL) ActiveRoom[$ "Section_WallType"] = SectionWallType.Rail;
		
		for(var i = 0; i < 2; i++){
			if(btnSection_SwitchBlock[i].ClickedL){
				ActiveRoom[$ "Section_WallType"] = SectionWallType.SwitchBlock;
				ActiveRoom[$ "Section_Color"] = i;
			}
		}
	
		if(btnSection_Delete.ClickedL){
			ActiveRoom[$ "Section_ID"] = 0;
			ActiveRoom[$ "SpecialObjSection"] = 0;
			ActiveRoom[$ "Section_WallType"] = SectionWallType.Rail;

			global.SectionActive = false;
			
			SectionButtonsRefresh();
			
		}

	}
	
	
	if(btnSection_Key.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.Key ? SpecialObject.Key : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}
	
	if(btnSection_SpecialRoom.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.SpecialRoom ? SpecialObject.SpecialRoom : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}
	
	if(btnSection_Crystal.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.Crystal ? SpecialObject.Crystal : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}

	if(btnSection_DoorSwitch.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.DoorSwitch ? SpecialObject.DoorSwitch : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}

	if(btnSection_EnemyTrap.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.EnemyTrap ? SpecialObject.EnemyTrap : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}

	if(btnSection_Warp.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.Warp ? SpecialObject.Warp : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}

	if(btnSection_Boss.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.Boss ? SpecialObject.Boss : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}

	if(btnSection_House.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.House ? SpecialObject.House : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}
	
	if(btnSection_Jail.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.Jail ? SpecialObject.Jail : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}
	
	if(btnSection_JailKey.ClickedL){
		ActiveRoom[$ "SpecialObj"] = (ActiveRoom[$ "SpecialObj"] != SpecialObject.JailKey ? SpecialObject.JailKey : 0);
		ActiveRoom[$ "SpecialObjSection"] = (global.SectionActive ? ActiveRoom[$ "Section_ID"] : 0);
	}
	
	if(btnWarpClear.ClickedL){
		ActiveRoom[$ "Warp_DestGridPosition"] = -1;
		WarpSet = false;
	}
	if(btnWarpSet.ClickedL){
		ActiveRoom[$ "Warp_DestGridPosition"] = -1;
		WarpRoomIndex = global.ActiveRoom;
		WarpSet = true;
	}

	//Dungeon shifting
	
	var _ShiftX = 0;
	var _ShiftY = 0;

	if(btnShiftUp.ClickedL) _ShiftY = -1;
	if(btnShiftDown.ClickedL) _ShiftY = 1;
	if(btnShiftLeft.ClickedL) _ShiftX = -1;
	if(btnShiftRight.ClickedL) _ShiftX = 1;


	if(_ShiftX != 0 || _ShiftY != 0){
		
		var _DungeonRooms = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms;
		var _Rooms = array_length(_DungeonRooms);
		
		//check if edges are reached
		for(var i = 0; i < _Rooms; i++){
			var _Room = _DungeonRooms[i];
			if( (_Room.GridX == 0 && _ShiftX = -1) || (_Room.GridX == 7 && _ShiftX = 1) ) _ShiftX = 0;
			if( (_Room.GridY == 0 && _ShiftY = -1) || (_Room.GridY == 7 && _ShiftY = 1) ) _ShiftY = 0;
		}	
		
		var _Shift = _ShiftX != 0 || _ShiftY != 0;
		
		for(var i = 0; i < _Rooms && _Shift; i++){
			
			var _Room = _DungeonRooms[i];
			
			_Room.x += (_ShiftX * 256);
			_Room.y += (_ShiftY * 256);
			
			_Room.GridX += _ShiftX;
			_Room.GridY += _ShiftY;
			
			if(_Room.Warp_DestGridPosition != -1){
				_Room.Warp_DestGridPosition += _ShiftX;
				_Room.Warp_DestGridPosition += (_ShiftY * 8);
			}
			
		}
		
		if(_Shift){
			RoomButtons_LoadFromDungeon();
			_ResetView = true;
		}
		
	}
		
}



if(btnResetGrid.ClickedL || _ResetView){
	camera_set_view_size(view_camera[1], OriginalCamW, OriginalCamH);
	camera_set_view_pos(view_camera[1], 0, 1200); 
	Cam_CurrentW = OriginalCamW;
	Cam_CurrentH = OriginalCamH;
	
}


//Panning and Zooming


if(mouse_y < 1200) exit;

if(mouse_wheel_up()){
	
	var Cam_NewW = Cam_CurrentW * 0.8;
	if(Cam_NewW < OriginalCamW / 8) Cam_NewW = OriginalCamW / 8;
	UpdateZoom = true;
	
}
if(mouse_wheel_down()){
	
	var Cam_NewW = Cam_CurrentW * 1.2;
	if(Cam_NewW > OriginalCamW) Cam_NewW = OriginalCamW;
	
	UpdateZoom = true;
	
}

if(UpdateZoom){
	
	var Cam_NewH = Cam_NewW * CamRatio

	var Mx_Ratio = (mouse_x - camera_get_view_x(view_camera[1])) / Cam_CurrentW
	var My_Ratio = (mouse_y - camera_get_view_y(view_camera[1])) / Cam_CurrentH
	
	var Cam_NewX = round(mouse_x - (Mx_Ratio * Cam_NewW));
	var Cam_NewY = round(mouse_y - (My_Ratio * Cam_NewH));
		
	camera_set_view_size(view_camera[1], Cam_NewW, Cam_NewH);
	camera_set_view_pos(view_camera[1], Cam_NewX, Cam_NewY);
	
	Cam_CurrentW = Cam_NewW;
	Cam_CurrentH = Cam_NewH;
	
	UpdateZoom = false;
	
}


if( mouse_check_button_pressed(mb_middle)){
	WinMove_MX = mouse_x;
	WinMove_MY = mouse_y;
}

Panning = false;
if(mouse_check_button(mb_middle)){
	
	Panning = true;
	var CamX = camera_get_view_x(view_camera[1]);
	var CamY = camera_get_view_y(view_camera[1])
	var CamW = camera_get_view_width(view_camera[1]);
	var CamH = camera_get_view_height(view_camera[1]);
	
	if(window_view_mouse_get_x(1) >= CamX && window_view_mouse_get_x(1) < CamX + CamW - 1 && window_view_mouse_get_y(1) >= CamY && window_view_mouse_get_y(1) < CamY + CamH - 1){
		WinMove_PosX = WinMove_MX - window_view_mouse_get_x(1);
		WinMove_PosY = WinMove_MY - window_view_mouse_get_y(1);
		var NewX = camera_get_view_x(view_camera[1]) + WinMove_PosX;
		var NewY = camera_get_view_y(view_camera[1]) + WinMove_PosY;
		camera_set_view_pos(view_camera[1], NewX, NewY);
	}

	
}		
	