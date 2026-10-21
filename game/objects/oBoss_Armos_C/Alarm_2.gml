/// @description Shake alarm

State = EnemyState.Jumping;
with(oBoss_Armos) Enemy_UpdateState(EnemyState.Jumping);
ShakeOffset = 0;
audio_stop_sound(Sound_Push);
Armos_Waypoints_Set();
