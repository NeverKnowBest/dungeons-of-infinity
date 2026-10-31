/// @description Level arrival audio delay
if(ExitLook[$ "ArriveSound"] == undefined) exit;	//a look with no sound on arrival (Edge: walking in from the edge of an area)
var snd = audio_play_sound(ExitLook.ArriveSound, 1, false);	//the look of the exit Link took (roadmap F4b)
audio_sound_gain(snd, 1, 1000);	

