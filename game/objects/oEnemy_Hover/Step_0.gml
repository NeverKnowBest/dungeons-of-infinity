if(!OnWaterTile(TMID, x + vx, y)) vx = 0;	
if(!OnWaterTile(TMID, x, y + vy)) vy = 0;

event_inherited();

PauseCheck

switch(State){
	case EnemyState.Walking:
		Speed -= SlowdownSpeed;
		if(Speed <= 0){
			Speed = 0;
			Enemy_UpdateState(EnemyState.Standing);
		}else{
			vx = lengthdir_x(Speed, Dir);
			vy = lengthdir_y(Speed, Dir);
		}
		break;
	
}