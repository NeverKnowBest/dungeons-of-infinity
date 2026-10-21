LightFlickerDist += (LightFlickerDir * 0.01);
	
if(LightFlickerDir == 1 && LightFlickerDist >= LightFlickerLenTarget){
	LightFlickerDist = LightFlickerLenTarget;
	LightFlickerDir *= -1;
	LightFlickerLenTarget = random_range(0.01, LightFlickerLenMax);
}else if(LightFlickerDir == -1 && LightFlickerDist <= 0){
	LightFlickerDist = 0;
	LightFlickerDir *= -1;
}

Lighting_UpdateLight_Radius(RoomIndex, LightIndex, LightStrength + LightFlickerDist);