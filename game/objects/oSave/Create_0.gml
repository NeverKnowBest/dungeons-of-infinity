depth = -1000;

Alpha = 0;
AlphaSpeed = 0.18;

Open = true;

FrameW = 104;
FrameH = 96;
FrameX = oCamera.X + 48;
FrameY = oCamera.Y + 48;
FrameCentre = FrameX + (FrameW / 2);

audio_play_sound(Sound_Antidote, 1, false);

var i = 0;
MenuText[i++] = "Quit to Title"
MenuText[i++] = "Quit to Desktop"

MenuItems = array_length(MenuText);

SelectorPos = 0;

QuitTo = 0;

User_SaveGame();

with(oLink){
	UpdateState(LinkState.Dialogue);
}
global.Paused = true;