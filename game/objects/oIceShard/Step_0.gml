x += vx;
ObjSetY(y_base + vy);
vz += g;
z += vz;
if(z <= 0){		
	instance_destroy(id);
	instance_create_layer(x, y_base, "ObjsDoors_" + FloorLevelStr, oSparkle);
}
