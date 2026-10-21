event_inherited();

Enemy = true;

Damage = 1.75;

ObjSetY(y);

LightIndex = Lighting_CreateLight(RoomIndex, x, y_base, 0.25, [0.7, 0.0, 0.0]);

TailDelay = 4;
alarm[0] = TailDelay;