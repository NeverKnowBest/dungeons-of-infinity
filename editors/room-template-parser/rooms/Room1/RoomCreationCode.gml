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
global.RoomTemplateObjTypes_Section[RoomTemplateClass.Special] = [];
global.RoomTemplateObjTypes_Section[RoomTemplateClass.Other] = [];
global.RoomTemplateObjTypes_Section[RoomTemplateClass.Village] = [];
global.RoomTemplateObjTypes_Section[RoomTemplateClass.Mines] = [];

global.TemplateObjsThatCanRotate = ds_list_create();
ds_list_add(global.TemplateObjsThatCanRotate, "PotTreasures", "Kinstones", "Altars", "Jails");

global.RoomSizeIndex[1][1] = RoomSize._1x1;
global.RoomSizeIndex[1][2] = RoomSize._1x2;
global.RoomSizeIndex[2][1] = RoomSize._2x1;
global.RoomSizeIndex[2][2] = RoomSize._2x2;
	
//global.RoomTransformTypeList = ds_list_create_sequence(0, TransformTypes - 1);
	
//global.MainSectionIndexes = [1, 2, 9, 17, 21, 25, 27];
	
Data_InitDoorCoordinates();

instance_create_layer(0, 0, "Instances", oParse);