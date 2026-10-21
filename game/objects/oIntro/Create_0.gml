
//Lighting engine might be disabled from the ini file, so save the setting first, then reset it after
GLighting = global.GlobalLighting;
global.GlobalLighting = true; 

Intro_ShowLink();

DarkScreenAlpha = 1;
DrawDarkScreen = true;

CreatedWall = false;

alarm[0] = 1; //rain drops
alarm[1] = irandom_range(60, 100); //lighting
alarm[3] = 1; //rain splashes
alarm[5] = irandom_range(1, 40);

global.RainSound = audio_play_sound(Sound_Rain, 1, true, 0.3);

Setup = true;

NoMoreBombs = false;
NoMoreBombsText = "What!? You ran out of bombs? Your one job was to get into the castle using all these free bombs. If you couldn't figure that out, how will you defeat Agahnim? Well I guess you're stuck now, start a new game and try again Einstein."