
Time_PauseStart();
TimePlayed = Time_Str(Time_PlayingTotal());


MenuText[MenuSelection_GameMenuID.Main] = ["Resume Game", "New Game", "Options", "Quit to Title", "Quit to Desktop"];

MenuText[MenuSelection_GameMenuID.Options] = ["Back", "SFX:", "Music:", "HUD:", "CRT Effect:", "Item Msgs:"];

MenuText[MenuSelection_GameMenuID.Quit] = ["Cancel", "OK"];

for(var i = 0; i <= MenuSelection_GameMenuID.Quit; i++){
	MenuItems[i] = array_length(MenuText[i]);
}


SelectorPos = 0;

Index = 0;

QuitTo = 0;
Quitting = false;
QuitDelay = 30;


depth = -1000;

Alpha = 0;
AlphaSpeed = 0.18;

Open = true;
Close = false;

FrameW = 128;
FrameH = 154;
FrameX = oCamera.X + ((CAM_W - FrameW) / 2);
FrameY = oCamera.Y + ((CAM_H - FrameH) / 2);
FrameCentre = FrameX + (FrameW / 2);

PlayTimeY = FrameY + FrameH - 25;

global.Paused = true;

if(audio_is_playing(oLink.LowHealthSound)) audio_pause_sound(oLink.LowHealthSound);

audio_play_sound(Sound_Pickup, 1, false);

Music_Fade(0.25, 6);