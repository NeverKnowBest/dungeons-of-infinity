function Pot_Create(_RoomIndex, _x, _y, _ItemClass, _InSection = false){

	var FloorLevelStr = GetFloorLevelString(_x, _y);
	var FloorLevel = GetFloorLevelID(FloorLevelStr);

	var WaterLevelTMID = GetFloorLevelTMID("Tiles_Water", _x, _y);
	var DecorLevelTMID = GetFloorLevelTMID("Tiles_Decor", _x, _y);
	
	var LayerDoors = "ObjsDoors_" + FloorLevelStr;
	var LayerFloor = "ObjsFloor_" + FloorLevelStr;
	
	
	//floor base
	if(global.Xmas)
		DrawTileBlock(DecorLevelTMID, _x, _y, 9, 2, 2, 2)
	else
		DrawTileBlock(WaterLevelTMID, _x, _y, 1, 2, 2, 2);	
	
	if(global.Switch_Add && (Room.Switch.Type == SwitchType.FloorSwitch || Room.Switch.Type == SwitchType.FloorSwitchMonument)){
		Room.Switch.Inst = instance_create_layer(_x, _y, LayerFloor, oFloorSwitch);
		Room.Switch.Inst.Action = Room.Switch.Action;
		Room.Switch.Inst.RoomIndex = _RoomIndex;
		global.Switch_Add = false;
		_ItemClass = -1;
	}
	
	var PotInst = instance_create_layer(_x + 8, _y + 12, LayerDoors, oPot);
	if(_ItemClass != -1) PotInst.ContentsObj = _ItemClass;	
	
	PotInst.Index = (global.Xmas ? choose(2, 3) : global.Level.PotStyle);
	PotInst.FloorLevel = FloorLevel;
	PotInst.InSection = _InSection;
	
	var WallInst = WallObj_Create(LayerFloor, _x, _y, 2, 2);
	WallInst.FloorLevel = FloorLevel;
	WallInst.BlockItems = false;
	WallInst.BlockProjectiles = false;
	
	PotInst.WallObj = WallInst; //Save wall inst so we can destroy it after pot is grabbed
	
	return PotInst;
		
}
