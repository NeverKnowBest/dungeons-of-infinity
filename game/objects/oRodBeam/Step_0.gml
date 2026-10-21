PauseObj

x += vx;
ObjSetY(y_base + vy);

Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, random_range(0.55, 0.63));

var inst = CheckProjectileCollision(FloorLevel);
if(inst != noone){
	if(inst.object_index != oBush && inst.object_index != oPot) instance_destroy(id);
}

event_inherited();

if(WallCollided){
	var inst = instance_create_layer(x, y_base, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oRodFireEffect, {Index : Index, FloorLevel : FloorLevel});
	instance_destroy(id);
}