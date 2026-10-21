exit;
for(var i=0;i<4;i++)
{
	var _x=x-150+100*i
	if point_in_rectangle(mouse_x,mouse_y,_x-40,y-40,_x+40,y+40)
	{
		global.Board[piece_to_promote[0]][piece_to_promote[1]]=(i+2)*(global.current_player);
		instance_destroy()
	}
}
