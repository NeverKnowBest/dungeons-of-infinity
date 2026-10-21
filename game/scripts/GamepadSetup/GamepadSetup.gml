function GamepadSetup() {
	var ID = -1;
	//check for XInput gamepads
	for(var i = 0; i < 4; i++){
		if(gamepad_is_connected(i)){ 
			ID = i;
			break;
		}
	}

	if(ID == -1){ //No XInput pads found, check DirectInput
		for(var i = 4; i < 12; i++){
			if(gamepad_is_connected(i)){ 
				ID = i;
				break;
			}
		}	
	}

	return ID;

}
