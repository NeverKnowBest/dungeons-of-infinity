var _RoomIndex = Dungeon_GetRoomIndex(x, y);
var _HeartX = clamp(x, Room.x + 48, Room.x + 208);
var _HeartY = clamp(y, Room.y + 50, Room.y + 208);

ItemSpawn(ItemClass.HeartPiece, _HeartX, _HeartY, ItemFrom.Enemy, ItemSpawnType.DropVeryHigh, UPPER);
	
SpawnedHeart = true;