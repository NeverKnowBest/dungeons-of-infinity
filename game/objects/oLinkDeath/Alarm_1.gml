SpinCount--;
if(SpinCount <= 0){
	oLink.sprite_index = global.LinkSpr_Dead; 
	oLink.image_index = 0;
	Falling = true;
}else{
	switch(SpinDir){
		case UP: SpinDir = RIGHT; oLink.sprite_index = global.LinkSpr_Stand_Right; break;
		case DOWN: SpinDir = LEFT; oLink.sprite_index = global.LinkSpr_Stand_Left; break;
		case LEFT: SpinDir = UP; oLink.sprite_index = global.LinkSpr_Stand_Up; break;
		case RIGHT: SpinDir = DOWN; oLink.sprite_index = global.LinkSpr_Stand_Down; break;
	
	}

	alarm[1] = SpinDelay;
}