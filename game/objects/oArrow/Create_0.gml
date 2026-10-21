event_inherited();


Speed = 7;

Damage = 3;

FloorLevel = oLink.FloorLevel;
FloorLevelStr = GetFloorLevelString(FloorLevel);

DestroyTimer = false;

ObjSetImageSpeed(0);
alarm[1] = 3;

audio_play_sound_stopall(Sound_Arrow_Shoot);

visible = false;
Setup = true;