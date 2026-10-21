event_inherited();

instance_create_layer(x, y, "ObjsHigher_" + FloorLevelStr, oExplosionLight);


if(oCamera.InView(x, y)){
	audio_play_sound_stopall(Sound_BombBlow);
}