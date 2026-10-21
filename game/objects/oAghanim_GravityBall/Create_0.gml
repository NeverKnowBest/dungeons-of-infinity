event_inherited();

FloorLevel = UPPER;

Enemy = true;
LinkTouchDestroy = false;

Damage = 3;

HitV = 3;
HitTime = 12;

Init = false;

Sound = audio_play_sound(Sound_AghanimGravityBall, 1, true);
SoundPaused = false;

LightIndex1 = Lighting_CreateLight(RoomIndex, x, y, 1.2, [1.3, 0.9, 0.5]);
LightIndex2 = Lighting_CreateLight(RoomIndex, x - 10, y + 26, 0.6, [1.0, 0.6, 0.3]);
LightIndex3 = Lighting_CreateLight(RoomIndex, x + 10, y + 26, 0.6, [1.0, 0.6, 0.3]);