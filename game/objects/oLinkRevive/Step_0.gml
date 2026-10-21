
RotAngle = RotAngle + (RotDir * RotSpeed);
if(RotAngle < 0) RotAngle += 360;
if(RotAngle >= 360) RotAngle -= 360;

for(var i = 0; i < 4; i++){
	BeamPosX[i] = x + lengthdir_x(RotDist, RotAngle + (i * 15));
	BeamPosY[i] = y + lengthdir_y(RotDist, RotAngle + (i * 15));
}
