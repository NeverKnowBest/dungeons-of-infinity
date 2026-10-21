enum MusicState{
	Stopped,
	Play,
	FadeOut	
}

function Music_GetLevelMusicStr(_Level){
	switch(_Level){
		case DungeonLevel.Castle: case DungeonLevel.CastleBasement: case DungeonLevel.CastleJails: return "Castle";
		case DungeonLevel.Catacombs: case DungeonLevel.Sewers: case DungeonLevel.Mines: case DungeonLevel.LanmolasLair: return "Dungeon0";
		case DungeonLevel.Ruins1: case DungeonLevel.Ruins2: case DungeonLevel.Ruins3: case DungeonLevel.MoldormsLair: return "Dungeon1";
		case DungeonLevel.Aghanim1: case DungeonLevel.Aghanim2: case DungeonLevel.Aghanim3: return "Dungeon0";
	}
	
}
function Music_PlayDungeonMusic(_Level, _Fade = false, _FadeTime = 2000){
	var MusicStr = "Music_" + Music_GetLevelMusicStr(_Level);
	var Asset_Intro = asset_get_index(MusicStr + "_Intro");
	var Asset_Main = asset_get_index(MusicStr + "_Main");
	if(_Fade)
		Music_FadeOut(_FadeTime, Asset_Intro, Asset_Main, true);
	else
		Music_Play(Asset_Intro, Asset_Main, true);

}

function Music_Play(Intro, Main, MainLoop){
	
	audio_stop_sound(oMusic.Song_Playing);
	
	oMusic.Song_Intro = Intro;
	oMusic.Song_Main = Main;
	oMusic.Song_Main_Loop = MainLoop;
	
	oMusic.Song_Queued = (oMusic.Song_Intro != noone ? oMusic.Song_Intro : oMusic.Song_Main);
	
	oMusic.State = MusicState.Play;
	
}

function Music_FadeOut(Time, NextSong_Intro, NextSong_Main, NextSong_MainLoop){
	
	audio_sound_gain(oMusic.Song_Playing, 0, Time);

	oMusic.Song_Intro = NextSong_Intro;
	oMusic.Song_Main = NextSong_Main;
	oMusic.Song_Main_Loop = NextSong_MainLoop;
	
	oMusic.Song_Queued = (oMusic.Song_Intro != noone ? oMusic.Song_Intro : oMusic.Song_Main);
	
	oMusic.State = MusicState.FadeOut;
}