global.Paused = true;
global.LinkDead = true;
LastSongIndex = oMusic.SongPlaying_Index;
Music_Stop();
oMusic.SongPlaying_Index = -1;
audio_stop_all();
audio_play_sound(Sound_Hurt, 1, false);

Dungeon_DestroyUnimportantObjs();


StartFade = false;
FadeToBlack_Alpha = 0;
ShowRed = false;
SpinDir = DOWN;
SpinDelay = 6;
SpinCount = 12;
Falling = false;
FadeToGameOver = false;
GameOverSeq = noone;
GameOver = false;
ShowMenu = false;
Quit = false;
MenuText[0] = "New Game";
MenuText[1] = "Quit to Title";
MenuText[2] = "Quit to Desktop";

Selector_Index = 0;
Selector_Frame = 0;

PendantAni = false;
PendantAni_Y = oLink.y - 5;
PendantAni_V = -0.15;
PendantAni_YEnd = PendantAni_Y - 16;

ReviveLink = false;

FadeToWhite = false;
FadeToWhite_Alpha = 0;

FadeToGame = false;

alarm[0] = 40;

