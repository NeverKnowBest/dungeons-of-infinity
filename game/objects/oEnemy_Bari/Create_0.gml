event_inherited();

Size = EnemySize.Small;

Type = (LevelDef.EnemyStats == DungeonLevel.Aghanim1 ? 1 : 0);

switch(Type){
	case 0: //blue
		Enemy_SetEnergy(3);
		Attack = 1.25;
		Speed = 0.25;
		break;
	case 1: //red
		Enemy_SetEnergy(5);
		Attack = 2.25;
		Speed = 0.65;
		break;	
}

LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.8, [0.8, 0.8, 0.8], false);

z = 8;
ObjSetY(y_base);

Bari_UpdateDir(irandom(360), choose(-1, 1));

Enemy_UpdateState(EnemyState.Walking);


