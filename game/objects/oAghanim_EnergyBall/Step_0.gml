PauseObj

x += vx;
y += vy;

ObjSetY(y);


switch(oBoss_Aghanim.EnergyBall_PalIndex){
	case 0:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, ((vx != 0 || vy != 0) ? [1.3, 0.9, 0.5] : [1.0, 0.6, 0.3]));
		break;
	case 1:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, ((vx != 0 || vy != 0) ? [0.5, 1.1, 1.6] : [0.4, 0.7, 1.2]));
		break;
}

event_inherited();


if(WallCollided) instance_destroy(id);


