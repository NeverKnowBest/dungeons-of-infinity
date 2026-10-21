function Zol_UpdateDir(){

	var _D = oLink.Cape ? irandom(359) : point_direction(x, y, oLink.x, oLink.y);
	DirX = lengthdir_x(1, _D);
	DirY = lengthdir_y(1, _D);
	LookDir = DirX >= 0 ? 1 : -1;
	MoveCount = irandom_range(3, 8);
}