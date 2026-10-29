//Outdoor levels (docs/design/direcao.md): a locked door of a painted room is two key blocks in the passage of the
//wall, as in ALttP; the key opens them like any locked door (UnlockDoor) and they go with it
if(Status != DoorStatus.Locked && Status != DoorStatus.LockedHalf) exit;
if(!RegionRoom_Is(RoomIndex)) exit;
if(Location == "Top" || Location == "Bottom"){
	var _Y = y + (Location == "Top" ? 8 : 0);
	draw_sprite(sKeyBlock, 0, x, _Y);
	draw_sprite(sKeyBlock, 0, x + 16, _Y);
}else{
	var _X = x + (Location == "Left" ? 8 : 0);
	draw_sprite(sKeyBlock, 0, _X, y);
	draw_sprite(sKeyBlock, 0, _X, y + 16);
}
