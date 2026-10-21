FloorLevel = GetFloorLevelID(x, y);

PassageArea = array_create(4, 0);  //This will hold the 4 coordinates of the passageway
PassageArea[0] = x;
PassageArea[1] = y - 64;
PassageArea[2] = x + 32;
PassageArea[3] = y + 8;	
PassageOrientation = TOP_BOTTOM;

Closed = true;
Opened = false;