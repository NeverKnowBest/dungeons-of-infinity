event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
	Speed = AngrySpeed;
}

PauseCheck

switch(State){
	case EnemyState.Walking:
		
		if(WallCollide_X || WallCollide_Y){
			Angle = Angle + (irandom_range(90, 180) * choose(1, -1));
			Angle = AngleCheck(Angle);
			Hoarder_UpdateDir();
		}
		
		var AngleDiff = angle_difference(ChargeAngle, Angle);
		Angle = (Angle + (irandom_range(RotateSpeed - 2, RotateSpeed + 2) * sign(AngleDiff))) mod 360;
		Angle = AngleCheck(Angle);
		
		vx = lengthdir_x(Speed, Angle);
		vy = lengthdir_y(Speed, Angle);
		
		break;
}