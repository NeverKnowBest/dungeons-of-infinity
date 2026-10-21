PauseImageExit

x += vx;
ObjSetY(y_base + vy);


Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y_base);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, choose(0.5, 0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58));

event_inherited();

if(WallCollided){
	instance_create_layer(x, y_base, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oFireEffect, {FloorLevel : FloorLevel});
	instance_destroy(id);
}