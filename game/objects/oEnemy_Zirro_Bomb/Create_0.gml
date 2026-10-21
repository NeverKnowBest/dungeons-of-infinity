event_inherited();

Speed = 1;

vx = 0;
vy = 0;
vz = 0;
az = -0.05;
z = 16;

ObjSetY(y);
FloorLevel = GetFloorLevelID(x, y_base);

AnimationEndDestroy = false;

if(oCamera.InView(x, y_base)){
	if(!audio_is_playing(Sound_Fall)) audio_play_sound(Sound_Fall, 1, false);
}