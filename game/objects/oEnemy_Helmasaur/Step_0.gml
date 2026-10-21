event_inherited();

if(KnockBackDone || PushbackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
	alarm[1] = 1;
}

PauseCheck

switch(State){
	case EnemyState.Walking:
		
		var _Speed = (oLink.Cape || oLink.InDoor_Full ? 0 : Speed);
		var _RotateSpeed = (oLink.Cape ? 0 : RotateSpeed);
		
		var AngleDiff = angle_difference(ChargeAngle, Angle);
		Angle = (Angle + (_RotateSpeed * sign(AngleDiff))) mod 360;
		if(Angle < 0) Angle += 360;
		
		vx = lengthdir_x(_Speed, Angle);
		vy = lengthdir_y(_Speed, Angle);
		
		break;

}