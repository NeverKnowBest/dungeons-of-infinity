ClickedL = false;
ClickedR = false;

if(global.MsgBoxFlag && !MsgBoxButton){
	MouseOver = false;
	exit;
}

if(!visible) exit;

MouseOver = mouse_x >= x && mouse_y >= y && mouse_x < x + W && mouse_y < y + H;

if(MouseOver && mouse_check_button_pressed(mb_left)) ClickedL = true;
if(MouseOver && mouse_check_button_pressed(mb_right)) ClickedR = true;

if(ClickedL && Checkbox) ChkStatus = !ChkStatus;