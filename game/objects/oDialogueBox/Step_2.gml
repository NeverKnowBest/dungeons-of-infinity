if(CameraExists){

	if(oCamera.RoomTransition != NONE || oLink.State == LinkState.AutoMove) exit;

	if(oLink.State != LinkState.Dialogue || !global.Paused){
		with(oLink) UpdateState(LinkState.Dialogue);
		global.Paused = true;	
	}
	
}

if(ScriptNext){
	
	ScriptNext = false;
		
	do{	
	
		GotoFlag = false;
	
		ScriptCode = Script[# 0, ScriptPos];
	
		switch(ScriptCode){
	
			case DBScriptCode.Dialogue_YesNo:
			case DBScriptCode.Dialogue_Buy:
			case DBScriptCode.Dialogue_ChessEnd:
			case DBScriptCode.Dialogue_NoSound:
			case DBScriptCode.Dialogue:
				
				var DialogueStr = is_method(Script[# 1, ScriptPos]) ? Script[# 1, ScriptPos]() : Script[# 1, ScriptPos];
				
				//if dialogue string has "\\" in it, then use SplitStrToArray which splits the lines at every \\. 
				//Otherwise use SplitSentenceToArray which splits it automatically based on the width of the container
				//^ splits only the first line, then the rest gets split using SplitSentenceToArray.
				
				if(string_count("\\", DialogueStr) > 0){
					DialogueArray = SplitStrToArray(DialogueStr, "\\");	
				}else if(string_count("^", DialogueStr) > 0){
					Title = SplitStrToArray(DialogueStr, "^");
					DialogueArray = SplitSentenceToArray(Title[1], global.Font_Blue, SurfaceW);
					array_insert(DialogueArray, 0, Title[0]);
				}else DialogueArray = SplitSentenceToArray(DialogueStr, global.Font_Blue, SurfaceW) ;  
				
				LinesLeft = array_length(DialogueArray);
				SurfaceH = 0;
				SurfaceY = 0;
				SurfaceShiftDelay = 4;
				InputChoice = 0;
				Status = DialogueBoxStatus.InitFirstLines;
				break;
	
			case DBScriptCode.IfGoto:
				var Condition = Script[# 1, ScriptPos]();
				ScriptPos =  Condition ? Script[# 2, ScriptPos] : Script[# 3, ScriptPos];
				GotoFlag = true;
				break;
				
			case DBScriptCode.Error:
				audio_play_sound_stopall(Sound_Error);
				ScriptPos =  Script[# 1, ScriptPos]
				GotoFlag = true;
				break;
				
			case DBScriptCode.End:
				global.DB_ExitCode = Script[# 1, ScriptPos];
				Status = DialogueBoxStatus.Close;
				break;
		
		}

	}until !GotoFlag
	

	
}

switch(Status){
		
	case DialogueBoxStatus.InitFirstLines:
	
		if(SurfaceH < SurfaceMaxH){
			SurfaceH += 16;
			if(ScriptCode != DBScriptCode.Dialogue_NoSound){
				audio_play_sound(Sound_Text, 1, false);
			}
			
			if(SurfaceH >= SurfaceMaxH){
				SurfaceH = SurfaceMaxH;
				Status = DialogueBoxStatus.NextLineWait;
				if(ScriptCode != DBScriptCode.Dialogue_NoSound){
					audio_play_sound(Sound_TextDone, 1, false);
				}

			}else{
				SurfaceShiftDelay = 4;
				Status = DialogueBoxStatus.ShiftDelay;
				SurfaceShiftDelayLastState = DialogueBoxStatus.InitFirstLines;
			}
			if(!surface_exists(Surface)){
				Surface = surface_create(SurfaceW, floor(SurfaceH));
			}else surface_resize(Surface, SurfaceW, floor(SurfaceH));
		}
		break;
		
	case DialogueBoxStatus.NextLineWait:

			var Key = input_check_pressed("sword") || input_check_pressed("action");
			
			if(LinesLeft <= 3){
				switch(ScriptCode){
					case DBScriptCode.Dialogue:
					case DBScriptCode.Dialogue_NoSound:
						if(Key){
							ScriptPos = Script[# 2, ScriptPos];
							ScriptNext = true;
							exit;
						}
						break;
						
					case DBScriptCode.Dialogue_YesNo:
						Status = DialogueBoxStatus.Input;
						InputChoices = 2;
						
						break;
					case DBScriptCode.Dialogue_Buy:
					case DBScriptCode.Dialogue_ChessEnd:
						Status = DialogueBoxStatus.Input;
						InputChoices = 3;
						break;
				}
				
			}else{
				if(Key) Status = DialogueBoxStatus.ShiftLine;
			}
		break;
	
	case DialogueBoxStatus.ShiftLine:
		SurfaceY-=8;
		if(ScriptCode != DBScriptCode.Dialogue_NoSound){
			audio_play_sound(Sound_Text, 1, false);
		}
		if(SurfaceY mod (clamp(LinesLeft,1,3) * 16) == 0){
			LinesLeft -= 3;
			if(LinesLeft < 0) LinesLeft = 0;
			Status = DialogueBoxStatus.NextLineWait;
			if(ScriptCode != DBScriptCode.Dialogue_NoSound){
				audio_play_sound(Sound_TextDone, 1, false);
			}
		}else{
			SurfaceShiftDelay = 4;
			Status = DialogueBoxStatus.ShiftDelay;
			SurfaceShiftDelayLastState = DialogueBoxStatus.ShiftLine;
		}
		break;
		
	case DialogueBoxStatus.ShiftDelay:
		SurfaceShiftDelay--;
		if(SurfaceShiftDelay == 0)
			Status = SurfaceShiftDelayLastState;
		break;
	
	case DialogueBoxStatus.Input:
		if(input_check_pressed("left")){
			InputChoice -= 1;
			if(InputChoice < 0) InputChoice = InputChoices - 1;
		}
		if(input_check_pressed("right")){
			InputChoice = (InputChoice + 1) mod InputChoices;
		}
		if(input_check_pressed("sword") || input_check_pressed("action")){
			ScriptPos = Script[# 2 + InputChoice, ScriptPos];
			ScriptNext = true;
			exit;
		}
		break;
	
	case DialogueBoxStatus.Close:
		
		if(!instance_exists(oInventory)){
			global.Paused = false;
			with(oLink) UpdateState(LinkState.Standing);	
		}else{
			with(oLink) UpdateState(LinkState.Inventory);	
		}
		
		instance_destroy(id);
		exit;
		break;
			
}


	
