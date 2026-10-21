
enum jsonLayer_RoomTemplate{
	Rooms,
	Pit,
	Holes,
	Water,
	Carpets,
	FloorObjs,
	Spikes,	
	WallsLower,
	WallsUpper,
	WallsCommon,
	Blocks,
	SpecialRoomObjs,
	Stairs,
	Doors,
	LowerFloor,
	ExtraCeilings,
	OutOfBounds,
	Sections
}

enum jsonLayer_RoomTemplate_Section{
	SectionArea,
	Zones,
	Enemies,
	FloorObjs,
	SectionWalls,	
	RollingSpikes,
	GuruBars,
	Jails,
	Altars,
	Kinstones,
	Monuments,
	PotTreasureCrystals,
	PotCrystals,
	TreasureCrystals,
	PotTreasures,
	Crystals,
	Treasures,
	Pots
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
	DrawBridge,
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
	Carpet_Full
}


function Dungeon_PickRoomTemplate(_RoomIndex){
	
	switch(global.Level.Index){
		case DungeonLevel.Start: 
		switch(_RoomIndex){
				case 0: return GetSpecialTemplateIndex("Start", "South"); 
				case 1: return GetSpecialTemplateIndex("Start", "North"); 
		}
			break;
		case DungeonLevel.Aghanim4: 
			switch(_RoomIndex){
				case 0: return GetSpecialTemplateIndex("Boss", "FinalHall")			
				case 1: return GetSpecialTemplateIndex("Boss", "Final")
			}
			break;
		
	}
	
	switch(Room.Type){
		case RoomType.Special: 				
			return Dungeon_PickSpecialRoom(_RoomIndex)
		case RoomType.House: 
			return Dungeon_GetHouseTemplate(_RoomIndex, Room.GridX, Room.GridY)
		case RoomType.Village: 
			return GetSpecialTemplateIndex("Village", "Main" + string(_RoomIndex))
					
	}
	
	if(global.Level.IsBossLevel && RoomID(_RoomIndex, RoomType.Boss)) return (global.Level.Index == DungeonLevel.MoldormsLair ? GetSpecialTemplateIndex("Boss", "Moldorm") : 0)


	while(global.RoomTemplateListIndex < global.Templates_Room_Count - 1){
		
		global.RoomTemplateListIndex++;
		
		var _RoomTemplateIndex = global.RoomTemplateList[| global.RoomTemplateListIndex];
	
		var RoomTemplate = global.Templates_Room[_RoomTemplateIndex];
		var SectionArray = RoomTemplate[$ "Sections"][Room.Section_ID];
		var RoomTransformation = RoomTemplate[$ "RoomTransformation"];
		
		
		if(RoomTemplate[$ "type"] != "") continue; //don't pick special Rooms types
		
		//only pick a template for the entrance Room that have the entrance property set
		if(RoomID(_RoomIndex, RoomType.Entrance) && !RoomTemplate.Entrance) continue;
		
		
		//if Room is adjacent to boss Room, and the template isn't set for one, continue
		if(global.Level.IsBossLevel && _RoomIndex == 5){
			var _RoomIsBossAdjacent = RoomID(_RoomIndex, RoomType.BossAdjacent);
			var _TemplateIsBossAdjacent = RoomTemplate.AdjacentBossRoom;
			if(_RoomIsBossAdjacent && !_TemplateIsBossAdjacent) continue;
		}
		
		
		//Temp: Force template for Room index
		
		//if(global.RoomIndex == 0 || global.RoomIndex == 7 || global.RoomIndex == 8){
			//if(global.Templates_Room[_RoomTemplateIndex][$ "id"] != 663) continue;			
		//}else{
		//	if(global.Templates_Room[RoomTemplateIndex][$ "id"] != 11115) continue;
		//}
		
		//if(_RoomIndex == 1 && global.Templates_Room[_RoomTemplateIndex][$ "id"] != 23039 && global.Templates_Room[_RoomTemplateIndex][$ "RoomTransformation"] != ObjTransformation.RotateCW) continue;
		//if(global.RoomIndex == 8 || global.RoomIndex == 15 || global.RoomIndex == 17){// || RoomIndex == 2 || RoomIndex == 37){
		//	if(global.Templates_Room[RoomTemplateIndex][$ "id"] != 663) continue;
		//}//else if(RoomIndex == 2){
		//	if(global.Templates_Room[RoomTemplateIndex][$ "id"] != 11102) continue;
		//} else if(RoomIndex == 0){
		//if(global.RoomIndex == 3 && global.Templates_Room[RoomTemplateIndex][$ "id"] != 11139) continue;
		//} else if(global.Templates_Room[RoomTemplateIndex][$ "id"] != 663) continue;
		//if(global.RoomIndex == 18){
		//	if(RoomTemplate[$ "id"] != 11165 || RoomTemplate[$ "RoomTransformation"] != ObjTransformation.RotateCCW) continue;
		//}

		Room.UnusedZone = -1;

		
		if(Room.width != RoomTemplate.width || Room.height != RoomTemplate.height) continue;

			
		//Check if there's a section in the Room, then check if template has the right section for it. If not, go to the next template
		//Rooms can have a built in section that is part of the Room layout, check for that too
		var BuiltInSection = GetPropertyValue(RoomTemplate[$ "properties"], "BuiltInSection");	
				
		if(Room.Section_ID == 0){ 
			//If SectionID = 0 and the template has a built in section, we can't pick this template, go to the next one
			if(BuiltInSection > 0) continue;
		}else{
				
			var SectionIsInTemplate = false;
					
			if(Room.Section_ID == BuiltInSection){
				//Only allow builtin sections to be used when dungeon Room is using rail sections to divide section, they can't be switchblocks
				if(Room[$ "Section_WallType"] = SectionWallType.Rail) SectionIsInTemplate = true;
			}else{
				//check for section walls in template
				if(array_length(SectionArray[$ "SectionWalls"]) > 0) SectionIsInTemplate = true;

			}

			if(!SectionIsInTemplate) continue; //no suitable sections in template, go to the next one

		}

			
			
		var RoomDoors = array_length(DungeonRoom[$ "Doors"]);
		var TemplateDoors = array_length(RoomTemplate[$ "Doors"]);
			
		var RoomDoorsMatch = 0; RoomDoorsMatch = array_create(RoomDoors, false);
			
		var ZonesArray = SectionArray[$ "Zones"];
		var Zones = array_length(ZonesArray);
		var ZoneStatus = 0; ZoneStatus = array_create(Zones, false); //holds the array where each index is the zone obj's index to keep track if it's used or not when picking Room templates
		var ZonesLeft = Zones;

		//Go through each door in dungeon Room and compare with template locations. 
		for(var RoomDoorIndex = 0; RoomDoorIndex < RoomDoors; RoomDoorIndex++){
					
			var _Door = DungeonRoom[$ "Doors"][RoomDoorIndex];
			var DungeonDoorX = _Door.x;
			var DungeonDoorY = _Door.y;

			for(var RoomTemplateDoorIndex = 0; RoomTemplateDoorIndex < TemplateDoors; RoomTemplateDoorIndex++){
					
				var TemplateDoor = RoomTemplate[$ "Doors"][RoomTemplateDoorIndex];
				var TemplateDoorX = TemplateDoor.x;
				var TemplateDoorY = TemplateDoor.y;
					
				if(DungeonDoorX == TemplateDoorX && DungeonDoorY == TemplateDoorY){
						
					//found a door that matches
						
					RoomDoorsMatch[RoomDoorIndex] = true;
						
					//if it's in a zone, then mark that zone off as used
					var ZoneIndex = InZone(_RoomIndex, TemplateDoor, _RoomTemplateIndex, Room.Section_ID, false);
					if(ZoneIndex != -1){
						if(!ZoneStatus[ZoneIndex]) ZonesLeft--; //only reduce ZonesLeft if that zone hasn't been used yet
						ZoneStatus[ZoneIndex] = true;							
					}
					break;
						
				}
			}

		}

		var RoomTemplateMatch = true;
		for(var i = 0; i < RoomDoors; i++){
			if(!RoomDoorsMatch[i]){
				RoomTemplateMatch = false;
				break;
			}
		}
			
		if(!RoomTemplateMatch) continue;
			
			

		if(ZonesLeft > 1) continue; //We can't have more than 1 unused zone	
		else{  
			
			if(ZonesLeft == 1){
					

				//Store the unused zone(if any) into Room.UnusedZone, which will be used in SpawnSpecialObjects
				for(var ZoneIndex = 0; ZoneIndex < Zones; ZoneIndex++){
					if(ZoneStatus[ZoneIndex] == false){
						Room.UnusedZone = ZoneIndex;
						break;
					}
				}							
					
				var Zone = ZonesArray[Room.UnusedZone];
					
				if(GetPropertyValue(Zone[$ "properties"], "NoObjects") != -1) continue;


				//if there's a special obj and it's in the main section(which is where the unused zone would be, then use this template
				if(Room.SpecialObject != SpecialDungeonObj.None && Room.SpecialObject != SpecialDungeonObj.Boss && !Room.SpecialObject_InSection){
					return _RoomTemplateIndex;
				}
					
					
				//Zone is still unused, so if there won't be a shop or bonus treasure, continue
				//if(!global.SpawnShop && !global.SpawnBonusTreasure) continue;
					
				//if(global.SpawnShop){
						
				//	//see if there's an altar in that zone for the shop, if not continue
				//	var AltarArray = SectionArray[$ "Altars"];
				//	var Altars = array_length(AltarArray);
						
				//	if(Altars == 0) continue;
						
				//	var AltarValid = false;
				//	for(var AltarIndex = 0; AltarIndex < Altars; AltarIndex++){
				//		var Altar = AltarArray[AltarIndex];
				//		//see if altar is in the zone
				//		if(rectangle_in_rectangle(Altar.x, Altar.y, Altar.x + Altar.width - 1, Altar.y + Altar.height - 1, Zone.x, Zone.y, Zone.x + Zone.width - 1, Zone.y + Zone.height - 1) != 0){
				//			AltarValid = true;
				//			break;
				//		}
				//	}
						
				//	if(!AltarValid) continue;
						
				//}
					
			}
				
			return _RoomTemplateIndex;
				
		}
						
	
	}
	

	return -1;
			
}

function Dungeon_PickSpecialRoom(_RoomIndex){
			
	//ds_list_shuffle(global.RoomTemplateList);	
	
	//if special Room is not a secret Room, and door pos is at 6 or 18, Prob that it will be a fairy Room
	var Door0Pos = DungeonRoom.Doors[0].Position;
	var IsFairyRoom = false;
	var IsShopRoom = false;
	if(Room.Secret == -1 && (Door0Pos == 6 || Door0Pos == 18)){ //if Room is not a secret Room, and door is at bottom, chance to set to either fairy or shop
		var IsFairyRoom = Prob(Chance_SpecialRoomIsFairy);
		if(!IsFairyRoom && global.Level.Index > DungeonLevel.Castle) IsShopRoom = Prob(Chance_SpecialRoomIsShop) && global.Level.ShopCount < global.Level.MaxShops; //don't pick shops on castle level
	}
	
	for(var _RoomTemplateListIndex = 0; _RoomTemplateListIndex < global.Templates_Room_Count; _RoomTemplateListIndex++){
		
		var RoomTemplateIndex = global.RoomTemplateList[| _RoomTemplateListIndex];
		var RoomTemplate = global.Templates_Room[RoomTemplateIndex];
		
		//if(global.RoomIndex == 26 && RoomTemplate[$ "id"] != 25868) continue;
		
		if(RoomTemplate[$ "type"] == "Special"){
			
			if( (IsFairyRoom && RoomTemplate[$ "name"] != "Fairy") || (!IsFairyRoom && RoomTemplate[$ "name"] == "Fairy")) continue;
			if( (IsShopRoom && RoomTemplate[$ "name"] != "Shop") || (!IsShopRoom && RoomTemplate[$ "name"] == "Shop")) continue;
			
			var RoomDoors = array_length(DungeonRoom[$ "Doors"]);
			var TemplateDoors = array_length(RoomTemplate[$ "Doors"]);
			
			var RoomDoorsMatch = 0; RoomDoorsMatch = array_create(RoomDoors, false);

			//Go through each door in dungeon Room and compare with template locations. 
			for(var RoomDoorIndex = 0; RoomDoorIndex < RoomDoors; RoomDoorIndex++){
					
				var _Door = DungeonRoom[$ "Doors"][RoomDoorIndex];
				var DungeonDoorX = _Door.x;
				var DungeonDoorY = _Door.y;

				for(var RoomTemplateDoorIndex = 0; RoomTemplateDoorIndex < TemplateDoors; RoomTemplateDoorIndex++){
					
					var TemplateDoor = RoomTemplate[$ "Doors"][RoomTemplateDoorIndex];
					var TemplateDoorX = TemplateDoor.x;
					var TemplateDoorY = TemplateDoor.y;
					
					if(DungeonDoorX == TemplateDoorX && DungeonDoorY == TemplateDoorY){
						
						//found a door that matches						
						RoomDoorsMatch[RoomDoorIndex] = true;
						break;
						
					}
				}

			}

			var RoomTemplateMatch = true;
			for(var j = 0; j < RoomDoors; j++){
				if(!RoomDoorsMatch[j]){
					RoomTemplateMatch = false;
					break;
				}
			}
			
			if(!RoomTemplateMatch) continue;
			else return RoomTemplateIndex;
			
		}	
			
	}

	return -1;
	
}

function RoomID(_RoomIndex, _Type, _Name = ""){
	if(_Name == "")
		return Room.Type == _Type
	else
		return Room.Type == _Type && Room.Name == _Name
}

function Dungeon_GetHouseTemplate(_RoomIndex, DungeonGridX, DungeonGridY){
			
	//houses are only used in the village level. The templates that are used for the houses in the village have
	//their grid coordinates set to the corresponding dungeon grid from Dungeon Editor
	
	for(var i = 0; i < global.Templates_Room_Count; i++){

		var RoomTemplate = global.Templates_Room[i];
				
		if(RoomTemplate[$ "type"] == "House"){
			
			if(GetPropertyValue(RoomTemplate[$ "properties"], "House_MapGridX") == DungeonGridX && GetPropertyValue(RoomTemplate[$ "properties"], "House_MapGridY") == DungeonGridY){
				return i;
			}
			
		}	
			
	}

	return -1;
	
}

function GetSpecialTemplateIndex(_Type, _Name){

	for(var TemplateIndex = 0; TemplateIndex < global.Templates_Room_Count; TemplateIndex++){
		var Template = global.Templates_Room[TemplateIndex];
		if(Template[$ "type"] == _Type && Template[$ "name"] == _Name) return TemplateIndex;			
	}
	
	return -1;
	
}

function Data_LoadRoomTemplates(){
	

	global.jsonData_RoomTemplates = json_parse(buffer_read(buffer_load("Room Templates.json"), buffer_string));

	global.Templates_Room_Count = array_length(global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"]);
	global.Templates_Room = array_create(global.Templates_Room_Count);
	
	global.Templates_Room_IDList = ds_list_create();
	
	var MainObjTypes = array_create(0);
	array_insert(MainObjTypes, 0, "Pit", "Holes", "Water", "Carpets", "FloorObjs", "Spikes", "WallsLower", "WallsUpper", "WallsCommon", "Blocks", "SpecialRoomObjs", "Stairs", "Doors", "LowerFloor", "ExtraCeilings", "OutOfBounds");
	
	var SectionObjTypes = array_create(0);
	array_insert(SectionObjTypes, 0, "SectionArea", "Zones", "Enemies", "FloorObjs", "SectionWalls", "RollingSpikes", "GuruBars", "Jails", "Altars", "Kinstones", "Monuments", "PotTreasureCrystals", "PotCrystals", "TreasureCrystals", "PotTreasures", "Crystals", "Treasures", "Pots");

	
	//Create Room structures
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < global.Templates_Room_Count; RoomTemplateIndex++){
		
		//In the Templates_Room_IDList list, store each Room ID as a key, and the RoomTemplateIndex as the value.
		//Each item in Tiled is linked to the Room they're in so they contain the Room ID. Using a map makes it easy to find the RoomTemplateIndex they're supposed to be in
		var ID = global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"][RoomTemplateIndex].id;
		ds_list_add(global.Templates_Room_IDList, ID);
		
		
		global.Templates_Room[RoomTemplateIndex] = StructCopy(global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"][RoomTemplateIndex]);
		
		for(var LayerIndex = 0; LayerIndex < array_length(MainObjTypes); LayerIndex++)
			global.Templates_Room[RoomTemplateIndex][$ MainObjTypes[LayerIndex]] = array_create(0);
		
		//create the array holding all 30 sections including main(0), plus objects that are on the section layers
		global.Templates_Room[RoomTemplateIndex][$ "Sections"] = array_create(31);
		for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
			global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex] = {};
			for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(SectionObjTypes); ObjTypeIndex++){
				global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ SectionObjTypes[ObjTypeIndex]] = array_create(0);
			}
		}
		
		var RoomProperties = global.Templates_Room[RoomTemplateIndex][$ "properties"];
		variable_struct_set(global.Templates_Room[RoomTemplateIndex], "RoomTransformation", ObjTransformation.None);
		
		variable_struct_set(global.Templates_Room[RoomTemplateIndex], "Entrance", GetPropertyValue(RoomProperties, "Entrance"));
		
		//Set if template can be an adjacent boss Room based on template flags. Array indexes: 0:default, 1:H, 2:V, 3:HV, 4:CW, 5:CCW
		//first replace all the flag str names so it's just csv values
		var AdjacentBossRoomFlagStr = GetPropertyValue(RoomProperties, "AdjacentBossRoom");

		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "Default:", "");
		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "H:", "");
		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "V:", "");
		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "HV:", "");
		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "CW:", "");
		AdjacentBossRoomFlagStr = string_replace(AdjacentBossRoomFlagStr, "CCW:", "");
		SetPropertyValue(RoomProperties, "AdjacentBossRoom", AdjacentBossRoomFlagStr);
		//Create an array that holds all 6 flags for the template. It will be needed when transformation the template below. 
		//But only 1 true/false value is needed per template, which be set to AdjacentBossRoom
		global.Templates_Room[RoomTemplateIndex][$ "AdjacentBossRoomFlags"] = array_create(6);
		global.Templates_Room[RoomTemplateIndex].AdjacentBossRoomFlags = SplitStrToArray(AdjacentBossRoomFlagStr, "\n", true); //this now holds the csv's at each index
		variable_struct_set(global.Templates_Room[RoomTemplateIndex], "AdjacentBossRoom", RealToBool(global.Templates_Room[RoomTemplateIndex].AdjacentBossRoomFlags[0]));
	}
	
	//Add objects to Room structures
	for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(MainObjTypes); ObjTypeIndex++){
		
		var ObjTypeArray = global.jsonData_RoomTemplates[$ "layers"][ObjTypeIndex + 1][$ "objects"]; //adding 1 because layer 0 in json struct is the Rooms layer
		var ObjsOnLayer = array_length(ObjTypeArray)  
		
		for(var ObjIndex = 0; ObjIndex < ObjsOnLayer; ObjIndex++){
			
			var Obj = ObjTypeArray[ObjIndex];
			var Properties = Obj[$ "properties"];
			var RoomID = GetPropertyValue(Properties, "Room");
			if(RoomID == -1){show_message("Invalid Room ID, make sure every obj has a Room reference"); game_end(); exit}
			
			var RoomTemplateIndex = ds_list_find_index(global.Templates_Room_IDList, RoomID);
			var TemplateObjArray = global.Templates_Room[RoomTemplateIndex][$ MainObjTypes[ObjTypeIndex]];
			
			//Subtract RoomX and RoomY to place the objects relative to (0,0)
			Obj.x -= global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"][RoomTemplateIndex].x;
			Obj.y -= global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"][RoomTemplateIndex].y;
			
			var ArreyLen = array_length(TemplateObjArray);
			array_insert(TemplateObjArray, ArreyLen, Obj)

		}
	}
	
	//Add Sections objects
	var ItemLayer = jsonLayer_RoomTemplate_Section.Monuments + 1;
	
	for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
		
		for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(SectionObjTypes); ObjTypeIndex++){
			
			//Note, json structure starts at section 30 and goes down to 0, it's in reverse order, so it's 30 - SectionIndex when referencing json structure
			
			if(ObjTypeIndex <= ItemLayer - 1)
				var ObjTypeArray = global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Sections][$ "layers"][30 - SectionIndex][$ "layers"][ObjTypeIndex][$ "objects"];
			else
				var ObjTypeArray = global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Sections][$ "layers"][30 - SectionIndex][$ "layers"][ItemLayer][$ "layers"][ObjTypeIndex - ItemLayer][$ "objects"];
			
			var ObjsOnLayer = array_length(ObjTypeArray);

			for(var ObjIndex = 0; ObjIndex < ObjsOnLayer; ObjIndex++){
			
				var Obj = ObjTypeArray[ObjIndex];
				var ObjProperties = Obj[$ "properties"];
				var RoomID = GetPropertyValue(ObjProperties, "Room");
				if(RoomID == -1){show_message("Room ID not found! Obj ID: " + string(Obj[$ "id"])); game_end(); exit}
				
				if(ObjTypeIndex == jsonLayer_RoomTemplate_Section.Monuments){
					variable_struct_set(Obj, "ObjAllowed", true);				
				}
				
				var RoomTemplateIndex = ds_list_find_index(global.Templates_Room_IDList, RoomID);
				var RoomTemplate = global.jsonData_RoomTemplates[$ "layers"][jsonLayer_RoomTemplate.Rooms][$ "objects"][RoomTemplateIndex];

				//Subtract RoomX and RoomY to place the objects relative to (0,0)
				Obj.x -= RoomTemplate.x;
				Obj.y -= RoomTemplate.y;

				var TemplateObjArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ SectionObjTypes[ObjTypeIndex]];
				var ArreyLen = array_length(TemplateObjArray);
				array_insert(TemplateObjArray, ArreyLen, Obj)

			}
	
		}
		
	}		


	
	//Now add reflected and rotated copies for each Room
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < global.Templates_Room_Count; RoomTemplateIndex++){
		
		var RoomW = global.Templates_Room[RoomTemplateIndex][$ "width"];
		var RoomH = global.Templates_Room[RoomTemplateIndex][$ "height"];
		var RoomSizeIndex = GetRoomSizeIndex(RoomW / 256, RoomH / 256);
		var Properties = global.Templates_Room[RoomTemplateIndex][$ "properties"];
		
		TransformFlag[ObjTransformation.FlipH] = GetPropertyValue(Properties, "FlipH");
		TransformFlag[ObjTransformation.FlipV] = GetPropertyValue(Properties, "FlipV");
		TransformFlag[ObjTransformation.FlipHV] = GetPropertyValue(Properties, "FlipHV");
		TransformFlag[ObjTransformation.RotateCW] = GetPropertyValue(Properties, "RotateCW");
		TransformFlag[ObjTransformation.RotateCCW] = GetPropertyValue(Properties, "RotateCCW");

		for(var TransformType = 1; TransformType <= 5; TransformType++){
			if(TransformFlag[TransformType]){
				
				//Create new struct to hold a copy of the current Room. Then we transform the copy.
				var NewRoomStruct = StructCopy(global.Templates_Room[RoomTemplateIndex]);
				var NewRoomIndex = array_length(global.Templates_Room);
				
				variable_struct_set(NewRoomStruct, "RoomTransformation", TransformType)
				
				
				//Set transformed section ID for the builtIn Section
				var BuiltInSection = GetPropertyValue(global.Templates_Room[RoomTemplateIndex][$ "properties"], "BuiltInSection");
				if(BuiltInSection > 0){
					var NewSectionID = GetTransformedSectionID(BuiltInSection, TransformType);
					SetPropertyValue(NewRoomStruct[$ "properties"], "BuiltInSection", NewSectionID);
				}

		
				switch(TransformType){
					case ObjTransformation.RotateCW: case ObjTransformation.RotateCCW:
						NewRoomStruct.width = RoomH;
						NewRoomStruct.height = RoomW;
						break;
				}
				
				array_insert(global.Templates_Room, NewRoomIndex, NewRoomStruct);

				global.Templates_Room[NewRoomIndex].AdjacentBossRoom = RealToBool(global.Templates_Room[RoomTemplateIndex][$ "AdjacentBossRoomFlags"][TransformType]);

				//Transform main objects
				for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(MainObjTypes); ObjTypeIndex++){
					
					var OldObjArray = global.Templates_Room[RoomTemplateIndex][$ MainObjTypes[ObjTypeIndex]];
					var NewObjArray = global.Templates_Room[NewRoomIndex][$ MainObjTypes[ObjTypeIndex]];
					
					TransformObjArray (OldObjArray, NewObjArray, TransformType, RoomSizeIndex);
					
				}
				
				//Transform section objects		
				
				//Clear all section objects in new template first
				for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
					for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(SectionObjTypes); ObjTypeIndex++){
						
						var NewObjArray = global.Templates_Room[NewRoomIndex][$ "Sections"][SectionIndex][$ SectionObjTypes[ObjTypeIndex]];
						array_resize(NewObjArray, 0);
						
					}
				}	
				
				//Now copy objects from old template to new template from each Section ID to New Section ID
				for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
					for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(SectionObjTypes); ObjTypeIndex++){
						
						var NewSectionID = GetTransformedSectionID(SectionIndex, TransformType);
						
						var OldObjArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ SectionObjTypes[ObjTypeIndex]];
						var NewObjArray = global.Templates_Room[NewRoomIndex][$ "Sections"][NewSectionID][$ SectionObjTypes[ObjTypeIndex]];
						
						var ObjCount = array_length(OldObjArray)
						if(ObjCount > 0){

							for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){
								array_insert(NewObjArray, ObjIndex, StructCopy(OldObjArray[ObjIndex]));
							}
							
						}
						
					}
				}
				
				//Now perform transformations to all sections
				for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
					for(var ObjTypeIndex = 0; ObjTypeIndex < array_length(SectionObjTypes); ObjTypeIndex++){
						
						var NewObjArray = global.Templates_Room[NewRoomIndex][$ "Sections"][SectionIndex][$ SectionObjTypes[ObjTypeIndex]];
						var NewObjArrayCopy = StructCopy(NewObjArray);
						
						var ObjCount = array_length(NewObjArrayCopy)
						if(ObjCount > 0) TransformObjArray (NewObjArrayCopy, NewObjArray, TransformType, RoomSizeIndex);
						
					}
				}					
				

				
			}
		}

	}
	
	//Recount Room templates because we added all the flipped versions
	global.Templates_Room_Count = array_length(global.Templates_Room)

	//Create list containing 0 to RoomTemplates - 1. The list will be shuffled when picking Room templates. 
	//This will be the order of which Room templates to check so we get a random pick every time.
	global.RoomTemplateList = ds_list_create_sequence(0, global.Templates_Room_Count - 1);
	

	//Go through each template and remove items that have rotation. All templates will now have only correctly orientated objects
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < global.Templates_Room_Count; RoomTemplateIndex++){
		
		var RoomTransformation = global.Templates_Room[RoomTemplateIndex][$ "RoomTransformation"];
		
		for(var SectionIndex = 0; SectionIndex <= 30; SectionIndex++){
			
			var TreasureArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "Treasures"];
			for(var TreasureIndex = 0; TreasureIndex < array_length(TreasureArray); TreasureIndex++){
				var Treasure = TreasureArray[TreasureIndex];
				if(!CheckRotation(Treasure, RoomTransformation)){
					array_delete(TreasureArray, TreasureIndex, 1);
					--TreasureIndex;
				}
			}

			var PotTreasureArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "PotTreasures"];
			for(var PotTreasureIndex = 0; PotTreasureIndex < array_length(PotTreasureArray); PotTreasureIndex++){
				var PotTreasure = PotTreasureArray[PotTreasureIndex];
				if(!CheckRotation(PotTreasure, RoomTransformation)){
					array_delete(PotTreasureArray, PotTreasureIndex, 1);
					--PotTreasureIndex;
				}
			}

			var TreasureCrystalArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "TreasureCrystals"];
			for(var TreasureCrystalIndex = 0; TreasureCrystalIndex < array_length(TreasureCrystalArray); TreasureCrystalIndex++){
				var TreasureCrystal = TreasureCrystalArray[TreasureCrystalIndex];
				if(!CheckRotation(TreasureCrystal, RoomTransformation)){
					array_delete(TreasureCrystalArray, TreasureCrystalIndex, 1);
					--TreasureCrystalIndex;
				}
			}

			var PotTreasureCrystalArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "PotTreasureCrystals"];
			for(var PotTreasureCrystalIndex = 0; PotTreasureCrystalIndex < array_length(PotTreasureCrystalArray); PotTreasureCrystalIndex++){
				var PotTreasureCrystal = PotTreasureCrystalArray[PotTreasureCrystalIndex];
				if(!CheckRotation(PotTreasureCrystal, RoomTransformation)){
					array_delete(PotTreasureCrystalArray, PotTreasureCrystalIndex, 1);
					--PotTreasureCrystalIndex;
				}
			}
			
			var MonumentArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "Monuments"];
			for(var MonumentIndex = 0; MonumentIndex < array_length(MonumentArray); MonumentIndex++){
				var Monument = MonumentArray[MonumentIndex];
				if(!CheckRotation(Monument, RoomTransformation)){
					array_delete(MonumentArray, MonumentIndex, 1);
					--MonumentIndex;
				}
			}
			
			var KinstoneArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "Kinstones"];
			for(var KinstoneIndex = 0; KinstoneIndex < array_length(KinstoneArray); KinstoneIndex++){
				var Kinstone = KinstoneArray[KinstoneIndex];
				if(!CheckRotation(Kinstone, RoomTransformation)){
					array_delete(KinstoneArray, KinstoneIndex, 1);
					--KinstoneIndex;
				}
			}
			
			var AltarArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "Altars"];
			for(var AltarIndex = 0; AltarIndex < array_length(AltarArray); AltarIndex++){
				var Altar = AltarArray[AltarIndex];
				if(!CheckRotation(Altar, RoomTransformation)){
					array_delete(AltarArray, AltarIndex, 1);
					--AltarIndex;
				}
			}
			
			var JailArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "Jails"];
			for(var JailIndex = 0; JailIndex < array_length(JailArray); JailIndex++){
				var Jail = JailArray[JailIndex];
				if(!CheckRotation(Jail, RoomTransformation)){
					array_delete(JailArray, JailIndex, 1);
					--JailIndex;
				}
			}

			var GuruBarArray = global.Templates_Room[RoomTemplateIndex][$ "Sections"][SectionIndex][$ "GuruBars"];
			for(var GuruBarIndex = 0; GuruBarIndex < array_length(GuruBarArray); GuruBarIndex++){
				var GuruBar = GuruBarArray[GuruBarIndex];
				if(!CheckRotation(GuruBar, RoomTransformation)){
					array_delete(GuruBarArray, GuruBarIndex, 1);
					--GuruBarIndex;
				}
			}
			
		}
		
	}

	
	global.SpecialRoom_Moldorm = GetSpecialTemplateIndex("Boss", "Moldorm");

	
}

enum Mask{
	OutOfBounds,
	WallsUpper,
	WallsLower,
	WallsCommon,
	Stairs,
	LowerFloor,
	Doors
}

function GenerateRoomTemplateObjGrids(){
	
	//Create grids the size of the Rooms and set every location to true if there a specific obj there.
		
	var _Templates = array_length(global.Templates_Room);
	
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < _Templates; RoomTemplateIndex++){
		
		var Template = global.Templates_Room[RoomTemplateIndex];
		var RoomW = Template[$ "width"];
		var RoomH = Template[$ "height"];
		var RoomGridW = RoomW / 8;
		var RoomGridH = RoomH / 8;

		
		variable_struct_set(Template, "ObjGrids", {});

		
		var ObjTypeList = ds_list_create();
		ds_list_add(ObjTypeList, "OutOfBounds", "ExtraCeilings", "WallsUpper");

		var ObjTypes = ds_list_size(ObjTypeList);

		
		for(var ObjsTypeIndex = 0; ObjsTypeIndex < ObjTypes; ObjsTypeIndex++){
			
			var ObjTypeStr = ObjTypeList[| ObjsTypeIndex];
			
			var ObjType = Template[$ ObjTypeStr];
			
			var ObjCount = array_length(ObjType);
			

			variable_struct_set(Template.ObjGrids, ObjTypeStr, ds_grid_create(RoomGridW,RoomGridH));
			
			var ObjGrid = Template.ObjGrids[$ ObjTypeStr];
			
			for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){
				var Obj = ObjType[ObjIndex];
				var ObjGridX =	Obj.x / 8;
				var ObjGridY =	Obj.y / 8;
				var ObjGridW = Obj.width / 8;
				var ObjGridH = Obj.height / 8;
				for(var TileY = 0; TileY < ObjGridH; TileY++){
					for(var TileX = 0; TileX < ObjGridW; TileX++){
						
						ObjGrid[# ObjGridX + TileX, ObjGridY + TileY] = true;
						//var Bit = power(2, RoomGridW - 1 - ObjGridX - TileX);
						//Masks[| ObjsTypeIndex][ObjGridY + TileY] = (Masks[| ObjsTypeIndex][ObjGridY + TileY] | (PlayfieldMask[ObjGridY + TileY] & Bit));

					}				
				}
			}
			

		}
		

		//variable_struct_set(Template.ObjGrid, "RoomShape", ds_grid_create(RoomGridW,RoomGridH));
		//variable_struct_set(Template.ObjGrid, "Playfield_Upper", ds_grid_create(RoomGridW,RoomGridH));
		//variable_struct_set(Template.ObjGrid, "Playfield_Lower", ds_grid_create(RoomGridW,RoomGridH));
		//variable_struct_set(Template.ObjGrid, "Doors_Upper", ds_grid_create(RoomGridW,RoomGridH));
		//variable_struct_set(Template.ObjGrid, "Doors_Lower", ds_grid_create(RoomGridW,RoomGridH));		


	//	for(var GridY = 0; GridY < RoomGridH; GridY++){
			
	//		var UpperWalls = (Masks[| Mask.WallsUpper][GridY] | Masks[| Mask.Stairs][GridY] | Masks[| Mask.WallsCommon][GridY]);
			
	//		//var LowerWalls = (Masks[| Mask.WallsLower][GridY] | Masks[| Mask.Stairs][GridY] | Masks[| Mask.WallsCommon][GridY]);
			
	//		var PlayfieldMask_Upper = PlayfieldMask[GridY] & ~(UpperWalls | Masks[| Mask.LowerFloor][GridY] | Masks[| Mask.OutOfBounds][GridY]);
			
	//		var PlayfieldMask_Lower = Masks[| Mask.LowerFloor][GridY] & ~(UpperWalls | Masks[| Mask.WallsLower][GridY])
			
	//		var DoorsMask_Upper = Masks[| Mask.Doors][GridY] & ~Masks[| Mask.LowerFloor][GridY];
	//		var DoorsMask_Lower = Masks[| Mask.Doors][GridY] & ~DoorsMask_Upper;
			
	//		var RoomShapeMask = PlayfieldMask_Upper | PlayfieldMask_Lower | Masks[| Mask.WallsLower][GridY] | Masks[| Mask.WallsCommon][GridY] | Masks[| Mask.Stairs][GridY];
			
	//		for(var GridX = 0; GridX < RoomGridW; GridX++){

	//			var Bit = RoomShapeMask & power(2, RoomGridW - 1 - GridX);
	//			ds_grid_add(Template.Masks.RoomShape, GridX, GridY, Bit);
				
	//			var Bit = PlayfieldMask_Upper & power(2, RoomGridW - 1 - GridX);
	//			ds_grid_add(Template.Masks.Playfield_Upper, GridX, GridY, Bit);

	//			Bit = PlayfieldMask_Lower & power(2, RoomGridW - 1 - GridX);
	//			ds_grid_add(Template.Masks.Playfield_Lower, GridX, GridY, Bit);

	//			Bit = DoorsMask_Upper & power(2, RoomGridW - 1 - GridX);
	//			ds_grid_add(Template.Masks.Doors_Upper, GridX, GridY, Bit);

	//			Bit = DoorsMask_Lower & power(2, RoomGridW - 1 - GridX);
	//			ds_grid_add(Template.Masks.Doors_Lower, GridX, GridY, Bit);
				
	//		}			
	//	}

	}
	
	ds_list_destroy(ObjTypeList);
	//ds_list_destroy(Masks);
	
}

function GenerateTemplateMapRoomSprites(){
	
	//***Note: all templates must have these 3 layers: "OutOfBounds", "ExtraCeilings", "WallsUpper" in order to construct the map Room sprites
	
	var _Templates = array_length(global.Templates_Room);
	
	for(var RoomTemplateIndex = 0; RoomTemplateIndex < _Templates; RoomTemplateIndex++){
		
		var Template = global.Templates_Room[RoomTemplateIndex];
		var RoomW = Template[$ "width"];
		var RoomH = Template[$ "height"];
		var RoomGridW = RoomW / 8;
		var RoomGridH = RoomH / 8;
		
		var RoomSprSurface = surface_create(RoomGridW, RoomGridH);
		var RoomSprSurface_Visited = surface_create(RoomGridW, RoomGridH);

	    surface_set_target(RoomSprSurface);
	    draw_clear_alpha(#242424, 1.0);
		
		for(var GridY = 2; GridY < RoomGridH - 2; GridY++){
			for(var GridX = 2; GridX < RoomGridW - 2; GridX++){
				if(!Template.ObjGrids.OutOfBounds[# GridX, GridY]) 
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_black, 1);
				if(Template.ObjGrids.WallsUpper[# GridX, GridY]){
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_dkgrey, 1);
				}
				if(Template.ObjGrids.ExtraCeilings[# GridX, GridY]) 
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, c_dkgrey, 1);

			}			
		}
		variable_struct_set(Template, "RoomMapSpr", sprite_create_from_surface(RoomSprSurface, 0, 0, RoomGridW, RoomGridH, false, false, 0, 0));
		surface_reset_target();
		surface_free(RoomSprSurface);
		
	    surface_set_target(RoomSprSurface_Visited);
	    draw_clear_alpha(make_color_rgb(0,30,60), 1);
		
		for(var GridY = 2; GridY < RoomGridH - 2; GridY++){
			for(var GridX = 2; GridX < RoomGridW - 2; GridX++){
				if(!Template.ObjGrids.OutOfBounds[# GridX, GridY]) 
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, make_color_rgb(0,60,90), 1);
				if(Template.ObjGrids.WallsUpper[# GridX, GridY]){
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, make_color_rgb(0,85,130), 1);
				}
				if(Template.ObjGrids.ExtraCeilings[# GridX, GridY]) 
					draw_sprite_ext(sPixel, 0, GridX, GridY, 1, 1, 0, make_color_rgb(0,85,130), 1);
			}			
		}
			
		variable_struct_set(Template, "RoomMapSpr_Visited", sprite_create_from_surface(RoomSprSurface_Visited, 0, 0, RoomGridW, RoomGridH, false, false, 0, 0));		
		surface_reset_target();
		surface_free(RoomSprSurface_Visited);
		
	}
	
	
	
}




