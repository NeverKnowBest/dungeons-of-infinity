with(oLink){
	UpdateState(LinkState.VideoGame);	
}

StockfishProcess = 0;
StockfishStr_Win = "Checkmate! Good game!"
StockfishStr_Lose = "You are a chess master!"
StockfishStr_Draw = "It's a draw! Good Game!"
StockfishStr_Start = "Your move. Good luck!"

AllowAIMove = true;

DB_Started = false;

Board_Reset("");


AIWindowW = sprite_width + 26;
AIWindowX = x + ((sprite_width - AIWindowW) / 2);
AIWindowY = y - 36;


