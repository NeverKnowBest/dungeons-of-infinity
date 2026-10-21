if(global.Paused) exit;

x += vx;
ObjSetY(y_base + vy);

Lighting_UpdateLight_Pos(RoomIndex, LightIndex, x, y_base);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, random_range(0.5, 0.7));

switch(Type){
	case 0:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.7, random_range(0.3, 0.6), 0.2]);
		break;
	case 1:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.2, random_range(0.3, 0.7), 0.7]);
		break;
}

event_inherited();

if(WallCollided){
	instance_destroy(id);
}