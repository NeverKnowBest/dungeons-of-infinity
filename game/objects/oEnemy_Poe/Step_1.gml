if(Setup){
	
	var _Frames = irandom(Frames);
	
	while(_Frames > 0){
		
		Poe_Update();	
		x += vx;
		ObjSetY(y_base + vy);
		_Frames--;

		if(_Frames <= 0){
			var DistToDoor = distance_to_object(oDoor);		
			if(DistToDoor < 48){
				_Frames += irandom(100); //keep moving poe until away from door
			}
		}
		
	}
	
	Setup = false;
	
}

