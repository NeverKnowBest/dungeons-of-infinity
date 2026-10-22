enum CarpetStyle{
	None,
	Path,
	Full
}

function Dungeon_Draw_Carpets(_RoomIndex){
	
	global.SpawnedCarpets = false;
	global.SpawnedCarpetStyle = CarpetStyle.None;
	
	if(!variable_struct_exists(Room.Template, "Carpets")) exit;
	
	switch(global.Level.Index){
		
		default:
			exit;
		
		case DungeonLevel.Castle:
		case DungeonLevel.WaterTemple:
		case DungeonLevel.Aghanim1:
			break;
		
	}

	
	if(Room.Section_ID != 0) exit;
	
	if(ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)) exit;
	
	if(!Prob(Chance_Decor_Carpets) && !StartingRoom) exit;
	
	var CarpetArray = Room.Template[$ "Carpets"];
	var CarpetCount = array_length(CarpetArray);
	
	var DoorArray = Room.Doors;
	var DoorCount = array_length(DoorArray);
	
	
	if(CarpetCount > 0 && DoorCount >= 2 && _RoomIndex != global.Level.RoomIndex_Entrance){ 		

		//determine if there's at least 1 connection possible based on the doors
		
		var _Matches = 0;

		for(var i = 0; i < DoorCount; i++){
			
			var Door = DoorArray[i];			
			
			if(Door.Status == DoorStatus.Unused || Door.Status == DoorStatus.Secret_Closed || Door.Status == DoorStatus.Secret_Open || Door.Status == DoorStatus.Curtain) continue;
			
			for(var CarpetIndex = 0; CarpetIndex < CarpetCount; CarpetIndex++){
			
				var Carpet = CarpetArray[CarpetIndex];
			
				if(Carpet.gid != TemplateObjGID.Carpet_H && Carpet.gid != TemplateObjGID.Carpet_V) continue;
			
				var _FromDoorList = CSVToList(GetPropertyValue(Carpet.properties, "DoorsFrom"));

				if(ds_list_find_index(_FromDoorList, Door.Position) != -1){
					_Matches++;
					break;
				}
				ds_list_destroy(_FromDoorList);
			
			}
			
			if(_Matches >= 2) break;
			
		}
		
		if(_Matches >= 2){

			var DoorPositionList = ds_list_create();
	
			for(var i = 0; i < DoorCount; i++){
				var Door = DoorArray[i];
				if(Door.Status == DoorStatus.Unused || Door.Status == DoorStatus.Secret_Closed || Door.Status == DoorStatus.Secret_Open || Door.Status == DoorStatus.Curtain) continue;
				ds_list_add(DoorPositionList, Door.Position);
			}
		
			for(var Pass = 0; Pass < 2; Pass++){ //1st pass do H/V carpets, then corners			
		
				for(var CarpetIndex = 0; CarpetIndex < CarpetCount; CarpetIndex++){
		
					var Carpet = CarpetArray[CarpetIndex];
					var CarpetGID = Carpet.gid;
					var CarpetX = Room.x + Carpet.x;
					var CarpetY = Room.y + Carpet.y;
					var CarpetX2 = CarpetX + Carpet.width - 1;
					var CarpetY2 = CarpetY + Carpet.height - 1;
					var CarpetTileW = Carpet.width / 8;
					var CarpetTileH = Carpet.height / 8;
		
					var TMID = GetFloorLevelTMID("Tiles_Floor", CarpetX, CarpetY);
		
					DoorList[1] = CSVToList(GetPropertyValue(Carpet.properties, "DoorsFrom"));
					DoorList[2] = CSVToList(GetPropertyValue(Carpet.properties, "DoorsTo"));
					Doors[1] = ds_list_size(DoorList[1]);
					Doors[2] = ds_list_size(DoorList[2]);
		
					switch(CarpetGID){
					
						case TemplateObjGID.Carpet_H:
						case TemplateObjGID.Carpet_V:
					
							if(Pass != 0) break;
					
							//check if door list 1/2 has door locations that exist. If so, then draw carpet
				
							DoorMatch[1] = false;
							DoorMatch[2] = false;
				
							for(var DoorSetIndex = 1; DoorSetIndex <= 2; DoorSetIndex++){
					
								for(var i = 0; i < Doors[DoorSetIndex]; i++){
									
									var DoorPositionStr = DoorList[DoorSetIndex][| i];
									if(DoorPositionStr == ""){
										continue;
									}
									
									var DoorPosition = real(DoorPositionStr);
					
									//check if door is invalid, if so continue;
									var InvalidDoor = false;
									var RoomDoors = array_length(Room.Doors);
									for(var _RoomDoorIndex = 0; _RoomDoorIndex < RoomDoors; _RoomDoorIndex++){
										var _RoomDoorPosition = DungeonRoom.Doors[_RoomDoorIndex].Position;
										//if(_RoomDoorPosition > 12) continue;
										var _RoomDoorStatus = Room.Doors[_RoomDoorIndex].Status;
										if(_RoomDoorPosition == DoorPosition && Carpet_InvalidDoor(_RoomDoorStatus)){
											InvalidDoor = true;
											break;
										}
									}
									if(InvalidDoor) continue;
					
					
									if(ds_list_find_index(DoorPositionList, DoorPosition) != -1){
										DoorMatch[DoorSetIndex] = true;
										break;
									}
								}
					
							}

							if(DoorMatch[1] && DoorMatch[2]){
								if(CarpetGID == TemplateObjGID.Carpet_H)
									Carpet_Draw_H(CarpetX, CarpetY, CarpetTileW, CarpetTileH, TMID);
								else
									Carpet_Draw_V(CarpetX, CarpetY, CarpetTileW, CarpetTileH, TMID);
					
								global.SpawnedCarpets = true;
								global.SpawnedCarpetStyle = CarpetStyle.Path;
					
							}
				
					
							break;
			
						default:
					
							if(Pass != 1) break;
					
							var Top = false;
							var Bottom = false;
							var Left = false;
							var Right = false;
				
							//check top of carpet
							switch(CarpetGID){
								case TemplateObjGID.Carpet_TL:
								case TemplateObjGID.Carpet_TR:
								case TemplateObjGID.Carpet_TLR:
								case TemplateObjGID.Carpet_TBL:
								case TemplateObjGID.Carpet_TBR:
								case TemplateObjGID.Carpet_TBLR:
									var DoorInstAbove = collision_rectangle(CarpetX, CarpetY - 24, CarpetX2, CarpetY, oDoor, false, true);
									if(DoorInstAbove != noone){
										if(Carpet_InvalidDoor(DoorInstAbove.Status)) break;
									}
									var TileAbove = tilemap_get_at_pixel(TMID, CarpetX, CarpetY - 4);							
									if(TileAbove == global.CarpetTileTrim || DoorInstAbove != noone) Top = true;
									break;
							}
				
							//check below carpet
							switch(CarpetGID){
								case TemplateObjGID.Carpet_BL:
								case TemplateObjGID.Carpet_BR:
								case TemplateObjGID.Carpet_BLR:
								case TemplateObjGID.Carpet_TBL:
								case TemplateObjGID.Carpet_TBR:
								case TemplateObjGID.Carpet_TBLR:
									var DoorInstBelow = collision_rectangle(CarpetX, CarpetY2, CarpetX2, CarpetY2 + 24, oDoor, false, true);
									if(DoorInstBelow != noone){
										if(Carpet_InvalidDoor(DoorInstBelow.Status)) break;
									}
									var TileBelow = tilemap_get_at_pixel(TMID, CarpetX, CarpetY2 + 4);							
									if(TileBelow == global.CarpetTileTrim || DoorInstBelow != noone) Bottom = true;
									break;
							}
				
							//check left of carpet
							switch(CarpetGID){
								case TemplateObjGID.Carpet_TL:
								case TemplateObjGID.Carpet_BL:
								case TemplateObjGID.Carpet_TLR:
								case TemplateObjGID.Carpet_BLR:
								case TemplateObjGID.Carpet_TBL:
								case TemplateObjGID.Carpet_TBLR:
									var DoorInstLeft = collision_rectangle(CarpetX - 24, CarpetY, CarpetX, CarpetY2, oDoor, false, true);
									if(DoorInstLeft != noone){
										if(Carpet_InvalidDoor(DoorInstLeft.Status)) break;
									}
									var TileLeft = tilemap_get_at_pixel(TMID, CarpetX - 4, CarpetY);
									if(TileLeft == global.CarpetTileTrim || DoorInstLeft != noone) Left = true;
									break;
							}
				
							//check right of carpet
							switch(CarpetGID){
								case TemplateObjGID.Carpet_TR:
								case TemplateObjGID.Carpet_BR:
								case TemplateObjGID.Carpet_TLR:
								case TemplateObjGID.Carpet_BLR:
								case TemplateObjGID.Carpet_TBR:
								case TemplateObjGID.Carpet_TBLR:
									var DoorInstRight = collision_rectangle(CarpetX2, CarpetY, CarpetX2 + 24, CarpetY2, oDoor, false, true);
									if(DoorInstRight != noone){
										if(Carpet_InvalidDoor(DoorInstRight.Status)) break;
									}
									var TileRight = tilemap_get_at_pixel(TMID, CarpetX2 + 4, CarpetY);
									if(TileRight == global.CarpetTileTrim || DoorInstRight != noone) Right = true;
									break;
							}
				
							if(Top || Bottom || Left || Right){
								Carpet_Draw_Corner(CarpetX, CarpetY, TMID, Top, Bottom, Left, Right);
								global.SpawnedCarpets = true;
								global.SpawnedCarpetStyle = CarpetStyle.Path;
							}
				
							break;

					}

					ds_list_destroy(DoorList[1]);
					ds_list_destroy(DoorList[2]);
	
				}
			}
			
			ds_list_destroy(DoorPositionList);
			
		}		
		
		if(global.SpawnedCarpets) exit;
	
	}

}

function Dungeon_Draw_CarpetsFull(_RoomIndex){

	if(global.SpawnedCarpets || !variable_struct_exists(Room.Template, "CarpetsFull")) exit;
	
	if(Room.Section_ID != 0) exit;
	
	if(global.Level.Index != DungeonLevel.Castle && global.Level.Index != DungeonLevel.WaterTemple) exit;
	
	var FullCarpets = Prob(Chance_Decor_CarpetsFull) || Room.GridW == 2 || Room.GridH == 2;
	
	var CarpetX, CarpetY, CarpetTileW, CarpetTileH;
	if(FullCarpets){

		var CarpetArray = Room.Template[$ "CarpetsFull"];
		var CarpetCount = array_length(CarpetArray);
		if(CarpetCount == 0) exit;
	
		var FullCarpetList = ds_list_create_sequence_shuffled(0, CarpetCount - 1);
				
		var Carpet = CarpetArray[FullCarpetList[| 0]];
			
		CarpetX = Room.x + Carpet.x;
		CarpetY = Room.y + Carpet.y;
		CarpetTileW = Carpet.width / 8;
		CarpetTileH = Carpet.height / 8;
		
		var TMID = GetFloorLevelTMID("Tiles_Floor", CarpetX, CarpetY);	

		//expand carpet as much as possible
		var _X1 = CarpetX;
		var _Y1 = CarpetY;
		var _X2 = _X1 + Carpet.width - 1;
		var _Y2 = _Y1 + Carpet.height - 1;		
				
		while(1){
			if(collision_rectangle(_X1, _Y1, _X2, _Y2, oWall, false, true) != noone){
				_X1 += 16;
				break;
			}else{
				_X1 -= 8;
			}
		}
		while(1){
			if(collision_rectangle(_X1, _Y1, _X2, _Y2, oWall, false, true) != noone){
				_X2 -= 16;
				break;
			}else{
				_X2 += 8;
			}
		}
		while(1){
			if(collision_rectangle(_X1, _Y1, _X2, _Y2, oWall, false, true) != noone){
				_Y1 += 16;
				break;
			}else{
				_Y1 -= 8;
			}
		}
		while(1){
			if(collision_rectangle(_X1, _Y1, _X2, _Y2, oWall, false, true) != noone){
				_Y2 -= 16;
				break;
			}else{
				_Y2 += 8;
			}
		}

		CarpetX = _X1;
		CarpetY = _Y1;
		CarpetTileW = (_X2 - _X1 + 1) / 8;
		CarpetTileH = (_Y2 - _Y1 + 1) / 8;

		if(CarpetTileW >= 10 && CarpetTileH >= 10){
			Carpet_Draw_Full(CarpetX, CarpetY, CarpetTileW, CarpetTileH, TMID);
			global.SpawnedCarpets = true;
			global.SpawnedCarpetStyle = CarpetStyle.Full;
		}
		
		ds_list_destroy(FullCarpetList);		
			
		
	}	
	
}

function Carpet_InvalidDoor(_DoorStatus){
	return (_DoorStatus == DoorStatus.Secret_Closed || _DoorStatus == DoorStatus.Secret_Open || (global.Level.Index == DungeonLevel.Castle && _DoorStatus == DoorStatus.Entrance))		
}

function Carpet_Draw_H(_CornerX, _CornerY, _TileW, _TileH, _TMID){

	for(var _y = 0; _y < _TileH; _y++){
		for(var _x = 0; _x < _TileW; _x++){
			var _TileX = _CornerX + (_x * 8);
			var _TileY = _CornerY + (_y * 8);
			tilemap_set_at_pixel(_TMID, global.CarpetTileBase, _TileX, _TileY);
			if(_y == 0 || _y == _TileH - 1) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
		}
	}	
}


function Carpet_Draw_V(_CornerX, _CornerY, _TileW, _TileH, _TMID){
	
	for(var _y = 0; _y < _TileH; _y++){
		for(var _x = 0; _x < _TileW; _x++){
			var _TileX = _CornerX + (_x * 8);
			var _TileY = _CornerY + (_y * 8);
			tilemap_set_at_pixel(_TMID, global.CarpetTileBase, _TileX, _TileY);
			if(_x == 0 || _x == _TileW - 1) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
		}
	}	
}

function Carpet_Draw_Full(_CornerX, _CornerY, _TileW, _TileH, _TMID){
	
	for(var _y = 0; _y < _TileH; _y++){
		for(var _x = 0; _x < _TileW; _x++){
			var _TileX = _CornerX + (_x * 8);
			var _TileY = _CornerY + (_y * 8);
			tilemap_set_at_pixel(_TMID, global.CarpetTileBase, _TileX, _TileY);
			if(_x == 0 || _x == _TileW - 1 || _y == 0 || _y == _TileH - 1) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
		}
	}	
}

function Carpet_Draw_Corner(_CornerX, _CornerY, _TMID, _Top, _Bottom, _Left, _Right){
		
	for(var _y = 0; _y < 6; _y++){
		for(var _x = 0; _x < 6; _x++){
			
			var _TileX = _CornerX + (_x * 8);
			var _TileY = _CornerY + (_y * 8);
			
			tilemap_set_at_pixel(_TMID, global.CarpetTileBase, _TileX, _TileY);
			
			//corners
			if((_x == 0 && _y == 0) || (_x == 5 && _y == 0) || (_x == 0 && _y == 5) || (_x == 5 && _y == 5)) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
			
			//sides
			if(!_Top && _x > 0 && _x < 5 && _y == 0) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
			if(!_Bottom && _x > 0 && _x < 5 && _y == 5) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
			if(!_Left && _x == 0 && _y > 0 && _y < 5) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
			if(!_Right && _x == 5 && _y > 0 && _y < 5) tilemap_set_at_pixel(_TMID, global.CarpetTileTrim, _TileX, _TileY);
			
		}
	}

}


function CornersOnCarpet(_TMID, _x1, _y1, _x2, _y2){
	
	var Corners = 0;
	var TileTL = tilemap_get_at_pixel(_TMID, _x1, _y1);
	var TileTR = tilemap_get_at_pixel(_TMID, _x2, _y1);
	var TileBL = tilemap_get_at_pixel(_TMID, _x1, _y2);
	var TileBR = tilemap_get_at_pixel(_TMID, _x2, _y2);
	var TileMid= tilemap_get_at_pixel(_TMID, _x1 + round((_x2 - _x1) / 2), _y1 + round((_y2 - _y1) / 2));
	
	if(TileTL == global.CarpetTileBase || TileTL == global.CarpetTileTrim) Corners++;
	if(TileTR == global.CarpetTileBase || TileTR == global.CarpetTileTrim) Corners++;
	if(TileBL == global.CarpetTileBase || TileBL == global.CarpetTileTrim) Corners++;	
	if(TileBR == global.CarpetTileBase || TileBR == global.CarpetTileTrim) Corners++;	
	if(TileMid == global.CarpetTileBase || TileMid == global.CarpetTileTrim) Corners++;	
	
	return Corners;
	
	
}