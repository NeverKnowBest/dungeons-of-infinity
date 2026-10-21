PauseObj

x += vx;
ObjSetY(y_base + vy);

Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y_base);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, random_range(0.55, 0.63));

var inst = CheckProjectileCollision(FloorLevel);
if(inst != noone){
	instance_create_layer(inst.x, inst.y, "Objs_" + GetFloorLevelString(FloorLevel), oCaneBeamHit, {Index : Index, FloorLevel : FloorLevel});
	if(inst.object_index != oBush && inst.object_index != oPot) instance_destroy(id);
}

event_inherited();

if(WallCollided){
	var inst = instance_create_layer(x, y_base, "Objs_" + GetFloorLevelString(FloorLevel), oCaneBeamHit, {Index : Index, FloorLevel : FloorLevel});
	instance_destroy(id);
}