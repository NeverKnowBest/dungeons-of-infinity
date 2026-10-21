/// @description Explosion Timer

if(ExplodeCount < 25){
	ExplodeCount++;
	instance_create_depth(oZerberk_MiniArcade_Ship.x + irandom_range(-12, 12), oZerberk_MiniArcade_Ship.y + irandom_range(-12, 0), oZerberk_MiniArcade_Ship.depth - 5, oZerberk_MiniArcade_Explosion);
	alarm[4] = 4;
}else{
	with(oZerberk_MiniArcade_Alien) instance_destroy(id);
	with(oZerberk_MiniArcade_Ship) instance_destroy(id);
	with(oZerberk_MiniArcade_Laser) instance_destroy(id);
	with(oZerberk_MiniArcade_Explosion) instance_destroy(id);
	ExplodeCount = 0;
	Arcade_Hiscore_Check(ArcadeGame.SporkInvaders);
	State = MiniArcadeState.GameOver;
}
