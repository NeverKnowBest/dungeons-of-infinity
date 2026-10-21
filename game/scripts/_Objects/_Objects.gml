#macro PauseObj if(global.Paused){ ObjPause(); exit;}else image_speed = LastImageSpeed
#macro PauseImage image_speed = (global.Paused ? 0 : LastImageSpeed)
#macro PauseImageExit if(global.Paused){ image_speed = 0; exit; }else image_speed = LastImageSpeed

function ObjSetY(NewY){
	//Use this function to set an object's y position that uses y_base. We have to first set the y-base since y depends on it.
	//y_base is used for the shadow/real position so we can move the actual object for things like jumping and it won't affect the base's position.
	y_base = NewY;
	y = y_base - z;	
}


function ObjPause(){
	image_speed = 0;
	ObjIncAlarms();
}
function ObjIncAlarms(){
	for(var i = 0; i < 12; i++){
		if(alarm[i] > 0) alarm[i] += 1;
	}		
}

function ObjSetImageSpeed(NewSpeed){
	image_speed = NewSpeed;
	LastImageSpeed = image_speed;
}

function DirFaceLink(){
	
	//returns the quadrant the inst should face to look at Link
	
	var D = point_direction(x, y, oLink.x, oLink.y);
	return DirFaceAngle(D);
		
}

function DirFaceAngle(_Angle){
	
	//returns the quadrant the inst should face based on angle
	
	if(_Angle >= 45 && _Angle < 135) return UP; 
	else if( (_Angle >= 0 && _Angle < 45) || (_Angle >= 315 && _Angle <= 360) ) return RIGHT; 
	else if(_Angle >= 135 && _Angle < 225) return LEFT; 
	else if(_Angle >= 225 && _Angle < 315) return DOWN; 
		
}

function DirFacePos(_x, _y){
	
	//returns the quadrant the inst should face to look at position
	
	var D = point_direction(x, y, _x, _y);
	if(D >= 45 && D < 135) return UP; 
	else if( (D >= 0 && D < 45) || (D >= 315 && D <= 360) ) return RIGHT; 
	else if(D >= 135 && D < 225) return LEFT; 
	else if(D >= 225 && D < 315) return DOWN; 
		
}

function ObjCenterX(){
	return bbox_left + ((bbox_right - bbox_left) / 2);	
}
function ObjCenterY(){
	return bbox_top + ((bbox_bottom - bbox_top) / 2);	
}

function OppositeDir(_Dir){
	switch(_Dir){
		case LEFT: return RIGHT;	
		case RIGHT: return LEFT;	
		case UP: return DOWN;	
		case DOWN: return UP;		
	}	
}

function DirAngle(_Dir){
	//returns the angle for the given dir index
	switch(_Dir){
		case LEFT: return 180;	
		case RIGHT: return 0;	
		case UP: return 90;	
		case DOWN: return 270;		
	}	
	
}