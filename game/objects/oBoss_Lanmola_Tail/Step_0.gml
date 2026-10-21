event_inherited();

if(oBoss_Lanmola_C.Destroyed[ID]){
	vx = 0; vy = 0; vz = 0;	
	exit;
}

if(global.Paused){
	ObjPause();
	exit;
}

Lanmola_Update();

var VY = vy - vz;
if(VY == 0) VY = (0.01 * sign(vy)); //sometimes YComp can be 0 causing the HeadAngle to be 0 since all arguments are 0. In that case, just make VY a small number with the same sign as vy;
Angle = point_direction(0, 0, vx, VY);

