/// @description Advance mouth frame


MouthFrame++;

if(MouthFrame >= 3){
	Octorok_Shoot();
	alarm[4] = ShotDelay / 2;
	MouthFrame = 0;
}else alarm[2] = MouthFrameDelay;
	
