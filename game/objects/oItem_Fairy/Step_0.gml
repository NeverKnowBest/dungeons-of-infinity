PauseObj

x += vx;
z = clamp(z + vz, z_min, z_max);

ObjSetY(y_base + vy);


if( (vx < 0 && x < ContainX1) || vx > 0 && x > ContainX2){
	x = clamp(x, ContainX1, ContainX2);
	vx *= -1;
}
if( (vy < 0 && y_base < ContainY1) || (vy > 0 && y_base > ContainY2)){
	ObjSetY(clamp(y_base, ContainY1, ContainY2));
	vy *= -1;
}
	


Dir = vx >= 0 ? 1 : -1;
