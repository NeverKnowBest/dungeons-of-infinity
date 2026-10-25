enum SongIndex{
	None,
	Start,
	Castle,
	Dungeon1,
	Dungeon2,
	Dungeon3,
	Village,
	Village_Cave,
	Village_Store,
	Village_Pub,
	Village_Arcade,
	Village_Letter,
	Mines,
	Fairy,
	GemPond,
	WishRoom,
	Star,
	Letter,
	TMNT,
	Boss,
	Boss_Final_Hallway,
	Boss_Final,
	Sanctuary
}

enum MusicState{
	Stopped,
	Playing,
	Waiting
}

#macro SongFadeLen_CameraTransition 70
#macro SongFadeLen_House 70
#macro SongFadeLen_NextLevel 80

function Music_InitData(){
	
	
	global.Music_SongAsset[SongIndex.None] =				{Intro: noone,					Main : noone};
	global.Music_SongAsset[SongIndex.Start] =				{Intro: Music_Start_Intro,		Main : Music_Start_Main};
	global.Music_SongAsset[SongIndex.Castle] =				{Intro: Music_Castle_Intro,		Main : Music_Castle_Main};
	global.Music_SongAsset[SongIndex.Dungeon1] =			{Intro: Music_Dungeon1_Intro,	Main : Music_Dungeon1_Main};
	global.Music_SongAsset[SongIndex.Dungeon2] =			{Intro: Music_Dungeon2_Intro,	Main : Music_Dungeon2_Main};
	global.Music_SongAsset[SongIndex.Dungeon3] =			{Intro: Music_Dungeon3_Intro,	Main : Music_Dungeon3_Main};
	global.Music_SongAsset[SongIndex.Village] =				{Intro: Music_Village_Intro,	Main : Music_Village_Main};
	global.Music_SongAsset[SongIndex.Village_Cave] =		{Intro: Music_Cave_Intro,		Main : Music_Cave_Main};
	global.Music_SongAsset[SongIndex.Village_Store] =		{Intro: noone,					Main : Music_Village_Store};
	global.Music_SongAsset[SongIndex.Village_Pub] =			{Intro: noone,					Main : Music_Village_Pub};
	global.Music_SongAsset[SongIndex.Village_Arcade] =		{Intro: noone,					Main : Music_Village_Arcade};
	global.Music_SongAsset[SongIndex.Village_Letter] =		{Intro: noone,					Main : Music_Village_Letter};	
	global.Music_SongAsset[SongIndex.Mines] =				{Intro: noone,					Main : Music_Mines};
	global.Music_SongAsset[SongIndex.Fairy] =				{Intro: Music_Fairy_Intro,		Main : Music_Fairy_Main};
	global.Music_SongAsset[SongIndex.GemPond] =				{Intro: noone,					Main : Music_GemPond};
	global.Music_SongAsset[SongIndex.WishRoom] =			{Intro: Music_WishRoom_Intro,	Main : Music_WishRoom_Main};
	global.Music_SongAsset[SongIndex.Star] =				{Intro: noone,					Main : Music_Star};
	global.Music_SongAsset[SongIndex.Letter] =				{Intro: noone,					Main : Music_Village_Letter};
	global.Music_SongAsset[SongIndex.TMNT] =				{Intro: Music_TMNT_Intro,		Main : Music_TMNT_Main};
	global.Music_SongAsset[SongIndex.Boss] =				{Intro: Music_Boss_Intro,		Main : Music_Boss_Main};
	global.Music_SongAsset[SongIndex.Boss_Final_Hallway] =	{Intro: noone,					Main : Music_Boss_Final_Hallway};
	global.Music_SongAsset[SongIndex.Boss_Final] =			{Intro: Music_Boss_Final_Intro, Main : Music_Boss_Final_Main};
	global.Music_SongAsset[SongIndex.Sanctuary] =			{Intro: Music_Sanctuary_Intro,	Main : Music_Sanctuary_Main};

	
	global.Music_LevelSongIndex = [ SongIndex.Start,
									SongIndex.Castle,
									SongIndex.Castle,
									SongIndex.Castle,
									SongIndex.Dungeon1,
									SongIndex.Dungeon1,
									SongIndex.Village_Cave,
									SongIndex.Dungeon2,
									SongIndex.Dungeon1,
									SongIndex.Dungeon1,
									SongIndex.Mines,
									SongIndex.Dungeon2,									
									SongIndex.Dungeon3,
									SongIndex.Boss_Final_Hallway
								  ]	
	

	
}



function Music_Play(_SongIndex, _Delay = 1){
	
	if(oMusic.SongPlaying_Index == _SongIndex) exit; //that song index is already playing, so exit
	
	oMusic.SongIndexAssets = global.Music_SongAsset[_SongIndex];
	
	if(oMusic.SongIndexAssets.Intro != noone){
		oMusic.SongPlaying_Asset = oMusic.SongIndexAssets.Intro;
		oMusic.SongPlaying_Intro = true;
	}else{
		oMusic.SongPlaying_Asset = oMusic.SongIndexAssets.Main
		oMusic.SongPlaying_Intro = false;
	}
	
	oMusic.SongPlaying_Index = _SongIndex;
	
	oMusic.alarm[0] = _Delay;	
	
	oMusic.State = MusicState.Waiting;
	
}

function Music_Stop(){
	audio_stop_sound(oMusic.SongPlaying_Inst);
	oMusic.SongPlaying_Inst = noone;
	oMusic.Fade = false;
	oMusic.State = MusicState.Stopped;	
}

function Music_Fade(_FadeToGain = 0, _Frames = SongFadeLen_CameraTransition, NextSongIndex = -1){
	
	if(oMusic.Fade) exit; //song is already fading so exit and let it finish
	
	oMusic.Fade_Frames = max(_Frames, 1);
	oMusic.Fade_ToGain = _FadeToGain;
	var _GainDiff = _FadeToGain - oMusic.SongPlaying_Gain;
	oMusic.Fade_GainPerFrame = _GainDiff / _Frames;
	oMusic.Fade_NextSongIndex = NextSongIndex;
	oMusic.Fade = true;
}


function _Music_SetGain(_NewGain, _Time = 0){
	oMusic.SongPlaying_Gain = clamp(_NewGain, 0, 1);
	audio_sound_gain(oMusic.SongPlaying_Inst, oMusic.SongPlaying_Gain, _Time);
}

function Music_Mute(_Status){
	oMusic.Mute = _Status;
	oMusic.MuteEnable = true;	
}