if(Init){
	Init = false;
	INIT();
	if(!window_get_fullscreen()) window_set_fullscreen(true);
	instance_destroy(id);
	room_goto_next();	
}