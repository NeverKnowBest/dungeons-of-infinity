function Beamos_Laser_Reset(){
	LaserPointsX = 0;
	LaserPointsY = 0;
	LaserPointsX[0] = EyeX;
	LaserPointsY[0] = EyeY;
	LaserPoints = 1;
	Shooting = false;
}

function Beamos_Laser_Draw(){
	for(var i = Beamos_Laser_MinPoint(); i < LaserPoints; i++){
		draw_sprite(sEnemy_Beamos_Laser, 0, LaserPointsX[i], LaserPointsY[i]);	
	}	
}

function Beamos_EyeX(){
	return x + (dcos(-EyeA) * EyeR * 2);
}

function Beamos_EyeY(){
	return y - 19 + (dsin(-EyeA) * EyeR);
}

function Beamos_Laser_Hit(_x, _y){
	instance_create_layer(_x, _y, "ObjsHigher_" + FloorLevelStr, oBeamosHit);
	Beamos_DestroyLaserLights();
	Beamos_Laser_Reset();		
}

function Beamos_Laser_MinPoint(){
	return max(LaserPoints - LaserLength, 0);
}

function Beamos_DestroyLaserLights(){
	for(var i = 0; i < array_length(LaserLights); i++){
		Lighting_DestroyLight(RoomIndex, LaserLights[i]);
	}
	LaserLights = [];
}