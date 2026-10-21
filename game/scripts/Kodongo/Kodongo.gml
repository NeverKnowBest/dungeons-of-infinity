function Kodongo_UpdateDir(_Dir){
	
	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(WalkSpeed);	
	
}

function Kodongo_Shoot(){
	
	var VarStruct = {FloorLevel : FloorLevel, ItemHolding : noone, SectionID: 0, _RoomIndex : 0};
	
	var inst = noone;
	
	switch(Dir){
		case LEFT:
			inst = instance_create_layer(x - 8, y - 5, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball, VarStruct);
			inst.vx = -inst.Speed;
			break;
		case RIGHT:
			inst = instance_create_layer(x + 8, y - 5, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball, VarStruct);
			inst.vx = inst.Speed;
			break;
		case UP:
			inst = instance_create_layer(x, y - 14, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball, VarStruct);
			inst.vy = -inst.Speed;
			break;
		case DOWN:
			inst = instance_create_layer(x, y + 6, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oEnemy_Fireball, VarStruct);
			inst.vy = inst.Speed;
			break;
	}
	
	with(inst){
		Damage = 1.5 + (other.Type * 0.5);
	}
	
	FireballCount++;
	
	if(FireballCount >= 3 + Type) Enemy_UpdateState(Script[# 0, ScriptPos]);
	else alarm[1] = FireballDelay;
	
}
