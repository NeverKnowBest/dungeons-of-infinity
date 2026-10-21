RoomIndex = Dungeon_GetRoomIndex(x, y);
FloorLevel = GetFloorLevelID(x, y);

Frame = 0;
BeamX = x + 4;
BeamY = y - 16;
Beam2X = x + 50;
PoleDist = 69;
BatX = x + (PoleDist / 2);
DestroyedInit = false;
Destroyed = false;
ShowBeam = true;


LightRadius[0] = 1.0;
LightRadius[1] = 1.05;
LightRadius[2] = 1.1;
LightRadius[3] = 1.15;
LightRadius[4] = 1.2;
LightRadius[5] = 1.25;
LightIndex = Lighting_CreateLight(RoomIndex, BatX, y - 9, LightRadius[0], [1.2, 1.2, 0.8]);

