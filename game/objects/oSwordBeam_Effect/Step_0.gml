if(global.Paused){
	ObjIncAlarms();
	audio_pause_sound(BeamSound);
	exit;
}else{
	if(BeamSound != noone){
		audio_resume_sound(BeamSound);
	}
}

x += vx;
y += vy;


RotAngle = RotAngle + (RotDir * RotSpeed);
if(RotAngle < 0) RotAngle += 360;
if(RotAngle >= 360) RotAngle -= 360;

for(var i = 0; i < 4; i++){
	BeamPosX[i] = x + lengthdir_x(RotDist, RotAngle + (i * 15));
	BeamPosY[i] = y + lengthdir_y(RotDist, RotAngle + (i * 15));
}


Lighting_UpdateLight_Pos(RoomIndex, LightIndex, BeamPosX[0], BeamPosY[0]);


switch(BeamColor){
	case 0:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.7, 0.4, 0.2]);
		break;
	case 1:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.2, 0.4, 0.7]);
		break;
}

