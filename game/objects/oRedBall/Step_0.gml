if(global.Paused){
	ObjIncAlarms();
	exit;
}

x += vx;
ObjSetY(y_base + vy);


Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y_base);

event_inherited();

if(WallCollided){
	instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oWallHit, {PlaySound: false});
	instance_destroy(id);
}