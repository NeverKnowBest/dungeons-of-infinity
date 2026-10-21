if(global.Paused) exit;


DrawShadow = false;

switch(State){
	
	case PickupObjState.Idle:
		DrawShadow = ShadowAtRest;
		break;
		
	case PickupObjState.PickUp:

		PickupObj_RevealContents();

		FloorLevel = oLink.FloorLevel;
		FloorLevelStr = GetFloorLevelString(FloorLevel);

		layer = layer_get_id("ObjsHigher_" + FloorLevelStr);
		
		audio_play_sound(Sound_Pickup, 1, false);	
		
		State = PickupObjState.PickedUp;
		
		break;
	
	case PickupObjState.Throw:
		
		PickupObj_InitThrow();
		
		x = oLink.x;
		ObjSetY(oLink.y - 1);
		
		switch(oLink.Facing){
			case UP: vy = -Speed; break;
			case DOWN: vy = Speed; break;
			case LEFT: vx = -Speed; break;
			case RIGHT: vx = Speed; break;
		}
	
		FloorLevel = oLink.FloorLevel;
		FloorLevelStr = GetFloorLevelString(FloorLevel);
		layer = layer_get_id("ObjsHigher_" + FloorLevelStr);
		
		if(object_index == oBomb){
			if(!Red) alarm[0] = Bomb_IgniteDelayQuick;
		}
		
		audio_play_sound(Sound_Throw, 1, false);
		
		break;
	
	case PickupObjState.Travelling:
		
		if(DestroyedByExitRoom && Dungeon_GetRoomIndex(x, y_base) != RoomIndex){
			State = PickupObjState.Idle;
			instance_destroy(id);
			exit;
		}
		
		vz += g;
		z += vz;

		x += vx;
		ObjSetY(y_base + vy);
		
		DrawShadow = true;
		
		var CollisionInst = CheckProjectileCollision(FloorLevel);
		if(CollisionInst != noone){

			if(DestroyOnContact){
				State = PickupObjState.Destroyed;
				break;
			}
		
		}
		
		if(Item_OverHole() && z <= 1){
			Item_FallInHole();
			exit;
		}
		
		if(Item_CheckPondWater()) exit;
		
		Item_CheckFloorLevelSwitch();

		if(Bounces > 0 && z <= 0){
	
			z = 0;
			
			if(DestroyOnContact){
				State = PickupObjState.Destroyed;
				break;
			}
			
			vx /= 3;
			vy /= 3;
			vz = Bounces * 0.5;
			Bounces--;
	
			if(Bounces <= 0){
				Bounces = 0;
				vx = 0;
				vy = 0;
				State = PickupObjState.Stopped;
				layer = layer_get_id("Objs_" + FloorLevelStr);
				mask_index = sprite_index;
				break;
			}
		}

		if(!WallCollided && CheckWallCollide){
	
			var WallInst = instance_place(x, y_base, oWall);
		
			if(WallInst != noone){
				
				if(	WallInst.BlockItems && ( FloorLevel == WallInst.FloorLevel || (FloorLevel == LOWER && WallInst.FloorLevel == UPPER) || WallInst.FloorLevel == UPPERLOWER)){
				//if( (FloorLevel == WallInst.FloorLevel || (FloorLevel == LOWER && WallInst.FloorLevel == UPPER) || WallInst.FloorLevel == UPPERLOWER) && ){
			
					var _HitSpeed = sqrt(abs(vx) + abs(vy)) * .8;
			
					if(WallInst.Position == LEFT){
						vx = _HitSpeed * (vx < 0 ? WallBounceFactor : 1); vy = 0; 
					}else if(WallInst.Position == RIGHT){
						vx = -_HitSpeed * (vx > 0 ? WallBounceFactor : 1); vy = 0; 
					}else if(WallInst.Position == TOP){
						vy = _HitSpeed * (vy < 0 ? WallBounceFactor : 1); vx = 0; 
					}else if(WallInst.Position == BOTTOM){
						vy = -_HitSpeed * (vy > 0 ? WallBounceFactor : 1); vx = 0; 
					}else if(WallInst.Position == TOPLEFT){
						vx = _HitSpeed; vy = _HitSpeed; 
					}else if(WallInst.Position == TOPRIGHT){
						vx = -_HitSpeed; vy = _HitSpeed; 
					}else if(WallInst.Position == BOTTOMLEFT){
						vx = _HitSpeed; vy = -_HitSpeed; 
					}else if(WallInst.Position == BOTTOMRIGHT){
						vx = -_HitSpeed; vy = -_HitSpeed; 
					}else if(WallInst.Position == NONE){
						vx *= -WallBounceFactor;
						vy *= -WallBounceFactor;
					}
				
					WallCollided = true;
					if(DestroyOnContact){
						State = PickupObjState.Destroyed;
						break;
					}
				}
			}
		}
		
		break;
	
	case PickupObjState.Stopped:
		DrawShadow = ShadowAtRest;
		break;
}

PickupObj_CheckRoomIndex();

switch(State){
	default: 
		Item_CheckWater();
		break;
		
	case PickupObjState.PickUp:
	case PickupObjState.PickedUp:
	case PickupObjState.Throw:
		exit;
}