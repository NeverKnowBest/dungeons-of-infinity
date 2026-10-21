enum SongIndex{
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
	Fairy,
	Boss,
	Boss_Final_Hallway,
	Boss_Final	
}

enum MusicState{
	Stopped,
	Playing
}

function Music_InitData(){
	
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
	global.Music_SongAsset[SongIndex.Fairy] =				{Intro: Music_Fairy_Intro,		Main : Music_Fairy_Main};
	global.Music_SongAsset[SongIndex.Boss] =				{Intro: Music_Boss_Intro,		Main : Music_Boss_Main};
	global.Music_SongAsset[SongIndex.Boss_Final_Hallway] =	{Intro: noone,					Main : Music_Boss_Final_Hallway};
	global.Music_SongAsset[SongIndex.Boss_Final] =			{Intro: Music_Boss_Final_Intro, Main : Music_Boss_Final_Main};
	
	
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
									SongIndex.Dungeon1,
									SongIndex.Dungeon2,
									SongIndex.Dungeon3,
									SongIndex.Dungeon3,
									SongIndex.Dungeon3,
									SongIndex.Boss_Final_Hallway
								  ]	
	

	
	//audio_group_set_gain(audiogroup_SFX, 0.8, 0);
	//audio_group_set_gain(audiogroup_Music, 0.6, 0);

	audio_master_gain(0.5);
	//audio_master_gain(0.0);

	//global.Music_DefaultLevel = 0.5;	
	
}



function Music_Play(_SongIndex, _Delay = 1){
	
	if(oMusic.SongPlaying_Index == _SongIndex) exit; //that song index is already playing, so exit
	
	var _Asset = global.Music_SongAsset[_SongIndex];
	
	if(_Asset.Intro != noone){
		oMusic.SongPlaying_Asset = _Asset.Intro;
		oMusic.SongPlaying_Intro = true;
	}else{
		oMusic.SongPlaying_Asset = _Asset.Main
		oMusic.SongPlaying_Intro = false;
	}
	
	oMusic.SongPlaying_Index = _SongIndex;
	
	oMusic.alarm[0] = _Delay;	
	
}

function Music_Stop(){
	audio_stop_sound(oMusic.SongPlaying_AudioInst);
	oMusic.Fade = false;
	oMusic.State = MusicState.Stopped;	
}

function _Music_SetGain(_NewGain){
	oMusic.SongPlaying_Volume = _NewGain;
	audio_sound_gain(oMusic.SongPlaying_AudioInst, oMusic.SongPlaying_Volume, 0);
}

