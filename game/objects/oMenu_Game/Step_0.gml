Link_PauseHitFlashingTimer();

if(Quitting){
	exit;
}

if(Open){
	Alpha += AlphaSpeed;
	if(Alpha >= 1){
		Alpha = 1;
		Open = false;
	}
	exit;
}

if(Close){
	Alpha -= AlphaSpeed;
	if(Alpha <= 0){
		instance_destroy(id);
	}
	exit;
}

if(keyboard_check(vk_alt)) exit;

var _Input_MenuUp = input_check_pressed("menu_up");
var _Input_MenuDown = input_check_pressed("menu_down");
var _Input_MenuInput =  input_check_pressed("menu_input");
var _Input_MenuAccess =  input_check_pressed("menu_access");
var _Input_MenuBack =  input_check_pressed("menu_back");

// Rows behave as in the title menu: up/down moves (scrolling if needed), left/right changes toggles and sliders,
// confirm runs the row, Back (or the pause button) leaves the page
var _Page = Menu_ActiveIndex;
var _Row = Menu[_Page][SelectorPos];
var _Dir = _Input_MenuDown ? 1 : (_Input_MenuUp ? -1 : 0);

if(_Dir != 0){
	SelectorPos = Menu_MoveSelector(_Page, SelectorPos, _Dir);
}else if(Menu_RowHasValue(_Row)){
	Menu_RowHold(_Row);
}

if(_Input_MenuInput){
	Menu_RowSelect(_Row);
}else if(_Input_MenuAccess || _Input_MenuBack){
	Menu_Back();
}
