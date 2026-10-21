event_inherited();

SoundPaused = ObjPauseSound(Sound, SoundPaused);

PauseCheck


if(oLink.State != LinkState.FallingOverEdge && oLink.State != LinkState.Falling && State != EnemyState.Killed){
	if((Hit_Started && Hit_LinkWeaponClass == LinkWeaponClass.Sword) || ObjCollision(x, y, oLink, FloorLevel)){
		sprite_index = sBoss_Moldorm_Head_Hit;
		alarm[4] = 30;
		with(oLink) {
			LinkThrow();
			LinkBounceBack(point_direction(other.x, other.y, x, y), 3, 14);
		}

	}
}


if(State != EnemyState.Killed){
	var PreviousPoints = array_length(PPX);
	for(var i = PreviousPoints - 1; i > 0; i--){
		PPX[i] = PPX[i - 1];	
	}
	var PreviousPoints = array_length(PPY);
	for(var i = PreviousPoints - 1; i > 0; i--){
		PPY[i] = PPY[i - 1];	
	}

	PPX[0] = x;
	PPY[0] = y;

}


for(var _SectionIndex = 0; _SectionIndex < 4; _SectionIndex++){
	if(instance_exists(BodyInst[_SectionIndex])){
		BodyInst[_SectionIndex].x = PPX[PP[_SectionIndex][SpeedIndex]];
		with(BodyInst[_SectionIndex]){
			ObjSetY(other.PPY[other.PP[_SectionIndex][other.SpeedIndex]]);
		}
	}
}
	
if(WallCollide_X || WallCollide_Y) Dir = point_direction(0, 0, vx, vy);
	

switch(State){
	
	case EnemyState.Walking:
		
		vx = lengthdir_x(Speed[SpeedIndex], Dir);
		vy = lengthdir_y(Speed[SpeedIndex], Dir);
		
		Dir = (Dir + (DirV * 5)) mod 360;
		
		if(HuntLink){
			
			if(collision_line(x, y, x + lengthdir_x(128, Dir), y + lengthdir_y(128, Dir), oLink, false, true)){
				//Dir = point_direction(x, y, oLink.x, oLink.y);
				DirV = 0;
				alarm[1] = irandom_range(40, 60);
				alarm[8] = -1;
				HuntLink = false;
			}
		}
		
		if(!audio_is_playing(Sound) || Sound == noone) Sound = audio_play_sound(Sound_MoldormSkitter, 1, true); //when link dies, it kills all the sounds, so if he is revived, we have to replay this sound
		
		HitAllowed = true;
		with(oBoss_Moldorm_Tail){
			Hit_Allowed = true;
		}
		
		break;
	
	case EnemyState.Hit:
	case EnemyState.Killed:
		KnockBackColorFrame = (KnockBackColorFrame + 1) mod global.KnockBackColorFrames;	
	case EnemyState.Idle:
		EyeA = (EyeA + 30) mod 360;
		vx = 0;
		vy = 0;
		HitAllowed = false;
		with(oBoss_Moldorm_Tail){
			Hit_Allowed = false;
		}
		break;
		
}

