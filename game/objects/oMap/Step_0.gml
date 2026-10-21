Link_PauseHitFlashingTimer();

if(Open){
	Alpha += AlphaSpeed;
	if(Alpha >= 1){
		Alpha = 1;
		Open = false;
	}
	exit;
}

LinkAlpha = (LinkAlpha + 3) mod 360;