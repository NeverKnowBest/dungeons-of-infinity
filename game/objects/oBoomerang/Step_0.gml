if(global.Paused){
	if(!SoundPaused && SoundInst != noone){
		audio_pause_sound(SoundInst);
		SoundPaused = true;
	}
}else{
	if(SoundPaused){
		audio_resume_sound(SoundInst)
		SoundPaused = false
	}
}

PauseObj

if(!Thrown && oLink.State == LinkState.Hit){
	instance_destroy(id);
	exit;
}

if(!Thrown && oLink.image_index >= 1){
	x = oLink.x;
	ObjSetY(oLink.y - 6);
	ObjSetImageSpeed(1);
	SoundInst = audio_play_sound(Sound_Boomerang, 1, true);
	Thrown = true;
}

if(Thrown){
	
	vx += ax;
	vy += ay;
	
	vx = clamp(vx, -7, 7);
	vy = clamp(vy, -7, 7);
	
	x += vx;
	ObjSetY(y_base + vy);

	
	if(Returning){
		
		var Dir = point_direction(x, y_base, oLink.x, oLink.y - 6);
		v+=-a
		v = clamp(v, -7, 7);
		vx = lengthdir_x(v, Dir);
		vy = lengthdir_y(v, Dir);
		
		if(instance_place(x, y_base, oLink) != noone){
			alarm[1] = 1;
			ObjCollideDelay = true;
		}

	}
	
	var _inst = CheckProjectileCollision(FloorLevel);
	if(_inst != noone){
		if(_inst.object_index != oBush && _inst.object_index != oPot){
			Returning = true;
			exit;
		}
	}

	event_inherited();
	if(WallCollided){
	
		 //Once obj is done colliding with wall after delay. See alarm0 in oProjectile
	
		instance_create_layer(x, y_base, "ObjsHigher_" + GetFloorLevelString(oLink.FloorLevel), oWallHit, {PlaySound: true});	

		v = max(abs(vx), abs(vy)) * 0.75;
		Returning = true;
	
		WallCollided = false;
	
	}

}

if(!Returning){

	if(sign(vx) != starting_vx_sign || sign(vy) != starting_vy_sign){
		Returning = true;
		v = 0;
	}
}


