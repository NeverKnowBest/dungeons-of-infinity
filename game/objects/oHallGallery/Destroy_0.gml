global.Paused = false;
Time_PauseEnd();
if(!global.LinkDead){
	with(oLink) UpdateState(LinkState.Standing);
}
