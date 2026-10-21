function Warp_Create(_RoomIndex, _x, _y, _FloorLevel){

	var WarpInst = instance_create_layer(_x, _y, "ObjsFloor_" + GetFloorLevelString(_FloorLevel), oWarp, {RoomIndex : _RoomIndex, FloorLevel : _FloorLevel});
	if(global.Switch_Add){
		Room.Switch.HiddenObjInst = WarpInst;
		WarpInst.visible = false;
		WarpInst.IsSwitchWarp = true;
		for(var i = 0; i < 3; i++){
			Lighting_UpdateLight_Visible(_RoomIndex, WarpInst.LightIndex[i], false);
		}

	}else{
		//add warp to large map items so we can draw the icon if Link has a compass
		ds_list_add(global.LargeMapItems, WarpInst); 		
	}
	
	return WarpInst;
	
}