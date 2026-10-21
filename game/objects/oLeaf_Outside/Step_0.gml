
x += vx;
y += vy;

	
if(Prob(0.075)){
	FlipX = FlipX * -1;
}else if(Prob(0.075)){
	FlipY = FlipY * -1;
}


if(AlwaysRotate){
	var _Angle = irandom_range(8, 30) * AlwaysRotateDir;
	Angle += _Angle;
	AlwaysRotateDegrees -= abs(_Angle);
	if(AlwaysRotateDegrees <= 0){
		AlwaysRotate = false;
		alarm[0] = irandom_range(30, 180);
	}
}else if(Prob(0.8)){
	Angle += random_range(irandom_range(-2, -15), irandom_range(2, 15));
	Angle = clamp(Angle, MinAngle, MaxAngle);
}

vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);

if(x < oCamera.X || y > oCamera.Y2) instance_destroy(id);