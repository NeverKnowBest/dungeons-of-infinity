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
	
	global.current_player=__turn=="w"?1:-1;
	
	check_castle_king=array_create(6,false)
	if string_pos("K",__castling){check_castle_king[5]=true;check_castle_king[1]=true;}
	if string_pos("Q",__castling){check_castle_king[3]=true;check_castle_king[1]=true;}
	if string_pos("k",__castling){check_castle_king[4]=true;check_castle_king[0]=true;}
	if string_pos("q",__castling){check_castle_king[2]=true;check_castle_king[0]=true;}
	
    // Compute the en passant component of the hash
    if __enpassant=="-"{enpassent=[]}else{enpassent=[string_ord_at(__enpassant,1)-ord("a"),real(string_char_at(__enpassant,2))];}
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

    if(global.current_player == 1){
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

    __fen += " " + string(HalfMove) + " " + string(1 + floor(array_length(moved_arr) / 2));

    return __fen;
}

function FenToHash(___fen)
{
	var __RANDOM_64=hash_RANDOM_64()
	var __hash=0;
    var __fenParts= explode(" ",___fen);
    var __pieces=__fenParts[0];
    var __turn=__fenParts[1];
    var __castling=__fenParts[2];
    var __enpassant=__fenParts[3];
	var __board=[[0]];
	for(var i=7;i>=0;i--){__board[i]=[0,0,0,0,0,0,0,0];}
    var __pieceRank=7;
    var __pieceFile=0;
	var __chr=""
    for(var i=0;i<string_length(__pieces);i++) 
	{
		__chr=string_char_at(__pieces,i+1)
        switch(__chr)
		{
            case "8": case "7": case "6": case "5": case "4": case "3": case "2": case "1": __pieceFile+=real(__chr); break;
            case "/": __pieceFile=0;__pieceRank--;break;
            default:
                __hash=int64(__hash ^ __RANDOM_64[64*(string_pos(__chr,"pPnNbBrRqQkK")-1)+8*__pieceRank+__pieceFile]);
				if __chr=="p" or __chr=="P"{__board[__pieceRank][__pieceFile]=-1+i*2;} __pieceFile++;break
        }
    }
	
	if __turn=="w"{__hash=int64(__hash ^ __RANDOM_64[780]);}
	
	if __castling!="-"
	{
        for(var i=0;i<string_length(__castling);i++)
		{
            switch(string_char_at(__castling,i+1))
			{
                case "K": __hash=int64(__hash ^ __RANDOM_64[768  ]);break;
                case "Q": __hash=int64(__hash ^ __RANDOM_64[768+1]);break;
                case "k": __hash=int64(__hash ^ __RANDOM_64[768+2]);break;
                case "q": __hash=int64(__hash ^ __RANDOM_64[768+3]);break;
            }
        }
    }

    // Compute the en passant component of the hash
    if __enpassant!="-"
	{
        var __epx=string_ord_at(__enpassant,1)-ord("a");
		for(var i=-1;i<1;i+=2)
        {
	        if __epx+i>=0 and __epx+i<8 
			{
				if __board[3+real(__turn=="w")][__epx+i]==(__turn=="w"?1:-1){__hash=int64(__hash ^ __RANDOM_64[772+__epx]);}
			}
		}
    }
	return __hash;
}



