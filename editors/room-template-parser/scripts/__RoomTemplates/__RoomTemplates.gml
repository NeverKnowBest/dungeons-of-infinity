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
	GanonHead
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

enum RoomSize{
	_1x1,
	_1x2,
	_2x1,
	_2x2
}
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


function RoomTemplates_Parse(_TemplateClass, _Buffer){

	var _RoomTemplates_JSON = json_parse(buffer_read(_Buffer, buffer_string));
	
	
	var _RoomTemplates_Temp_Count = array_length(_RoomTemplates_JSON[$ "layers"][0][$ "objects"]);
	var _RoomTemplates_Temp = array_create(_RoomTemplates_Temp_Count);
	
	var _MainObjTypeArray = global.RoomTemplateObjTypes[_TemplateClass];
	var _MainObjTypes = array_length(_MainObjTypeArray);
	
	//In the Templates_Room_IDList list, store each Room ID as a key, and the RoomTemplateIndex as the value.
	//Each item in Tiled is linked to the Room they're in so they contain the Room ID. Using a map makes it easy to find the RoomTemplateIndex they're supposed to be in
	var _RoomTemplates_Temp_IDList = ds_list_create();
		
	//Create Room structures
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < _RoomTemplates_Temp_Count; RoomTemplateIndex++){
		
		var jsonRoomObj = _RoomTemplates_JSON[$ "layers"][0][$ "objects"][RoomTemplateIndex];

		var ID = jsonRoomObj.id;
		ds_list_add(_RoomTemplates_Temp_IDList, ID);
		
		_RoomTemplates_Temp[RoomTemplateIndex] = StructCopy(jsonRoomObj);
		var _RoomTemplate = _RoomTemplates_Temp[RoomTemplateIndex];
		
		for(var LayerIndex = 0; LayerIndex < _MainObjTypes; LayerIndex++){
			_RoomTemplate[$ _MainObjTypeArray[LayerIndex]] = array_create(0);
		}
		
		//switch(_TemplateClass){
			
		//	case RoomTemplateClass.Main_Upper:
			
				//create the array holding all 20 sections including main(0), plus objects that are on the section layers
				_RoomTemplate[$ "Sections"] = array_create(31);
				for(var _SectionIndex = 0; _SectionIndex <= 30; _SectionIndex++){
					_RoomTemplate[$ "Sections"][_SectionIndex] = {};
					for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(global.RoomTemplateObjTypes_Section[_TemplateClass]); ObjTypeIndex++){
						_RoomTemplate[$ "Sections"][_SectionIndex][$ global.RoomTemplateObjTypes_Section[_TemplateClass][ObjTypeIndex]] = array_create(0);
					}
				}
				
				var _MainSectionIDs = GetPropertyValue(_RoomTemplate[$ "properties"], "Split_MainSectionIDs");
				if(_MainSectionIDs != -1){
					_RoomTemplate[$ "Split_MainSectionIDs"] = SplitStrToArray(_MainSectionIDs, ",", true);
					array_insert(_RoomTemplate[$ "Split_MainSectionIDs"], 0, 0); //add 0 to the first index for main section
				}
				

		//		break;
			
		//	case RoomTemplateClass.Main_Lower:
		//	case RoomTemplateClass.Stairs:
		//	case RoomTemplateClass.Obstacles:
		//	case RoomTemplateClass.Sections:
		//		//these classes only have a main section
		//		_RoomTemplate[$ "Sections"] = array_create(1);
		//		_RoomTemplate[$ "Sections"][0] = {};
		//		for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(global.RoomTemplateObjTypes_Section); ObjTypeIndex++){
		//			_RoomTemplate[$ "Sections"][0][$ global.RoomTemplateObjTypes_Section[ObjTypeIndex]] = array_create(0);
		//		}
		//		break;
				
		//}

		switch(_TemplateClass){
			case RoomTemplateClass.Main_Upper:
			case RoomTemplateClass.Main_Lower:
				_RoomTemplate[$ "SizeIndex"] = (_RoomTemplate[$ "height"] == 128 ? RoomSize._1x1 : RoomSize._1x2);
				break;
			default:
				_RoomTemplate[$ "SizeIndex"] = global.RoomSizeIndex[_RoomTemplate[$ "width"] / 256][_RoomTemplate[$ "height"] / 256];
				break;
		}
		
		//_RoomTemplate[$ "RoomTransformation"] = ObjTransformation.None;
		
		_RoomTemplate[$ "RoomTransformationsAllowed"] = array_create(8, true);
		
	}
	
	
	//Add main objects to Room structures
	for(var ObjTypeIndex = 0; ObjTypeIndex < _MainObjTypes; ObjTypeIndex++){
		
		var ObjTypeArray = _RoomTemplates_JSON[$ "layers"][ObjTypeIndex + 1][$ "objects"]; //adding 1 because layer 0 in json struct is the Rooms layer
		
		for(var ObjIndex = 0; ObjIndex < array_length(ObjTypeArray); ObjIndex++){
			
			var Obj = ObjTypeArray[ObjIndex];
			var Properties = Obj[$ "properties"];
			var _RoomID = GetPropertyValue(Properties, "Room");

			if(_RoomID == -1){
				Error("Room ID not found for Obj ID: " + string(Obj[$ "id"]), true);
				exit;
			}
			
			var RoomTemplateIndex = ds_list_find_index(_RoomTemplates_Temp_IDList, _RoomID);
			var TemplateObjArray = _RoomTemplates_Temp[RoomTemplateIndex][$ _MainObjTypeArray[ObjTypeIndex]];
			var ArreyLen = array_length(TemplateObjArray);
			
			RoomTemplates_FixObjRotation(Obj);
			
			//Subtract RoomX and RoomY to place the objects relative to (0,0)
			Obj.x -= _RoomTemplates_JSON[$ "layers"][0][$ "objects"][RoomTemplateIndex].x;
			Obj.y -= _RoomTemplates_JSON[$ "layers"][0][$ "objects"][RoomTemplateIndex].y;			
			
			array_insert(TemplateObjArray, ArreyLen, Obj);
			
		}
	}
	
	
	
	//Add Sections objects
	
	switch(_TemplateClass){
		
		case RoomTemplateClass.Main_Upper:
		case RoomTemplateClass.Main_Lower:
		case RoomTemplateClass.Stairs:
		case RoomTemplateClass.Jails:
		case RoomTemplateClass.Obstacles:
		case RoomTemplateClass.Sections:

			for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(global.RoomTemplateObjTypes_Section[_TemplateClass]); ObjTypeIndex++){

				for(var SectionClassIndex = 0; SectionClassIndex < 5; SectionClassIndex++){
			
					if(SectionClassIndex > 0 && _TemplateClass != RoomTemplateClass.Main_Upper) break;
			
					var _jsonSectionArray = _RoomTemplates_JSON[$ "layers"][global.RoomTemplateSectionLayerIndex[_TemplateClass]][$ "layers"][SectionClassIndex][$ "layers"];
		
					var ObjTypeArray = _jsonSectionArray[ObjTypeIndex][$ "objects"];

					var ObjsOnLayer = array_length(ObjTypeArray);

					for(var ObjIndex = 0; ObjIndex < ObjsOnLayer; ObjIndex++){
			
						var Obj = ObjTypeArray[ObjIndex];
						var ObjProperties = Obj[$ "properties"];
						var _RoomID = GetPropertyValue(ObjProperties, "Room");
						if(_RoomID == -1){
							Error("Room ID not found for Obj ID: " + string(Obj[$ "id"]), true);
							exit;
						}
			
			//			if(ObjTypeIndex == jsonLayer_RoomTemplate_Section.Monuments){
			//				variable_struct_set(Obj, "ObjAllowed", true);				
			//			}
				
						var _RoomTemplateIndex = ds_list_find_index(_RoomTemplates_Temp_IDList, _RoomID);
				
						var _RoomTemplate = _RoomTemplates_JSON[$ "layers"][0][$ "objects"][_RoomTemplateIndex];

						RoomTemplates_FixObjRotation(Obj);
				
						//Subtract RoomX and RoomY to place the objects relative to (0,0)
						Obj.x -= _RoomTemplate.x;
						Obj.y -= _RoomTemplate.y;
			
						var _SectionIndex = (_TemplateClass == RoomTemplateClass.Main_Upper ? _RoomTemplates_Temp[_RoomTemplateIndex][$ "Split_MainSectionIDs"][SectionClassIndex] : 0);

						var TemplateObjArray = _RoomTemplates_Temp[_RoomTemplateIndex][$ "Sections"][_SectionIndex][$ global.RoomTemplateObjTypes_Section[_TemplateClass][ObjTypeIndex]];
						var ArreyLen = array_length(TemplateObjArray);
						array_insert(TemplateObjArray, ArreyLen, Obj);

					}
	
				}
		
			}
			
			break;
	
	}
	
	ds_list_destroy(_RoomTemplates_Temp_IDList);
	delete _RoomTemplates_JSON;
	
	
	for(var RoomTemplateIndex_Main = 0; RoomTemplateIndex_Main < _RoomTemplates_Temp_Count; RoomTemplateIndex_Main++){
		
		var _RoomTemplate_Main = _RoomTemplates_Temp[RoomTemplateIndex_Main];
		
		var Properties_Main = _RoomTemplate_Main[$ "properties"];	
		
		//depending on the class and room name, put template in different places in array
		switch(_TemplateClass){
			
			case RoomTemplateClass.Main_Upper:	
			case RoomTemplateClass.Main_Lower:	
			case RoomTemplateClass.Stairs:	
			case RoomTemplateClass.Jails:	
			case RoomTemplateClass.Sections:	
				var _FinalTemplateArray = global.Templates_Room[_TemplateClass][_RoomTemplate_Main.SizeIndex];
				break;
			
			case RoomTemplateClass.Obstacles:
				switch(_RoomTemplate_Main[$ "type"]){
					case "Blocks":			var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Obstacles.Blocks]; break;
					case "MovingFloors":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Obstacles.MovingFloors]; break;
					case "SpikeBlocks":		var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Obstacles.SpikeBlocks]; break;
				}
				break;
				
			case RoomTemplateClass.Special:
				switch(_RoomTemplate_Main[$ "type"]){
					case "Fairy":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Fairy]; break;
					case "Shop":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Shop]; break;
					case "GemPond":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.GemPond]; break;
					case "Treasure":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Treasure]; break;
					case "TreasureLarge": var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.TreasureLarge]; break;
					case "Rupee":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Rupee]; break;
					case "Gem":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Gem]; break;
					case "Kinstone":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Special.Kinstone]; break;

				}
				break;
				
			case RoomTemplateClass.Other:
				switch(_RoomTemplate_Main[$ "type"]){
					case "Boss":		var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Other.Boss]; break;
					case "Start":		var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Other.Start]; break;
					case "Unique":		var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Other.Unique]; break;
					case "Save":		var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Other.Save]; break;
				}
				break;
				
			case RoomTemplateClass.Village:
				switch(_RoomTemplate_Main[$ "type"]){
					case "House":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Village.House]; break;
					case "Main":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Village.Main]; break;
					case "Maze":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Village.Maze]; break;
					case "Exit":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Village.Exit]; break;
				}
				break;
				
			case RoomTemplateClass.Mines:
				switch(_RoomTemplate_Main[$ "type"]){
					case "House":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Mines.House]; break;
					case "Main":	var _FinalTemplateArray = global.Templates_Room[_TemplateClass][RoomTemplateClass_Mines.Main]; break;
				}
				break;
				
		}
		
		
		var _RoomSymetry_Main = GetPropertyValue(Properties_Main, "Symetry");
		
		switch(_TemplateClass){
			
			case RoomTemplateClass.Village:
			case RoomTemplateClass.Mines:
			case RoomTemplateClass.Other:
			
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipH] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipV] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHV] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCCW] = false;
				array_push(_FinalTemplateArray, StructCopy(_RoomTemplate_Main));
				break;
				
			case RoomTemplateClass.Obstacles:
			case RoomTemplateClass.Sections:
			case RoomTemplateClass.Special:
				RoomTemplates_Parse_GenerateDoorCodes(_RoomTemplate_Main, _TemplateClass);
				array_push(_FinalTemplateArray, StructCopy(_RoomTemplate_Main));
				break;

			case RoomTemplateClass.Jails:
				if(_RoomSymetry_Main == 1){ //symetrical horizontally
					_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipH] = false;
				}
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipV] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHV] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCCW] = false;
				
				RoomTemplates_Parse_GenerateDoorCodes(_RoomTemplate_Main, _TemplateClass);
				
				array_push(_FinalTemplateArray, StructCopy(_RoomTemplate_Main));				
				break;
			
			case RoomTemplateClass.Stairs:
				
				//no stair rooms have any rotations
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.RotateCCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCW] = false;
				_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHRotateCCW] = false;
				
				if(_RoomSymetry_Main == 1){ //symetrical horizontally
					_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipH] = false;
					_RoomTemplate_Main.RoomTransformationsAllowed[ObjTransformation.FlipHV] = false;
				}
				
				RoomTemplates_Parse_GenerateDoorCodes(_RoomTemplate_Main, _TemplateClass);
				
				array_push(_FinalTemplateArray, StructCopy(_RoomTemplate_Main));
				
				break;

				
			case RoomTemplateClass.Main_Upper:
			case RoomTemplateClass.Main_Lower:
				
				//go through each combination of rooms that can fit, and for those that do, flipV the 2nd and combine them int the final room template array
	
				//When both splits have Symetry property = 0, then add another copy with the 2nd template flipped horizontally.
				//Note: only templates that have their connections equidistant from room's horizontal half point should have this property. 
				//Otherwise you can't just have either the main or 2nd split be horizontally flipped to create a new template since connections won't match.
				//Those rooms have a symetry set to -1

		
				for(var RoomTemplateIndex_2nd = RoomTemplateIndex_Main; RoomTemplateIndex_2nd < _RoomTemplates_Temp_Count; RoomTemplateIndex_2nd++){

					var _RoomTemplate_2nd = _RoomTemplates_Temp[RoomTemplateIndex_2nd];
		
					if(_RoomTemplate_Main[$ "height"] != _RoomTemplate_2nd[$ "height"]) continue;

					
					//check if split connections fit
					for(var _MainRoomSplitConnectionIndex = 0; _MainRoomSplitConnectionIndex < 2; _MainRoomSplitConnectionIndex++){
						
						var _MainRoomConnection = _RoomTemplate_Main[$ "SplitConnections"][_MainRoomSplitConnectionIndex];
				
						var Fit = false;
				
						for(var _2ndRoomSplitConnectionIndex = 0; _2ndRoomSplitConnectionIndex < 2; _2ndRoomSplitConnectionIndex++){
					
							var _2ndRoomConnection = _RoomTemplate_2nd[$ "SplitConnections"][_2ndRoomSplitConnectionIndex];
							
							if(_MainRoomConnection.x == _2ndRoomConnection.x && _MainRoomConnection.y == _2ndRoomConnection.y){
								Fit = true;
								break;
							}
						}
				
						if(!Fit) break;
				
					}

					if(!Fit) continue;
					
					
					//found a 2nd room where connections fit, flipV 2nd room and objs and merge main and 2nd into 1 room
			
					//copy room template struct of main template as a new template in global.Templates_Room. Secondary objs will be added to this one

					var Properties_2nd = _RoomTemplate_2nd[$ "properties"];	
					
					var _RoomSymetry_2nd = GetPropertyValue(Properties_2nd, "Symetry");
					
					var _AddFlipHRoom = (_RoomSymetry_Main == 0 && _RoomSymetry_2nd == 0);
					var _RoomsToAdd = (_AddFlipHRoom ? 2 : 1);
					repeat(_RoomsToAdd){ 
						
						
						//when this rooms is connected with itself with no flip, it resembles 32820 and 32847. 11115 doesn't create zones properly, but the other 2 does, so don't create 11115 room with mirror of itself
						if(_RoomTemplate_Main.id == 11115 && _RoomTemplate_2nd.id == 11115 && !_AddFlipHRoom) continue;
						
						
						var _NewTemplate = StructCopy(_RoomTemplate_Main);				

						//Create new struct to hold a copy of the 2nd Room. Then we transform the copy.
						var _RoomTemplate_2ndCopy = StructCopy(_RoomTemplate_2nd);
						
						if(_AddFlipHRoom){
							_2ndRoomFlipType = ObjTransformation.FlipHV;
							_AddFlipHRoom = false;
						}else{
							var _2ndRoomFlipType = ObjTransformation.FlipV;
						}
						
						RoomTemplates_Parse_SplitRoom_AddObjs(_NewTemplate, _RoomTemplate_2ndCopy, _MainObjTypeArray, _2ndRoomFlipType, _TemplateClass);
						
						RoomTemplates_Parse_SplitRoom_FixRoom(_NewTemplate, _2ndRoomFlipType, _TemplateClass);
						
						RoomTemplates_Parse_GenerateDoorCodes(_NewTemplate, _TemplateClass);

						array_push(_FinalTemplateArray, StructCopy(_NewTemplate));

						delete _NewTemplate
						delete _RoomTemplate_2ndCopy
						
					}

				}
				

				break;
			
		}

	}
	
	RoomTemplates_GenerateImageSheet()
	
}	

function RoomTemplates_Parse_SplitRoom_AddObjs(_MainTemplate, _2ndTemplate, _ObjTypeArray, _FlipType, _TemplateClass){

	
	var _TemplateH = _MainTemplate[$ "height"];
	
	_MainTemplate[$ "height"] *= 2;	//enlarge main template to allow the flipped 2nd room below it
	
	var _ObjTypes = array_length(_ObjTypeArray);
	
	for(var _ObjTypeIndex = 0; _ObjTypeIndex < _ObjTypes; _ObjTypeIndex++){
						
		var _ObjType = _ObjTypeArray[_ObjTypeIndex];				
		
		//Flips objs first
		var ObjArray = _2ndTemplate[$ _ObjType];	
		
		var NewObjArray = TransformObjArray(ObjArray, _FlipType, _ObjType, 256, _TemplateH);
							
		//add secondary objs to main template
		var Objs = array_length(NewObjArray);
		for(var _ObjIndex = 0; _ObjIndex < Objs; _ObjIndex++){
							
			var _Obj = NewObjArray[_ObjIndex];
			array_push(_MainTemplate[$ _ObjType], StructCopy(_Obj));
							
			//Shift secondary template objs to new positions
			var _NewObj = _MainTemplate[$ _ObjType][array_length(_MainTemplate[$ _ObjType]) - 1];
			_NewObj.y += _TemplateH;
							
		}

	}
	
	//sections

	var _MainTemplate_MainSection = _MainTemplate[$ "Sections"][0];
	var _2ndTemplate_MainSection = _2ndTemplate[$ "Sections"][0];
	
	var _SectionObjTypes = array_length(global.RoomTemplateObjTypes_Section[_TemplateClass]);


	//add transformed sections from 2nd template to main template
	
	var _NewSectionIDs = array_create(0); //When the 2nd room section is flipped and copied, keep track of the new sections being created. Will be added to _MainTemplate.Split_MainSectionIDs in the end

	for(var _2ndSectionIDIndex = 1; _2ndSectionIDIndex <= 4; _2ndSectionIDIndex++){
		
		var _OldSectionID = _2ndTemplate.Split_MainSectionIDs[_2ndSectionIDIndex];
		if(_OldSectionID == 0) continue;

		var _Section_2nd = _2ndTemplate[$ "Sections"][_OldSectionID];

		var _NewSectionID = GetTransformedSectionID(_OldSectionID, _FlipType);
		var _NewSection_Main = _MainTemplate[$ "Sections"][_NewSectionID];

		for(var _ObjTypeIndex = 0; _ObjTypeIndex < _SectionObjTypes; _ObjTypeIndex++){
			
			var _ObjType = global.RoomTemplateObjTypes_Section[_TemplateClass][_ObjTypeIndex];

			var ObjArray_2nd = _Section_2nd[$ _ObjType];

			var NewObjArray = TransformObjArray(ObjArray_2nd, _FlipType, _ObjType, 256, _TemplateH);
			var Objs = array_length(NewObjArray);
				
			for(var _ObjIndex = 0; _ObjIndex < Objs; _ObjIndex++){
				
				var _Obj = NewObjArray[_ObjIndex];
				
				array_push(_NewSection_Main[$ _ObjType], StructCopy(_Obj));

				var _NewObj = _NewSection_Main[$ _ObjType][array_length(_NewSection_Main[$ _ObjType]) - 1];

				//Shift obj to new positions
				_NewObj.y += _TemplateH;
				
			}

				
		}	
			
		array_push(_NewSectionIDs, _NewSectionID);

		
	}
	
	//at this point, the main template's original sections don't have objs on the bottom half
	//and also the new sections in the main template that were added from 2nd template don't have any items in the top half.
	//So add section 0 objs from either main or 2nd template to fill those areas
	
	//Add objs to MainTemplate original sections from 2ndTemplate flipped section 0
	for(var _MainSectionIDIndex = 1; _MainSectionIDIndex <= 4; _MainSectionIDIndex++){
		
		var _SectionID = _MainTemplate.Split_MainSectionIDs[_MainSectionIDIndex];
		if(_SectionID == 0) continue;
		
		var _Section_Main = _MainTemplate[$ "Sections"][_SectionID];

		for(var _ObjTypeIndex = 0; _ObjTypeIndex < _SectionObjTypes; _ObjTypeIndex++){
			
			var _ObjType = global.RoomTemplateObjTypes_Section[_TemplateClass][_ObjTypeIndex];

			var ObjArray_2nd = _2ndTemplate_MainSection[$ _ObjType];

			var NewObjArray = TransformObjArray(ObjArray_2nd, _FlipType, _ObjType, 256, _TemplateH);
			var Objs = array_length(NewObjArray);
				
			for(var _ObjIndex = 0; _ObjIndex < Objs; _ObjIndex++){
				
				var _Obj = NewObjArray[_ObjIndex];
				
				array_push(_Section_Main[$ _ObjType], StructCopy(_Obj));

				var _NewObj = _Section_Main[$ _ObjType][array_length(_Section_Main[$ _ObjType]) - 1];

				//Shift obj to new positions
				_NewObj.y += _TemplateH;
				
			}

				
		}	
		
	}	
	
	
	//Add objs to new MainTemplate sections in the top half from main template section 0
	var _NewSectionIDCount = array_length(_NewSectionIDs);
	for(var _NewSectionIDIndex = 0; _NewSectionIDIndex < _NewSectionIDCount; _NewSectionIDIndex++){
		
		var _NewSectionID = _NewSectionIDs[_NewSectionIDIndex];
		
		var _Section_Main = _MainTemplate[$ "Sections"][_NewSectionID];

		for(var _ObjTypeIndex = 0; _ObjTypeIndex < _SectionObjTypes; _ObjTypeIndex++){
			
			var _ObjType = global.RoomTemplateObjTypes_Section[_TemplateClass][_ObjTypeIndex];

			var ObjArray = _MainTemplate_MainSection[$ _ObjType];

			var Objs = array_length(ObjArray);
				
			for(var _ObjIndex = 0; _ObjIndex < Objs; _ObjIndex++){
				
				var _Obj = ObjArray[_ObjIndex];
				
				array_push(_Section_Main[$ _ObjType], StructCopy(_Obj));
				
			}

				
		}	
		
	}


	//Add main objs from 2nd template section 0 to main template section 0
	for(var _ObjTypeIndex = 0; _ObjTypeIndex < _SectionObjTypes; _ObjTypeIndex++){
			
		var _ObjType = global.RoomTemplateObjTypes_Section[_TemplateClass][_ObjTypeIndex];

		var ObjArray_2nd = _2ndTemplate_MainSection[$ _ObjType];

		var NewObjArray = TransformObjArray(ObjArray_2nd, _FlipType, _ObjType, 256, _TemplateH);
		var Objs = array_length(NewObjArray);
				
		for(var _ObjIndex = 0; _ObjIndex < Objs; _ObjIndex++){
				
			var _Obj = NewObjArray[_ObjIndex];
				
			array_push(_MainTemplate_MainSection[$ _ObjType], StructCopy(_Obj));

			var _NewObj = _MainTemplate_MainSection[$ _ObjType][array_length(_MainTemplate_MainSection[$ _ObjType]) - 1];

			//Shift obj to new positions
			_NewObj.y += _TemplateH;
				
		}

				
	}
	
	//join new section IDs to main section ID array
	_MainTemplate.Split_MainSectionIDs = array_concat(_MainTemplate.Split_MainSectionIDs, _NewSectionIDs);
	array_sort(_MainTemplate.Split_MainSectionIDs, true);

}

function RoomTemplates_Parse_SplitRoom_FixRoom(_NewTemplate, _FlipType, _TemplateClass){

	RoomTemplates_Parse_SplitRoom_CombineWalls(_NewTemplate, "WallsUpper");
	if(_TemplateClass == RoomTemplateClass.Main_Lower){
		RoomTemplates_Parse_SplitRoom_CombineWalls(_NewTemplate, "WallsLower"); //also combine the lower walls if they exist
	}
	RoomTemplates_Parse_SplitRoom_MergeDoors(_NewTemplate);	
	RoomTemplates_Parse_SplitRoom_FixCarpets(_NewTemplate, _FlipType);
	
}

function RoomTemplates_Parse_SplitRoom_CombineWalls(_NewTemplate, _WallType){
	
	//combine walls that touch/connect rooms into 1 wall

	var _WallArray = _NewTemplate[$ _WallType];

	do{
							
		var _WallCombined = false;
							
		var _Walls = array_length(_WallArray);
						
		for(var _WallIndex1 = 0; _WallIndex1 < _Walls; _WallIndex1++){
							
			var _Wall1 = _WallArray[_WallIndex1];
			
			//check only walls that connect vertically
			if(_Wall1.gid != TemplateObjGID.WallSideL && _Wall1.gid != TemplateObjGID.WallSideR && _Wall1.gid != TemplateObjGID.WallLowerSideL && _Wall1.gid != TemplateObjGID.WallLowerSideR) continue;
			
			var _Wall1_X1 = _Wall1.x;
			var _Wall1_Y1 = _Wall1.y;
			var _Wall1_X2 = _Wall1_X1 + _Wall1.width - 1;
			var _Wall1_Y2 = _Wall1_Y1 + _Wall1.height - 1;
							
			for(var _WallIndex2 = 0; _WallIndex2 < _Walls; _WallIndex2++){
								
				var _Wall2 = _WallArray[_WallIndex2];
				
				if(_Wall1 == _Wall2) continue;
				
				//check only walls that connect vertically
				if(_Wall2.gid != TemplateObjGID.WallSideL && _Wall2.gid != TemplateObjGID.WallSideR && _Wall2.gid != TemplateObjGID.WallLowerSideL && _Wall2.gid != TemplateObjGID.WallLowerSideR) continue;
				
				var _Wall2_X1 = _Wall2.x;
				var _Wall2_Y1 = _Wall2.y;
				var _Wall2_X2 = _Wall2_X1 + _Wall2.width - 1;
				var _Wall2_Y2 = _Wall2_Y1 + _Wall2.height - 1;
				
				if(_Wall1.gid == _Wall2.gid){
					
					var _Wall1_2Check = (_Wall1_Y2 == _Wall2_Y1 - 1);
					var _Wall2_1Check = (_Wall2_Y2 == _Wall1_Y1 - 1);
					
					if(_Wall1_X1 == _Wall2_X1 && _Wall1_X2 == _Wall2_X2 && (_Wall1_2Check || _Wall2_1Check)){
						if(_Wall1_2Check){
							_Wall1.height += _Wall2.height;
							array_delete(_WallArray, _WallIndex2, 1);
						}else if(_Wall2_1Check){
							_Wall2.height += _Wall1.height;
							array_delete(_WallArray, _WallIndex1, 1);
						}
						_WallCombined = true;
						break;
					}
				}

			}
								
			if(_WallCombined) break;
								
		}
						
	}until(!_WallCombined)

		
}

function RoomTemplates_Parse_SplitRoom_MergeDoors(_NewTemplate){
	
	//Edge doors may overlap after combining, find duplicates and delete them

	var _DoorArray = _NewTemplate[$ "Doors"];

	do{
							
		var _DoorRemoved = false;
							
		var _Doors = array_length(_DoorArray);
						
		for(var _DoorIndex1 = 0; _DoorIndex1 < _Doors - 1; _DoorIndex1++){
							
			var _Door1 = _DoorArray[_DoorIndex1];

			for(var _DoorIndex2 = _DoorIndex1 + 1; _DoorIndex2 < _Doors; _DoorIndex2++){
								
				var _Door2 = _DoorArray[_DoorIndex2];

				if(_Door1.gid == _Door2.gid){

					if(_Door1.x == _Door2.x && _Door1.y == _Door2.y){
						array_delete(_DoorArray, _DoorIndex2, 1);
						_DoorRemoved = true;
						break;
					}

				}
			}
								
			if(_DoorRemoved) break;
								
		}
						
	}until(!_DoorRemoved)
	
}

function RoomTemplates_Parse_SplitRoom_FixCarpets(_NewTemplate, _FlipType){
	
	var _CarpetArray = _NewTemplate[$ "Carpets"];
	var _CarpetCount = array_length(_CarpetArray);
	
	if(_CarpetCount == 0) exit;
	
	
	//find where 2nd template carpets start

	var _2ndCarpetsIndex = -1;
	
	var _TemplateHeightHalf = _NewTemplate.height / 2;
	
	for(var _CarpetIndex = 0; _CarpetIndex < _CarpetCount; _CarpetIndex++){
		
		var _Carpet = _CarpetArray[_CarpetIndex];
		
		if(_Carpet.y < _TemplateHeightHalf && _Carpet.y + _Carpet.height > _TemplateHeightHalf) continue; //don't look at carpets that are split between both halfs
		
		if(_Carpet.y >= _TemplateHeightHalf && _2ndCarpetsIndex == -1){
			_2ndCarpetsIndex = _CarpetIndex;
		}
		
	}
	
	var _FromDoors_Old = array_create(_CarpetCount);
	var _ToDoors_Old = array_create(_CarpetCount);	
	var _FromDoors_New = array_create(_CarpetCount);
	var _ToDoors_New = array_create(_CarpetCount);	
	
	//convert door codes to array, transform 2nd template codes also
	for(var _CarpetIndex = 0; _CarpetIndex < _CarpetCount; _CarpetIndex++){
		
		var _Carpet = _CarpetArray[_CarpetIndex];
		var _PropertyArray = _Carpet[$ "properties"];
		
		var _DoorsFromStr = GetPropertyValue(_PropertyArray, "DoorsFrom");
		var _DoorsToStr = GetPropertyValue(_PropertyArray, "DoorsTo");

		_FromDoors_Old[_CarpetIndex] = _DoorsFromStr == -1 ? [] : SplitStrToArray(_DoorsFromStr, ",", true);
		_ToDoors_Old[_CarpetIndex] = _DoorsToStr == -1 ? [] : SplitStrToArray(_DoorsToStr, ",", true);		
		
		_FromDoors_New[_CarpetIndex] = array_create(0);
		_ToDoors_New[_CarpetIndex] = array_create(0);
		
		array_copy(_FromDoors_New[_CarpetIndex], 0, _FromDoors_Old[_CarpetIndex], 0, array_length(_FromDoors_Old[_CarpetIndex]));
		array_copy(_ToDoors_New[_CarpetIndex], 0, _ToDoors_Old[_CarpetIndex], 0, array_length(_ToDoors_Old[_CarpetIndex]));
		
	}
	

	
	for(var _CarpetIndex_Main = 0; _CarpetIndex_Main < _2ndCarpetsIndex; _CarpetIndex_Main++){

		//copy all From & To door codes from 2nd to main To array
		for(var _CarpetIndex_2nd = _2ndCarpetsIndex; _CarpetIndex_2nd < _CarpetCount; _CarpetIndex_2nd++){
			
			_ToDoors_New[_CarpetIndex_Main] = array_concat(_ToDoors_New[_CarpetIndex_Main], _FromDoors_Old[_CarpetIndex_2nd]);

			_ToDoors_New[_CarpetIndex_Main] = array_concat(_ToDoors_New[_CarpetIndex_Main], _ToDoors_Old[_CarpetIndex_2nd]);
			
		}

	}
	
	for(var _CarpetIndex_2nd = _2ndCarpetsIndex; _CarpetIndex_2nd < _CarpetCount; _CarpetIndex_2nd++){

		//copy all From & To door codes from Main to 2nd To array
		for(var _CarpetIndex_Main = 0; _CarpetIndex_Main < _2ndCarpetsIndex; _CarpetIndex_Main++){

			_ToDoors_New[_CarpetIndex_2nd] = array_concat(_ToDoors_New[_CarpetIndex_2nd], _FromDoors_Old[_CarpetIndex_Main]);

			_ToDoors_New[_CarpetIndex_2nd] = array_concat(_ToDoors_New[_CarpetIndex_2nd], _ToDoors_Old[_CarpetIndex_Main]);
			
		}

	}
	
	//remove duplicates and set properties with new csv's
	
	for(var _CarpetIndex = 0; _CarpetIndex < _CarpetCount; _CarpetIndex++){
		
		var _Carpet = _CarpetArray[_CarpetIndex];
		
		_FromDoors_New[_CarpetIndex] = array_unique(_FromDoors_New[_CarpetIndex]);
		var _FromStr = ArrayToCSV(_FromDoors_New[_CarpetIndex]);
		SetPropertyValue(_Carpet[$ "properties"], "DoorsFrom", _FromStr);
		
		_ToDoors_New[_CarpetIndex] = array_unique(_ToDoors_New[_CarpetIndex]);
		var _ToStr = ArrayToCSV(_ToDoors_New[_CarpetIndex]);
		SetPropertyValue(_Carpet[$ "properties"], "DoorsTo", _ToStr);

	}
	
	
	
}

function RoomTemplates_GenerateImageSheet(){
	
	var RoomW = 64;

	var RoomGridW = 32;
	var RoomGridH = 64;
	
	var ImageW = RoomW * RoomGridW;
	var ImageH = RoomW * RoomGridH;
	
	var ImageSheetSurface = surface_create(ImageW, ImageH);
	
	surface_set_target(ImageSheetSurface);
	draw_clear_alpha(c_black, 0);
	
	var PosIndex = 0;
	//for(var _RoomTemplateClassIndex = 0; _RoomTemplateClassIndex < RoomTemplateClasses; _RoomTemplateClassIndex++){
		
		for(var RoomTemplateIndex = 0; RoomTemplateIndex < array_length(global.Templates_Room[0][0]); RoomTemplateIndex++){	
		
			var Template = global.Templates_Room[0][0][RoomTemplateIndex];
		
			//if(Template[$ "type"] != "SplitRoom") continue;
		
			var SprPosX = (PosIndex mod RoomGridW) * RoomW;
			var SprPosY = (PosIndex div RoomGridW) * RoomW;
		
			draw_sprite(Template.RoomMapSpr, 0, SprPosX, SprPosY);
		
			PosIndex++;
		
		}
		
	//}
	
	var FullSheetSpr = sprite_create_from_surface(ImageSheetSurface, 0, 0, ImageW, ImageH, false, false, 0, 0);
	surface_reset_target();
	surface_free(ImageSheetSurface);
	
	sprite_save(FullSheetSpr, 0, "C:\\Omnitron\\Zelda\\" + "TemplateSheet.png");
	sprite_delete(FullSheetSpr);
	
}

function RoomTemplates_Parse_GenerateDoorCodes(_Template, _TemplateClass){
	
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

	switch(_TemplateClass){ //these template classes don't have zones
		case RoomTemplateClass.Special:
		case RoomTemplateClass.Sections:
			exit;
			break;
	}
	
	//Create masks for all zones in each section for each tranform type. If door falls in zone, add a bit, similar to door codes above
	
	var _MainSectionIDsExist = variable_struct_exists(_Template, "Split_MainSectionIDs");
	var _MainSectionIDs = (_MainSectionIDsExist ? array_length(_Template.Split_MainSectionIDs) : 1);
	
	var _ZoneCodes = Array_Create3D(4, _MainSectionIDs, TransformTypes); //array of door codes for all zones for each section IDs for each transformation types. There should never be more than 4 zones needed per template
	
	for(var _TransformType = 0; _TransformType < TransformTypes; _TransformType++){
		
		if(!_Template.RoomTransformationsAllowed[_TransformType]) continue;
		
		for(var _MainSectionIDIndex = 0; _MainSectionIDIndex < _MainSectionIDs; _MainSectionIDIndex++){
							
			var _MainSectionID = _MainSectionIDsExist ? _Template.Split_MainSectionIDs[_MainSectionIDIndex] : 0;
			
			var _SectionsArray = _Template.Sections;
			var _ZoneArray = _SectionsArray[_MainSectionID].Zones;
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

function Data_InitDoorCoordinates(){
	
	global.DoorCoordinates = Array_Create2D(24, 4);
	
	XYArray[RoomSize._1x1] = [168, 16,		//1
							  216, 56,
							  216, 112,
							  216, 168,
							  168, 216,
							  112, 216,		//6
							  56, 216,
							  16, 168,
							  16, 112,
							  16, 56,
							  56, 16,
							  112, 16,		//12
							  152, 40,		//13
							  192, 72,
							  192, 112,
							  192, 152,
							  152, 192,
							  112, 192,		//18
							  72, 192,
							  40, 152,
							  40, 112,
							  40, 72,
							  72, 40,
							  112, 40]		//24

	XYArray[RoomSize._1x2] = [168, 16,		//1
							  216, 112,
							  216, 240,
							  216, 368,
							  168, 472,
							  112, 472,		//6
							  56, 472,
							  16, 368,
							  16, 240,
							  16, 112,
							  56, 16,
							  112, 16,		//12
							  152, 40,		//13
							  192, 112,
							  192, 240,
							  192, 368,
							  152, 448,
							  112, 448,		//18
							  72, 448,
							  40, 368,
							  40, 240,
							  40, 112,
							  72, 40,
							  112, 40]		//24

	XYArray[RoomSize._2x1] = [368, 16,		//1
							  472, 56,
							  472, 112,
							  472, 168,
							  368, 216,
							  240, 216,		//6
							  112, 216,
							  16, 168,
							  16, 112,
							  16, 56,
							  112, 16,
							  240, 16,		//12
							  368, 40,		//13
							  448, 72,
							  448, 112,
							  448, 152,
							  368, 192,
							  240, 192,		//18
							  112, 192,
							  40, 152,
							  40, 112,
							  40, 72,
							  112, 40,
							  240, 40]		//24

	XYArray[RoomSize._2x2] = [368, 16,		//1
							  472, 112,
							  472, 240,
							  472, 368,
							  368, 472,
							  240, 472,		//6
							  112, 472,
							  16, 368,
							  16, 240,
							  16, 112,
							  112, 16,
							  240, 16,		//12
							  368, 40,		//13
							  448, 112,
							  448, 240,
							  448, 368,
							  368, 448,
							  240, 448,		//18
							  112, 448,
							  40, 368,
							  40, 240,
							  40, 112,
							  112, 40,
							  240, 40]		//24
							  
	for(var _RoomSize = 0; _RoomSize < 4; _RoomSize++){
		for(var _Position = 0; _Position < 24; _Position++){
			var _x = XYArray[_RoomSize][_Position * 2];
			var _y = XYArray[_RoomSize][(_Position * 2) + 1];
			global.DoorCoordinates[_RoomSize][_Position + 1] = new Data_CreateStruct_DoorCoordinate(_x, _y, _Position + 1);
		}
	}

	
}

function Data_CreateStruct_DoorCoordinate(_x, _y, _position) constructor{
	
	x = _x;
	y = _y;

	Level = (_position <= 12 ? "Upper" : "Lower");
	
	switch(_position){
		case 11: case 12: case 1: case 23: case 24: case 13:
			Location = "Top";
			break;
		case 2: case 3: case 4: case 14: case 15: case 16:
			Location = "Right";
			break;
		case 5: case 6: case 7: case 17: case 18: case 19:
			Location = "Bottom";
			break;
		case 8: case 9: case 10: case 20: case 21: case 22:
			Location = "Left";
			break;
	}
}