function Skeleton_UpdateDir(_Dir){
	
	Dir = _Dir;
	HeadDir = Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(WalkSpeed);
	
}