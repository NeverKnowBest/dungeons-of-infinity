// Feather disable GM2064
// Hall of Fame gallery: one statue at a time, left/right goes to the next/previous one, up/down picks one of its
// achievements to read what it asks for. Created by oHallStatue with the Index of the statue Link talked to.
if(!variable_instance_exists(id, "Index")) Index = 0;
depth = -1000;
Sel = 0;
Slide = 0;
Alpha = 0;
Closing = false;
InputDelay = 2;
global.Paused = true;
Time_PauseStart();
with(oLink) UpdateState(LinkState.Inventory);
audio_play_sound(Sound_Pickup, 1, false);
