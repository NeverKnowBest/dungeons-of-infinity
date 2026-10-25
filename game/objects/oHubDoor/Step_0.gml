// Feather disable GM2064
if(!instance_exists(oLink) || instance_exists(oHubTravel)) exit;
if(global.Paused || instance_exists(oMenu_Game) || instance_exists(oDialogueBox)) exit;
if(oLink.State == LinkState.Dead) exit;

if(point_in_rectangle(oLink.x, oLink.y, x, y, x + TrigW, y + TrigH)){
	var _Dest = Hub_FindRoom(DestTemplate);
	if(_Dest == -1) exit;
	var _DestRoom = global.Level.Rooms[_Dest];
	instance_create_layer(0, 0, "System", oHubTravel, {
		DestRoom: _Dest, DestX: _DestRoom.x + DestX, DestY: _DestRoom.y + DestY, DestFacing: DestFacing
	});
}
