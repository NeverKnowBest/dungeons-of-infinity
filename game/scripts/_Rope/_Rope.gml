function Rope_UpdateDir(_Dir){

	Dir = _Dir;
	Enemy_UpdateSprite(State);
	Enemy_UpdateV(State == EnemyState.Walking ? WalkSpeed : RunSpeed);
	alarm[0] = irandom_range(30, 120);

}