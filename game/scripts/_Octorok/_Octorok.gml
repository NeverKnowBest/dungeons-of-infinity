function Octorok_UpdateDir(_Dir){
	
	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(Speed);
	
}

function Octorok_Shoot(){
	
	var inst = noone;
	
	switch(Dir){
		case LEFT:
			inst = instance_create_layer(x - 11, y + 2, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oRock);
			inst.vx = -inst.Speed;
			break;
		case RIGHT:
			inst = instance_create_layer(x + 11, y + 2, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oRock);
			inst.vx = inst.Speed;
			break;
		case UP:
			inst = instance_create_layer(x, y - 8, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oRock);
			inst.vy = -inst.Speed;
			break;
		case DOWN:
			inst = instance_create_layer(x, y + 6, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oRock);
			inst.vy = inst.Speed;
			break;
	}
	
	with(inst){
		Damage = 1.25 + (other.Type * 0.5);
	}
	
	ShotCount--;
	alarm[3] = ShotDelay;
	
	
}

function Octorok_Shots(){
	
	switch(Type){
		case 0: return choose(1, 4);
		case 1: return choose(4, 8);		
	}
	
}