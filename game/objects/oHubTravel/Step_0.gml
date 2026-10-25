switch(State){
	
	case 0:
		Alpha = min(1, Alpha + 0.1);
		if(Alpha >= 1){
			Hub_MoveLinkTo(DestRoom, DestX, DestY, DestFacing);
			Hold = 8;
			State = 1;
		}
		break;
		
	case 1:
		Hold--;
		if(Hold <= 0) State = 2;
		break;
		
	case 2:
		Alpha = max(0, Alpha - 0.1);
		if(Alpha <= 0){
			with(oLink) UpdateState(LinkState.Standing);
			instance_destroy();
		}
		break;
		
}
