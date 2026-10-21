if(global.Paused) exit;

x += vx;
ObjSetY(y_base + vy);


if(AllowCollision){
	var _inst = CheckProjectileCollision(FloorLevel);
	if(_inst != noone){
		if(_inst.object_index != oBush && _inst.object_index != oPot) instance_destroy(id);
	}
}


event_inherited();

if(WallCollided) instance_destroy(id);
