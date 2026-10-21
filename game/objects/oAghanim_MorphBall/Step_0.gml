PauseObj

if(!Move) exit;

x += vx;
y += vy;

if( (vx == 0 || (vx < 0 && x <= MoveX) || (vx > 0 && x >= MoveX)) && (vy == 0 || (vy < 0 && y <= MoveY) || (vy > 0 && y >= MoveY)) ){
	x = MoveX;
	y = MoveY;
	Move = false;
	MorphFrom = true;
	alarm[0] = MorphAniDelay;
}

with(oBoss_Aghanim){
	x = other.x;
	ObjSetY(other.y + 16)
}