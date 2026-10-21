if(Close){
	Alpha -= AlphaSpeed;
	if(Alpha <= 0){
		instance_destroy(id);
	}
}
