/// @description Wake

if(!InitialWakeDone || oLink.Cape){
	//so the first time they wake they don't appear under Link. Future wakes will be under Link
	InitialWakeDone = true;
}else{
	var _Buffer = 64;
	x = clamp(oLink.x, global.Level.Rooms[RoomIndex].x + _Buffer, global.Level.Rooms[RoomIndex].x2 - _Buffer);
	var _y = clamp(oLink.y, global.Level.Rooms[RoomIndex].y + _Buffer, global.Level.Rooms[RoomIndex].y2 - _Buffer);
	ObjSetY(_y);
}
Enemy_UpdateState(EnemyState.Wake);