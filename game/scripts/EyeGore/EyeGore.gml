function Eyegore_UpdateDir(_Dir){

	Dir = _Dir;
				
	Enemy_UpdateSprite(State);
				
	Enemy_UpdateV(WalkSpeed);
		
	alarm[0] = DirTime;
				
}