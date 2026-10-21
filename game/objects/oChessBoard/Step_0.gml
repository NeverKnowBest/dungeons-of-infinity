if(!DB_Started && input_check_pressed("item")){
	
	switch(Status){
		case ChessStatus.Playing:
			var MsgInst = instance_create_layer(0, 0, "System", oDialogueBox_Chess, {Msg : "Resign?"});
			break;
		case ChessStatus.GameOver:
			var MsgInst = instance_create_layer(0, 0, "System", oDialogueBox_Chess, {Msg : "New Game?"});
			break;
	
	}
	//MsgBox("Exit game?", true);

	DB_Started = true;
	
}

if(DB_Started){
	
	if(!instance_exists(global.DB_Inst)){
		
		switch(global.DB_ExitCode){
			
			case 0:
				with(oLink) UpdateState(LinkState.VideoGame);
				break;
				
			case 1:
				instance_destroy(self);
				break;
			
			case 2:
				with(oLink) UpdateState(LinkState.VideoGame);
				Board_Reset();	
				break;
			
		}
		
		DB_Started = false;
		
	}else exit;
	
}

 
if(Status == ChessStatus.Playing){
	
	MoveType = MoveTypes.None;
	
	switch(global.Chess_Player){
		
		case Player.Human:
	
			if(input_check_pressed("left")){
				SelectionX--;
				if(SelectionX < 0) SelectionX += 8;
			}
			if(input_check_pressed("right")){
				SelectionX = (SelectionX + 1) mod 8;
			}
			if(input_check_pressed("up")){
				SelectionY--;
				if(SelectionY < 0) SelectionY += 8;
			}
			if(input_check_pressed("down")){
				SelectionY = (SelectionY + 1) mod 8;
			}

			if(input_check_pressed("action") || input_check_pressed("sword")){
	
				var _BoardGridY = 7 - SelectionY;
				
				if( sign(global.Board[SelectionX][_BoardGridY]) == global.Chess_Player && !array_equals_(piece_selected, [SelectionX, _BoardGridY])){
					var __t = get_legal_moves([SelectionX, _BoardGridY]);
					array_can_move = __t[0];
					array_can_capture = __t[1];
					piece_selected = [SelectionX, _BoardGridY];
					break;
				}
				if(array_find(array_can_move, [SelectionX, _BoardGridY]) || array_find(array_can_capture, [SelectionX, _BoardGridY])){
					move(piece_selected, [SelectionX, _BoardGridY]);
					StockfishStr = "";
				}else audio_play_sound(Sound_Chess_Notify, 1, false);
				
				array_can_move=[];
				array_can_capture=[];
				piece_selected=[];
				
			}
		
			break;
		
		
		case Player.AI:
			
			if(!AllowAIMove) break;
			
			do{
				
				StockfishProcess = ProcessExecuteAsync(GAMEDIR_DATA + "sf.exe");
				
				do{
				}until ProcIdExists(StockfishProcess);
	
				FEN_BeforeAIMove = BoardToFen();
				
				if(HalfMove <= 9)
					var DepthStr = string(irandom_range(5, 8)); //stronger for first few opening moves
				else
					var DepthStr = string(irandom_range(2, 5));
					
				ExecutedProcessWriteToStandardInput(StockfishProcess, "position fen " + FEN_BeforeAIMove + "\ngo depth " + DepthStr + "\n");
			
				do{
					AIOutput = ExecutedProcessReadFromStandardOutput(StockfishProcess)
					var BestMoveStrPos = string_pos("bestmove", AIOutput);
		
				}until (BestMoveStrPos != 0)
			
				AIOutput = string_copy(AIOutput, BestMoveStrPos, 100);
				
				FreeExecutedProcessStandardInput(StockfishProcess);
				FreeExecutedProcessStandardOutput(StockfishProcess);
				
				ProcIdKill(StockfishProcess);	
				do{
				}until !ProcIdExists(StockfishProcess);

				
			}until (string_pos("sf", AIOutput) == 0 && BestMoveStrPos != 0); //sometimes SF doesn't understand the command and spits out the greeting message, if so restart process and try again
			
			
			
			var StrStartX = 10;

			var MoveStr1 = string_copy(AIOutput, StrStartX, 1);
			var MoveStr2 = string_copy(AIOutput, StrStartX + 1, 1);
			var MoveStr3 = string_copy(AIOutput, StrStartX + 2, 1);
			var MoveStr4 = string_copy(AIOutput, StrStartX + 3, 1);
	
			PromotePiece = string_copy(AIOutput, StrStartX + 4, 1);
			if(PromotePiece == "b" || PromotePiece == "r") PromotePiece = "q"; //sometimes it picks a rook, might as well pick a queen
			
			MoveStart = [ord(MoveStr1) - 97, ord(MoveStr2) - 49];
			MoveEnd = [ord(MoveStr3) - 97, ord(MoveStr4) - 49];

			move(MoveStart, MoveEnd);
			
			break;
		
	}
	
	
	VerifyChecks();
	
	if(MoveType != MoveTypes.None){
		if(Status == ChessStatus.GameOver){
			audio_play_sound(Sound_Chess_Checkmate, 1, false);
			//Board_Reset();
		}else if(MoveType == MoveTypes.Capture){ 
			audio_play_sound(Sound_Chess_Capture, 1, false);
		}else{
			if(check_king[0] || check_king[1]){
				audio_play_sound(Sound_Chess_Check, 1, false);
			}else{
				audio_play_sound(Sound_Chess_Move, 1, false);
			}
		}
	}

}
