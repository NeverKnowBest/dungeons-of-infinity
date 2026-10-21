draw_text(x,y-400,"Chess engine with ai")
if qq0==-1
{
	var __arr=["Player vs Player","Player vs AI","AI vs AI"]
	draw_text(x,y-200,"Choose Game Mode")
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		var __col=c_silver
		draw_rectangle_color(x-150,_y-40,x+150,_y+40,__col,__col,__col,__col,0)
		draw_text_color(x,_y,__arr[i],c_black,c_black,c_black,c_black,1)
	}
}
else if qq1==-1
{
	var __arr=["Easy","Medium","Hard"]
	draw_text(x,y-200,"Choose AI Level")
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		var __col=c_silver
		draw_rectangle_color(x-150,_y-40,x+150,_y+40,__col,__col,__col,__col,0)
		draw_text_color(x,_y,__arr[i],c_black,c_black,c_black,c_black,1)
	}
}
else if qq2==-1
{
	var __arr=["White","Black","Random"]
	draw_text(x,y-200,qq0==1?"Color for Player":"Color for Player1")
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		var __col=c_silver
		draw_rectangle_color(x-150,_y-40,x+150,_y+40,__col,__col,__col,__col,0)
		draw_text_color(x,_y,__arr[i],c_black,c_black,c_black,c_black,1)
	}
}
