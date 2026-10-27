
if(!instance_exists(oLink)) exit;

if(RoomTransition != NONE){
	
	if(!RoomTransitionInit){
				
		Dungeon_RoomActivate(global.TransitionRoomIndex);
		
		if(LevelDef.Special != LevelSpecial.Intro){

			if(global.Level.Rooms[global.TransitionRoomIndex].Secret == 2) audio_play_sound_stopall(Sound_Secret);
		
			if(instance_exists(oPendantAlert)) instance_destroy(oPendantAlert);
		
			ResetEnemies = true;
		
		}
		
		//poe may be outside room if was hit multiple times and nudged off path. So deactivate & reset poes that are outside room before camera starts moving
		with(oEnemy_Poe){
			if(RoomIndex != Dungeon_GetRoomIndex(x, y)){
				x = Reset_StartX;
				y = Reset_StartY;
				instance_deactivate_object(id);				
			}
		}
		
		global.Level.Rooms[global.TransitionRoomIndex].Visited = true;
		
		Map_UpdateExploredRooms();
		
		global.Paused = true;
		
		RoomTransitionInit = true;

		
	}else{

		
		if(ResetEnemies){
			Enemy_Reset(global.TransitionRoomIndex);
			ResetEnemies = false;
		}
		
		
		var _X = X + (MoveSpeed * sign(TransitionEndX - X));
		var _Y = Y + (MoveSpeed * sign(TransitionEndY - Y));
		Cam_SetPos(_X, _Y);
		
		if(X == TransitionEndX && Y == TransitionEndY){

			Dungeon_DestroyUnimportantObjs();
			
			with(oLink){ 

				UpdateState(LinkState.AutoMove);
				AutoMoveDirX = 0;
				AutoMoveDirY = 0;			
				AutoMoveSpeed = WalkSpeed;
				AutoMoveFrames = 12 + (GoingThruClosedDoor * 11);
			
				switch(other.RoomTransition){
					case LEFT:
						oLink.AutoMoveDirX = -1;
						break;
					case RIGHT:
						oLink.AutoMoveDirX = 1;		
						break;
					case UP:
						oLink.AutoMoveDirY = -1;
						oLink.AutoMoveFrames = 11 + (oLink.GoingThruClosedDoor * 15);
						break;
					case DOWN:
						oLink.AutoMoveDirY = 1;
						break;
				}
				
				FallSpawnX = x + (AutoMoveFrames * WalkSpeed * AutoMoveDirX);
				FallSpawnY = y + (AutoMoveFrames * WalkSpeed * AutoMoveDirY);
				FallSpawnFacing = other.RoomTransition;
				FallSpawnFloorLevel = FloorLevel;
			}		
			
			if(global.Level.Rooms[global.CurrentRoomIndex].Secret == -1) oHUD.CheckPendentSecret = true;
			
			SetToRoomIndex(global.TransitionRoomIndex,false,false);			

			if(LevelDef.Special == LevelSpecial.FinalBoss){
				if(TemplateCheck(global.CurrentRoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "FinalBoss")){
					global.FinalBoss = true;
				}				
			}
			
			global.InWaterSprite = Link_GetInWaterSprite();	
			
			global.TransitionRoom = -1;
			global.TransitionRoomIndex = -1;
			
			RoomTransition = NONE;
			RoomTransitionInit = false;
			OpenTransition = false;
			
		}
	}
	
}else{
	
	if(!Override) Cam_UpdatePos();
	
}

Cam_SetPos(X, Y);

if(alarm[0] >= 0){
	camera_set_view_pos(view_camera[1], X + random_range(-ShakeAmount, ShakeAmount), Y + random_range(-ShakeAmount, ShakeAmount));
}else{
	camera_set_view_pos(view_camera[1], X, Y);
}
