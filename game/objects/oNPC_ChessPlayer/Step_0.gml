if(DB_Started){
	if(!instance_exists(global.DB_Inst)){
		
		if(global.DB_ExitCode == 1){
			instance_create_layer(x - 12, y - 100, "ObjsHigher_Upper", oChessBoard);
		}		
		DB_Started = false;
		
	}else exit;
	
}

if(OfferGame){
	MsgBox("Want to play a game of chess\\with me?", true);
	OfferGame = false;
	DB_Started = true;
}
