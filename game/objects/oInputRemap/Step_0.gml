if(keyboard_check_pressed(vk_backspace)){					
	input_binding_scan_set_Failure(0);
}

if(global.BindingRemap_Next){
	
	io_clear();
	input_clear_momentary(true);
	input_binding_scan_start(input_binding_scan_set_Success, input_binding_scan_set_Failure);
	global.BindingRemap_Next = false;

}

