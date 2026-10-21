if(instance_exists(Obj_promote_piece)){
	//wait player choose promote piece
	alarm[1] = 1;
	exit;
}

check_king = [false, false];//reset check king after every move

if( AI[global.current_player == 1] ){
	StockfishProcess = ProcessExecuteAsync("Stockfish.exe");
	do{
	}until ProcIdExists(StockfishProcess)
	alarm[0] = 30; //call AI code when AI turn
}

global.current_player *= -1;//change player after played


is_checkmate();//check is checkmate(win white,win black,DRAW)

check();//check


