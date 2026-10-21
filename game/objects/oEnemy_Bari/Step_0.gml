event_inherited();

var _KnockBackOrStun = (KnockBackDone || StunDone);
if(_KnockBackOrStun || ShockDone){
	CanShock = false;
	Enemy_UpdateState(EnemyState.Walking);
	if(_KnockBackOrStun) alarm[0] = 25;
}

PauseCheck

if(!CanShock){
	CircleA = (CircleA + (CircleDir * CircleV)) mod 360;
	vx = lengthdir_x(Speed, (CircleA + 90) mod 360)
	vy = lengthdir_y(Speed, (CircleA + 90) mod 360)
}

