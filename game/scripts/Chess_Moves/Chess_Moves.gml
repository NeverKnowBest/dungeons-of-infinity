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

