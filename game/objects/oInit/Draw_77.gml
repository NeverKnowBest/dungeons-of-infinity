if(Init){
	Init = false;
	INIT();
	if(global.Fullscreen != window_get_fullscreen()) window_set_fullscreen(global.Fullscreen);
	instance_destroy(id);
	room_goto_next();	
}