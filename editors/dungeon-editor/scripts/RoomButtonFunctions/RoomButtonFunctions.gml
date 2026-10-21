
function RoomButton_Create(_RoomIndex, _GridX, _GridY, _GridW, _GridH){

	var Xpos = oDungeonGrid.x + (_GridX * global.RoomButtonW);
	var YPos = oDungeonGrid.y + (_GridY * global.RoomButtonW);		
	var ButtonInst = CreateButton(Xpos, YPos, false, _GridW * global.RoomButtonW, _GridH * global.RoomButtonW);
	ButtonInst.Color = make_color_rgb(40,40,40);
	ButtonInst.mask_index = asset_get_index("sGridRoom_" + string(_GridW) + "x" + string(_GridH) + "_Mask");
	var Rooms = array_length(oDungeonGrid.RoomButtons);
	array_insert(oDungeonGrid.RoomButtons, Rooms, new init_RoomButton(ButtonInst, _RoomIndex, _GridX, _GridY, _GridW, _GridH));
	
}


function RoomButton_AddRoom(RoomIndex, NewRoom, ButtonGridX, ButtonGridY, RoomGridW, RoomGridH){
	
	var RoomArray = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms;
	var Rooms = array_length(RoomArray);
	var ButtonIndex = GetRoomButtonIndex_FromGrid(ButtonGridX, ButtonGridY);
	
	if(NewRoom) array_insert(RoomArray, Rooms, new init_DungeonRoom(ButtonGridX, ButtonGridY, RoomGridW, RoomGridH));

	//delete any buttons that overlap new resized button
	if(RoomGridW != 1 || RoomGridH != 1){			
		var DeleteButtons = ds_list_create();
		for(var i = 0; i < array_length(oDungeonGrid.RoomButtons); i++){
			var B2x = oDungeonGrid.RoomButtons[i].GridX;
			var B2y = oDungeonGrid.RoomButtons[i].GridY;
			if(point_in_rectangle(B2x, B2y, ButtonGridX, ButtonGridY, ButtonGridX + RoomGridW - 1, ButtonGridY + RoomGridH - 1)) ds_list_add(DeleteButtons, i);						
		}
		for(var B = 0; B < ds_list_size(DeleteButtons); B++)
			RoomButton_Delete(DeleteButtons[| B] - B)

		ds_list_destroy(DeleteButtons);
				
		//Create new button
		RoomButton_Create(RoomIndex, ButtonGridX, ButtonGridY, RoomGridW, RoomGridH);			

	}else{
		oDungeonGrid.RoomButtons[ButtonIndex].RoomIndex = RoomIndex;
				
	}
			
}


function RoomButtons_GridCreate(){

	//destroy all existing buttons first
	var RoomButtons = array_length(oDungeonGrid.RoomButtons);
	for(var i = 0; i < RoomButtons; i++){
		RoomButton_Delete(0)
		
	}
	oDungeonGrid.RoomButtons = 0;
	oDungeonGrid.RoomButtons = array_create(0);
	
	//create new grid
	for(var GridY = 0; GridY < DungeonGridMax; GridY++){
		for(var GridX = 0; GridX < DungeonGridMax; GridX++){
			RoomButton_Create(-1, GridX, GridY, 1, 1);
		}
	}
	
}

function RoomButtons_LoadFromDungeon(){
	
	RoomButtons_GridCreate();
	
	//load room buttons
	var Rooms = array_length(global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms);
	for(var RoomIndex = 0; RoomIndex < Rooms; RoomIndex++){
		var GridX = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridX;
		var GridY = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridY;
		var GridW = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridW;
		var GridH = global.Data_Dungeons[global.DungeonClass][global.DungeonIndex].Rooms[RoomIndex].GridH;
		RoomButton_AddRoom(RoomIndex, false, GridX, GridY, GridW, GridH);
		
	}
	
	global.ActiveRoom = 0;
	
	RoomButton_Activate();

}

function RoomButton_Delete(_ButtonIndex){
	
	instance_destroy(oDungeonGrid.RoomButtons[_ButtonIndex].ButtonInst);
	delete oDungeonGrid.RoomButtons[_ButtonIndex];
	array_delete(oDungeonGrid.RoomButtons, _ButtonIndex, 1);	
	
}

function RoomButton_Activate(){
	
	oDungeonRoom.SelectedDoor = noone;
	
	Doors_Refresh();
	
	global.SectionActive = false;
	
	SectionButtonsRefresh();
	
}

function GetRoomButtonIndex_FromRoomIndex(_RoomIndex){
	
	var RoomButtons = array_length(oDungeonGrid.RoomButtons);	 
	for(var ButtonIndex = 0; ButtonIndex < RoomButtons; ButtonIndex++){
	
		var Button = oDungeonGrid.RoomButtons[ButtonIndex];
		
		if(Button.RoomIndex == _RoomIndex)	return ButtonIndex;
				
	}
	
	return -1;
	
}

function GetRoomButtonIndex_FromGrid(_GridX, _GridY){
	
	var RoomButtons = array_length(oDungeonGrid.RoomButtons);	 
	for(var ButtonIndex = 0; ButtonIndex < RoomButtons; ButtonIndex++){
		var Button = oDungeonGrid.RoomButtons[ButtonIndex];
		if(Button.GridX == _GridX && Button.GridY == _GridY) return ButtonIndex;
				
	}
	
	return -1;
	
}

function GetRoomButtonIndex_FromButtonInst(_ButtonInst){
	
	var RoomButtons = array_length(oDungeonGrid.RoomButtons)	;	 
	for(var ButtonIndex = 0; ButtonIndex < RoomButtons; ButtonIndex++){
	
		var Button = oDungeonGrid.RoomButtons[ButtonIndex];
		
		if(Button.ButtonInst == _ButtonInst) return ButtonIndex;
				
	}
	
	return -1;
	
}