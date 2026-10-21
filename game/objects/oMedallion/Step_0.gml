if(!global.Paused) global.Paused = true;
if(oLink.State != LinkState.Idle){
	with(oLink) UpdateState(LinkState.Idle);	
}