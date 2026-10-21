//#macro Room global.Dungeon[$ "Rooms"][global.RoomIndex]

enum DungeonLevel{
	Start = -1,
	Castle,
	CastleBasement,
	CastleJails,
	Catacombs,
	Sewers,
	Village,
	LanmolasLair,
	Ruins1,
	Ruins2,
	Ruins3,
	MoldormsLair,
	Aghanim1,
	Aghanim2,
	Aghanim3,
	Aghanim4	
}

function Dungeon_BossLevel(_Level){
	return (_Level == DungeonLevel.CastleJails || _Level == DungeonLevel.LanmolasLair || _Level == DungeonLevel.MoldormsLair || _Level == DungeonLevel.Aghanim4)
}


function Dungeon_Init(){

	
	Dungeon_Clear();

	//global.DungeonDepth = 0; //temp, for testing
	//var SetDepth = choose(0,1,2,3,4,6,7,8,9,10,11,12,13);
	
	var SetDepth = DungeonLevel.Castle;
	if(global.DungeonDepth < SetDepth) global.DungeonDepth = SetDepth; //temp, to force a depth	
	
	global.EvenDungeon = (global.DungeonDepth mod 2 == 0 || global.DungeonDepth == DungeonLevel.Start);
	global.BossLevel = Dungeon_BossLevel(global.DungeonDepth);
	
	
	switch(global.DungeonDepth){
		default:
			global.DungeonNo = choose(3,4,5,7,8,9,10,11,12,13,14,15,16,17);
			break;
		case DungeonLevel.Start:
			global.DungeonNo = 0;
			break;
		case DungeonLevel.Village:
			global.DungeonNo = 2;
			break;
		
	}
	
	//choose no flip, H, V or HV based on dungeon level
	if(global.DungeonDepth == DungeonLevel.Village){
		global.Dungeon = global.Dungeons_FlippedV[global.DungeonNo]
	}else{
		if(global.EvenDungeon){
			global.Dungeon = FlipCoin_Bool() ? global.Dungeons[global.DungeonNo]: global.Dungeons_FlippedH[global.DungeonNo];
		}else{
			global.Dungeon = FlipCoin_Bool() ? global.Dungeons_FlippedV[global.DungeonNo]: global.Dungeons_FlippedHV[global.DungeonNo]	
		}
		
	}
	global.EntranceRoomIndex = global.Dungeon[$ "EntranceRoomIndex"];
	global.EntranceRoom = global.Dungeon[$ "Rooms"][global.EntranceRoomIndex];
	
	global.RoomCount = array_length(global.Dungeon[$ "Rooms"]);
	
	global.Theme_Pots = (global.DungeonDepth == 3 || global.DungeonDepth == 6 || global.DungeonDepth == 10 || global.DungeonDepth == 13) ? 1 : 0;
	
	global.SwitchBlockColors = 0; 
	global.SwitchBlockLoweredColor = 0; 	
	
	global.BossRoomIndex = -1;
	global.BossRoomAdjacentIndex = -1;
	
	global.Dungeon_VisitedRooms = 0; global.Dungeon_VisitedRooms = array_create(global.RoomCount, false);
	global.Dungeon_SecretRooms = 0;	global.Dungeon_SecretRooms = array_create(global.RoomCount, -1);
	global.Dungeon_SpecialRooms = 0; global.Dungeon_SpecialRooms = array_create(global.RoomCount, -1);
	global.Dungeon_HouseRooms = 0; global.Dungeon_HouseRooms = array_create(global.RoomCount, false);
	global.Dungeon_Shop_ExistsInRoom = 0; global.Dungeon_Shop_ExistsInRoom = array_create(global.RoomCount, false);
	global.Dungeon_Shop_Type = 0; global.Dungeon_Shop_Type = array_create(global.RoomCount, ShopTypes.Various);
	
	//pre-set all room indexes in global.DungeonGrid_RoomIndex
	for(var RoomIndex = 0; RoomIndex < global.RoomCount; RoomIndex++){
		
		var _Room = global.Dungeon[$ "Rooms"][RoomIndex];
		global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY] = RoomIndex;
		if(_Room.GridW == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY] = RoomIndex;
		if(_Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY + 1] = RoomIndex;
		if(_Room.GridW == 2 && _Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY + 1] = RoomIndex;
		
		//also set the boss room index while we're in this loop
		if(_Room[$ "SpecialObj"] == SpecialDungeonObj.Boss) global.BossRoomIndex = RoomIndex;

	}
	
	//Determine adjacent boss room
	for(var RoomIndex = 0; RoomIndex < global.RoomCount; RoomIndex++){
		var _Room = global.Dungeon[$ "Rooms"][RoomIndex];
		var DoorCount = array_length(_Room.Doors);
		for(var DoorIndex = 0; DoorIndex < DoorCount; DoorIndex++){	
			var _Door = _Room.Doors[DoorIndex];
			if(_Door.ConnectedRoomIndex == global.BossRoomIndex){
				global.BossRoomAdjacentIndex = RoomIndex;
				break;
			}
		}
		if(global.BossRoomAdjacentIndex != -1) break;
	}
	
	//reset all door statuses to open if they're already set to secret. If not the ones that were set to secret last time would still be set that way
	for(var RoomIndex = 0; RoomIndex < global.RoomCount; RoomIndex++){
		var _Room = global.Dungeon[$ "Rooms"][RoomIndex];
		var DoorCount = array_length(_Room.Doors);
		for(var DoorIndex = 0; DoorIndex < DoorCount; DoorIndex++){	
			var _Door = _Room.Doors[DoorIndex];
			if(_Door.Status == DoorStatus.Secret_Closed || _Door.Status == DoorStatus.Secret_Open)
				_Door.Status = DoorStatus.Open;
		}
		
	}


	//Determine Secret Rooms
	for(var RoomIndex = 0; RoomIndex < global.RoomCount; RoomIndex++){
		//if(global.Dungeon_SecretRooms[RoomIndex] == 1) continue; //continue if this room has already been flagged as secret
		
		var _Room = global.Dungeon[$ "Rooms"][RoomIndex];
		var RSI = GetRoomSizeIndex(_Room.GridW, _Room.GridH);
		
		if(_Room.SpecialObj == SpecialDungeonObj.SpecialRoom){ //secret rooms will only have 1 door
			
			//This is the prob that a Special room will be hidden with secret doors. Otherwise the special room will have regular doors
			//Use only secret_closed doors for village
			if(Prob(Chance_SecretDoor) || global.DungeonDepth == DungeonLevel.Village){ 
				
				global.Dungeon_SecretRooms[RoomIndex] = 1;
				
				if(global.DungeonDepth == DungeonLevel.Village && RoomIndex == 14) continue; //special locked door with special room, so don't make doo secret
				
				var _Door = _Room.Doors[0]; //special rooms should always only have 1 door into them, so we can index at 0
				_Door.Status = DoorStatus.Secret_Closed;
				var _ConnectedRoomIndex = _Door.ConnectedRoomIndex;
				var ConnectedRoom = global.Dungeon[$ "Rooms"][_ConnectedRoomIndex];
				var ConnectRSI = GetRoomSizeIndex(ConnectedRoom.GridW, ConnectedRoom.GridH);
				var ConnectedPos = Door_GetConnectedPos(_Room.GridX, _Room.GridY, RSI, ConnectedRoom.GridX, ConnectedRoom.GridY, ConnectRSI, _Door.Position);
				
				
				var ConnectedRoomDoorsArray = ConnectedRoom.Doors;
				var ConnectedRoomDoors = array_length(ConnectedRoomDoorsArray);
				for(var i = 0; i < ConnectedRoomDoors; i++){
					_OtherDoor = ConnectedRoomDoorsArray[i];
					if(_OtherDoor.Position == ConnectedPos){
						_OtherDoor.Status = DoorStatus.Secret_Closed;
						break;
					}
				}		
				
			}

		}
		
	}
	
	//determine house rooms
	for(var RoomIndex = 0; RoomIndex < global.RoomCount; RoomIndex++){
		var _Room = global.Dungeon[$ "Rooms"][RoomIndex];
		if(_Room.SpecialObj == SpecialDungeonObj.House) global.Dungeon_HouseRooms[RoomIndex] = true;
	}	
	
	//Add 0 to Rooms-1 to list, then shuffle. Pick rooms from the list instead of doing them sequencially.
	//This prevents shops to be bunched up in rooms by the entrance, it spreads them out
	var ShuffledRoomIndexesList = ds_list_create();
	for(var i = 0; i < global.RoomCount; i++){
		ds_list_add(ShuffledRoomIndexesList, i);
	}
	ds_list_shuffle(ShuffledRoomIndexesList);
	

	global.MaxShops = ceil(global.RoomCount / 9);	
	
	for(var ListIndex = 0; ListIndex < global.RoomCount; ListIndex++){
		
		global.RoomIndex = ShuffledRoomIndexesList[| ListIndex];		
		
		global.SectionID = Room[$ "Section_ID"];
		global.SpecialObj = Room[$ "SpecialObj"];
		global.SpecialObj_InSection = (Room[$ "SpecialObjSection"] > 0);
		//global.SpecialObj_SectionType = (global.SpecialObj_InSection ? Section.Other : Section.Main);	
		
		global.SpecialRoom = (Room.SpecialObj == SpecialDungeonObj.SpecialRoom);
		global.VillageRoom = (global.DungeonDepth == DungeonLevel.Village && (global.RoomIndex >= 0 && global.RoomIndex <= 5));
		global.HouseRoom = (Room.SpecialObj == SpecialDungeonObj.House);
		
		//if we're not on a boss level, don't draw the boss room
		if(!global.BossLevel && global.RoomIndex == global.BossRoomIndex) continue;

		
		global.UnusedZoneIndex = -1; 
	
		
		if(global.RoomIndex == global.BossRoomIndex){
			global.RoomTemplate = global.DungeonDepth == DungeonLevel.MoldormsLair ? global.SpecialRoom_Moldorm : 0;
		}else if(global.VillageRoom){
			global.RoomTemplate = global.SpecialRoom_Village[global.RoomIndex];
			global.Dungeon_SpecialRooms[global.RoomIndex] = SpecialRoom.Village;
		}else if(global.HouseRoom){
			global.RoomTemplate = Dungeon_GetHouseTemplate(Room.GridX, Room.GridY);
		}else if(global.SpecialRoom){
			global.RoomTemplate = Dungeon_PickSpecialRoom();
		}else{
			global.RoomTemplate = Dungeon_PickRoomTemplate();
		}

		if(global.RoomTemplate == -1){
			Error("Room index " + string(global.RoomIndex) + " doesn't have a suitable template", true);
			exit;
		}						
		global.DungeonGrid_RoomTemplate[# Room.GridX, Room.GridY] = global.RoomTemplate;	
		
		Room.Template = global.RoomTemplate;
		
		Room.Lighting = RoomLighting();

		var RoomTemplateProperties = global.Data_RoomTemplates[global.RoomTemplate][$"properties"];
		global.ForceWallTheme = GetPropertyValue(RoomTemplateProperties, "ForceWallTheme");
			
		Dungeon_Draw_Floors();
		
		Dungeon_Draw_Walls();
		
		Dungeon_Draw_Pit();
		
		var RoomGridX = Room.x / 8; var RoomGridY = Room.y / 8;
		var RoomGridW = Room.width / 8; var RoomGridH = Room.height / 8;
		if(!global.VillageRoom) Dungeon_Draw_Ceiling(GetTileID(8, 6 + (global.DungeonDepth * 6)), RoomGridX, RoomGridY, RoomGridX, RoomGridY, RoomGridX + RoomGridW, RoomGridY + RoomGridH);
		
		Dungeon_Draw_ExtraCeilings();		
			
		Dungeon_CreateDoors();
		
		Dungeon_Draw_Stairs();
			
		if(global.RoomIndex != global.BossRoomAdjacentIndex)
			Dungeon_Draw_FloorObjs(); //Don't draw floorobjs(holes especially) if next to boss room, since holes might take away entrance tiles
		
		if(global.SpecialRoom || global.VillageRoom || global.HouseRoom){
			Dungeon_Draw_SpecialObjs_Forced();
		}else{
			
			//if we're in the boss room at a boss depth, then don't draw special items
			if(global.RoomIndex == global.BossRoomIndex && global.BossLevel){
				SpawnBoss();
			}else{
				Dungeon_Draw_SpecialObjs();
			}
			
		}
		
		if(global.DungeonDepth != DungeonLevel.Village) Dungeon_Draw_WallDecor();
		
	}
	
	//Load();
	
	Map_Init();
	
	Dungeon_InitDoors();
	
	ds_list_destroy(ShuffledRoomIndexesList);
	
	//Save();
	
	
	Link_SetStartingPos();
	
	global.StatsToAdd[Stat.GamesPlayed]++;
	
	
	
}

function Dungeon_Init_Intro(){
	
	Dungeon_Clear();
	
	global.Dungeon = global.Dungeons[0]; 

	global.EntranceRoomIndex = global.Dungeon[$ "EntranceRoomIndex"];
	global.EntranceRoom = global.Dungeon[$ "Rooms"][global.EntranceRoomIndex];
	
	global.RoomCount = array_length(global.Dungeon[$ "Rooms"]);
	global.Dungeon_VisitedRooms = 0; global.Dungeon_VisitedRooms = array_create(global.RoomCount, false);
	
	global.EvenDungeon = true;

	global.BossRoomIndex = -1;
	global.BossRoomAdjacentIndex = -1;
	
	global.Dungeon_SpecialRooms = 0; global.Dungeon_SpecialRooms = array_create(global.RoomCount, -1);
	
	for(global.RoomIndex = 0; global.RoomIndex < global.RoomCount; global.RoomIndex++){
		
		//pre-set all room indexes in global.DungeonGrid_RoomIndex
		var _Room = global.Dungeon[$ "Rooms"][global.RoomIndex];
		global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY] = global.RoomIndex;
		if(_Room.GridW == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY] = global.RoomIndex;
		if(_Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY + 1] = global.RoomIndex;
		if(_Room.GridW == 2 && _Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY + 1] = global.RoomIndex;
				
		
		switch(global.RoomIndex){
			case 0: global.RoomTemplate = GetSpecialTemplateIndex("Start_S"); break;				
			case 1: global.RoomTemplate = GetSpecialTemplateIndex("Start_N"); break;
		}

		if(global.RoomTemplate == -1){
			Error("Room index " + string(global.RoomIndex) + " doesn't have a suitable template", true);
			exit;
		}
		
		global.DungeonGrid_RoomTemplate[# Room.GridX, Room.GridY] = global.RoomTemplate;
		Room.Template = global.RoomTemplate;
		Room.Lighting = 0.0;
		
		Dungeon_Draw_Floors();
		
		//Dungeon_Draw_Walls();
		
		Dungeon_Draw_FloorObjs();		
				
		Dungeon_Draw_SpecialObjs_Forced();

	}
	
	Map_Init();
	
	Dungeon_InitDoors();
	
	Link_SetStartingPos();
	
	instance_create_layer(-100, -100, "System", oIntro);
	
}


function Dungeon_Init_Final(){

	Dungeon_Clear();

	global.Dungeon = global.Dungeons[1]; 
	
	global.EntranceRoomIndex = global.Dungeon[$ "EntranceRoomIndex"];
	global.EntranceRoom = global.Dungeon[$ "Rooms"][global.EntranceRoomIndex];
	
	global.RoomCount = array_length(global.Dungeon[$ "Rooms"]);
	
	global.BossRoomIndex = 1;
	global.BossRoomAdjacentIndex = 0;
	
	global.DungeonDepth = DungeonLevel.Aghanim4;
	global.BossLevel = Dungeon_BossLevel(global.DungeonDepth);

	
	for(global.RoomIndex = 0; global.RoomIndex < global.RoomCount; global.RoomIndex++){
		
		//pre-set all room indexes in global.DungeonGrid_RoomIndex
		var _Room = global.Dungeon[$ "Rooms"][global.RoomIndex];
		global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY] = global.RoomIndex;
		if(_Room.GridW == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY] = global.RoomIndex;
		if(_Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX, _Room.GridY + 1] = global.RoomIndex;
		if(_Room.GridW == 2 && _Room.GridH == 2) global.DungeonGrid_RoomIndex[# _Room.GridX + 1, _Room.GridY + 1] = global.RoomIndex;
				
		
		switch(global.RoomIndex){
			case 0: global.RoomTemplate = GetSpecialTemplateIndex("FinalBoss_Hallway"); break;				
			case 1: global.RoomTemplate = GetSpecialTemplateIndex("FinalBoss"); break;
		}

		if(global.RoomTemplate == -1){
			Error("Room index " + string(global.RoomIndex) + " doesn't have a suitable template", true);
			exit;
		}
		
		global.DungeonGrid_RoomTemplate[# Room.GridX, Room.GridY] = global.RoomTemplate;
		Room.Template = global.RoomTemplate;
		Room.Lighting = 0.0;
		
		Dungeon_Draw_Floors();
		
		Dungeon_Draw_Walls();
		
		Dungeon_Draw_Pit();
		
		Dungeon_Draw_FloorObjs();		
		
		Dungeon_Draw_ExtraCeilings();
		
		Dungeon_Draw_SpecialObjs_Forced();
		
		switch(global.RoomIndex){
			case 0:	
				instance_create_layer(Room.x + 93, Room.y + 60, "Objs_Upper", oFinalBossGate);
				instance_create_layer(Room.x, Room.y, "ObjsHigher_Upper", oCrystalEnd);	
				DrawTileBlock(global.TMID_Tiles_Decor_Upper, Room.x + 88, Room.y + 16, 74, 0, 3, 4);
				DrawTileBlock(global.TMID_Tiles_Decor_Upper, Room.x + 144, Room.y + 16, 77, 0, 3, 4);
				break;
			
			case 1:
				DrawTileBlock(global.TMID_Tiles_Decor_Upper, Room.x + 88, Room.y + 208, 80, 0, 3, 4);
				DrawTileBlock(global.TMID_Tiles_Decor_Upper, Room.x + 144, Room.y + 208, 83, 0, 3, 4);
				break;
			
		}
		
		Dungeon_CreateDoors();
		
		var inst = instance_create_layer(Room.x, Room.y, "Starfield", oStarfield);
		inst.RoomH = Room.height;
		layer_set_visible(global.LayerID_Starfield, true);

		
	}
	
	Map_Init();
	
	Dungeon_InitDoors();
	
	Link_SetStartingPos();
	
}

