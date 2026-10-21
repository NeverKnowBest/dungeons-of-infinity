function mini_max0()
{
	
	//book movements based on polyglot file .bin
	if(array_length(arr_bin) > 0){
		
		var __hash = FenToHash(FEN_arr[FEN_index]);
		var __CodeMove = BestCodeMoveFromHash(__hash, arr_bin);
		
		if(__CodeMove != 0){
			var __arrMoveBin = CodeToMove(__CodeMove);
			if(array_length(__arrMoveBin) == 4){
				move([__arrMoveBin[0], __arrMoveBin[1]], [__arrMoveBin[2], __arrMoveBin[3]]);
				show_debug_message("moved by polyglot book "+string(__arrMoveBin));
				exit;
			}
		}
	}

	
	var __depth = 0;
    var __best_move = [];
    var __best = global.current_player*9999;
	var __sizearrmoved = array_length(moved_arr)
    var __piece_pp = [];
	var __arr = [];
	var __t = [];
	var i = 0;
	var j = 0;
	var __piecetemp0 = 0

	//calculate __num_piece_of_myplayer and __num_piece_of_notmyplayer
	var __num_piece_of_myplayer = 0;
	var __num_piece_of_notmyplayer = 0;
	for(var j = 0; j < 8; j++){
        for(var i = 0; i < 8; i++){
			if(global.Board[i][j] != 0){
				if(sign(global.Board[i][j]) == global.current_player){
					__num_piece_of_myplayer++;
				}else{
					__num_piece_of_notmyplayer++;
				}
			}
		}
	}


    for(var j = 0; j < 8; j++){
        for(var i = 0; i < 8; i++){
			
			__piecetemp0=global.Board[i][j];
			
			if(sign(__piecetemp0) == global.current_player){
				__t = get_legal_moves([i,j], false);
				__arr = __t[1];
		        array_copy(__arr, array_length(__arr), __t[0], 0, array_length(__t[0]))//used to plus between 2 array(__t[0]+__t[1])
				for(var k = 0; k < array_length(__arr); k++){
					//check not to repeat the movement more than 3 times
					if(__sizearrmoved > 24){
						
						var __num_moved_same_piece = 0;
						
						if(__num_piece_of_myplayer < 9 && __num_piece_of_myplayer > 1){
							var __max_chk = 9;
						}else{
							var __max_chk = 4;
						}
						
						for(var zz = 1; zz <= __max_chk; zz++){
							if(moved_arr[__sizearrmoved-2 * zz][0] == __piecetemp0){
								__num_moved_same_piece++;
							}else{
								break;
							}
						}
						
						if(__num_moved_same_piece >= 4){
							if(array_equals_(moved_arr[__sizearrmoved - 2][1], __arr[k]) &&
							   array_equals_(moved_arr[__sizearrmoved - 6][1], __arr[k]) &&
							   array_equals_(moved_arr[__sizearrmoved - 4][2], __arr[k]) &&
							   array_equals_(moved_arr[__sizearrmoved - 8][2], __arr[k])){
								continue;
							}
							if(__num_moved_same_piece >= 9){
								continue;
							}
						}
						
					}

					
					//making fake move
					if(abs(__piecetemp0) == King){
						King_pos[global.current_player == 1] = __arr[k]; //store piece when existing in new position before fake move
					}
		            
					var __piece_none_p = global.Board[__arr[k][0]][__arr[k][1]]; //store piece when existing in new position before fake move
					global.Board[__arr[k][0]][__arr[k][1]] = __piecetemp0; //move piece to new position in fake move
					global.Board[i][j]=0//reset old position in fake move
					
					//call algorithm alpha-beta
		            var __val = mini_max1(__depth+1, -1 * global.current_player, -10000, 10000);
					
					if(abs(__piecetemp0) == King){
						if(__num_piece_of_notmyplayer == 1 && __num_piece_of_myplayer > 1){
							__val = global.current_player * 9999;
						}
					}
					
					//add some bonus in cases promotion or en passent
					if(abs(__piecetemp0) == Pawn){
						if(__arr[k][1] == 7 || __arr[k][1] == 0){
							__val += (global.current_player * 100 + 300 * real(__num_piece_of_notmyplayer == 1));
						}//promotion
						if array_length(enpassent)>0{if array_equals_([__arr[k][0],j],enpassent){__val+=global.current_player*10;}}//en passent
					}
					
					//choose best move
		            if(global.current_player == -1){
			            if(__val >= __best){ //when to ai to black
							__best = __val;
							__best_move = __arr[k];
							__piece_pp = [i,j];
						}
					}else{
						if(__val <= __best){ //when to ai to white
							__best = __val;
							__best_move = __arr[k];
							__piece_pp = [i,j];
						}
					}
					
					//undo the fake movement
					global.Board[i][j] = __piecetemp0;//move piece to old position after finsh fake move
					global.Board[__arr[k][0]][__arr[k][1]] = __piece_none_p//undo piece in new position that captured
					if(abs(__piecetemp0) == King){
						King_pos[global.current_player == 1] = [i,j]; //undo king position in array(King_pos) when piece(king) that fake move
					}
				}
			}
		}
	}
	
	if(array_length(__piece_pp) == 0){
		checkmate = "DRAW"; //show "draw" when not have any move
		exit
	}
	
	move(__piece_pp, __best_move);
	
}

//mini-max algorithm with alpha-beta pruning
function mini_max1(___depth, ___is_black_turn, ___alpha, ___beta){
	
	if(global.hard == ___depth){//return points of board when 
		var __piece_temp = 0;
		var __result = 0;
	    for(var j = 0; j < 8; j++){
	        for(var i = 0; i < 8; i++){
				__piece_temp=global.Board[i][j];
				if(__piece_temp != 0){
					__result += (arrPoint[abs(__piece_temp) - 1] * sign(__piece_temp));
					__result += ((__piece_temp < 0) ? global.Table[abs(__piece_temp) - 1][7-j][7-i] * -1 : global.Table[abs(__piece_temp) - 1][j][i]);
				}
			}
		}
		return -__result;
	}
	
	//store all legal move in array(__arr)
	var __arr = [];
	var __t = [];
	for(var j = 0; j < 8; j++){
        for(var i = 0; i < 8; i++){
            if(sign(global.Board[i][j]) == ___is_black_turn){
				__t = get_legal_moves([i,j], true);
			    for(var k = 0; k < array_length(__t[1]); k++){
					array_push(__arr,[ [i,j], __t[1][k] ]);
				}
				for(var k = 0; k < array_length(__t[0]); k++){
					array_insert(__arr, 0, [ [i,j], __t[0][k] ]);
				}
			}
		}
	}

	
	var __ii = [];
	var __val = 0;
	var __piece_none_p = 0;
	var __piece_p = [];
	var __best = ___is_black_turn * 9999;
	var __piecetemp0 = 0;
	for(var i = array_length(__arr) - 1; i >= 0; i--){
		
        __piece_p = __arr[i][0];//old position piece in fake move 
		__piecetemp0 = global.Board[__piece_p[0]][__piece_p[1]];//piece move in fake move 
        __ii = __arr[i][1];//new position in fake move 
        
		//fake move
		if(abs(__piecetemp0) == King){
			King_pos[__piecetemp0 > 0] = __ii; //change king position in array(King_pos) when piece(king) that fake move
		}
		__piece_none_p = global.Board[__ii[0]][__ii[1]];//store piece when existing in new position before fake move
		global.Board[__ii[0], __ii[1]] = __piecetemp0;//move piece to new position in fake move
		global.Board[__piece_p[0]][__piece_p[1]] = 0;//reset old position in fake move
		//mini-max algorithm
		__val = mini_max1(___depth + 1, ___is_black_turn *- 1, ___alpha, ___beta);
		
		//choose best move
		if(___is_black_turn == -1){
			__best = max(__best, __val);
			___alpha=  max(___alpha, __best)
		}else{
			__best = min(__best, __val);
			___beta = min(___beta, __best)
		}
		
		//Undo fake move
		global.Board[__piece_p[0], __piece_p[1]] = __piecetemp0;//move piece to old position after finsh fake move
		global.Board[__ii[0]][__ii[1]] = __piece_none_p;//undo piece in new position that captured
		if(abs(__piecetemp0) == King){
			King_pos[__piecetemp0 > 0] = __piece_p; //undo king position in array(King_pos) when piece(king) that fake move
		}
		
        if(___beta <= ___alpha){
			return __best
		}
	}
	
	return __best
	
}
