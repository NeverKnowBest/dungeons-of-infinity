#macro Room global.Level.Rooms[_RoomIndex]
#macro DungeonRoom global.Level.DungeonTemplate.Rooms[_RoomIndex]
#macro TemplateRoom global.Templates_Room[Room.TemplateIndex]
#macro StartingRoom (global.Level.Index == DungeonLevel.Castle && _RoomIndex == global.Level.RoomIndex_Entrance)
#macro DungeonGridW 8

#macro TileLayers 11
enum TileLayer{
	Pit,
	Floor_Lower,
	Water_Lower,
	Walls_Lower,
	Decor_Lower,
	Floor_Upper,
	Water_Upper,
	Walls_Upper,
	Decor_Upper,
	Ceiling,
	Higher	
}

#macro DungeonLevels 16
enum DungeonLevel{
	Start,
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

enum RoomType{
	Normal,
	Entrance,
	BossAdjacent,
	Boss,
	Start,
	Special,
	Village,
	House	
}


global.Level = 0;


function Dungeon_CreateStruct_Level(_LevelIndex) constructor{
	
	Index = _LevelIndex;
	
	DungeonTemplate_Index = 19;//Dungeon_PickTemplateIndex(_LevelIndex);
	DungeonTemplate_Flip = Dungeon_PickTemplateFlip(_LevelIndex);	
	
	DungeonTemplate = global.Templates_Dungeon[DungeonTemplate_Flip][DungeonTemplate_Index];
	
	RoomCount = array_length(DungeonTemplate.Rooms);
	
	Rooms = array_create(RoomCount);
		
	RoomIndex_Entrance = DungeonTemplate.EntranceRoomIndex;
	RoomIndex_Boss = -1;
	RoomIndex_BossAdjacent = -1;
	
	Map_RoomIndex = Array_Create2D(DungeonGridW, DungeonGridW);
	Map_TemplateIndex = Array_Create2D(DungeonGridW, DungeonGridW, -1);

	StartDir = Dungeon_StartDir(_LevelIndex);
	IsBossLevel = Dungeon_IsBossLevel(_LevelIndex);
	
	SwitchBlock_Colors = 2;
	SwitchBlock_ActiveColor = SwitchBlockColor.Red; //color that the crystal is showing, SBs with this color are lowered/active
	
	ShopCount = 0;
	AltarCount = 0;
	
	MaxShops = ceil(RoomCount / 9);
	
	PotStyle = (_LevelIndex == DungeonLevel.Catacombs || _LevelIndex == DungeonLevel.LanmolasLair || _LevelIndex == DungeonLevel.MoldormsLair || _LevelIndex == DungeonLevel.Aghanim3) ? 1 : 0;
	
	SaveData = {
		
		Link_Health : 3,
		Link_HealthMax : 3,
		Link_Magic : 3,
		Link_Rupees : 0,
		Link_Keys : 0,
		Link_Arrows : 0,
		Link_Bombs : 0,
		
		Inventory : Array_Create2D(2, global.Inventory_SlotLimit),
		
		Objs_Walls : [],
		Objs_Doors : [],
		Objs_Curtains : [],
		Objs_Pots : [],
		Objs_Treasures : [],
		Objs_Torches : [],
		Objs_WallLights : [],
		Objs_Crystals : [],
		Objs_SwitchBlocks : [],
		Objs_Shops : [],
		Objs_ShopKeepers : [],
		Objs_Items : [],
		Objs_Kinstones : [],
		Objs_KeyBlocks : [],
		Objs_PushBlocks : [],
		Objs_FloorSwitches : [],
		Objs_Enemies : [],
		Objs_EnemyTraps : [],
		Objs_GuruBars : [],
		Objs_DeadGuys : [],
		Objs_HeartGuys : [],
		Objs_Fairies_Health : [],
		Objs_Prisoners : [],
	}
	
}

function Dungeon_CreateStruct_Room(_RoomIndex) constructor{
	
	var _DungeonRoom = global.Level.DungeonTemplate.Rooms[_RoomIndex];
	
	x = _DungeonRoom.x;
	y = _DungeonRoom.y;
	width = _DungeonRoom.width;
	height = _DungeonRoom.height;
	TileX = x / 8;
	TileY = y / 8;
	TileW = width / 8;
	TileH = height / 8;
	GridX = _DungeonRoom.GridX;
	GridY = _DungeonRoom.GridY;
	GridW = _DungeonRoom.GridW;
	GridH = _DungeonRoom.GridH;
	
	
	//create all tile layers for each Room
	Tiles = array_create(TileLayers);
	for(var _TileLayerIndex = 0; _TileLayerIndex < TileLayers; _TileLayerIndex++){
		Tiles[_TileLayerIndex] = Array_Create2D(_DungeonRoom.GridW * 32, _DungeonRoom.GridH * 32);
	}
	
	var _DoorsArray = _DungeonRoom[$ "Doors"];
	var _DoorCount = array_length(_DoorsArray);
	Doors = array_create(_DoorCount);
	for(var _DoorIndex = 0; _DoorIndex < _DoorCount; _DoorIndex++){
		Doors[_DoorIndex] = new Dungeon_CreateStruct_Door();
		Doors[_DoorIndex].Status = _DungeonRoom.Doors[_DoorIndex].Status;
	}
	
	
	//to-do: will be for sillouettes of Link/enemies/objects that are under upper floors. Have to rewrite some of the pixel shader. 
	//Should be combined with Masking routine, instead of setting pixels to be alpha 0, set them to be a certain color
	SilouetteAreas = []; 

	
	Visited = false;
	Secret = -1;
	Lighting = 0.0
	Water = false;
	Sand = false;
	
	Section_ID = _DungeonRoom.Section_ID;
	Section_WallType = _DungeonRoom.Section_WallType;
	
	UnusedZone = -1;
			
	SpecialObject = _DungeonRoom.SpecialObj;
	SpecialObject_InSection = (_DungeonRoom.SpecialObjSection > 0);
	SpecialObject_SectionType = (SpecialObject_InSection ? Section.Other : Section.Main);
	
	WarpDestX = -1; //location where Link gets transported from a Warp obj
	WarpDestY = -1;
	
	TemplateIndex = 0;
	Type = RoomType.Normal;
	Name = "";
	
	RoomSongIndex = global.Music_LevelSongIndex[global.Level.Index];
	
	switch(SpecialObject){
		
		case SpecialDungeonObj.SpecialRoom:
			Type = RoomType.Special;
			break;
		
		case SpecialDungeonObj.House:
			Type = RoomType.House;
			break;
		
		case SpecialDungeonObj.Boss:
			Type = RoomType.Boss;
			break;
			
	}
	
	if(global.Level.Index == DungeonLevel.Start)
		Type = RoomType.Start;
	else if(global.Level.Index == DungeonLevel.Village && (_RoomIndex >= 0 && _RoomIndex <= 5)){
		Type = RoomType.Village;
	}else if(_RoomIndex == global.Level.RoomIndex_Entrance)
		Type = RoomType.Entrance;
	else if(_RoomIndex == global.Level.RoomIndex_BossAdjacent)
		Type = RoomType.BossAdjacent;	
		
	//FloorStyle
	
}

function Dungeon_CreateStruct_Door() constructor{
	
	Status = DoorStatus.Open;

}

function Dungeon_InitLevel(_LevelIndex){

	Dungeon_Clear();
	
	if(global.Continue){
		Dungeon_LoadLevel();
		Map_Init();
		Dungeon_InitDoors();
		Link_SetStartingPos();
		global.Continue = false;
		exit;
	}else{
		global.Level = new Dungeon_CreateStruct_Level(_LevelIndex);
	}
	
	
	//Init Room data
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		
		var _RoomTemplate = global.Level.DungeonTemplate[$ "Rooms"][_RoomIndex];

		//pre-set all Room indexes in global.DungeonGrid_RoomIndex
		global.Level.Map_RoomIndex[_RoomTemplate.GridY][_RoomTemplate.GridX] = _RoomIndex;
		if(_RoomTemplate.GridW == 2) global.Level.Map_RoomIndex[_RoomTemplate.GridY][_RoomTemplate.GridX + 1] = _RoomIndex;
		if(_RoomTemplate.GridH == 2) global.Level.Map_RoomIndex[_RoomTemplate.GridY + 1][_RoomTemplate.GridX] = _RoomIndex;
		if(_RoomTemplate.GridW == 2 && _RoomTemplate.GridH == 2) global.Level.Map_RoomIndex[_RoomTemplate.GridY + 1][_RoomTemplate.GridX + 1] = _RoomIndex;
		
		//set the boss Room index
		if(_RoomTemplate.SpecialObj == SpecialDungeonObj.Boss) global.Level.RoomIndex_Boss = _RoomIndex;
		
		//Determine adjacent boss Room
		var _DoorCount = array_length(_RoomTemplate.Doors);
		for(var _DoorIndex = 0; _DoorIndex < _DoorCount; _DoorIndex++){	
			var _Door = _RoomTemplate.Doors[_DoorIndex];
			if(_Door.ConnectedRoomIndex != -1){
				if(global.Level.DungeonTemplate[$ "Rooms"][_Door.ConnectedRoomIndex].SpecialObj == SpecialDungeonObj.Boss){
					global.Level.RoomIndex_BossAdjacent = _RoomIndex;
					break;
				}
			}
		}
		
		global.Level.Rooms[_RoomIndex] = new Dungeon_CreateStruct_Room(_RoomIndex);
	
	}

	//set up secret room. This has to be done in a seperate loop after all the rooms have been initialised
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		
		if(Room.Secret != -1) continue; //continue if this Room has already been flagged as secret
		
		var _RoomTemplateRSI = GetRoomSizeIndex(Room.GridW, Room.GridH);
		
		if(Room.Type == RoomType.Special){ //secret Rooms will only have 1 door
			
			//This is the prob that a Special Room will be hidden with secret doors. Otherwise the special Room will have regular doors
			//Use only secret_closed doors for village
			if(Prob(Chance_SecretDoor) || global.Level.Index == DungeonLevel.Village){ 
				
				Room.Secret = 1;
				
				if(global.Level.Index == DungeonLevel.Village && _RoomIndex == 13) continue; //special locked door with special Room, so don't make door secret
				
				Room.Doors[0].Status = DoorStatus.Secret_Closed; //special Rooms should always only have 1 door into them, so we can index at 0
				
				var _ConnectedRoomTemplateIndex = DungeonRoom.Doors[0].ConnectedRoomIndex;
				var _ConnectedRoomTemplate = global.Level.DungeonTemplate.Rooms[_ConnectedRoomTemplateIndex];
				var _ConnectedRoomTemplateRSI = GetRoomSizeIndex(_ConnectedRoomTemplate.GridW, _ConnectedRoomTemplate.GridH);
				var _ConnectedDoorPos = Door_GetConnectedPos(DungeonRoom.GridX, DungeonRoom.GridY, _RoomTemplateRSI, _ConnectedRoomTemplate.GridX, _ConnectedRoomTemplate.GridY, _ConnectedRoomTemplateRSI, DungeonRoom.Doors[0].Position);
				
				var _ConnectedRoom = global.Level.Rooms[_ConnectedRoomTemplateIndex];
				
				var _ConnectedRoomTemplateDoorsArray = _ConnectedRoomTemplate.Doors;
				var ConnectedRoomTemplateDoors = array_length(_ConnectedRoomTemplateDoorsArray);
				for(var i = 0; i < ConnectedRoomTemplateDoors; i++){
					var _ConnectedDoor = _ConnectedRoomTemplateDoorsArray[i];
					if(_ConnectedDoor.Position == _ConnectedDoorPos){
						_ConnectedRoom.Doors[i].Status = DoorStatus.Secret_Closed;
						break;
					}
				}		
				
			}

		}
		
	}
	
	global.CarpetTileBase = GetTileID(111, LevelTilesY + 2); 
	global.CarpetTileTrim = GetTileID(110, LevelTilesY + 4); 	
	
	//Add 0 to Rooms-1 to list, then shuffle. Pick Rooms from the list instead of doing them sequencially.
	//This prevents shops to be bunched up in Rooms by the entrance, it spreads them out
	var ShuffledRoomIndexesList = ds_list_create_sequence_shuffled(0, global.Level.RoomCount - 1);

	for(var _RoomListIndex = 0; _RoomListIndex < global.Level.RoomCount; _RoomListIndex++){
		
		var _RoomIndex = ShuffledRoomIndexesList[| _RoomListIndex];

		//if we're not on a boss level, don't draw the boss Room
		if(!global.Level.IsBossLevel && RoomID(_RoomIndex, RoomType.Boss)) continue;
		
		
		ds_list_shuffle(global.RoomTemplateList);
		global.RoomTemplateListIndex = -1;
		
		while(global.RoomTemplateListIndex < global.Templates_Room_Count){
			
			Room.TemplateIndex = Dungeon_PickRoomTemplate(_RoomIndex);
		
			if(Room.TemplateIndex == -1){
				Error("Room index " + string(_RoomIndex) + " doesn't have a suitable template", true);
				exit;
			}	

			global.Level.Map_TemplateIndex[Room.GridY][Room.GridX] = Room.TemplateIndex;			
		
			var _Template = TemplateRoom;
		
		
			//var LowerFloorAreaArray = _Template.LowerFloor;
			//var LowerFloorAreaCount = array_length(LowerFloorAreaArray);
			//for(var i = 0; i < LowerFloorAreaCount; i++){
			//	var LowerFloorArea = LowerFloorAreaArray[i];
			//	var X1 = LowerFloorArea.x;
			//	var Y1 = LowerFloorArea.y;
			//	var X2 = X1 + LowerFloorArea.width - 1;
			//	var Y2 = Y1 + LowerFloorArea.height - 1;
			
			//	Room.SilouetteAreas[i] = [X1, Y1, X2, Y2];
			
			//}
		
			
			var RoomTemplateProperties = _Template[$"properties"];
			global.ForceWallTheme = GetPropertyValue(RoomTemplateProperties, "ForceWallTheme");
			
			Room.Name = TemplateRoom[$ "name"];	
			Room.Lighting = RoomLighting(_RoomIndex);	
			
			if(RoomID(_RoomIndex, RoomType.Boss)) Room.RoomSongIndex = SongIndex.Boss;
			if(RoomID(_RoomIndex, RoomType.Special, "Fairy")) Room.RoomSongIndex = SongIndex.Fairy;
			if(global.Level.Index == DungeonLevel.Village){
				if(RoomID(_RoomIndex, RoomType.Village) || RoomID(_RoomIndex, RoomType.House)) Room.RoomSongIndex = SongIndex.Village;
				if(RoomID(_RoomIndex, RoomType.House, "Arcade")) Room.RoomSongIndex = SongIndex.Village_Arcade;
				if(RoomID(_RoomIndex, RoomType.House, "Store")) Room.RoomSongIndex = SongIndex.Village_Store;	
				if(RoomID(_RoomIndex, RoomType.House, "Pub")) Room.RoomSongIndex = SongIndex.Village_Pub;
			}
				
			Dungeon_Draw_Floors(_RoomIndex);
		
			Dungeon_Draw_Walls(_RoomIndex);
		
			if(global.Level.Index != DungeonLevel.Start && Room.Type != RoomType.Village){
				Dungeon_Draw_Ceiling(GetTileID(8, LevelTilesY + 2), Room.TileX, Room.TileY, Room.TileX, Room.TileY, Room.TileX + Room.TileW, Room.TileY + Room.TileH);
			}
		
			Dungeon_Draw_ExtraCeilings(_RoomIndex);		
		
			Dungeon_CreateDoors(_RoomIndex);
			
			Dungeon_Draw_Carpets(_RoomIndex);
		
			Dungeon_Draw_Pit(_RoomIndex);
		
			Dungeon_Draw_Holes(_RoomIndex);
		
			Dungeon_Draw_Water(_RoomIndex);
				
			Dungeon_Draw_Stairs(_RoomIndex);
				
			Dungeon_Draw_FloorObjs(_RoomIndex); 		
			
			var SpawnedSpecialObs = true;
			if(global.Level.Index == DungeonLevel.Start || global.Level.Index == DungeonLevel.Aghanim4 || Room.Type == RoomType.Special || Room.Type == RoomType.Village || Room.Type == RoomType.House){
				Dungeon_Draw_SpecialObjs_Forced(_RoomIndex);
				break;
			}else{
			
				//if we're in the boss Room at a boss depth, then don't draw special items
				if(global.Level.IsBossLevel && _RoomIndex == global.Level.RoomIndex_Boss){
					SpawnBoss(_RoomIndex);
					break;
				}else{
					
					var SpawnedSpecialObs = Dungeon_Draw_SpecialObjs(_RoomIndex);
					
					if(!SpawnedSpecialObs){
						
						//special objects couldn't spawn, so clear room and try another template
						var ObjsToDestroyList = ds_list_create();
						ds_list_add(ObjsToDestroyList, oWall, oDoor, oSwitchBlock);
						var ObjsToDestroy = ds_list_size(ObjsToDestroyList);
						
						var ObjCollisionList = ds_list_create();
						
						for(var i = 0; i < ObjsToDestroy; i++){
							ds_list_clear(ObjCollisionList); 
							var _Obj = ObjsToDestroyList[| i];
							var _Objs = collision_rectangle_list(Room.x, Room.y, Room.x + (Room.GridW * 256) - 1, Room.y + (Room.GridH * 256) - 1, _Obj, false, true, ObjCollisionList, false);
							for(var j = 0; j < _Objs; j++){
								instance_destroy(ObjCollisionList[| j]);
							}
						}
						ds_list_destroy(ObjCollisionList);
						
						ClearTileBlock(global.TMID_Higher,		Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Ceiling,		Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Decor_Upper, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Walls_Upper, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Water_Upper, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Floor_Upper, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Decor_Lower, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Walls_Lower, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Water_Lower, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Floor_Lower, Room.x, Room.y, Room.TileW, Room.TileH);
						ClearTileBlock(global.TMID_Pit,			Room.x, Room.y, Room.TileW, Room.TileH);
						
						continue;
						
					}else break;
				}
			
			}
			
		}
		
		if(!SpawnedSpecialObs){
			Error("Room index " + string(_RoomIndex) + " doesn't have a suitable template for special objs", true);
			exit;
		}
		
		Dungeon_Draw_WallDecor(_RoomIndex);
		
		
		if(global.Level.Index == DungeonLevel.Aghanim4){

			switch(_RoomIndex){
				case 0:	
					instance_create_layer(Room.x + 93, Room.y + 60, "Objs_Upper", oFinalBossGate);
					instance_create_layer(Room.x, Room.y, "ObjsHigher_Upper", oCrystalEnd);	
					DrawTileBlock(global.TMID_Decor_Upper, Room.x + 88, Room.y + 16, 74, 0, 3, 4);
					DrawTileBlock(global.TMID_Decor_Upper, Room.x + 144, Room.y + 16, 77, 0, 3, 4);
					break;
			
				case 1:
					DrawTileBlock(global.TMID_Decor_Upper, Room.x + 88, Room.y + 208, 80, 0, 3, 4);
					DrawTileBlock(global.TMID_Decor_Upper, Room.x + 144, Room.y + 208, 83, 0, 3, 4);
					break;
			
			}

		}

			
	}
		
	Map_Init();
	
	Dungeon_InitDoors();
	
	ds_list_destroy(ShuffledRoomIndexesList);
	
	Link_SetStartingPos();
	
	
	switch(global.Level.Index){
		
		case DungeonLevel.Start:
			instance_create_layer(-100, -100, "System", oIntro);
			break;

		case DungeonLevel.Castle:
			if(audio_is_playing(global.RainSound)){
				audio_sound_gain(global.RainSound, 0.3, 200)
			}else{
				global.RainSound = audio_play_sound(Sound_Rain, 1, true, 0.3);
			}
			global.StatsToAdd[Stat.GamesPlayed]++;
			oRender.FadeIn();
			break;
			
		case DungeonLevel.Aghanim4:
			var inst = instance_create_layer(Room.x, Room.y, "Starfield", oStarfield);
			inst.RoomH = Room.height;
			layer_set_visible(global.LayerID_Starfield, true);
			break;
	}
	
	input_clear_momentary(true);
	
	if(global.Level.Index > DungeonLevel.Start) Music_Play(global.Music_LevelSongIndex[global.Level.Index], 10);
	
}

function Dungeon_DestroyLevel(){
	
	if(is_struct(global.Level)){
		for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
			var _Room = global.Level.Rooms[_RoomIndex];
			var _DoorCount = array_length(_Room.Doors);
			for(var _DoorIndex = 0; _DoorIndex < _DoorCount; _DoorIndex++){
				delete _Room.Doors[_DoorIndex];
			}
			delete _Room
		}
		delete global.Level.SaveData;
		delete global.Level;
	}	
	
}

function Dungeon_IsBossLevel(_Level){
	return (_Level == DungeonLevel.CastleJails || _Level == DungeonLevel.LanmolasLair || _Level == DungeonLevel.MoldormsLair || _Level == DungeonLevel.Aghanim4)
}
function Dungeon_StartDir(_Level){
	return _Level mod 2 == 1 || _Level == DungeonLevel.Start ? UP : DOWN
}

function Dungeon_PickTemplateIndex(_Level){
	
	switch(_Level){
		default:
			//return 3//irandom_range(3, 18)
			
			var DungeonList = ds_list_create();
			for(var i = 3; i <= 19; i++){
				ds_list_add(DungeonList, i);
			}
			ds_list_shuffle(DungeonList);
			var Dungeons = ds_list_size(DungeonList);
			
			if(_Level == DungeonLevel.CastleJails) _Level += 3; //to make sure there's extra rooms for the jail level, I want it larger than this progression allows.
			
			var MinRooms = floor(30 * log10((2.5 + _Level) / 2));
			var MaxRooms = floor(72 * log10((2 + _Level) / 2));

			for(var i = 0; i < Dungeons; i++){
				var DungeonIndex = DungeonList[| i];
				var RoomCount = array_length(global.Templates_Dungeon[0][DungeonIndex].Rooms);
				if(RoomCount >= MinRooms && RoomCount <= MaxRooms) return DungeonIndex;
			}
				
			return DungeonList[| 0] //fail safe
			
			
		case DungeonLevel.Start:
			return 0;
			break;
		case DungeonLevel.Village:
			return 2;
			break;
		
	}
	
}

function Dungeon_PickTemplateFlip(_Level){
	
	switch(_Level){
		case DungeonLevel.Start: 
		case DungeonLevel.Aghanim4: 
			return Flip.None
		case DungeonLevel.Village: return Flip.V
		
		default:
			if(Dungeon_StartDir(_Level) == UP){
				return FlipCoin_Bool() ? Flip.None: Flip.H
			}else{
				return FlipCoin_Bool() ? Flip.V: Flip.HV
			}		
	}

}


