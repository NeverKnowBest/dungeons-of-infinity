

if(Action == "Spawn"){
	SpawnDelay = Value1;
	SpawnDir = Value2;
	FloorLevel = GetFloorLevelID(x, y);
	FloorLevelStr = GetFloorLevelString(FloorLevel);
	alarm[0] = 1;
}