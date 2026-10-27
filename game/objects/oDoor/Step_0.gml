if(Open){
	
	if(Status == DoorStatus.Closed && !audio_is_playing(Sound_DoorOpen)) audio_play_sound(Sound_DoorOpen, 1, false);
	
	if(Status != DoorStatus.ClosedHalf) UpdateStatus = true;
	Status = DoorStatus.ClosedHalf;
	
	DoorChangeAniFrame++;
	if(DoorChangeAniFrame >= 8){
		Open = false;
		
		Status = Exit ? DoorStatus.Exit : DoorStatus.Open;
		
		DoorChangeAniFrame = 0;
		
		UpdateStatus = true;
		
	}
	
}

if(Close){
	
	if( (Status == DoorStatus.Open || Status = DoorStatus.Entrance) && !audio_is_playing(Sound_DoorClose)) audio_play_sound(Sound_DoorClose, 1, false);
	
	if(Status != DoorStatus.ClosedHalf) UpdateStatus = true;
	Status = DoorStatus.ClosedHalf;
	
	DoorChangeAniFrame++;
	if(DoorChangeAniFrame >= 8){
		Close = false;
		Status = DoorStatus.Closed;
		DoorChangeAniFrame = 0;
		
		UpdateStatus = true;
		
		if( !(LevelDef.Special == LevelSpecial.FinalBoss && TemplateCheck(RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "FinalBoss")) ){
			with(oLink){
				UpdateState(LinkState.Standing);
			}
		}
		
		global.Paused = false;
		
	}
	
}

if(Unlock){
	
	if(Status != DoorStatus.LockedHalf) UpdateStatus = true;
	Status = DoorStatus.LockedHalf;
	
	DoorChangeAniFrame++;
	if(DoorChangeAniFrame >= 8){
		Unlock = false;
		Status = DoorStatus.Open;
		DoorChangeAniFrame = 0;
		
		UpdateStatus = true;
		
	}
	
}

if(UpdateStatus){
	
	Door_DrawTiles(self);
	
	if(WallInst != noone){
		if(Status == DoorStatus.Open || Status = DoorStatus.Exit || Status == DoorStatus.Secret_Open){
			WallInst.BlockLink = false;
			WallInst.BlockLinkCarry = (Status == DoorStatus.Exit);
			WallInst.BlockProjectiles = false;
		}
		if(Status == DoorStatus.Closed || Status == DoorStatus.Locked || Status == DoorStatus.Secret_Closed || Status == DoorStatus.Curtain){
			WallInst.BlockLink = true;
			WallInst.BlockLinkCarry = true;
			WallInst.BlockProjectiles = true;
		}

		with(oLink){
			if(House_Inside) other.WallInst.BlockLinkCarry = true
		}
	
	}
	
	Door_UpdateLights();
		
	UpdateStatus = false;
	
}

