if(!visible) exit;

for(var i = 0; i < 3; i++){

	LightPhase[i] += LightPhaseSpeed;

	if(LightPhase[i] >= 1)	LightPhase[i] -= 1;

	var _NewR = lerp(R, 0, LightPhase[i]);
	var _NewG = lerp(G, 0, LightPhase[i]);
	var _NewB = lerp(B, 0, LightPhase[i]);
	
	Lighting_UpdateLight_RGB(RoomIndex, LightIndex[i], [_NewR, _NewG, _NewB])
	Lighting_UpdateLight_Radius(RoomIndex, LightIndex[i], LightPhase[i] * 1.75);
	
}