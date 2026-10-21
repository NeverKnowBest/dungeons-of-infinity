if(vx != 0 || vy != 0){
	
	var inst = CheckProjectileCollision(FloorLevel);
	
	if(inst != noone){
		
		if(inst.object_index != oBush && inst.object_index != oPot){
			
			audio_play_sound_stopall(Sound_Arrow_Hit);
			
			instance_destroy(id);
			
		}
	}
}	