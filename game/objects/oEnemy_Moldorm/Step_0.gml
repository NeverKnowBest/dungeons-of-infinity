
event_inherited();

if(Hit_Started){
	Dir = point_direction(0, 0, vx, vy);
}

if(point_distance(BodyX, BodyY, x, y) > 9){
	var Angle = point_direction(x, y, BodyX, BodyY);
	BodyX = x + lengthdir_x(9, Angle); 
	BodyY = y + lengthdir_y(9, Angle);
}

if(point_distance(TailX, TailY, BodyX, BodyY) > 7){
	var Angle = point_direction(BodyX, BodyY, TailX, TailY);
	TailX = BodyX + lengthdir_x(7, Angle); 
	TailY = BodyY + lengthdir_y(7, Angle);
}

if(Destroyed) exit;

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck


if(WallCollide_X || WallCollide_Y) Dir = point_direction(0, 0, vx, vy);


switch(State){
	
	case EnemyState.Walking:
		
		vx = lengthdir_x(Speed, Dir);
		vy = lengthdir_y(Speed, Dir);
		
		Dir = (Dir + (DirV * 5)) mod 360;
		
		break;
}






