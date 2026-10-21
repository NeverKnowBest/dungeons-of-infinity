if(!variable_instance_exists(id, "FloorLevel")) FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);
RoomIndex = Dungeon_GetRoomIndex(x, y);
LightIndex = -1;
LastImageSpeed = image_speed;
AnimationEndDestroy = true;
