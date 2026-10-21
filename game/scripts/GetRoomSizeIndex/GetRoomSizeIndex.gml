enum RoomSize{
	_1x1,
	_1x2,
	_2x1,
	_2x2
}

function GetRoomSizeIndex(_GridW, _GridH){
	if(_GridW == 1 && _GridH == 1) return 0;	
	if(_GridW == 1 && _GridH == 2) return 1;	
	if(_GridW == 2 && _GridH == 1) return 2;	
	if(_GridW == 2 && _GridH == 2) return 3;	
}