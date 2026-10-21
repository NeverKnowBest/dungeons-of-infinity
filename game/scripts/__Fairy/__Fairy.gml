function Fairy_NewDir(){
	var _Angle = irandom(360);			
	if(Get_Allowed) Speed = random_range(0.5, 1);
	vx = lengthdir_x(Speed, _Angle);
	vy = lengthdir_y(Speed, _Angle);	
	NewZ = irandom_range(z_min, z_max);
	vz = sign(NewZ - z) * ZSpeed;
	Dir = vx >= 0 ? 1 : -1;
	alarm[1] = irandom_range(15, 45);
	
}