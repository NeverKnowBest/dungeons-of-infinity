
function Chicken_PickNewDir(){
	
	_Dir = irandom(359);
	vx = lengthdir_x(Speed, _Dir);
	vy = lengthdir_y(Speed, _Dir);
	Dir = Chicken_GetDir();
}

function Chicken_SetScared(){
	Scared = true;
	ObjSetImageSpeed(1);
	audio_play_sound(Sound_Chicken, 1, false);
}

function Chicken_GetDir(){
	return vx >= 0 ? 1 : -1;
}