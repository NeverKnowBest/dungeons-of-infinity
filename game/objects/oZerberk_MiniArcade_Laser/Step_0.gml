y += vy;


var AlienInst = instance_place(x, y, oZerberk_MiniArcade_Alien)
if(AlienInst != noone){
	oZerberk_MiniArcade_Game.Score++;
	instance_create_depth(AlienInst.x, AlienInst.y, depth - 5, oZerberk_MiniArcade_Explosion);
	instance_destroy(AlienInst);
	instance_destroy(id);
	audio_play_sound(choose(sndZerberk_MiniArcade_Hit1, sndZerberk_MiniArcade_Hit2, sndZerberk_MiniArcade_Hit3), 1, false);
}

if(y < 0) instance_destroy(id)

