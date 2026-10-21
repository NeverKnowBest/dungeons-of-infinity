function RoomSizeIndex(_GridW, _GridH){
	if(_GridW == 1 && _GridH == 1) return RoomSize._1x1;	
	if(_GridW == 1 && _GridH == 2) return RoomSize._1x2;	
	if(_GridW == 2 && _GridH == 1) return RoomSize._2x1;	
	if(_GridW == 2 && _GridH == 2) return RoomSize._2x2;	
}


function GetRoomIndex(_GridX, _GridY){

	var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms;
	var Rooms = array_length(RoomArray);
	
	for(var RoomIndex = 0; RoomIndex < Rooms; RoomIndex++){
			
		var RoomGridX = RoomArray[RoomIndex].GridX;
		var RoomGridY = RoomArray[RoomIndex].GridY;
			
		if(RoomGridX == _GridX && RoomGridY == _GridY) return RoomIndex;
				
	}
	
	return -1;
	
}

function GetDoorIndex(_RoomIndex, _Position){
	
	var DoorArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[_RoomIndex].Doors;
	var Doors = array_length(DoorArray);
	
	for(var DoorIndex = 0; DoorIndex < Doors; DoorIndex++){
		var Pos = DoorArray[DoorIndex].Position;
		if(Pos == _Position) return DoorIndex				
	}
	return -1;
}



function Doors_Refresh(){
	
	var Rooms = array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms);
	if(Rooms > 0 ){
		
		var Room = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[global.ActiveRoom];
		var _RoomSize = RoomSizeIndex(Room.GridW, Room.GridH);
	
		with(oRoom_Door){
			Enabled = false;
			Status = 0;
			x = oDungeonRoom.x + global.DoorCoordinates[_RoomSize][Position].x - 16;
			y = oDungeonRoom.y + global.DoorCoordinates[_RoomSize][Position].y - 16;
		}
		
	
		var DoorArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[global.ActiveRoom].Doors;
		var Doors = array_length(DoorArray);
		for(var DoorIndex = 0; DoorIndex < Doors; DoorIndex++){
			var Pos = DoorArray[DoorIndex].Position;
			if(Pos == global.DoorInstances[Pos].Position){
				global.DoorInstances[Pos].Enabled = true;
				global.DoorInstances[Pos].Status = DoorArray[DoorIndex].Status;
			}
						
		}
		
	}else{
		with(oRoom_Door){
			Enabled = false;
			Status = 0;
		}		
	}
		
}



function ToggleActiveSectionButtons(State, SwitchBlocks){

	oDungeonGrid.btnSection_Rail.visible = State && SwitchBlocks;
	for(var i = 0; i < 2; i++)
		oDungeonGrid.btnSection_SwitchBlock[i].visible = SwitchBlocks;
	oDungeonGrid.btnSection_Delete.visible = State;
	
}

function SectionButtonsRefresh(){
	
	if(array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"]) == 0) exit;
	
	var OnColor = make_color_rgb(30, 100, 30);
	var OffColor = make_color_rgb(30, 60, 120);		
	
	var ActiveRoomSection = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex][$ "Rooms"][global.ActiveRoom][$ "Section_ID"];

	var Room = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[global.ActiveRoom];
	var _RoomSize = RoomSizeIndex(Room.GridW, Room.GridH);
		
	for(var i = 1; i <= 30; i++){
		
		oDungeonGrid.btnSection[i].visible = false;
		
		if(global.DungeonClass != DungeonClass.Special){
			switch(_RoomSize){
				case RoomSize._1x1:
					oDungeonGrid.btnSection[i].visible = true;
					break;
			
				case RoomSize._1x2:
					if(i <= 3 || (i >= 6 && i <= 12) || i == 17 || i == 18){
						oDungeonGrid.btnSection[i].visible = true;
					}
					break;
				
				case RoomSize._2x1:
					if(i == 1 || (i >= 3 && i <= 6) || i == 8 || (i >= 13 && i <= 16) || i == 19 || i == 20){
						oDungeonGrid.btnSection[i].visible = true;
					}
					break;
			}
		}
		
		if(i == ActiveRoomSection){

			oDungeonGrid.btnSection[i].Sprite = sButtons_RoomSections_On;
			oDungeonGrid.btnSection[i].Color = (global.SectionActive ? OnColor : OffColor);

		}else{
			oDungeonGrid.btnSection[i].Sprite = sButtons_RoomSections_Off;
			oDungeonGrid.btnSection[i].Color = OffColor	
			
		}
	}	
	
	ToggleActiveSectionButtons(global.SectionActive && ActiveRoomSection > 0, global.SectionActive && ActiveRoomSection > 0 && ActiveRoomSection < 25);

}


function DungeonObjRefresh(){

	btnSection_Key.visible = false;
	btnSection_Crystal.visible = false;
	btnSection_DoorSwitch.visible = false;
	btnSection_EnemyTrap.visible = false;
	btnSection_Warp.visible = false;
	btnSection_SpecialRoom.visible = false;
	btnSection_Boss.visible = false;
	btnSection_House.visible = false;
	btnSection_Jail.visible = false;
	btnSection_JailKey.visible = false;			
	btnRoom[2][2].visible = true;
	
	switch(global.DungeonClass){
		case DungeonClass.Castle:
			btnSection_Key.visible = true;
			btnSection_SpecialRoom.visible = true;
			break;
			
		case DungeonClass.CastleBasement:
			btnSection_Key.visible = true;
			btnSection_DoorSwitch.visible = true;
			btnSection_SpecialRoom.visible = true;
			break;
		case DungeonClass.CastleJails:
			btnSection_Key.visible = true;
			btnSection_DoorSwitch.visible = true;
			btnSection_EnemyTrap.visible = true;
			btnSection_SpecialRoom.visible = true;
			btnSection_Boss.visible = true;
			btnSection_Jail.visible = true;
			btnSection_JailKey.visible = true;
			break;
		case DungeonClass.CatacombsSewers:
			btnSection_Key.visible = true;
			btnSection_Crystal.visible = true;
			btnSection_DoorSwitch.visible = true;
			btnSection_EnemyTrap.visible = true;
			btnSection_SpecialRoom.visible = true;
			break;
		case DungeonClass.BossesRuins:
			btnSection_Key.visible = true;
			btnSection_Crystal.visible = true;
			btnSection_DoorSwitch.visible = true;
			btnSection_EnemyTrap.visible = true;
			btnSection_Warp.visible = true;
			btnSection_SpecialRoom.visible = true;
			btnSection_Boss.visible = true;
			break;
		case DungeonClass.Aghanim:
			btnSection_Key.visible = true;
			btnSection_Crystal.visible = true;
			btnSection_DoorSwitch.visible = true;
			btnSection_EnemyTrap.visible = true;
			btnSection_Warp.visible = true;
			btnSection_SpecialRoom.visible = true;
			break;
		case DungeonClass.Special:
			btnSection_SpecialRoom.visible = true;
			btnSection_House.visible = true;
			btnRoom[2][2].visible = true;
			break;
		
	}
}

function GetConnectedDoorPos(ARGridX, ARGridY, ARSize, CRGridX, CRGridY, CRSize, ARDoorPos){
	
	//AR = Active Room
	//CR = Connected Room
	
	var A = (ARDoorPos > 12 ? 12 : 0); //A stands for 'Add 12'
	
	switch(ARSize){
		case "1x1":
			
			switch(CRSize){
				case "1x1":
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case "1x2":
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case "2x1":

					switch(ARDoorPos){
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case "2x2":
				
					switch(ARDoorPos){
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
				
			break;
		
		case "1x2":

			switch(CRSize){
				case "1x1":
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case "1x2":
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case "2x1":

					switch(ARDoorPos){
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case "2x2":
				
					switch(ARDoorPos){
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
			
		case "2x1":

			switch(CRSize){
				case "1x1":
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case "1x2":
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 12 + A;;
						case 7: case 19: return 12 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case "2x1":

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case "2x2":
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
		case "2x2":

			switch(CRSize){
				case "1x1":
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case "1x2":
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15:  if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case "2x1":

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
						
				case "2x2":
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
	}
		
	
}