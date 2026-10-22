// Feather disable GM2064
var _PosX = x;
var _PosY = y;
switch(SpawnDir){
	case UP:
		_PosY -= 20;
		break;
	case DOWN:
		_PosY += 20;
		break;		
	case LEFT:
		_PosX -= 20;
		break;
	case RIGHT:
		_PosX += 20;
		break;
}
instance_create_layer(_PosX, _PosY, "Objs_" + FloorLevelStr, oMineCart, {Dir : SpawnDir});
alarm[0] = SpawnDelay;