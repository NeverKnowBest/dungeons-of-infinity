enum IntroState{
	PreIntro,
	Intro,
	Fade,
	Start
}

global.RainSound = noone;

function Intro_ShowLink(){
	with(oLink){
		y += 40;
		Link_SetAutoMove(0, -1, WalkSpeed, 40);
	}
	oHUD.ShowLevelName = true;
	Music_Play(global.Music_LevelSongIndex[DungeonLevel.Start], 10);
	audio_sound_gain(global.RainSound, 0.7, 200);
	State = IntroState.Fade;
}