
if qq0==-1
{
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		var _y=y-50+100*i
		if point_in_rectangle(mouse_x,mouse_y,x-100,_y-40,x+100,_y+40)
		{
			qq0=i;if qq0==0{qq1=0}
		}
	}
}
else if qq1==-1
{
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		if point_in_rectangle(mouse_x,mouse_y,x-100,_y-40,x+100,_y+40)
		{
			qq1=i;
			global.hard=qq1+1
		}
	}
}
else if qq2==-1
{
	for(var i=0;i<3;i++)
	{
		var _y=y-50+100*i
		if point_in_rectangle(mouse_x,mouse_y,x-100,_y-40,x+100,_y+40)
		{
			qq2=i;if qq2==2{qq2=choose(0,1)};
		}
	}
}
//else if qq3==-1
//{
//	for(var i=0;i<3;i++)
//	{
//		var _y=y-50+100*i
//		if point_in_rectangle(mouse_x,mouse_y,x-100,_y-40,x+100,_y+40)
//		{
//			qq3=i;if qq3==2{qq3=choose(0,1)};
//		}
//	}
//}

if qq2!=-1
{
	var __ins = instance_create_depth(room_width/2,room_height/2,0,Obj_Board);
	__ins.isblackdown=qq2
	if(qq0 == 1){
		__ins.AI[qq2] = true;
	}else if(qq0 == 2){
		__ins.AI = [true,true];
	}
	if(__ins.AI[global.current_player == 1]){
		__ins.alarm[0] = 5;
	}
	instance_destroy();
}

