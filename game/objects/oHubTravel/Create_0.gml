// Feather disable GM2064
// Moves Link through a side door to another hub room the way dungeon rooms change: the camera scrolls to the new room,
// then Link walks a few steps in. Created by oHubDoor (at 0,0, outside every room, so the room change can't deactivate it).
// DestRoom, DestX, DestY, DestFacing come from oHubDoor.
FromRoom = global.CurrentRoomIndex;
State = 0;		// 0 camera scrolling, 1 Link walking in
global.Paused = true;
with(oLink) UpdateState(LinkState.Inventory);
var _Target = Hub_MoveLinkTo(DestRoom, DestX, DestY, DestFacing);
CamTargetX = _Target[0];
CamTargetY = _Target[1];
oCamera.Override = true;
Frames = 0;
