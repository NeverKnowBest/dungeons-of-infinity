PauseImageExit

x += vx;
ObjSetY(y_base + vy);

event_inherited();

if(WallCollided || Destroyed){
	instance_create_layer(x, y, EffectLayer(FloorLevel), oPotExplosion);
	audio_play_sound_stopall(Sound_PotShatter);
	instance_destroy(id);
}

