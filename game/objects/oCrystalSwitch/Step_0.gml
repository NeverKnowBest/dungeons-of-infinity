
if(Hit && !visible){
	Hit = false;
	exit;
}

if(Hit && !HitPause){
	global.Level.SwitchBlock_ActiveColor = global.Level.SwitchBlock_ActiveColor xor 1;
	with(oSwitchBlock) Toggle = true;
	Hit = false;
	HitPause = true;
	alarm[0] = 25;
	audio_play_sound(Sound_CrystalHit, 1, false);

}

if(LightID == -1) exit;

if(image_index != global.Level.SwitchBlock_ActiveColor){
	Crystal_UpdateLightColor();
}
