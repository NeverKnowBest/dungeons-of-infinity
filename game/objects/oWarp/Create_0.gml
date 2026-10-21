LightPhase[0] = 0;
LightPhase[1] = 1/3;
LightPhase[2] = 2/3;
LightPhaseSpeed = 0.01;
R = 1.6;
G = 1.0;
B = 0.8;
for(var i = 0; i < 3; i++){
	LightIndex[i] = Lighting_CreateLight(RoomIndex, x + 8, y + 8, (LightPhase[i] * 1.75), [lerp(R, 0, LightPhase[i]), lerp(G, 0, LightPhase[i]), lerp(B, 0, LightPhase[i])]);
}

IsSwitchWarp = false;