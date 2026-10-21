#macro MinEnemiesForStar 9

function StopStar(){
	Invincible = false;
	StarActive = false;
	if(State != LinkState.Star) exit;
	alarm[7] = -1;
	alarm[8] = -1;	
	instance_destroy(oSword);
}

