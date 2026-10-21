if(global.Paused) exit;

x += vx;
ObjSetY(y_base + vy);
vz += az;
z += vz;

if(z <= 1){
	if(tilemap_get_at_pixel(global.TMID_Floor_Lower, x, y_base) == 0){
		instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHigher_Upper", oSparkle);
		instance_destroy(id);
		exit;
	}
}

if(z <= 0){
	instance_create_layer(x, y, "ObjsHighest", oEnemy_Zirro_BombExplosion);
	instance_destroy(id);
}