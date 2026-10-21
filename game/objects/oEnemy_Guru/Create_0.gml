event_inherited();

layer = global.LayerID_ObjsHighest;
visible = true;

Type = Gurus_GetType();

switch(Type){
	case 0:
		Attack = 1.5;
		LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.6, [0.7, 0.3, 0.1]);
		break;
	case 1:
		Attack = 2.5;
		LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.6, [0.1, 0.3, 0.7]);
		break;
	case 2:
		Attack = 3.25;
		LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.6, [0.7, 0.1, 0.1]);
		break;
}

State = EnemyState.Walking;
Enemy_UpdateState(EnemyState.Walking);