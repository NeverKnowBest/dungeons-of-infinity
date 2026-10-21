enum DialogueBoxStatus{
	InitFirstLines,
	NextLineWait,
	ShiftLine,
	ShiftDelay,
	Input,
	Close
}

enum DBScriptCode{
	Dialogue,
	Dialogue_YesNo,
	Dialogue_Buy,
	Dialogue_ChessEnd,
	Dialogue_NoSound,
	IfGoto,
	Error,
	End
}

#macro DialogueBoxW 200
#macro DialogueBoxH 62
#macro DialogueBoxW_Curse 232
#macro DialogueBoxH_Curse 52

global.DB_Inst = noone;
global.DB_ExitCode = 0;

global.DB_MsgBoxQueue = ds_queue_create();

function MsgBox(_Str, _YesNo = false, _PlaySound = noone, _Method = undefined, _Y = 144, _CenterText = false){
	
	var _Inst = noone;
	if(global.DB_Inst != noone){
		ds_queue_enqueue(global.DB_MsgBoxQueue, [_Str, _YesNo, _PlaySound, _Method, _CenterText]);
	}else{
		_Inst = instance_create_layer(0, 0, "System", oDialogueBox_Msg, {Msg : _Str, YesNo : _YesNo, Method : _Method, Y : _Y, CenterText : _CenterText});
		if(_PlaySound != noone) audio_play_sound_stopall(_PlaySound);
	}
	
	return _Inst
	
}

function DialogueCycle(_DialogueArray, _SavedDialogueArray){
	
	//this function makes sure a new dialogue is selected from a dialogue array while avoiding dialogues used from a user array which is saved.
	//Examples that use this is the fortune teller prisoner and catacomb grave headings. They are used once per level and the ones used are saved so the next time it picks a new one.
	//Once all are used then the user array is cleared
	//See user script to see how to add and save a dialogue array
	
	var _Dialogues = array_length(_DialogueArray);
					
	//if all readings have been used, array will be filled with all fortune indexes, so erase it
	var _SavedArraySize = array_length(_SavedDialogueArray);
	if(_SavedArraySize >= _Dialogues){
		array_delete(_SavedDialogueArray, 0, _SavedArraySize);
	}
					
	//add all unused dialogues to array
	var _UnusedDialogues = [];
	for(var i = 0; i < _Dialogues; i++){
		if(!array_contains(_SavedDialogueArray, i)) array_push(_UnusedDialogues, i);
	}
					
	_UnusedDialogues = array_shuffle(_UnusedDialogues);
					
	var _DialogueIndex = _UnusedDialogues[0];
					
	array_push(_SavedDialogueArray, _DialogueIndex);
	User_Save();
	
	return _DialogueIndex;
	
}