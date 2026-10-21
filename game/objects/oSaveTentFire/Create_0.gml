FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);
WallObj_Create("Objs_" + FloorLevelStr, x, y, 2, 2);
FireLit = false;
