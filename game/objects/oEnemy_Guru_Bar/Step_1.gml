if(Setup && GuruCount > 0){

	//check if outter guru is close to a door or warp dest. If so increase angle until it's not
	
	var _AngleTryInc = 20;
	var _AngleTries = 360 / _AngleTryInc;
	var _OutterGuruIndex = GuruCount - 1;

	for(var i = 0; i < _AngleTries; i++){
		
		var _UpdateAngle = false;
		with(GuruInst[_OutterGuruIndex]){
			if(distance_to_object(oDoor) < 32 || distance_to_point(global.Level.Rooms[RoomIndex].WarpDest_X, global.Level.Rooms[RoomIndex].WarpDest_Y) < 32){
				_UpdateAngle = true;
			}
		}
		
		if(_UpdateAngle){
			Angle += _AngleTryInc;
			Gurus_Update();
		}else break;

	}

	

	Setup = false;
}