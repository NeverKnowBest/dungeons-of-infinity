//play when not end game


if checkmate=""
{
var _yst=room_height/2+240-isblackdown*560;
var _xst=room_width/2-320+isblackdown*560;
var _x=0;
var _y=0;
for(var j=0;j<8;j++)
{
	for(var i=0;i<8;i++)
	{
		_x=_xst+i*(isblackdown?-80:80);
		_y=_yst-j*(isblackdown?-80:80);
		if point_in_rectangle(mouse_x,mouse_y,_x,_y,_x+80,_y+80)
		{
			if sign(global.Board[i][j])==global.current_player and !array_equals_(piece_selected,[i,j])
			{
				var __t=get_legal_moves([i,j],false);array_can_move=__t[0];array_can_capture=__t[1];
				piece_selected=[i,j];
				exit
			}
			if array_find(array_can_move,[i,j]) or array_find(array_can_capture,[i,j])
			{
				move(piece_selected,[i,j]);
			}
			array_can_move=[];array_can_capture=[];piece_selected=[];//surface_free(BoardSurface)
		}
	}
}
}
//show PGN Code
_x=room_width/2
_y=room_height/2+440
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show PGN
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	if PGN_chk//check from variable if user enter FEN code or not
	{
	var __str=""
	for(var i=0;i<FEN_index;i++)
	{
		if i%2==0{__str+=string(1+i/2)+". "}
		__str+=PGN_arr[i]+" "
	}
	clipboard_set_text(__str)//copy PGN Code
	show_message_async(__str)//show PGN Code
	}
	else{show_message_async("Can't generate PGN Code becuase Enter FEN Code")}
}

_x=room_width/2-120
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show FEN Code
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	clipboard_set_text(FEN_arr[FEN_index])//copy FEN Code
	show_message_async(FEN_arr[FEN_index])//show FEN Code
}

_x=room_width/2-240
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//Enter FEN
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	msgFEN=get_string_async("Enter FEN",FEN_arr[FEN_index])//show dialog to enter FEN Code
}

//Back Move
if FEN_index>0
{
_x=room_width/2+120
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	FEN_index--;FenToBoard(FEN_arr[FEN_index]);//decrease FEN_index and generate board based FEN Code
	check_king=[false,false];//reset check king
	checkmate=""//reset checkmate
	is_checkmate()//make sure from sheckmate
	check()//make sure if check king or not
}
}
//Forward Move
if FEN_index<array_length(FEN_arr)-1
{
_x=room_width/2+240
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show PGN
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	FEN_index++;FenToBoard(FEN_arr[FEN_index]);//increase FEN_index and generate board based FEN Code
	check_king=[false,false];//reset check king
	checkmate=""//reset checkmate
	is_checkmate()//make sure from sheckmate
	check()//make sure if check king or not
}
}
_y=room_height/2+560
//Enter PGN
_x=room_width/2
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show PGN
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	msgPGN=get_string_async("Enter PGN","")//show dialog to enter PGN Code
}
//Play AI
_x=room_width/2-120
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show PGN
{
	array_can_move=[]//reset when selected piece
	array_can_capture=[]//reset when selected piece
	piece_selected=[];//reset when selected piece
	alarm[0]=1
}
//restart game
_x=room_width/2-240
if point_in_rectangle(mouse_x,mouse_y,_x-50,_y-50,_x+50,_y+50)//show PGN
{
	game_restart()
}


