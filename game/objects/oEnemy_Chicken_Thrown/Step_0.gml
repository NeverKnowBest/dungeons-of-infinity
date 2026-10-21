if(global.Paused) exit;

vz += g;
z += vz;

x += vx;
ObjSetY(y_base + vy);


if(WallCollided){
	
}

if(z <= 0){
	var inst = instance_create_layer(x, y_base, "Objs_" + GetFloorLevelString(x, y_base), oEnemy_Chicken);
	instance_destroy();
}
	
