/// @description Start moving
Sound = audio_play_sound(Sound_MoldormSkitter, 1, true);
alarm[1] = 30;
Enemy_UpdateState(EnemyState.Walking);
//StartMoving = true;
