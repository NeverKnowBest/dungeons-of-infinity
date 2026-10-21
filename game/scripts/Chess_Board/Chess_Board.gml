#macro Pawn 1
#macro Rook 2
#macro Night 3
#macro Bishop 4
#macro Queen 5
#macro King 6

enum ChessStatus{
	Playing,
	GameOver
}

enum Player{
	AI = -1,	
	Human = 1	
}

function Board_Reset(_FEN = ""){
	
	Status = ChessStatus.Playing;
	StockfishStr = StockfishStr_Start;	
	SelectionX = 4;
	SelectionY = 6;
	FromSquare = [-1, -1];
	ToSquare = [-1, -1];
	HalfMove = 0;
	PromotePiece = "";
	check_castle_king=[true,true,true,true,true,true]//used to know if you can castle king or not
	King_pos=[[4,7],[4,0]];//used to know King position
	check_king=[false,false];//used to know check for King or not
	moved_arr = []//history all moved
	enpassent = []//used to know if have en passent or not
	array_can_move=[]//used to know that moved can't captured
	array_can_capture=[]//used to know that moved can captured
	piece_selected=[];//used to save selected piece
	
	global.Chess_Player = Player.Human;

	for(var i = 0; i < 8; i++){
		global.Board[i] = [0,0,0,0,0,0,0,0];
	}

	if(_FEN != ""){
		FenToBoard(_FEN);
	}else{
		
		//Positive = White, Negative = Black
	
		//Pawns
		for(var i = 0; i < 8; i++){
			global.Board[i][1] = Pawn;
			global.Board[i][6] = -Pawn;
		}

	
		global.Board[0][7] = -Rook;
		global.Board[1][7] = -Night;
		global.Board[2][7] = -Bishop;
		global.Board[3][7] = -Queen;
		global.Board[4][7] = -King;
		global.Board[5][7] = -Bishop;
		global.Board[6][7] = -Night;
		global.Board[7][7] = -Rook;

		global.Board[0][0] = Rook;
		global.Board[1][0] = Night;
		global.Board[2][0] = Bishop;
		global.Board[3][0] = Queen;
		global.Board[4][0] = King;
		global.Board[5][0] = Bishop;
		global.Board[6][0] = Night;
		global.Board[7][0] = Rook;
	
	}
	
}

function is_on_board(_x, _y){
	return _x >= 0 && _x <= 7 && _y >= 0 && _y<=7
}

function get_position_king(_piece){
	
	///used to return king position

	for(var j = 0; j < 8; j++){
        for(var i = 0; i < 8; i++){
            if(global.Board[i][j] == _piece){
				return [i,j]
			}
		}
	}
	//return []
}

function get_legal_moves(___piece_p = [0,0]){
	
	var __t = get_possible_moves(___piece_p);//return all possible moves (__t[1]=moves captured,__t[0]=moves not captured)
	//delete if not legal moves
	for(var i = array_length(__t[1]) - 1; i >= 0; i--){
		if(!_validate_move(___piece_p, __t[1][i])){
			array_delete(__t[1], i, 1);
		}
	}
	
	for(var i = array_length(__t[0]) - 1; i >= 0; i--){
		if(!_validate_move(___piece_p, __t[0][i])){
			array_delete(__t[0],i,1);
		}
	}

	return [__t[0], __t[1]]
	
}

function move(___piece_p=[0,0], ___position=[0,0]){
	
	FromSquare = ___piece_p;
	ToSquare = ___position;
	
	var __piece = global.Board[___piece_p[0]][___piece_p[1]];
	var __type_piece = abs(__piece);//used to know type piece

	HalfMove++;
	
	if(global.Board[___position[0]][___position[1]] != 0){
		HalfMove = 0;//reset halfmove when captured
		if(abs(global.Board[___position[0]][___position[1]]) == King){//kill king
			Status = ChessStatus.GameOver;
			StockfishStr = (global.Chess_Player == Player.AI ? StockfishStr_Win : StockfishStr_Lose);
			exit;
		}
	}
	
	if(__type_piece == King){
		
		//change rook too if move is castle king
		if(check_castle_king[(__piece > 0)] && abs(___piece_p[0] - ___position[0]) == 2){
			if(___position[0] == 2){
				var __rookxold = 0;
				var __rookxnew = 3;
			}else{
				var __rookxold = 7;
				var __rookxnew = 5;
			}
			var __rook = global.Board[__rookxold][___piece_p[1]];
	        global.Board[__rookxold][___piece_p[1]] = 0;
			global.Board[__rookxnew][___piece_p[1]] = __rook;
		}
		King_pos[(__piece > 0)] = ___position;//change King_pos to new position King
	}else{
		if(__type_piece == Pawn){//remove en passent pawn 
			if(array_equals_([___position[0], ___piece_p[1]], enpassent)){
				global.Board[___position[0]][___piece_p[1]] = 0;
			}

		}
	}
	
	//do move

	global.Board[___piece_p[0]][___piece_p[1]]=0;
	global.Board[___position[0]][___position[1]]=__piece;
	
	//if array_length(moved_arr)>FEN_index{array_delete(moved_arr,FEN_index,array_length(moved_arr)-FEN_index)}//remove old moved when FEN_index not last element in FEN array
	array_push(moved_arr,[__piece,___piece_p,___position])//add [piece,old position,new poisition] to moved_arr(history)

	
	enpassent=[]//reset enpassent
    if __type_piece==Pawn
	{
		HalfMove=0
		if (___position[1]==0 or ___position[1]==7)//if promote pawn
		{
			if(PromotePiece != "")
			{
				global.Board[___position[0]][___position[1]] = PromoteStrToPiece(PromotePiece) * sign(__piece)

			}
			else
			{//show board to user choose promote
				global.Board[___position[0]][___position[1]] = Queen * sign(__piece)
			//	var __ins=instance_create_depth(room_width/2,room_height/2,-1,Obj_promote_piece)
			//	__ins.piece_to_promote=___position
			}
		}
		else
		{//enpassent when pawn move 2 steps
			if abs(___position[1]-___piece_p[1])==2{enpassent=___position}
		}
	}
	PromotePiece = "";

	for(var i=0;i<6;i++) //check from array "check_castle_king" if king and rook in the first position or not
	{
		if check_castle_king[i]
		{
			if global.Board[(i<2?4:(i<4?0:7))][7-7*(i%2)]!=(i<2?6:2)*((i%2)==1?1:-1){check_castle_king[i]=false;}
		}
	}

	global.Chess_Player *= -1;
	if(global.Chess_Player == Player.AI) alarm[0] = 30; //add pause to AI before move
	
}

function _validate_move(___piece_p,___new_position)
{
    //returns false if enemy can respond by capturing your king
	var __piece=global.Board[___piece_p[0]][___piece_p[1]];
	var __type_piece = abs(__piece);
    var __captured_en_passant = 0;
	//make fake move to check
    //copy whatever was at this position
    var __captured_piece = global.Board[___new_position[0]][___new_position[1]];
	global.Board[___piece_p[0]][___piece_p[1]] = 0;
    global.Board[___new_position[0]][___new_position[1]] = __piece;
    //if the move is en passant, copy the captured piece
    if(__type_piece == Pawn){
		if(array_length(enpassent) > 0){
			if(array_equals_([___new_position[0], ___piece_p[1]], enpassent)){
			    __captured_en_passant = global.Board[___new_position[0]][___piece_p[1]];
			    global.Board[___new_position[0]][___piece_p[1]] = 0;
			}
		}
	}
	
    global.Board[___piece_p[0]][___piece_p[1]] = 0;
    global.Board[___new_position[0]][___new_position[1]] = __piece;
	
	var __king_p = King_pos[(__piece > 0)];
    //if king is trying to castle through attacked position or through check
    if(__type_piece == King){
		if(abs(___new_position[0] - ___piece_p[0]) == 2){
	        if(check_king[__piece > 0] || (_validate_move(___new_position, [(___new_position[0] + ___piece_p[1]) / 2, ___new_position[1]]) == false)){
				//undo fake move and return false
				global.Board[___piece_p[0]][___piece_p[1]] = __piece;
				global.Board[___new_position[0]][___new_position[1]] = __captured_piece;
				return false//not legal move
			}
		}
		__king_p = ___new_position;//change check position king to new position when type piece==king
	}
	if(global.Board[__king_p[0]][__king_p[1]] == !King * sign(__piece)){
		King_pos[(__piece > 0)] = get_position_king(King * sign(__piece));
		__king_p = King_pos[(__piece > 0)];
	}
	//check if king under attack after move piece
	var __chkpiece = sign(__piece) * -1;
	for(var j = 0; j < 8; j++){
        for(var i = 0; i < 8; i++){
            if(sign(global.Board[i][j]) == __chkpiece){
				if(is_possible_moves_captured_king([i,j], __king_p)){
					//undo fake move and return false
					global.Board[___piece_p[0]][___piece_p[1]] = __piece;
					global.Board[___new_position[0]][___new_position[1]] = __captured_piece;
		            if(__captured_en_passant != 0){
						global.Board[___new_position[0]][___piece_p[1]] = __captured_en_passant;
					}
		            return false//not legal move
				}
			}
		}
	}
	
	//undo fake move and return true
	global.Board[___piece_p[0]][___piece_p[1]] = __piece;
	global.Board[___new_position[0]][___new_position[1]] = __captured_piece;
    if(__captured_en_passant != 0){
		global.Board[___new_position[0]][___piece_p[1]] = __captured_en_passant;
	}
    return true//legal move
}

function VerifyChecks(){
	
	//broken, fix
	
	check_king = [false, false];//reset check king after every move
	
	//check from pieces opponent's if can be captured king
	var __king_p = King_pos[(global.Chess_Player == Player.Human)];
    
	if(global.Board[__king_p[0]][__king_p[1]] == !King * global.Chess_Player){
		King_pos[(global.Chess_Player == Player.Human)] = get_position_king(King * global.Chess_Player);
		__king_p = King_pos[(global.Chess_Player == Player.Human)];
	}
	
	var __chkpiece = global.Chess_Player * -1;
	for(var j = 0; j < 8; j++){
	    for(var i = 0; i < 8; i++){
            if(sign(global.Board[i][j]) ==__chkpiece){
                if(is_possible_moves_captured_king([i,j], __king_p)){
					check_king[global.Chess_Player == Player.Human] = true;//check_king=true when pieces opponent's can captured king
					exit;
				}
			}
		}
	}
	
	//check if can player have legal moved or not
    for(var j = 0; j < 8; j++){
	    for(var i = 0; i < 8; i++){
            if(sign(global.Board[i][j]) == global.Chess_Player){
				var __t = get_legal_moves([i,j]);
                if(array_length(__t[0]) > 0 || array_length(__t[1]) > 0){
					exit;
				}
			}
		}
	}

	
	if(check_king[1]){
		Status = ChessStatus.GameOver
		StockfishStr = StockfishStr_Win;
		exit;
	}else if(check_king[0]){
		Status = ChessStatus.GameOver
		StockfishStr = StockfishStr_Lose;
		exit;
	}	
    StockfishStr = StockfishStr_Draw;
}


function BoardToFen()
{
	var __arrPS=["k","q","b","n","r","p","","P","R","N","B","Q","K"]
    var __fen="";
    var __c=0;
    for(var j = 7; j >= 0; j--){
        for(var i = 0; i <= 7; i++){
            if(global.Board[i][j] == 0){
				__c++;
			}else{
				if(__c > 0){
					__fen += string(__c);
				}
				__fen += __arrPS[6+global.Board[i][j]];
				__c=0;
			}
            if( i == 7){
				if(__c > 0){
					__fen += string(__c);
					__c=0
				}
				if(j > 0){
					__fen += "/";
				}
			}
        }
    }

    if(global.Chess_Player == Player.Human){
		__fen += " w";
	}else{
		__fen += " b";
	}

    var __rights = "";
    if(check_castle_king[1]){
		if(check_castle_king[5]){
			__rights+="K";
		} 
		if(check_castle_king[3]){
			__rights += "Q";
		}
	}
	
	if(check_castle_king[0]){
		if(check_castle_king[4]){
			__rights += "k";
		}
		if(check_castle_king[2]){
			__rights += "q";
		}
	}
	
    if(__rights == ""){
		__fen += " -";
	}else{
		__fen += " " + __rights;
	}

	if(array_length(enpassent) == 0){
		__fen += " -";
	}else{
		__fen += " " + chr(97 + enpassent[0]) + string(enpassent[1] + 1);
	}

    __fen += " " + string(HalfMove) + " " + string(1 + floor(HalfMove / 2));

    return __fen;
}

function FenToBoard(___fen)
{
    var __castling="-";
	var __enpassant="-";
	var __fenParts=explode(" ",___fen);var __size_arr=array_length(__fenParts);
	if __size_arr<2{return}
	var __pieces=__fenParts[0];
	var __turn=__fenParts[1];
	if __size_arr>2{__castling=__fenParts[2];}
	if __size_arr>3{__enpassant=__fenParts[3];}
	if __size_arr>4{HalfMove=real(__fenParts[4])}
	var __pieceRank=7;
    var __pieceFile=0;
	var __chr=""
	for(var i=7;i>=0;i--){global.Board[i]=[0,0,0,0,0,0,0,0];}
    for(var i=0;i<string_length(__pieces);i++) 
	{
		__chr=string_char_at(__pieces,i+1)
        switch(__chr)
		{
            case "8": case "7": case "6": case "5": case "4": case "3": case "2": case "1": __pieceFile+=real(__chr); break;
            case "/": __pieceFile=0;__pieceRank--;break;
            default: global.Board[__pieceFile][__pieceRank] = string_pos(__chr,"kqbnrp PRNBQK")-7;__pieceFile++;break
        }
    }
	
	global.Chess_Player = (__turn =="w" ? Player.Human : Player.AI);
	
	check_castle_king=array_create(6,false)
	if string_pos("K",__castling){check_castle_king[5]=true;check_castle_king[1]=true;}
	if string_pos("Q",__castling){check_castle_king[3]=true;check_castle_king[1]=true;}
	if string_pos("k",__castling){check_castle_king[4]=true;check_castle_king[0]=true;}
	if string_pos("q",__castling){check_castle_king[2]=true;check_castle_king[0]=true;}
	
    // Compute the en passant component of the hash
    if __enpassant=="-"{enpassent=[]}else{enpassent=[string_ord_at(__enpassant,1)-ord("a"),real(string_char_at(__enpassant,2))];}
}

function PromoteStrToPiece(_Piece){
	switch(string_lower(_Piece)){
		case "n": return Night
		case "b": return Bishop
		case "r": return Rook
		default: return Queen
	}
	
}