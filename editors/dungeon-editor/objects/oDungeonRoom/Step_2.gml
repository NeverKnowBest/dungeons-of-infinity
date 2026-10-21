
var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms;
if(array_length(RoomArray) == 0){
	chkLowerFloor.visible = false;
	exit;
}else{
	chkLowerFloor.visible = true;
}

var DoorArray = RoomArray[global.ActiveRoom].Doors;
var Rooms = array_length(RoomArray);
var Doors = array_length(DoorArray);
			
var ActiveRoomGridX = RoomArray[global.ActiveRoom].GridX;
var ActiveRoomGridY = RoomArray[global.ActiveRoom].GridY;		
var ActiveRoomGridW = RoomArray[global.ActiveRoom].GridW;
var ActiveRoomGridH = RoomArray[global.ActiveRoom].GridH;


sprite_index = asset_get_index("sRoom_" + string(ActiveRoomGridW) + "x" + string(ActiveRoomGridH) + "_Upper");
	

chkLowerFloor.y = y + sprite_height + 8;
//btnEntrance.y = y + sprite_height + 8;

with(oRoom_Door){

	
	if(Position > 12 && !oDungeonRoom.chkLowerFloor.ChkStatus) continue;
	
	//if(Position == 6 && global.ActiveRoom == global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].EntranceRoomIndex) continue;
	
	if(ClickedL || ClickedR){
		
		//Collect data before executing actions
		
		
		//check surrounding rooms and get their sizes so we can figure out which door position this door is next to
		
		var ActiveRoomButtonIndex = GetRoomButtonIndex_FromRoomIndex(global.ActiveRoom);
		var ActiveRoomButton = oDungeonGrid.RoomButtons[ActiveRoomButtonIndex];
		
		//Coordinates of the small doors on the room button
		var ActiveRoomButton_DoorX = global.DoorCoordinates[RoomSizeIndex(ActiveRoomButton.GridW, ActiveRoomButton.GridH)][Position].x / 4;
		var ActiveRoomButton_DoorY = global.DoorCoordinates[RoomSizeIndex(ActiveRoomButton.GridW, ActiveRoomButton.GridH)][Position].y / 4;
		
		var DoorTypes = 5;
		
		switch(Position){
			
			case 1: case 11: case 12: case 13: case 23: case 24:
				//check Up
				var ConnectedRoomButtonInst = instance_position(ActiveRoomButton.ButtonInst.x + ActiveRoomButton_DoorX, ActiveRoomButton.ButtonInst.y + ActiveRoomButton_DoorY - 16, oButton);
				break;

			case 5: case 6: case 7: case 17: case 18: case 19:
				//check Down
				var ConnectedRoomButtonInst = instance_position(ActiveRoomButton.ButtonInst.x + ActiveRoomButton_DoorX, ActiveRoomButton.ButtonInst.y + ActiveRoomButton_DoorY + 16, oButton);
				break;

			case 8: case 9: case 10: case 20: case 21: case 22:
				//check Left
				var ConnectedRoomButtonInst = instance_position(ActiveRoomButton.ButtonInst.x + ActiveRoomButton_DoorX - 16, ActiveRoomButton.ButtonInst.y + ActiveRoomButton_DoorY, oButton);
				break;

			case 2: case 3: case 4: case 14: case 15: case 16:
				//check Right
				var ConnectedRoomButtonInst = instance_position(ActiveRoomButton.ButtonInst.x + ActiveRoomButton_DoorX + 16, ActiveRoomButton.ButtonInst.y + ActiveRoomButton_DoorY, oButton);
				break;
				
		}
		
		
		var ConnectedRoomButtonIndex = GetRoomButtonIndex_FromButtonInst(ConnectedRoomButtonInst);
		var ConnectedRoomIndex = -1;
		var ConnectedDoorPos = -1;
		if(ConnectedRoomButtonIndex != -1){
			
			var ConnectedRoomButton = oDungeonGrid.RoomButtons[ConnectedRoomButtonIndex];
		
			var ActiveRoomSize = string(ActiveRoomButton.GridW) + "x" + string(ActiveRoomButton.GridH);
			var ConnectedRoomSize = string(ConnectedRoomButton.GridW) + "x" + string(ConnectedRoomButton.GridH);
		
			ConnectedDoorPos = GetConnectedDoorPos(ActiveRoomButton.GridX, ActiveRoomButton.GridY, ActiveRoomSize, ConnectedRoomButton.GridX, ConnectedRoomButton.GridY, ConnectedRoomSize, Position);
		
			if(ConnectedDoorPos == -1) continue; //Door can't be connected
		
			ConnectedRoomIndex = GetRoomIndex(ConnectedRoomButton.GridX, ConnectedRoomButton.GridY);
			
		}
		
	}
	
	//execute mouse actions
	if(ClickedL){ 

		if(other.SelectedDoor == id){
			other.SelectedDoor.Status = (other.SelectedDoor.Status + 1) mod DoorTypes;
			DoorArray = RoomArray[global.ActiveRoom].Doors;
			DoorArray[GetDoorIndex(global.ActiveRoom, other.SelectedDoor.Position)].Status = other.SelectedDoor.Status;

		}
		
		other.SelectedDoor = id;
		

		if(!Enabled){ 
			
			Enabled = true;
			
			if(Position > 12) ActiveRoomButton.LowerFloor = true;
			
			var RSI_A = RoomSizeIndex(ActiveRoomButton.GridW, ActiveRoomButton.GridH); 
			
			if(ConnectedRoomButtonIndex != -1 && !keyboard_check(vk_control)){ //If there's no adjacent room button, or control is held, then don't create an adjacent room
				
				var RSI_C = RoomSizeIndex(ConnectedRoomButton.GridW, ConnectedRoomButton.GridH); 
				
				if(ConnectedRoomIndex == -1){
					//no adjacent room found and there's a button at that position, so create a room so we can put adjacent door
					var RoomIndex = Rooms;
					array_insert(RoomArray, RoomIndex, new init_DungeonRoom(ConnectedRoomButton.GridX, ConnectedRoomButton.GridY, ConnectedRoomButton.GridW, ConnectedRoomButton.GridH));
					array_insert(RoomArray[RoomIndex].Doors, 0, new init_Door(RSI_C, ConnectedDoorPos, global.ActiveRoom, other.SelectedDoor.Position)); 
					ConnectedRoomIndex = RoomIndex;
					ConnectedRoomButton.RoomIndex = ConnectedRoomIndex;
					var Rooms = array_length(RoomArray);
					if(ConnectedDoorPos > 12) ConnectedRoomButton.LowerFloor = true;
				}else{
					//check to see if there's already a door at the connected door position. If so, don't add door
					var AddConnectedDoor = true;
					var ConnectedDoorArray = RoomArray[ConnectedRoomIndex].Doors;
					for(var DoorIndex = 0; DoorIndex < array_length(ConnectedDoorArray); DoorIndex++){
						var _Door = ConnectedDoorArray[DoorIndex];
						if(_Door.Position == ConnectedDoorPos){
							_Door.ConnectedRoomIndex = global.ActiveRoom;
							AddConnectedDoor = false;
							break;
						}
					}
					if(AddConnectedDoor) array_insert(RoomArray[ConnectedRoomIndex].Doors, 0, new init_Door(RSI_C, ConnectedDoorPos, global.ActiveRoom, other.SelectedDoor.Position)); 
						
				}
			}
			
			Doors = array_length(DoorArray);
			array_insert(DoorArray, Doors, new init_Door(RSI_A, Position, ConnectedRoomIndex, ConnectedDoorPos)); 

		}

		Doors_Refresh();
		
	}
	
	if(ClickedR && Enabled){
			
		//delete door
		Enabled = false;
		other.SelectedDoor = noone;
		var DIndex = GetDoorIndex(global.ActiveRoom, Position);
		if(DIndex != -1) array_delete(DoorArray, DIndex, 1);
		

		if(ConnectedRoomIndex != -1){
			var DIndex = GetDoorIndex(ConnectedRoomIndex, ConnectedDoorPos);
			if(DIndex != -1) array_delete(RoomArray[ConnectedRoomIndex].Doors, DIndex, 1);
		
		}
		
		Doors_Refresh();
		
	}	
}

//Entrance button
//if(SelectedDoor != noone)
//	btnEntrance.visible = (SelectedDoor.Position == 6);
//else
//	btnEntrance.visible = false;

//if(btnEntrance.ClickedL) global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].EntranceRoomIndex = global.ActiveRoom;




