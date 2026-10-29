

Status = DoorStatus.Open;
RoomIndex = 0;
Location = "";
Position = -1;
FloorLevel = UPPER;
LinkedDoor = noone;
CurtainInst = noone;
Entrance = false;
Exit = false;
ConnectedRoomIndex = 0;
SecretType = -1;

Open = false;
Close = false;
Unlock = false;

AddTracks = false; //for mine level

DoorChangeAniFrame = 0;

LightingFrame = 0;

FloorLight = -1;
EntranceLight = -1;


PassageArea = array_create(4, 0);  //This will hold the 4 coordinates of the passageway between doors for light dimming.

WallInst = noone; //Wall if door is locked or closed

UpdateStatus = true;

visible = (LevelDef.Layout == LevelLayout.Outdoor);	//outdoors a locked door draws its key blocks (Draw)
