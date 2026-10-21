/// @description Start walking after hit timer
State = EnemyState.Walking;

DirV = sign(angle_difference(point_direction(x, y, oLink.x, oLink.y), Dir));
EyeA = Dir;
HuntLink = true;
alarm[1] = -1;
alarm[6] = 90;


if(Energy <= LowEnergy){
	SpeedIndex = 1;
}
