event_inherited();

PauseObj

if(WallCollide_X || WallCollide_Y){
	
	var _PosX = x;
	var _PosY = y;

	if(WallCollide_X){
		_PosX = vx > 0 ? bbox_left : bbox_right;
	}
	if(WallCollide_Y){
		_PosY = vy > 0 ? bbox_top : bbox_bottom;
	}

	instance_create_layer(_PosX, _PosY, "ObjsHigher_" + FloorLevelStr, oWallHit, {PlaySound: true});
}