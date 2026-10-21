if(Stop) exit;

var _WallInst = instance_place(x + vx, y_base, oWall)
if(_WallInst != noone){
	if(!_WallInst.IsDoorEntrance) vx = 0;	
}

_WallInst = instance_place(x, y_base + vy, oWall)
if(_WallInst != noone){
	if(!_WallInst.IsDoorEntrance) vy = 0;	
}

x += vx;

ObjSetY(y_base + vy);

z += vz;
if(Prob(0.88)) vz -= random_range(0.075, 0.15);

if(z <= 0){ //leaf landed
	z = 0;
	Speed -= random_range(0.1, 0.15); //slow down faster because of ground friction
}else{ //leaf in the air
	
	if(Prob(0.88)) Speed -= random_range(0.025, 0.075);
	
	if(Prob(0.075)){
		FlipX = FlipX * -1;
	}else if(Prob(0.075)){
		FlipY = FlipY * -1;
	}
}

if(Speed <= 0) Speed = 0;

if(Speed == 0 && z == 0){
	layer = global.LayerID_ObjsDoors_Upper;
	Stop = true;
}

if(AlwaysRotate){
	Angle += (irandom_range(2, 15) * AlwaysRotateDir);
}else if(Prob(0.8)){
	Angle += random_range(irandom_range(-2, -15), irandom_range(2, 15));
}

vx = lengthdir_x(Speed, Angle);
vy = lengthdir_y(Speed, Angle);

