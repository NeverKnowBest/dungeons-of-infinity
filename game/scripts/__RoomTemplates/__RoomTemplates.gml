enum Mask{
	OutOfBounds,
	WallsUpper,
	WallsLower,
	WallsCommon,
	Stairs,
	LowerFloor,
	Doors
}

enum TemplateObjGID{
	DoorB=1,
	DoorL,
	DoorR,
	DoorT,
	StairsB,
	StairsL,
	StairsR,
	StairsT,
	WallCornerBL,
	WallCornerBR,
	WallCornerTL,
	WallCornerTR,
	WallInnerBL,
	WallInnerBR,
	WallInnerTL,
	WallInnerTR,
	WallLowerCornerBL,
	WallLowerCornerBR,
	WallLowerCornerTL,
	WallLowerCornerTR,
	WallLowerInnerBL,
	WallLowerInnerBR,
	WallLowerInnerTL,
	WallLowerInnerTR,
	WallLowerSideB,
	WallLowerSideL,
	WallLowerSideR,
	WallLowerSideT,
	WallSideB,
	WallSideL,
	WallSideR,
	WallSideT,
	Rail,
	Pot,
	Treasure,
	Crystal,
	PotOrTreasure,
	TreasureOrCrystal,
	PotOrCrystal,
	PotOrTreasureOrCrystal,
	Monument,
	Altar,
	Block,
	SpikeBlock,
	SpikeFloor,
	Hole,
	IceFloor,
	MovingFloorDown,
	MovingFloorLeft,
	MovingFloorRight,
	MovingFloorUp,
	Column=60,
	RailLarge=82,
	Kinstone,
	Jail,
	Shop,
	Rupee5,
	Rupee10,
	Rupee20,
	TreasureLarge,
	Fairy=92,
	Water,
	House,
	Bridge=96,
	Waterfall,
	Path1=99,
	Path2,
	PathTrim,
	Path3=109,
	Path4,
	Path5,
	Path6,
	Path7,
	Path8,
	Path9,
	Path10,
	Dirt=117,
	Dirt_Edge1,
	Dirt_Edge2,
	Dirt_Edge3,
	Tree1=135,
	Tree2,
	Tree3,
	Tree4,
	Statue,
	Pillar,
	BirdStatue=143,
	Bench=148,
	WaterTrough1,
	WaterTrough2,
	VillageEntranceSign,
	VillageFortWall,
	Tombstone,
	CemetaryWall,
	Gate,
	RuinWall,
	MedallionPlatform,
	Table1,
	Table2,
	Stove1,
	Stove2,
	Bed1,
	Bed2,
	Cabinet1,
	Cabinet2,
	Cabinet3,
	Shelves,
	Furniture1,
	Furniture2,
	LibraryShelves,
	FloorTrim,
	Bar_B,
	Bar_Hor,
	Bar_L,
	Bar_R,
	Bar_T,
	Bar_Ver,
	Bar_Corner_BL,
	Bar_Corner_BR,
	Bar_Corner_TL,
	Bar_Corner_TR,
	Arcade,
	BlacksmithIron,
	BlacksmithTools=185,
	Keg,
	Seat,
	Crate,
	Painting,
	Rug,
	Garbage,
	CashRegister,
	Bowl,
	Food,
	Bottle1,
	Bottle2,
	Hedge_BL,
	Hedge_BR,
	Hedge_End_B,
	Hedge_End_L,
	Hedge_End_R,
	Hedge_End_T,
	Hedge_Hor,
	Hedge_TL,
	Hedge_TR,
	Hedge_Ver,
	PillarLarge=208,
	NPC,
	FenceHor,
	FenceVer,
	Sand,
	AnimalBones,
	Temple,
	VillageRiverDrain,
	Sign,
	PoolTable,
	RollingSpikesV,
	RollingSpikesH,
	GuruBar,
	Chicken,
	Book,
	Decor_Mural_B,
	Decor_Mural_L,
	Decor_Mural_R,
	Decor_Mural_T,
	Tree_Large_B = 228,
	Tree_Large_L,
	Tree_Large_R,
	Tree_Large_T,
	CastleWallH,
	CastleWallV,
	CastleWallShadow,
	CastleWallFloor,
	CastleWallDoor,
	Bush,
	Carpet_H,
	Carpet_V,
	Carpet_TL,
	Carpet_TR,	
	Carpet_BL,
	Carpet_BR,
	Carpet_TLR,
	Carpet_BLR,
	Carpet_TBL,
	Carpet_TBR,
	Carpet_TBLR,
	Carpet_Full,
	TMNT_Couch1,
	TMNT_Couch2,
	TMNT_ElectricalPanel,
	TMNT_FootSoldierFloor,
	TMNT_Lamp,
	TMNT_Mutagen,
	TMNT_Sewer,
	TMNT_Sword,
	TMNT_TV,
	TMNT_Pizza=260,
	GemPond=262,
	Tent,
	Campfire,
	Torch,
	Gem,
	WallBlock,
	Shadow,
	Column_B,
	Column_L,
	Column_R,
	Column_T,
	Mine_CoalPit,
	Mine_Track_H,
	Mine_Track_V,
	Mine_Track_BL,
	Mine_Track_BR,
	Mine_Track_TL,
	Mine_Track_TR,
	Mine_Cart,
	Mine_Coal,
	Mine_Lava=294,
	Mine_DwarfWorker,
	Mine_GemRock,
	Mine_GemWall,
	StoreSign,
	Mine_Mushrooms,
	Mine_DrawBridgeH,
	Mine_DrawBridgeV,
	WallPitSideB,
	WallPitSideL,
	WallPitSideR,
	WallPitSideT,	
	WallPitCornerBL,
	WallPitCornerBR,
	WallPitCornerTL,
	WallPitCornerTR,
	WallPitInnerBL,
	WallPitInnerBR,
	WallPitInnerTL,
	WallPitInnerTR,
	WishPond,
	Warp,
	SaveTent,
	Frogs
}

enum RoomTemplateClass{
	Main_Upper,
	Main_Lower,
	Stairs,
	Jails,
	Village,
	Mines,
	Obstacles,
	Sections,
	Special,
	Other		
}
#macro RoomTemplateClasses 10

#macro RoomTemplateClasses_MainUpper 2 //2 for 1x1 and 1x2 room sizes
#macro RoomTemplateClasses_MainLower 2
#macro RoomTemplateClasses_Stairs 3 //3 for 1x1, 1x2, 2x1 room sizes
#macro RoomTemplateClasses_Jails 3 //3 for 1x1, 1x2, 2x1 room sizes
#macro RoomTemplateClasses_Sections 3 //3 for 1x1, 1x2, 2x1 room sizes

enum RoomTemplateClass_Obstacles{
	Blocks,	MovingFloors, SpikeBlocks
}
#macro RoomTemplateClasses_Obstacles 3

enum RoomTemplateClass_Special{
	Fairy, Shop, GemPond, Treasure, TreasureLarge, Rupee, Gem, Kinstone
}
#macro RoomTemplateClasses_Special 8

enum RoomTemplateClass_Other{
	Boss, Start, Unique, Save
}
#macro RoomTemplateClasses_Other 4

enum RoomTemplateClass_Village{
	Main, House, Maze, Exit
}
#macro RoomTemplateClasses_Village 4

enum RoomTemplateClass_Mines{
	Main, House
}
#macro RoomTemplateClasses_Mines 2

enum RoomSymetry{
	NonSymetrical,
	Symetrical,
	Full	
}

enum RoomObstacleClass{
	Blocks,
	Holes,
	Spikes,
	MovingFloors,
	SpikeBlocks	
}

enum RoomObstacle{
	Blocks,
	Holes,
	Spikes,
	MovingFloorsHoles,
	MovingFloorsSpikes,
	MovingFloorsSpikeBlocks,
	SpikeBlocks	
}
#macro ObstacleTypes 7

enum Section{
	Main,
	Other
}

enum SectionWallType{
	Rail,
	SwitchBlock
}

function RoomTemplates_Load(){
	
	global.RoomTemplateObjTypes[RoomTemplateClass.Main_Upper] =	["Water", "CarpetsFull", "Carpets", "Spikes", "WallsUpper", "Doors", "ExtraCeilings", "OutOfBounds", "SplitConnections"];	
	global.RoomTemplateObjTypes[RoomTemplateClass.Main_Lower] =	["Water", "CarpetsFull", "Carpets", "Spikes", "WallsLower", "WallsUpper", "Doors", "LowerFloor", "OutOfBounds", "SplitConnections"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Stairs] =		["Water", "Spikes", "WallsLower", "WallsUpper", "WallsCommon", "Stairs", "Doors", "LowerFloor", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Jails] =		["Water", "WallsUpper", "Objs", "Doors", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Obstacles] =	["Pit", "Water", "CarpetsFull", "FloorObjs", "WallsLower", "Holes", "Spikes", "WallsUpper", "WallsCommon", "Doors"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Sections] =	["Pit", "Water", "Spikes", "WallsLower", "Holes", "WallsUpper", "WallsCommon", "Doors", "LowerFloor", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Special] =	["Water", "FloorObjs", "WallsLower", "WallsUpper", "Objs", "Doors", "LowerFloor", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Other] =		["Pit", "Holes", "Water", "FloorObjs", "WallsLower", "WallsUpper", "WallsCommon", "Objs", "Stairs", "Doors", "LowerFloor", "ExtraCeilings", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Village] =	["Pit", "Holes", "Water", "FloorObjs", "WallsLower", "WallsUpper", "WallsCommon", "Objs", "Doors", "LowerFloor", "ExtraCeilings", "OutOfBounds"];
	global.RoomTemplateObjTypes[RoomTemplateClass.Mines] =		["Pit", "Holes", "Water", "FloorObjs", "WallsLower", "WallsUpper", "WallsCommon", "Objs", "Stairs", "Doors", "LowerFloor", "OutOfBounds"];
	
	//make this seperate for each room template type, since not all types need all of these objs, will save on load time
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Main_Upper] =	["SectionArea", "Zones", "Enemies", "SectionWalls", "MovingSpikeBlocks", "RollingSpikes", "GuruBars", "Jails", "Altars", "Kinstones", "Monuments", "Torches", "Crystals", "PotTreasures", "Treasures", "Pots"];
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Main_Lower] =	["Zones", "Enemies", "MovingSpikeBlocks", "GuruBars", "Altars", "Kinstones", "Monuments", "Torches", "Crystals", "PotTreasures", "Treasures", "Pots"];
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Stairs] =		["Zones", "Enemies", "MovingSpikeBlocks", "Altars", "Kinstones", "Monuments", "Torches", "Crystals", "PotTreasures", "Treasures", "Pots"];
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Jails] =		["Zones", "Enemies", "Jails", "Altars", "Kinstones", "Monuments", "Torches", "PotTreasures", "Treasures", "Pots"];
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Obstacles] =	["Zones", "Enemies", "MovingSpikeBlocks", "RollingSpikes", "GuruBars", "Altars", "Kinstones", "Monuments", "Torches", "Crystals", "PotTreasures", "Treasures", "Pots"];
	global.RoomTemplateObjTypes_Section[RoomTemplateClass.Sections] =	["SectionArea", "Enemies", "SectionWalls", "MovingSpikeBlocks", "RollingSpikes", "GuruBars", "Altars", "Kinstones", "Monuments", "Torches", "Crystals", "PotTreasures", "Treasures", "Pots"];


	
	global.RoomTransformTypeList = ds_list_create_sequence(0, TransformTypes - 1);
	
	global.MainSectionIndexes = [1, 2, 9, 17, 21, 25, 27];
		
	// One file per class, in RoomTemplateClass order, written by tools/templates/convert.py
	var _ClassFiles = ["Main_Upper", "Main_Lower", "Stairs", "Jails", "Village", "Mines", "Obstacles", "Sections", "Special", "Other"];
	global.Templates_Room = array_create(RoomTemplateClasses);
	for(var _ClassIndex = 0; _ClassIndex < RoomTemplateClasses; _ClassIndex++){
		var _File = GAMEDIR_ROOMTEMPLATES + _ClassFiles[_ClassIndex] + ".json";
		var _Buffer = buffer_load(_File);
		if(_Buffer == -1){
			Error("Room templates file not found: " + _File, true);
			return;
		}
		global.Templates_Room[_ClassIndex] = json_parse(buffer_read(_Buffer, buffer_string));
		buffer_delete(_Buffer);
	}

	for(var _ClassIndex = 0; _ClassIndex < RoomTemplateClasses; _ClassIndex++){
		var _SubClasses = array_length(global.Templates_Room[_ClassIndex]);
		for(var _SubClassIndex = 0; _SubClassIndex < _SubClasses; _SubClassIndex++){
			global.Templates_Room_Count[_ClassIndex][_SubClassIndex] = array_length(global.Templates_Room[_ClassIndex][_SubClassIndex]);
			global.UnusedRoomTemplatesList[_ClassIndex][_SubClassIndex] = ds_list_create();
		}
	}
	show_debug_message("Room templates loaded: " + json_stringify(global.Templates_Room_Count));

	
}

function RoomTemplate_GetNextIndex(_Class, _SubClass){
	
	
	if(ds_list_size(global.UnusedRoomTemplatesList[_Class][_SubClass]) == 0){
		ds_list_destroy(global.UnusedRoomTemplatesList[_Class][_SubClass]);
		global.UnusedRoomTemplatesList[_Class][_SubClass] = ds_list_create_sequence_shuffled(0, global.Templates_Room_Count[_Class][_SubClass] - 1);
	}
	
	var _NextIndex = global.UnusedRoomTemplatesList[_Class][_SubClass][| 0];
	ds_list_delete(global.UnusedRoomTemplatesList[_Class][_SubClass], 0);
	
	return _NextIndex;
	
}

function RoomTemplates_Pick(_RoomIndex){

	gml_pragma("forceinline");
	
	var _TemplateArray, _TemplateIndex;
	switch(Room.TemplateClass){
		
		case RoomTemplateClass.Special: 				
			return RoomTemplates_PickSpecial(_RoomIndex)
			
		case RoomTemplateClass.Village: 
			
			
			_TemplateArray = global.Templates_Room[RoomTemplateClass.Village][Room.TemplateSubClass]
			for(var _RoomTemplateIndex = 0; _RoomTemplateIndex < global.Templates_Room_Count[RoomTemplateClass.Village][Room.TemplateSubClass]; _RoomTemplateIndex++){
				var _Template = _TemplateArray[_RoomTemplateIndex];
				switch(Room.TemplateSubClass){
					case RoomTemplateClass_Village.Main:
						if(_Template[$ "name"] == string(_RoomIndex)) return _Template;
						break;
					
					case RoomTemplateClass_Village.Exit:
						if(_Template[$ "type"] == "Exit") return _Template;
						break
						
					case RoomTemplateClass_Village.Maze:
						if(_Template[$ "name"] == Room.TemplateName) return _Template;
						break;
						
					case RoomTemplateClass_Village.House:
						if(_Template[$ "type"] == "House"){
							if(GetPropertyValue(_Template[$ "properties"], "House_MapGridX") == Room.GridX && GetPropertyValue(_Template[$ "properties"], "House_MapGridY") == Room.GridY){
								Room.TemplateName = _Template[$ "name"];
								return _Template;
							}
						}
						break;

				}
			}

			break;
		
		case RoomTemplateClass.Mines: 
			
			
			_TemplateArray = global.Templates_Room[RoomTemplateClass.Mines][Room.TemplateSubClass]
			for(var _RoomTemplateIndex = 0; _RoomTemplateIndex < global.Templates_Room_Count[RoomTemplateClass.Mines][Room.TemplateSubClass]; _RoomTemplateIndex++){
				var _Template = _TemplateArray[_RoomTemplateIndex];
				switch(Room.TemplateSubClass){
					case RoomTemplateClass_Mines.Main:
						if(_Template[$ "name"] == string(global.MainTemplates_Mine[Room.GridY][Room.GridX])) return _Template;
						break;

					case RoomTemplateClass_Mines.House:
						if(_Template[$ "type"] == "House"){
							if(GetPropertyValue(_Template[$ "properties"], "House_MapGridX") == Room.GridX && GetPropertyValue(_Template[$ "properties"], "House_MapGridY") == Room.GridY){
								Room.TemplateName = _Template[$ "name"];
								return _Template;
							}
						}
						break;

				}
			}

			break;
		
		case RoomTemplateClass.Other:
			
			_TemplateArray = global.Templates_Room[RoomTemplateClass.Other][Room.TemplateSubClass]
			
			for(var _RoomTemplateIndex = 0; _RoomTemplateIndex < global.Templates_Room_Count[RoomTemplateClass.Other][Room.TemplateSubClass]; _RoomTemplateIndex++){
				
				var _Template = _TemplateArray[_RoomTemplateIndex];
				
				switch(Room.TemplateSubClass){
					
					case RoomTemplateClass_Other.Start:
						switch(_RoomIndex){
							case 0: _TemplateIndex = RoomTemplate_GetIndex(RoomTemplateClass.Other, RoomTemplateClass_Other.Start, "South", "Start"); break;
							case 1: _TemplateIndex = RoomTemplate_GetIndex(RoomTemplateClass.Other, RoomTemplateClass_Other.Start, "North", "Start"); break;
						}
						return global.Templates_Room[RoomTemplateClass.Other][RoomTemplateClass_Other.Start][_TemplateIndex]; 
						
					case RoomTemplateClass_Other.Boss:
					
						switch(global.Level.Index){

							case DungeonLevel.MoldormsLair: 
								_TemplateIndex = RoomTemplate_GetIndex(RoomTemplateClass.Other, RoomTemplateClass_Other.Boss, "Moldorm", "Boss");
								return global.Templates_Room[RoomTemplateClass.Other][RoomTemplateClass_Other.Boss][_TemplateIndex]; 
							
							default:
								_TemplateIndex = RoomTemplate_GetIndex(RoomTemplateClass.Other, RoomTemplateClass_Other.Boss, "Default", "Boss");
								return global.Templates_Room[RoomTemplateClass.Other][RoomTemplateClass_Other.Boss][_TemplateIndex]; 
							
						}
	
						
					case RoomTemplateClass_Other.Unique:
						if(_Template[$ "name"] == Room.TemplateName) return _Template;
						break;
					
					case RoomTemplateClass_Other.Save:
						return global.Templates_Room[RoomTemplateClass.Other][RoomTemplateClass_Other.Save][0]; 
				}
			}			
			break;
					
	}


	var _RoomTemplateClass = Room.TemplateClass;
	var _RoomTemplateSubClass = Room.TemplateSubClass;
	
	var _TemplateCount = global.Templates_Room_Count[_RoomTemplateClass][_RoomTemplateSubClass];

	if(_TemplateCount == 0){
		return -1; //no template available for that template class
	}
	
	var _BuiltInSection, NewRoomTemplate;
	for(var _Tries = 0; _Tries < _TemplateCount * 2; _Tries++){
		
		var TemplateOk = false;
		
		var _RoomTemplateIndex = RoomTemplate_GetNextIndex(_RoomTemplateClass, _RoomTemplateSubClass);	

		var RoomTemplate = global.Templates_Room[_RoomTemplateClass][_RoomTemplateSubClass][_RoomTemplateIndex];
		var _Properties = RoomTemplate[$ "properties"];
		

		if(_RoomTemplateClass == RoomTemplateClass.Sections){
			
			_BuiltInSection = GetPropertyValue(RoomTemplate[$ "properties"], "BuiltInSection");
			
			if(!SectionFamilyCheck(_BuiltInSection, DungeonRoom.Section_ID)) continue;
		
			if(Room.Section_WallType == SectionWallType.SwitchBlock){
				if(GetPropertyValue(_Properties, "SwitchBlock") == -1) continue;
			}
		}
		
		if(_RoomIndex == global.Level.RoomIndex_BossAdjacent && array_length(RoomTemplate[$ "Holes"]) > 0) continue; //Don't pick a template with holes next to boss Room, since holes might take away entrance tiles
		
		ds_list_shuffle(global.RoomTransformTypeList);

		for(var _TransformTypeIndex = 0; _TransformTypeIndex < TransformTypes; _TransformTypeIndex++){
		//for(var _TransformTypeIndex = 0; _TransformTypeIndex < 1; _TransformTypeIndex++){
			
			var _TransformType = global.RoomTransformTypeList[| _TransformTypeIndex];
			
			Room.UnusedZone = -1;
			
			if(!RoomTemplate.RoomTransformationsAllowed[_TransformType]) continue;

			if(_RoomIndex == global.Level.RoomIndex_BossAdjacent){
				if(_TransformType != ObjTransformation.None) continue; //only use templates with no transformations for adjacent boss rooms, that way we can more easily determine if the entrance will fit by setting a allowed property
				if(GetPropertyValue(_Properties, "NoBossAdjacent") != -1) continue;
			}
			
			if( (_RoomTemplateClass == RoomTemplateClass.Main_Upper || _RoomTemplateClass == RoomTemplateClass.Main_Lower) && _RoomTemplateSubClass != RoomSize._1x1){
				
				switch(Room.SizeIndex){
					case RoomSize._1x2:
						//only allow non-rotations for 1x2 rooms since that will change it to a 2x1 room
						switch(_TransformType){
							case ObjTransformation.None: case ObjTransformation.FlipH: case ObjTransformation.FlipV: case ObjTransformation.FlipHV:	
								break;								
							default: 
								continue;								
						}						
						break;
						
					case RoomSize._2x1:
						//only allow rotations for 2x1 rooms since all large templates are 1x2
						switch(_TransformType){
							case ObjTransformation.RotateCW: case ObjTransformation.RotateCCW: case ObjTransformation.FlipHRotateCW: case ObjTransformation.FlipHRotateCCW: 
								break;
							default: 
								continue;
						}
						break;				
				}
					
			}			

			//bitwise check for door match
			var _RoomDoorCode = Room.DoorCode;
			if((RoomTemplate.DoorCode[_TransformType] & _RoomDoorCode) != _RoomDoorCode) continue;
			
			var _SectionOk = true;

			var _MainSectionID = 0;
			
			if(DungeonRoom.Section_ID > 0){

				if(_TransformType == ObjTransformation.None){
					
					if(_RoomTemplateClass == RoomTemplateClass.Sections){
						
						if(_BuiltInSection != DungeonRoom.Section_ID) _SectionOk = false;
						
					}else{
						if(array_get_index(RoomTemplate.Split_MainSectionIDs, DungeonRoom.Section_ID) != -1)
							_MainSectionID = DungeonRoom.Section_ID; //SectionID found in main section ID list, so use that as the _MainSectionID
						else
							_SectionOk = false;
					}
					
				}else{
				
					//go through each of the templates main sections, and determine if the current transformation index will yield the sectionID the room needs
					_SectionOk = false;		
					
					if(_RoomTemplateClass = RoomTemplateClass.Sections){
						
						if(GetTransformedSectionIDReversed(_BuiltInSection, DungeonRoom.Section_ID, Room.SizeIndex == RoomSize._2x1) == _TransformType) _SectionOk = true;
												
					}else{
					
						for(var _MainSectionIDIndex = 1; _MainSectionIDIndex < array_length(RoomTemplate.Split_MainSectionIDs); _MainSectionIDIndex++){

							_MainSectionID = RoomTemplate.Split_MainSectionIDs[_MainSectionIDIndex];
					
							if(_MainSectionID == 0) continue;

							if(GetTransformedSectionIDReversed(_MainSectionID, DungeonRoom.Section_ID, Room.SizeIndex == RoomSize._2x1) == _TransformType){
								_SectionOk = true;
								break;
							}
				
						}
					}
				}
			}
			if(!_SectionOk) continue;

			//bitwise check for doors in zones
		
			var ZonesArray = RoomTemplate[$ "Sections"][Room.Section_ID][$ "Zones"];
			var Zones = array_length(ZonesArray);
			var ZoneStatus = array_create(Zones, false); //holds the array where each index is the zone obj's index to keep track if it's used or not when picking Room templates
			var ZonesLeft = Zones;
			
			var Doors = array_length(Room[$ "Doors"]);
			
			var _MainSectionIDsExist = variable_struct_exists(RoomTemplate, "Split_MainSectionIDs");
			var _MainSectionIDIndex = _MainSectionIDsExist ? array_get_index(RoomTemplate.Split_MainSectionIDs, _MainSectionID) : 0;
			
			if(_RoomIndex == global.Level.RoomIndex_BossAdjacent){ //don't worry about zones for room adjacent to boss room, causes issues with zones and unused doors
				Zones = 0;
				ZonesLeft = 0;
			}
			
			for(var _ZoneIndex = 0; _ZoneIndex < Zones; _ZoneIndex++){
				
				var ZoneCode = RoomTemplate.ZoneCodes[_TransformType][_MainSectionIDIndex][_ZoneIndex];
					
				if(ZoneCode == 0) continue;
				
				for(var _DoorIndex = 0; _DoorIndex < Doors; _DoorIndex++){
					
					var _Door = Room[$ "Doors"][_DoorIndex];
					
					if(_Door.Status == DoorStatus.Unused) continue;
					
					var _DoorBit = power(2, _Door.Position - 1);
					var _DoorInZone = _DoorBit & ZoneCode;
					if(_DoorInZone){
						if(!ZoneStatus[_ZoneIndex]) ZonesLeft--; //only reduce ZonesLeft if that zone hasn't been used yet
						ZoneStatus[_ZoneIndex] = true;						
					}
					
				}
				
			}
			

			if( ZonesLeft > 1 || (ZonesLeft == 1 && StartingRoom)){ //For starting room, doors must be the ones occupying the zones since items aren't generated. 
				continue; //We can't have more than 1 unused zone	
			}

			
			//Store the unused zone into Room.UnusedZone, which will be used in SpawnSpecialObjects
			for(var ZoneIndex = 0; ZoneIndex < Zones; ZoneIndex++){
				if(ZoneStatus[ZoneIndex] == false){
					Room.UnusedZone = ZoneIndex;
					break;
				}
			}							
			
			if(ZonesLeft == 1 && (ZonesArray[Room.UnusedZone][$ "type"] == "NoObjects" || (!Room.BonusTreasure && Room.SpecialObject != SpecialDungeonObj.Crystal && Room.SpecialObject != SpecialDungeonObj.Key && Room.SpecialObject != SpecialDungeonObj.Warp))){
				continue;
			}		




			TemplateOk = true;
			

			NewRoomTemplate = StructCopy(RoomTemplate);
			
			var _TransformTemplate = (_TransformType != ObjTransformation.None || _RoomTemplateClass == RoomTemplateClass.Sections);
			
			if(_TransformTemplate){
			
				switch(_TransformType){
					case ObjTransformation.RotateCW: 
					case ObjTransformation.RotateCCW:
					case ObjTransformation.FlipHRotateCW:
					case ObjTransformation.FlipHRotateCCW:
						NewRoomTemplate.width = RoomTemplate[$ "width"];
						NewRoomTemplate.height = RoomTemplate[$ "height"];
						break;
				}
			
				//Transform main objects
				for(var _ObjTypeIndex = 0; _ObjTypeIndex < array_length(global.RoomTemplateObjTypes[Room.TemplateClass]); _ObjTypeIndex++){
				
					var _ObjType = global.RoomTemplateObjTypes[Room.TemplateClass][_ObjTypeIndex];

					NewRoomTemplate[$ _ObjType] = TransformObjArray(NewRoomTemplate[$ _ObjType], _TransformType, _ObjType, NewRoomTemplate[$ "width"], NewRoomTemplate[$ "height"]);
					
				}

			}
			
			//transform section objs
			var NewSection = NewRoomTemplate[$ "Sections"][DungeonRoom.Section_ID];
			
			if(variable_struct_exists(NewRoomTemplate, "Sections") && _TransformTemplate){
			
				for(var _ObjTypeIndex = 0; _ObjTypeIndex < array_length(global.RoomTemplateObjTypes_Section[Room.TemplateClass]); _ObjTypeIndex++){
				
					var _ObjType = global.RoomTemplateObjTypes_Section[Room.TemplateClass][_ObjTypeIndex];
					var ObjArray = NewRoomTemplate[$ "Sections"][_MainSectionID][$ _ObjType];
				
					var NewObjArray = TransformObjArray(ObjArray, _TransformType, _ObjType, NewRoomTemplate[$ "width"], NewRoomTemplate[$ "height"]);
				
					//clear old objs in the new template section that might still be there before the transformation
					NewSection[$ _ObjType] = array_create(0);
				
					for(var _ObjIndex = 0; _ObjIndex < array_length(NewObjArray); _ObjIndex++){
				
						var _Obj = NewObjArray[_ObjIndex];
						array_push(NewSection[$ _ObjType], StructCopy(_Obj));
				
					}



				}
				
			}

			break;
		
		}

		if(TemplateOk){
			return NewRoomTemplate;
		}

	}
	

	return -1;
			
}

function RoomTemplates_PickSpecial(_RoomIndex){

	
	var SubClassList = ds_list_create();
	
	switch(global.Level.Index){
		
		default:

			ds_list_add(SubClassList,	RoomTemplateClass_Special.Rupee, RoomTemplateClass_Special.Rupee, RoomTemplateClass_Special.Rupee, RoomTemplateClass_Special.Rupee,
										RoomTemplateClass_Special.Gem, RoomTemplateClass_Special.Gem);
										
											
			if(Room.Doors[0].Status == DoorStatus.Secret_Closed){
				ds_list_add(SubClassList,	RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure,
											RoomTemplateClass_Special.Gem);
											
				if(!global.Level.LargeTreasureRoom) ds_list_add(SubClassList, RoomTemplateClass_Special.TreasureLarge,RoomTemplateClass_Special.TreasureLarge,RoomTemplateClass_Special.TreasureLarge);
			}else{

				if(global.Level.Index > DungeonLevel.Castle){
					ds_list_add(SubClassList, RoomTemplateClass_Special.Shop, RoomTemplateClass_Special.Shop, RoomTemplateClass_Special.Shop, RoomTemplateClass_Special.Shop);
					if(global.Level.Index == DungeonLevel.CastleJails){
						ds_list_add(SubClassList, RoomTemplateClass_Special.Shop, RoomTemplateClass_Special.Shop, RoomTemplateClass_Special.Shop); //add a few more shops for jail level since they're harder to create with the limited space
					}
				}
				
				if(Prob(Chance_TreasureRoomNonSecretDoor)) ds_list_add(SubClassList,	RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Treasure);
																						
				if(Prob(Chance_LargeTreasureRoomNonSecretDoor) && !global.Level.LargeTreasureRoom) ds_list_add(SubClassList, RoomTemplateClass_Special.TreasureLarge, RoomTemplateClass_Special.TreasureLarge, RoomTemplateClass_Special.TreasureLarge);
			}
			
			if(global.Level.Index > DungeonLevel.Castle) ds_list_add(SubClassList, RoomTemplateClass_Special.Kinstone);
			
			break;
		
		case DungeonLevel.Village:
			ds_list_add(SubClassList, RoomTemplateClass_Special.Treasure, RoomTemplateClass_Special.Rupee, RoomTemplateClass_Special.Gem);
			break;
			
		case DungeonLevel.Mines:
			ds_list_add(SubClassList, RoomTemplateClass_Special.Gem);
			break;
			
	}

	ds_list_shuffle(SubClassList);
	var _UseList = true;
	
	
	if(Room.FairyOrGemPond){ //if Room is not a secret Room, and door is at bottom, chance to set to either fairy or shop or gem pond
		if(!global.Level.FairyRoom && Prob(Chance_FairyRoom)){
			Room.TemplateSubClass = RoomTemplateClass_Special.Fairy; 
			global.Level.FairyRoom = true; //only allow 1 fairy room per level
			_UseList = false;
		}else if(!global.Level.GemPondRoom){ 
			Room.TemplateSubClass = RoomTemplateClass_Special.GemPond;
			global.Level.GemPondRoom = true; //only allow 1 gem pond room per level
			_UseList = false;
		}
		
	}

	
	while(ds_list_size(SubClassList) > 0){
		
		if(_UseList){
			Room.TemplateSubClass = SubClassList[| 0];
			ds_list_delete(SubClassList, 0);
		}
		
		for(var _Tries = 0; _Tries < global.Templates_Room_Count[RoomTemplateClass.Special][Room.TemplateSubClass] * 2; _Tries++){
		
			var RoomTemplateIndex = RoomTemplate_GetNextIndex(RoomTemplateClass.Special, Room.TemplateSubClass);
			var RoomTemplate = global.Templates_Room[RoomTemplateClass.Special][Room.TemplateSubClass][RoomTemplateIndex];

			//bitwise check for door match
			if((RoomTemplate.DoorCode[ObjTransformation.None] & Room.DoorCode) == Room.DoorCode){
				Room.TemplateIndex = RoomTemplateIndex;
				ds_list_destroy(SubClassList);
				if(Room.TemplateSubClass == RoomTemplateClass_Special.TreasureLarge) global.Level.LargeTreasureRoom = true;
				return RoomTemplate	
			}
			
		}
		
		_UseList = true;
		
	}
	
	ds_list_destroy(SubClassList);
	
	return -1;
	
}

function TemplateCheck(_RoomIndex, _Class, _SubClass, _Name = ""){
	
	if(_RoomIndex == -1) return false
	
	if(_Name != "")	return (Room.TemplateClass == _Class && Room.TemplateSubClass == _SubClass && Room.TemplateName == _Name)	
	else return (Room.TemplateClass == _Class && Room.TemplateSubClass == _SubClass)
}

function RoomTemplate_GetIndex(_Class, _SubClass, _Name = "", _Type = ""){
	
	var _TemplateArray = global.Templates_Room[_Class][_SubClass];
	var _Templates = array_length(_TemplateArray)
	for(var _TemplateIndex = 0; _TemplateIndex < _Templates; _TemplateIndex++){
		var _Template = _TemplateArray[_TemplateIndex];
		if(_Template[$ "name"] == _Name && _Template[$ "type"] == _Type){
			return _TemplateIndex;
		}
		
	}
	
	return -1
	
}

function RoomTemplates_Parse_GenerateObjGrids(_RoomIndex){
	
	//Create grids the size of the Rooms and set every location to true if there a specific obj there.


	var ObjTypeArray = ["OutOfBounds", "ExtraCeilings", "WallsUpper"];

	var ObjTypes = array_length(ObjTypeArray);

	for(var ObjsTypeIndex = 0; ObjsTypeIndex < ObjTypes; ObjsTypeIndex++){
			
		var ObjTypeStr = ObjTypeArray[ObjsTypeIndex];
		
		if(!variable_struct_exists(Room.Template, ObjTypeStr)) continue;
		
		var ObjType = Room.Template[$ ObjTypeStr];		
		
		var ObjCount = array_length(ObjType);

		var ObjGrid = Room.TemplateObjGrid[$ ObjTypeStr];
			
		for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){
			var Obj = ObjType[ObjIndex];
			var ObjGridX =	Obj.x / 8;
			var ObjGridY =	Obj.y / 8;
			var ObjGridW = Obj.width / 8;
			var ObjGridH = Obj.height / 8;
			for(var TileY = 0; TileY < ObjGridH; TileY++){
				for(var TileX = 0; TileX < ObjGridW; TileX++){
					ObjGrid[ObjGridY + TileY][ObjGridX + TileX] = true;
				}				
			}
		}
			
	}

	
}

function RoomTemplates_Parse_GenerateDoorCodes(_Template){
	
	//Generate door codes that will help identify quickly if a room template's doors matches the dungeon room's door.
	//The code is a 24-bit # where each bit starting from the right is a 1 if the template's door at position n exists
	//So if template has a door at positions 1, 3 and 5, the code would be 000000000000000000010101, or = 21
		
	var _Doors = array_length(_Template.Doors);
		
	if(_Doors == 0) exit;
	
	//var _RoomSizeIndex = global.RoomSizeIndex[_Template.width / 256][_Template.height / 256];
	
	var _DoorCode = array_create(TransformTypes); //array of door codes for all troom transformation types

	for(var _DoorIndex = 0; _DoorIndex < _Doors; _DoorIndex++){
			
		var _Door = _Template.Doors[_DoorIndex];

		for(var _Position = 0; _Position < 24; _Position++){
				
			var _Coord = global.DoorCoordinates[_Template.SizeIndex][_Position + 1];
			if(_Door.x == _Coord.x && _Door.y == _Coord.y){
					
				variable_struct_set(_Door, "Position", _Position + 1);
				variable_struct_set(_Door, "Location", _Coord.Location);
				
				for(var _TransformType = 0; _TransformType < TransformTypes; _TransformType++){
					
					if(!_Template.RoomTransformationsAllowed[_TransformType]) continue;
						
					var _NewDoorPos = GetTransformedDoorPosition(_Position + 1, _TransformType);
					_DoorCode[_TransformType] = _DoorCode[_TransformType] | power(2, _NewDoorPos - 1);

				}
					
				break;
					
			}
				
		}

	}
				
	variable_struct_set(_Template, "DoorCode", _DoorCode);


	//Create masks for all zones in each section for each tranform type. If door falls in zone, add a bit, similar to door codes above
	
	var _MainSectionIDsExist = variable_struct_exists(_Template, "Split_MainSectionIDs");
	var _MainSectionIDs = (_MainSectionIDsExist ? array_length(_Template.Split_MainSectionIDs) : 1);
	
	var _ZoneCodes = Array_Create3D(4, _MainSectionIDs, TransformTypes); //array of door codes for all zones for each section IDs for each transformation types. There should never be more than 4 zones needed per template
	
	for(var _TransformType = 0; _TransformType < TransformTypes; _TransformType++){
		
		if(!_Template.RoomTransformationsAllowed[_TransformType]) continue;
		
		for(var _MainSectionIDIndex = 0; _MainSectionIDIndex < _MainSectionIDs; _MainSectionIDIndex++){
							
			var _MainSectionID = _MainSectionIDsExist ? _Template.Split_MainSectionIDs[_MainSectionIDIndex] : 0;
							
			var _ZoneArray = _Template.Sections[_MainSectionID].Zones;
			var _Zones = array_length(_ZoneArray);
							
			for(var _ZoneObjIndex = 0; _ZoneObjIndex < _Zones; _ZoneObjIndex++){
								
				var _Zone = _ZoneArray[_ZoneObjIndex];

				for(var _DoorIndex = 0; _DoorIndex < _Doors; _DoorIndex++){
			
					var _Door = _Template.Doors[_DoorIndex];
					
					var _NewDoorPos = GetTransformedDoorPosition(_Door.Position, _TransformType);
					
					if(rectangle_in_rectangle(_Door.x, _Door.y, _Door.x + _Door.width - 1, _Door.y + _Door.height - 1, _Zone.x, _Zone.y, _Zone.x + _Zone.width - 1, _Zone.y + _Zone.height - 1) > 0){
									
						_ZoneCodes[_TransformType][_MainSectionIDIndex][_ZoneObjIndex] = _ZoneCodes[_TransformType][_MainSectionIDIndex][_ZoneObjIndex] | power(2, _NewDoorPos - 1);
						
					}
					
				}
								
			}
			
							
		}		
		
	}


	variable_struct_set(_Template, "ZoneCodes", _ZoneCodes);


}

function RoomTemplates_GetDoorLevel(_x, _y){
	return (_x == 16 || _y == 16 || _x == 216 || _y == 216 || _x == 472 || _y == 472) ? UPPER : LOWER;
}

function RoomTemplates_FixObjRotation(_Obj){

	//fix rotation from Tiled objects

	if(_Obj[$ "rotation"] == 90 || _Obj[$ "rotation"] == -90){
		var OldW_Temp = _Obj[$ "width"];
		_Obj[$ "width"] = _Obj[$ "height"];
		_Obj[$ "height"] = OldW_Temp;
	}
	
	switch(_Obj[$ "rotation"]){
		case 90:
			_Obj.x -= _Obj.width;
			break;
						
		case -90:
			_Obj.y -= _Obj.height;
			break;
						
		case 180:
			_Obj.x -= _Obj.width;
			_Obj.y -= _Obj.height;
			break;
					
	}
	
}

function ObstacleRoomCheck(_RoomIndex, _ObstacleClass){
	
	if(Room.TemplateClass != RoomTemplateClass.Obstacles) return true;

	return ObstacleClassCheck(_RoomIndex, _ObstacleClass)
	
}

function ObstacleClassCheck(_RoomIndex, _ObstacleClass){
	
	switch(_ObstacleClass){
		case RoomObstacleClass.Blocks:
			return Room.Obstacle == RoomObstacle.Blocks
			
		case RoomObstacleClass.Holes:
			return Room.Obstacle == RoomObstacle.Holes || Room.Obstacle == RoomObstacle.MovingFloorsHoles
		
		case RoomObstacleClass.Spikes:
			return Room.Obstacle == RoomObstacle.Spikes || Room.Obstacle == RoomObstacle.MovingFloorsSpikes
		
		case RoomObstacleClass.MovingFloors:
			return Room.Obstacle == RoomObstacle.MovingFloorsHoles || Room.Obstacle == RoomObstacle.MovingFloorsSpikes || Room.Obstacle == RoomObstacle.MovingFloorsSpikeBlocks
		
		case RoomObstacleClass.SpikeBlocks:
			return Room.Obstacle == RoomObstacle.SpikeBlocks || Room.Obstacle == RoomObstacle.MovingFloorsSpikeBlocks		
		
	}
	
	return false
	
}

function GetPropertyValue(PropertiesArray, PropertyName){
	
	//This function returns the Tiled property value of the property name from a ds list
	
	for(var i = 0; i < array_length(PropertiesArray); i++){
		if(PropertiesArray[i].name == PropertyName)	return PropertiesArray[i].value;
	}
			
	return -1; 

}

function SetPropertyValue(PropertiesArray, PropertyName, NewValue){

	var Properties = array_length(PropertiesArray);
	
	if(Properties == 0) exit;
	
	for(var i = 0; i < Properties; i++){
		if(PropertiesArray[i][$ "name"] == PropertyName){
			PropertiesArray[i][$ "value"] = NewValue;
			break;
		}
	}

}
