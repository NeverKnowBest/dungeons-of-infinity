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

enum MoveTypes{
	None,
	Normal,
	Capture,
	Check,
	CheckCapture
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
	MoveType = MoveTypes.None;
	
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

	
	if(global.Board[___position[0]][___position[1]] == 0){
		MoveType = MoveTypes.Normal;
	}else{
		MoveType = MoveTypes.Capture;
	}

	
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
			//	var __ins=instance_create_depth(Room_width/2,Room_height/2,-1,Obj_promote_piece)
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
	
	
	
	if(global.Chess_Player == Player.Human){
		AllowAIMove = false;
		alarm[0] = 45; //add pause to AI before move
	}
	//AllowAIMove = false;
	//alarm[0] = 1;
	
	global.Chess_Player *= -1;
	
	
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
	

	check_king = [false, false];//reset check king after every move
	
	//check from pieces opponent's if can be captured king
	var __king_p = King_pos[(global.Chess_Player == Player.Human)];
    
	if(global.Board[__king_p[0]][__king_p[1]] == !King * global.Chess_Player){
		King_pos[(global.Chess_Player == Player.Human)] = get_position_king(King * global.Chess_Player);
		__king_p = King_pos[(global.Chess_Player == Player.Human)];
	}
	
	var Victory = false;
	var __chkpiece = global.Chess_Player * -1;
	for(var j = 0; j < 8; j++){
	    for(var i = 0; i < 8; i++){
            if(sign(global.Board[i][j]) ==__chkpiece){
                if(is_possible_moves_captured_king([i,j], __king_p)){
					check_king[global.Chess_Player == Player.Human] = true;//check_king=true when pieces opponent's can captured king
					Victory = true;
					break;
				}
			}
		}
		if(Victory) break;
	}

	//check if can player have legal moves or not
	var ValidMoves = false;
	for(var j = 0; j < 8; j++){
		for(var i = 0; i < 8; i++){
	        if(sign(global.Board[i][j]) == global.Chess_Player){
				var __t = get_legal_moves([i,j]);
	            if(array_length(__t[0]) > 0 || array_length(__t[1]) > 0){
					ValidMoves = true;
					break;
				}
			}
		}
		if(ValidMoves) break;
	}	
	
	//count pieces. If there's 3 or less pieces, if one is a bishop or knight, it's so draw. 
	if(ValidMoves){
		var PieceCount = 0;
		for(var j = 0; j < 8; j++){
			for(var i = 0; i < 8; i++){
		        if(global.Board[i][j] != 0){
					PieceCount++;  
					if(PieceCount > 2) break;				
				}
			}
			if(PieceCount > 2) break;
		}
		if(PieceCount == 2) ValidMoves = false;
		
	}
	
	if(ValidMoves){
		if(check_king[1]) StockfishStr = "Check!"
	}else{
		Status = ChessStatus.GameOver;
		if(check_king[1]){
			StockfishStr = StockfishStr_Win;
		}else if(check_king[0]){
			StockfishStr = StockfishStr_Lose;
		}else{				
			StockfishStr = StockfishStr_Draw;
		}
	}
	
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

function generate_moves(___piece_p=[0,0],___offsets=[[0,0]])
{
    var __move_arr=[];
    var __capture_arr=[];
	var __new_x=0;var __new_y=0;
    for(var i=0;i<array_length(___offsets);i++)
	{
		__new_x=___piece_p[0]+___offsets[i][0];
		__new_y=___piece_p[1]+___offsets[i][1];
		while(is_on_board(__new_x,__new_y) and global.Board[__new_x][__new_y]==0)
		{
	        array_push(__move_arr,[__new_x,__new_y])
	        __new_x+=___offsets[i][0];__new_y+=___offsets[i][1]
		}
	    if is_on_board(__new_x,__new_y)
		{
			if sign(global.Board[__new_x][__new_y])!=sign(global.Board[___piece_p[0]][___piece_p[1]])
		    {
				array_push(__capture_arr,[__new_x,__new_y])
			}
		}
	}
    return [__move_arr,__capture_arr]
}


function get_possible_moves(___piece_p=[0,0]){
	var __piece=0
	__piece=global.Board[___piece_p[0]][___piece_p[1]]
	switch(abs(__piece))
	{
		case King: 
			var __move_arr=[]
	        var __capture_arr=[]
			//
			var __new_x=0;var __new_y=0;
	        for(var i=-1;i<=1;i++)
			{
	            for(var j=-1;j<=1;j++)
				{
	                __new_x=___piece_p[0]+i
	                __new_y=___piece_p[1]+j
	                if (i!=0 or j!=0) and is_on_board(__new_x,__new_y)
					{
	                    if global.Board[__new_x][__new_y]==0
						{
	                        array_push(__move_arr,[__new_x,__new_y])
						}
						else
						{
	                        if sign(global.Board[__new_x][__new_y])==sign(__piece)*-1
							{
	                            array_push(__capture_arr,[__new_x,__new_y])
							}
						}
					}
				}
			}
			if check_castle_king[(__piece>0)]
			{
				for(var i=0;i<8;i+=7)
				{
					var __chk=true;
					if check_castle_king[2+real(__piece>0)+2*real(i==7)] and ___piece_p[0]==4 and ___piece_p[1]==7-7*real(__piece>0)
					{
						for(var j=i+sign(___piece_p[0]-i);j!=___piece_p[0];j+=sign(___piece_p[0]-i))
						{if global.Board[j][___piece_p[1]]!=0{__chk=false;break;}}
						if __chk{array_push(__move_arr,[___piece_p[0]-2*sign(___piece_p[0]-i),___piece_p[1]])}
					}
				}
			}
	        return [__move_arr,__capture_arr];
		case Rook:
	        return generate_moves(___piece_p,[[-1,0],[1,0],[0,-1],[0,1]])
		case Night:
			var __move_arr=[]
	        var __capture_arr=[]
			var __new_x=0;
			var __new_y=0;
			var __arr=[-2,-1,1,2]
	        for(var i=0;i<4;i++)
	        {
				for(var j=0;j<4;j++)
				{
	                if abs(__arr[i])!=abs(__arr[j])
					{
						__new_x=___piece_p[0]+__arr[i]
		                __new_y=___piece_p[1]+__arr[j]
						if is_on_board(__new_x,__new_y)
						{
		                    if global.Board[__new_x][__new_y]==0
							{
		                        array_push(__move_arr,[__new_x,__new_y])
							}
							else
							{
		                        if sign(global.Board[__new_x][__new_y])==sign(__piece)*-1
								{
		                            array_push(__capture_arr,[__new_x,__new_y])
								}
							}
						}
					}
				}
			}
	        return [__move_arr,__capture_arr]
		case Queen:
			return generate_moves(___piece_p,[[-1,0],[1,0],[0,-1],[0,1],[-1,-1],[1,1],[1,-1],[-1,1]])
		case Bishop:
	        return generate_moves(___piece_p,[[-1,-1],[1,1],[1,-1],[-1,1]])
		default:
	        var __move_arr=[]
	        var __capture_arr=[]
	        var __new_y=___piece_p[1]+__piece
			if is_on_board(___piece_p[0], __new_y) and global.Board[___piece_p[0]][__new_y]==0
			{
	            array_push(__move_arr,[___piece_p[0],__new_y])
	            if ___piece_p[1]==((__piece<0)?6:1)
				{
	                __new_y+=__piece;
	                if global.Board[___piece_p[0]][__new_y]==0{array_push(__move_arr,[___piece_p[0],__new_y])}
				}
			}
	        __new_y=___piece_p[1]+__piece
	        for(var i=-1;i<=1;i+=2)
			{
	            if is_on_board(___piece_p[0]+i,__new_y)
				{
					if sign(global.Board[___piece_p[0]+i][__new_y])==sign(__piece)*-1
					{
						array_push(__capture_arr,[___piece_p[0]+i,__new_y])
					}
					else
					{
						if array_length(enpassent)>0
						{
							if array_equals_(enpassent,[___piece_p[0]+i,___piece_p[1]])
							{array_push(__capture_arr,[___piece_p[0]+i,__new_y])}
						}
					}
				}
			}
	        return [__move_arr,__capture_arr]
	}
}


/// @desc Description for generate_moves_captured_only
/// @param {array} [___piece_p]=[0,0] description
/// @param {array} [___offsets]=[[0,0]] description
/// @param {array} [___king_p]=[0,0] description
/// @returns {bool} description
function generate_moves_captured_only(___piece_p=[0,0],___offsets=[[0,0]],___king_p=[0,0])
{
	var __new_x=0;var __new_y=0;
    for(var i=0;i<array_length(___offsets);i++)
	{
		__new_x=___piece_p[0]+___offsets[i][0];
		__new_y=___piece_p[1]+___offsets[i][1];
		while(is_on_board(__new_x,__new_y) and global.Board[__new_x][__new_y]==0)
		{
	        __new_x+=___offsets[i][0];__new_y+=___offsets[i][1]
		}
	    if is_on_board(__new_x,__new_y)
		{
			if __new_x==___king_p[0] and __new_y==___king_p[1]{return true}
		}
	}
    return false
}


function is_possible_moves_captured_king(___piece_p=[0,0],___king_p=[0,0])
{
	var __piece=global.Board[___piece_p[0]][___piece_p[1]]
	switch(abs(__piece))
	{
		case King:
			if array_equals_(___piece_p,___king_p){return false}
	        for(var i=-1;i<=1;i++)
			{
	            for(var j=-1;j<=1;j++)
				{
	                if ___piece_p[0]+i==___king_p[0] and ___piece_p[1]+j==___king_p[1]{return true}
				}
			}
	        return false
		case Rook:
	        return generate_moves_captured_only(___piece_p,[[-1,0],[1,0],[0,-1],[0,1]],___king_p)
		case Night:
			var __arr=[-2,-1,1,2]
	        for(var i=0;i<4;i++)
	        {
				for(var j=0;j<4;j++)
				{
	                if abs(__arr[i])!=abs(__arr[j])
					{
		                if ___piece_p[0]+__arr[i]==___king_p[0] and ___piece_p[1]+__arr[j]==___king_p[1]{return true}
					}
				}
			}
	        return false
		case Queen:
			return generate_moves_captured_only(___piece_p,[[-1,0],[1,0],[0,-1],[0,1],[-1,-1],[1,1],[1,-1],[-1,1]],___king_p)
		case Bishop:
	        return generate_moves_captured_only(___piece_p,[[-1,-1],[1,1],[1,-1],[-1,1]],___king_p)
		default:
	        if ___piece_p[1]+__piece==___king_p[1]
			{
				for(var i=-1;i<=1;i+=2)
				{
		            if ___piece_p[0]+i==___king_p[0]{return true}
				}
			}
	        return false
	}
}

function array_find(___arr=[[-1,-1]],___value=[-1,-1])
{
	var __ss=array_length(___arr);
	for(var i=0;i<__ss;i++){if array_equals_(___arr[i],___value){return true}}
	return false
}

function array_equals_(___arr0=[-1,-1],___arr1=[-1,-1])//array_equals not working fine in html5 version IDE v2022.6.1.26
{
	if array_length(___arr0)==2 and array_length(___arr1)==2
	{
		return ___arr0[0]==___arr1[0] and ___arr0[1]==___arr1[1];
	}
	else
	{
		if array_length(___arr0)!=array_length(___arr1){return false;}
		else{return array_equals(___arr0,___arr1)}
	}
}


function explode(del,_str)//from gmlscripts.com
{
    var arr=[];
    var str = _str + del;
    var len =string_length(del);
    var ind = 0;
	if string_count(del,_str)>0
    {
		repeat (string_count(del, str)) {
	        var pos = string_pos(del, str) - 1;
			if string_copy(str, 1, pos)!=""
			{
	        arr[ind] = string_copy(str, 1, pos);
			str = string_delete(str, 1, pos + len);
	        ind++;
			}
	    }
	}
	else
	{
		if _str!=""{arr[0]=_str}
	}
    return arr;
}


