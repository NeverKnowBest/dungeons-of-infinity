function Crystal_Create(_RoomIndex, _x, _y){
	
	var FloorLevelStr = GetFloorLevelString(_x, _y);
	var Layer = "ObjsFloor_" + FloorLevelStr;
	var inst = instance_create_layer(_x + 8, _y + 16, Layer, oCrystalSwitch, {RoomIndex : _RoomIndex});
	inst.WallInst = WallObj_Create(Layer, _x, _y, 2, 2);
	inst.WallInst.FloorLevel = GetFloorLevelID(FloorLevelStr);
	
	if(global.Switch_Add){
		Room.Switch.HiddenObjInst = inst;
		inst.visible = false;
		inst.IsSwitchCrystal = true;		
		inst.WallInst.BlockLink = false;
		inst.WallInst.BlockEnemies = false;
		inst.WallInst.BlockProjectiles = false;
		inst.WallInst.IsHiddenObj = true;
		inst.alarm[1] = -1; //sparkle alarm

	}else{
		
		Crystal_CreateLight(inst);
		
		//add crystal to large map items so we can draw the icon if Link has a compass
		ds_list_add(global.LargeMapItems, inst); 			
			
	}
	
	return inst;
	
}

function Crystal_CreateLight(_Inst){
	
	with(_Inst){
		LightID = Lighting_CreateLight(RoomIndex, x, y - 8, 0.9, RedColor);
		Crystal_UpdateLightColor();
	}
	
}

function Crystal_UpdateLightColor(){
	
	image_index = global.Level.SwitchBlock_ActiveColor;
		
	switch(image_index){
		case 0:
			Lighting_UpdateLight_RGB(RoomIndex, LightID, RedColor);
			break;
		case 1:
			Lighting_UpdateLight_RGB(RoomIndex, LightID, BlueColor);
			break;

	}
	
}