if(Setup){
	
	switch(oLink.Facing){
		case LEFT: x-=4; ObjSetY(y_base - 6); vx = -Speed; image_angle = 90; break;
		case RIGHT: x+=6; ObjSetY(y_base - 6); vx = Speed; image_angle = -90; break;
		case UP:
			ObjSetY(y_base - 14); vy = -Speed; image_angle = 0; 
			layer = layer_get_id("ObjsFloor_" + FloorLevelStr);
			alarm[11] = 3;
			break;
		case DOWN: vy = Speed; image_angle = 180; break;
	}
	
	visible = true;
	
	Setup = false;
	
}