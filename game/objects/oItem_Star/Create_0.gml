event_inherited();

FloorLevel = GetFloorLevelID(x, y);
ShadowOffsetY = -2;


LightColors = [[1.0, 0.8, 0.2], [1.1, 0.9, 0.3], [1.2, 1.0, 0.4], [1.1, 0.9, 0.3], [1.0, 0.8, 0.2], [0.9, 0.7, 0.1], [0.8, 0.6, 0.0], [0.9, 0.7, 0.1]]
LightStrengths = [0.5, 0.51, 0.52, 0.51, 0.5, 0.49, 0.48, 0.449];
LightIndex = Lighting_CreateLight(RoomIndex, ObjCenterX(), ObjCenterY(), LightStrengths[0], LightColors[0]);

EnemiesInRoom = 0;