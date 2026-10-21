function Rat_UpdateDir(_Dir){
	
	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(WalkSpeed);
	alarm[0] = irandom_range(30, 120);
	
}