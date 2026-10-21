
NoteFrame++;

if(NoteFrame >= NoteFrameCount || Index == -1){
	NoteFrame = 0;
	Index = -1;
	PlayNote = false;
}else{
	if(NoteFrame == 2) audio_play_sound(Notes[Index], 1, false);
	alarm[0] = NoteFrameDelay;
}