function Zazak_Shoot(){
	
	var FloorLevelStr = GetFloorLevelString(x, y);
	var Layer = "ObjsHigher_" + FloorLevelStr;
	
	var inst;
	switch(Dir){
		case LEFT:
			inst = instance_create_layer(x - 8, y - 10, Layer, oEnemy_Fireball2);
			inst.vx = -inst.Speed;
			inst.Rot = 180;
			break;
		case RIGHT:
			inst = instance_create_layer(x + 8, y - 10, Layer, oEnemy_Fireball2);
			inst.vx = inst.Speed;
			inst.Rot = 0;
			break;
		case UP:
			inst = instance_create_layer(x, y - 18, Layer, oEnemy_Fireball2);
			inst.vy = -inst.Speed;
			inst.Rot = 90;
			inst.layer = layer_get_id("ObjsDoors_" + FloorLevelStr);
			Hit_AllowedTimer = 3;
			break;
		case DOWN:
			inst = instance_create_layer(x, y - 6, Layer, oEnemy_Fireball2);
			inst.vy = inst.Speed;
			inst.Rot = 270;
			break;
	}
	
	
}