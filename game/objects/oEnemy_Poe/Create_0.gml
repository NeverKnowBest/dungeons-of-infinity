event_inherited();

Size = EnemySize.Small;

switch(global.Level.Index){

	case DungeonLevel.Catacombs:
		image_index = 1;
		Attack = 1;
		break;
		
	default:
		image_index = 0;
		Attack = 1.5;
		Enemy_SetEnergy(3);
		break;

	case DungeonLevel.Aghanim1:
		sprite_index = sEnemy_FloatingHead;
		Attack = 2.0;
		Enemy_SetEnergy(6);
		break;
	
}

IgnoreWalls = true;

Dir = 1;

z = 12;
ObjSetY(y_base);

RoomFactorW = global.Level.Rooms[RoomIndex].GridW == 2 ? 2 : 1;
RoomFactorH = global.Level.Rooms[RoomIndex].GridH == 2 ? 3 : 1;

T = 0;
TInc = 0.008;

TDir = choose(1, -1);
Frames = round((2 * pi) / TInc); //frames for a full revolution

Enemy_UpdateState(EnemyState.Walking);

layer = global.LayerID_ObjsHighest;

IsPoe = (sprite_index == sEnemy_Poe);
LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.8, [0.5, 0.45, 0.4]);	
Lighting_UpdateLight_Visible(RoomIndex, LightIndex, IsPoe);

Setup = true;
