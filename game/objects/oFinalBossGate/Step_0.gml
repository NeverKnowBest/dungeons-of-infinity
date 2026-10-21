if(Destroyed && !DestroyedInit){
	instance_create_layer(BatX, BeamY + 8, "ObjsHighest", oEnemy_Destroy);
	audio_play_sound(Sound_Enemy_Kill, 1, false);
	DestroyedInit = true;
	alarm[0] = 40;	
}

if(ShowBeam){
	Frame = (Frame + 0.5) mod 4;
	Lighting_UpdateLight_Radius(RoomIndex, LightIndex, LightRadius[irandom(5)]);
}
