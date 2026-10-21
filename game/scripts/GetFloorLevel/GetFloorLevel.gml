
function GetFloorLevelString(){
	
	//return the string for floor level based either on macro ID value, or x/y position
	
	if(argument_count == 1){
		
		//Argument is floor level macro ID (UPPER, LOWER)
		var FloorLevel = argument[0];
		return FloorLevel == UPPER ? "Upper" : "Lower";
		
	}else if(argument_count == 2){
		
		//Arguments are x/y position
		var _x = argument[0];
		var _y = argument[1];
		
		//return either "Upper" or "Lower" depending if floor tile exists on upper floor at x,y
		if(tilemap_get_at_pixel(global.TMID_Floor_Upper, _x, _y) != 0)
			return "Upper";
		else
			return "Lower"	
		
	}

	
}

function GetFloorLevelID(){
	//returns the FloorLevel value from the string or position

	if(argument_count == 1){
		
		//Argument is floor level str
		var FloorLevel = argument[0];
		return FloorLevel == "Upper" ? UPPER : LOWER;
		
	}else if(argument_count == 2){
		
		//Arguments are x/y position
		var _x = argument[0];
		var _y = argument[1];
		
		//return either "Upper" or "Lower" depending if floor tile exists on upper floor at x,y
		if(tilemap_get_at_pixel(global.TMID_Floor_Upper, _x, _y) != 0)
			return UPPER;
		else
			return LOWER;	
		
	}

	
}

function GetFloorLevelTMID(TMString, _x, _y){
	
	//returns the Upper or Lower TMID for a point x,y for TM string name.
	
	var FloorLevelStr = GetFloorLevelString(_x, _y);

	return layer_tilemap_get_id(layer_get_id(TMString + "_" + FloorLevelStr));
		
}

