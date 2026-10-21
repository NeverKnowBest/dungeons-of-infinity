function RealToBool(_val){
	//converts _val	to true if non-zero, otherwise converts to false
	return _val != 0 ? true : false;
}

function AngleCheck(_Angle){
	if(_Angle < 0) return _Angle + 360;
	if(_Angle >= 360) return _Angle - 360;
	return _Angle;
}

function Array_Create2D(_SizeX, _SizeY, _DefaultValue = 0){
	
	var NewArray = array_create(_SizeY, _DefaultValue);
	
	for(var _y = 0; _y < _SizeY; _y++){
		NewArray[_y] = array_create(_SizeX, _DefaultValue);
	}
	
	return NewArray
}

function Surface_Clear(_Surface){
	surface_set_target(_Surface);
	draw_clear_alpha(c_black, 0.0);	
	surface_reset_target();	
}

function Surface_ClearToColor(_Surface, _Color){
	surface_set_target(_Surface);
	draw_clear_alpha(_Color, 1.0);	
	surface_reset_target();	
}

