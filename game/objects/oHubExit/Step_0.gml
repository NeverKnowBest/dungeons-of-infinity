if(!Leaving){
	
	if(!instance_exists(oLink)) exit;
	
	if(oLink.y >= y && abs(oLink.x - x) <= 12 && oLink.State != LinkState.Dead){
		Leaving = true;
		with(oLink) Link_SetAutoMove(0, 1, WalkSpeed, 16);
		Music_Fade(0, 20);
	}
	
	exit;
}

FadeAlpha = min(1, FadeAlpha + 0.05);

if(FadeAlpha >= 1 && !Started){
	Started = true;
	Hub_StartRun();
}
