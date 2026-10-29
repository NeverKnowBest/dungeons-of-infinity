// The level's weather (scripts/__Weather): the sheet's fields over the defaults
var _Weather = Weather_Defaults();
var _Sheet = LevelDef.Weather;
var _Names = variable_struct_get_names(_Sheet);
for(var i = 0; i < array_length(_Names); i++) _Weather[$ _Names[i]] = _Sheet[$ _Names[i]];
Cfg = _Weather;

//Lighting engine might be disabled from the ini file, so save the setting first, then reset it after
GLighting = global.GlobalLighting;
global.GlobalLighting = true;

DrawNight = true;

if(Cfg.Rain) alarm[0] = 1; //rain drops
if(Cfg.Lightning) alarm[1] = irandom_range(60, 100); //lighting
if(Cfg.Rain) alarm[3] = 1; //rain splashes
if(Cfg.Leaves) alarm[5] = irandom_range(1, 40);

if(Cfg.Rain){
	if(audio_is_playing(global.RainSound)) audio_stop_sound(global.RainSound);
	global.RainSound = audio_play_sound(Sound_Rain, 1, true, Cfg.Volume);
}

Setup = true;
