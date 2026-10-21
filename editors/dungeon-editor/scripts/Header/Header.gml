#macro DungeonGridMax 8

enum DungeonClass{
	Castle,				//no crystals, no warps
	CastleBasement,		//no crystals, no warps
	CastleJails,		//no crystals, no warps
	CatacombsSewers,	//Catacombs, Sewers, crystals, no warps
	BossesRuins,		//crystals, warps
	Aghanim,			//crystals, warps
	Special				//Village, start, etc
}

enum FloorLevel{
	Upper,
	Lower
}

enum SectionWallType{
	Rail,
	SwitchBlock
}

enum DoorStatus{
	Open,
	Closed,
	Locked,
	Entrance,
	Exit
}

enum MsgBox{
	Yes = 1,
	No = 2
}

enum SpecialObject{
	Key = 1,
	Crystal,
	DoorSwitch,
	Warp,
	SpecialRoom,
	Boss,
	House,
	Jail,
	JailKey,
	EnemyTrap
}

enum RoomSize{
	_1x1,
	_1x2,
	_2x1,
	_2x2
}

enum ButtonPos{
	TopLeft,
	DungeonGrid_Top,
	DungeonGrid_Below,
	SpecialObjs,
	Sections,
	SectionType,
	Warps,
	Shift
}

function init_Dungeon() constructor{
	Rooms = array_create(0);
	//EntranceRoomIndex = 0;
}


function init_DungeonRoom(_GridX, _GridY, _GridW, _GridH) constructor{
	GridX = _GridX;
    GridY = _GridY;
	GridW = _GridW;
	GridH = _GridH;
    x = GridX * 256;
    y = GridY * 256;
	width = GridW * 256;
	height = GridH * 256;
	Doors = array_create(0);
	Warp_DestGridPosition = -1;	
	Warp_DestRoomIndex = -1;
	WarpDest_WarpRoomIndex = -1;
	Template = -1;
	Lighting = false;
	Section_ID = 0;
	Section_WallType = SectionWallType.Rail;
	Section_Color = 0;
	SpecialObj = 0;
	SpecialObjSection = 0
}

function init_Door(_RoomSize, _Position, _ConnectedRoomIndex, _ConnectedDoorPos) constructor{
	
	x = global.DoorCoordinates[_RoomSize][_Position].x;
	y = global.DoorCoordinates[_RoomSize][_Position].y;
	Position = _Position;
	Level = global.DoorCoordinates[_RoomSize][_Position].Level;
	Location = global.DoorCoordinates[_RoomSize][_Position].Location;
	Status = 0;
	
	ConnectedRoomIndex = _ConnectedRoomIndex;
	ConnectedDoorPos = _ConnectedDoorPos;
	
}


function init_RoomButton(_inst, _RoomIndex, _GridX, _GridY, _GridW, _GridH) constructor{
	ButtonInst = _inst;
	RoomIndex = _RoomIndex;
	GridX = _GridX;
	GridY = _GridY;
	GridW =_GridW;
	GridH = _GridH;
	LowerFloor = false;
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

function Array_Create2D(_SizeX, _SizeY, _DefaultValue = 0){
	
	var NewArray = 0;
	
	for(var _y = 0; _y < _SizeY; _y++){
		NewArray[_y] = array_create(_SizeX, _DefaultValue);
	}
	
	return NewArray
}