
Music_Stop();

if(SongPlaying_Asset == noone) exit;

SongPlaying_Inst = audio_play_sound(SongPlaying_Asset, 1, SongIndexAssets.Intro == noone);

_Music_SetGain(1.0);
State = MusicState.Playing;	