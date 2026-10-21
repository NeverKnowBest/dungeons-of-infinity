event_inherited();

if(PlaySound){
	if(oCamera.InView(x, y)) audio_play_sound(Sound_Hookshot, 1, false, 0.7);
}

LightStrength = 0.75;
LightIndex = Lighting_CreateLight(RoomIndex, x, y, LightStrength, [0.2, 0.2, 0.2]);
