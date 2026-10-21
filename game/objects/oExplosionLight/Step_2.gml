
if(LightUpdate){
	Lighting_UpdateLight_Radius(RoomIndex, LightIndex, S[LightFrame] + random_range(-0.1, 0.1));
	Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [R[LightFrame], G[LightFrame], B[LightFrame]]);
	alarm[0] = LightDelay;
	LightUpdate = false;
}