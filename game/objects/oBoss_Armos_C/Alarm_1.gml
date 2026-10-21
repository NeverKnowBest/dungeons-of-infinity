/// @description Still alarm
State = EnemyState.Wake;
with(oBoss_Armos) Enemy_UpdateState(EnemyState.Wake);
Sound = audio_play_sound(Sound_Push, 1, true);
alarm[2] = 90;
