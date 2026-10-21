event_inherited();


Size = EnemySize.Tiny;

BubbleAngle[0] = 0;
BubbleAngle[1] = 90;
BubbleAngle[2] = 180;
BubbleAngle[3] = 270;

Type = (global.Level.Index >= DungeonLevel.MoldormsLair ? 1 : 0);

switch(Type){
	case 0:
		Attack = 1.25;
		Speed = 1;
		break;
	case 1:
		Attack = 2.25;
		Speed = 1.25;
		break;	
}

vx = choose(-Speed, Speed);
vy = choose(-Speed, Speed);

WallCollide_Bounce = true;

LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.7, [0.9, 0.1, 0.1]);

Enemy_UpdateState(EnemyState.Walking);