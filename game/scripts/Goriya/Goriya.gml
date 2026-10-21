function Goriya_Shoot(){

	switch(Dir){
		case LEFT:
			var inst = instance_create_layer(x - 8, y - 7, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball2);
			inst.vx = -inst.Speed;
			inst.Rot = 180;
			break;
		case RIGHT:
			var inst = instance_create_layer(x + 8, y - 7, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball2);
			inst.vx = inst.Speed;
			inst.Rot = 0;
			break;
		case UP:
			var inst = instance_create_layer(x, y - 18, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball2);
			inst.vy = -inst.Speed;
			inst.Rot = 90;
			inst.depth = depth + 1;
			Hit_AllowedTimer = 3;
			break;
		case DOWN:
			var inst = instance_create_layer(x, y + 2, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball2);
			inst.vy = inst.Speed;
			inst.Rot = 270;
			break;
	}
	
	CanShoot = false;
	alarm[2] = 45;
	
}

function Goriya_UpdateDir(_Dir){
	
	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(Speed);
	alarm[3] = irandom_range(30, 120);
	
	
}