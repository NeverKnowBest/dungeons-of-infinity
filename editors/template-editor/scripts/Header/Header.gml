
function struct_Template(_GridW, _GridH, _MainTemplate) constructor{

	GridW = _GridW;
	GridH = _GridH;
	width = GridW * 256;
	height = GridH * 256;
	
	//layers
	Decor = array_create(0);	
	Doors = array_create(0);
	ExtraCeilings = array_create(0);
	FloorObjs = array_create(0);
	LowerFloor = array_create(0);
	OutOfBounds = array_create(0);
	Pit = array_create(0);
	properties = array_create(0);
	Sections = array_create(31);
	for(var i = 0; i < 31; i++){
		array_insert(Sections, i, new struct_Section());
	}
	Stairs = array_create(0);
	WallsCommon = array_create(0);
	WallsLower = array_create(0);
	WallsUpper = array_create(0);
	
	Entrance = true;
	ID = 0;
	Name = "";
	RoomTransformation = 0;
	if(_MainTemplate){
		RoomTransformations[Transformation.H] = false;
		RoomTransformations[Transformation.V] = false;
		RoomTransformations[Transformation.HV] = false;
		RoomTransformations[Transformation.CW] = false;
		RoomTransformations[Transformation.CCW] = false;
	}
	
	//not used in template editor, used in game
	AdjacentBossRoomFlags = array_create(0); 
	ObjGrids = array_create(0);	
	AdjacentBoosRoom = false;
	RoomMapSpr = 0;	
	RoomMapSpr_Visited = 0;	
	
}

function struct_Section() constructor{
	Altars = array_create(0);
	Crystals = array_create(0);
	Enemies = array_create(0);
	Monuments = array_create(0);
	PotCrystals = array_create(0);
	Pots = array_create(0);
	PotTreasureCrystals = array_create(0);
	PotTreasures = array_create(0);
	SectionArea = array_create(0);
	SectionWalls = array_create(0);
	TreasureCrystals = array_create(0);
	Zones = array_create(0);
}

function struct_Door(_TemplateSize, _Position) constructor{
	ID = global.DoorObjID[_Position];
	x = global.DoorCoordinates[_TemplateSize][_Position].x;
	y = global.DoorCoordinates[_TemplateSize][_Position].y;
	Position = _Position;
	Level = global.DoorCoordinates[_TemplateSize][_Position].Level;
	Location = global.DoorCoordinates[_TemplateSize][_Position].Location;
	
}


function struct_TemplateObj(_ObjID, _Inst, _x, _y, _w, _h) constructor{
	ID = _ObjID;
	Inst = _Inst;
	x = _x;
	y = _y;
	width = _w;
	height = _h;	
}


function array_find_index(_Array, _Value){
	for(var i = 0; i < array_length(_Array); i++){
		if (_Array[i] == _Value) return i;
	}
	return -1;
}
