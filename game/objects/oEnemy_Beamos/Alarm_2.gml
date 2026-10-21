/// @description Flash and shoot
FlashColorIndex++;
if(FlashColorIndex >= array_length(FlashColors)){
	Flashing = false;
	FlashColorIndex = 0;
	Beamos_Laser_Reset();
	Shooting = true;
	audio_play_sound(Sound_Beamos_Shoot, 1, false);
	alarm[3] = 60;
}else{
	alarm[2] = FlashSpeed;
}