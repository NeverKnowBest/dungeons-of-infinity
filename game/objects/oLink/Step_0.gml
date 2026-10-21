

//States that exit right away

var _Exit = false;

switch(State){
	
	case LinkState.Descending:
	
		switch(DescendingPhase){
			case 1:
			
				if(image_index > image_number - 1){
				
					instance_activate_all(); //we need to activate everything this event in order to clear everything in the End Step event, activation takes 1 event to process
				
					InitNewDungeon = true;
				
					DescendingPhase = 2;
						
				}
				break;
			
			case 2:
				
				if(image_index > image_number - 1){
						
					var StartDir = Dungeon_StartDir(global.Level.Index);
					if(StartDir == UP){
						Link_SetAutoMove (0, -1, WalkSpeed, 12);
					}else{
						Link_SetAutoMove (0, 1, WalkSpeed, 10);
					}
						
					FallSpawnX = x + (AutoMoveFrames * WalkSpeed * AutoMoveDirX);
					FallSpawnY = y + (AutoMoveFrames * WalkSpeed * AutoMoveDirY);
					FallSpawnFacing = StartDir;
					FallSpawnFloorLevel = FloorLevel;
					if(global.Level.Index != DungeonLevel.Start) GoingThruClosedDoor = true;
					oHUD.CheckPendentSecret = true;
					DescendingPhase = 0;
						
				}
					
				break;
			}
	
			_Exit = true;
			break;
	
	case LinkState.Warping:
	
		if(!Warp_Engage && oRender.Mosaic_SizeDir == -1){
			Warp_Engage = true;
			var DestRoom = global.Level.Rooms[Warp_RoomIndex_To];
			x = DestRoom.WarpDest_X;
			y = DestRoom.WarpDest_Y;
			FallSpawnX = x;
			FallSpawnY = y;
			HitBox.x = x;
			HitBox.y = y;
			FloorLevel = GetFloorLevelID(x, y);
			FloorLevelStr = GetFloorLevelString(FloorLevel);
			FallSpawnFloorLevel = FloorLevel;
			LampDim = FloorLevel;
			UpdateCarryItem();
			Dungeon_DestroyUnimportantObjs();
			oCamera.SetToRoomIndex(Warp_RoomIndex_To, true, true, x - 128, y - 128)
			global.Level.Rooms[Warp_RoomIndex_To].Visited = true;
			Enemy_Reset(Warp_RoomIndex_To);
			Lighting_UpdateLinkLight([x, y - 6]);
			Map_UpdateExploredRooms();	
			Dungeon_RoomDeActivate(Warp_RoomIndex_From);
			
		}
		
		_Exit = true;
		break;
		
	case LinkState.FallingOverEdge:
		x += vx;
		y += vy;
		FallOverEdgeDelay--;
		if(FallOverEdgeDelay == 0){
			UpdateState(LinkState.Falling);
			instance_destroy(oSword);
			instance_destroy(oRod_Cane);
		}
			
		_Exit = true;
		break;
		
	case LinkState.HoldingItem:

		if(ItemHolding.object_index == oItem_Crystal && !HoldBossCrystal){
			audio_stop_sound(Music_Boss_Defeated);
			instance_destroy(ItemHolding);
			ItemHolding = noone;
			oHUD.BossesDefeated++;
			UpdateState(LinkState.Standing);
			with(oDoor){
				if(RoomIndex == global.CurrentRoomIndex && Location == "Top"){
					Open = true;
					Exit = true;
					break;
				}
			}
					
		}				

		_Exit = true;
		break;
	
	case LinkState.Falling:
	//case LinkState.SwordSpin:		
	case LinkState.Shocked:
	case LinkState.Inventory:
	case LinkState.Dialogue:
	case LinkState.VideoGame:
	case LinkState.Idle:
	case LinkState.Dead:
		_Exit = true;
		break;

}


if(_Exit || State == LinkState.AutoMove || oCamera.RoomTransition != NONE){
	
	if(alarm[3] >= 0) alarm[3]++; //pause the curse health drain timer for any exit state

}

if(_Exit){
	exit;	
}


if(State != LinkState.Hit && !BounceBack) {
	vx = 0; vy = 0;
}

	
//Check for keys and update v's only if in these states
if( (State == LinkState.Standing || State == LinkState.Walking || State == LinkState.Pushing || State == LinkState.Star ) && !BounceBack){
	

	keyUp =  input_check("up");
	keyDown = input_check("down");
	keyLeft = input_check("left");
	keyRight = input_check("right");		

		
	Action[ActionKey.Up] = keyUp || MoveAssistDir == UP;
	Action[ActionKey.Down] = keyDown || MoveAssistDir == DOWN;
	Action[ActionKey.Left] = keyLeft || MoveAssistDir == LEFT;
	Action[ActionKey.Right] = keyRight || MoveAssistDir == RIGHT;
	
	
	if(!global.ArcadeVP_Show && State != LinkState.Star){
		
		Action[ActionKey.Sword] = input_check_pressed("sword");
		
		
		Action[ActionKey.Interact] = input_check_pressed("action");
		Action[ActionKey.Item] = input_check_pressed("item");
	}
	
	Action[ActionKey.Run] = input_check("action");
	Action[ActionKey.Strafe] = input_check("strafe") || SwordCharge > 0;

	//Cancel movement actions if opposing directions are both true
	if(Action[ActionKey.Up] && Action[ActionKey.Down]){
		Action[ActionKey.Up] = false;
		Action[ActionKey.Down] = false;
	}
	if(Action[ActionKey.Left] && Action[ActionKey.Right]){
		Action[ActionKey.Left] = false;
		Action[ActionKey.Right] = false;
	}
	
	if(Action[ActionKey.Strafe]) FacingLock = Facing;
	
	
	if(MoveAssistDir != NONE){
		if(frac(x) != 0){
			x = round(x / 2) * 2;
		}
		if(frac(y) != 0){
			y = round(y / 2) * 2;
		}
		var S = MoveAssistSpeed;
	}else{
		var S = ( (ItemHolding == noone && SwordCharge == 0) ? (Action[ActionKey.Run] && !InDoorPassage ? RunSpeed : WalkSpeed) : CarryingSpeed);
	}
	

	vx = ( (Action[ActionKey.Left] ? -1 : 0) + (Action[ActionKey.Right] ? 1 : 0) ) * S;
	vy = ( (Action[ActionKey.Up] ? -1 : 0) + (Action[ActionKey.Down] ? 1 : 0) ) * S;

	vx_extra = 0;
	vy_extra = 0;


	
	if(ItemHolding == noone){
		if(Action[ActionKey.Sword] && global.Inventory.ItemData[ItemClass.Sword].Index != -1) UpdateState(LinkState.Sword);
	
		else if(Action[ActionKey.Item] && !InDoor_Full) Inventory_UseItem(Inventory_EquipedSlot, false);

	}

	var _CanPutDownObj = false;
	if(ItemHolding != noone){
		if(instance_exists(ItemHolding)){
			switch(ItemHolding.object_index){
				case oBomb:
					if(ItemHolding.Red) break;
				case oOrb:
				case oGem:
				case oWishStone:
					if(InDoor_Facing) break;
					_CanPutDownObj = true;
					break;
			}
		}
	}
	
	if(_CanPutDownObj && Action[ActionKey.Sword]){
		UpdateState(LinkState.PutDown);
	}else if(Action[ActionKey.Interact]) Interact();	
	
}


if(State == LinkState.Standing){
	if(Action[ActionKey.Up] || Action[ActionKey.Down] || Action[ActionKey.Left] || Action[ActionKey.Right]) UpdateState(LinkState.Walking);	
}else if(State == LinkState.Walking){
	if(!Action[ActionKey.Up] && !Action[ActionKey.Down] && !Action[ActionKey.Left] && !Action[ActionKey.Right]) UpdateState(LinkState.Standing);
}


if(Castle_Entering && oLink.State != LinkState.AutoMove && global.DB_Inst == noone){

	Link_SetAutoMove(0, -1, 0.4);
	Music_Fade(0, SongFadeLen_House, SongIndex.Castle);
	oRender.FadeOut();
	oIntro.alarm[1] = -1; //turn off lightning, it looks glitchy as screen is fading
	oIntro.alarm[2] = -1;
	global.GlobalLighting = true;

}

if(SwordCharge > 0){
	
	if(input_check("sword")){
		
		SwordCharge += SwordChargeSpeed;
		
		if(!SwordLevel(Swords.Long)){
			if(SwordCharge > 0.1) SwordCharge = 0.1;
		}else{
			if(SwordCharge > 1) SwordCharge = 1;
			if(SwordCharge >= SwordChargeReady && SwordChargePlaySound){
				audio_play_sound(Sound_SwordCharge, 1, false);
				SwordChargePlaySound = false;
			}
		}		
		
	}else{
		if(SwordCharge >= SwordChargeReady && (State == LinkState.Standing || State == LinkState.Walking)){
			UpdateState(LinkState.SwordSpin);
			exit;
		}else{
			Sword_ResetCharge();
			UpdateSprites();
		}		
	}
	
}

//Update states
switch(State){
	
	case LinkState.Walking:
			
			Facing_Check();
			
			UpdateSprites();
			
			if(CheckDoors() == 1) exit; //Descending if returns 1, so exit;
			
			CheckRoomTransition();
			
			if( InWater && !audio_is_playing(Sound_Water_Walk)) audio_play_sound(Sound_Water_Walk, 1, false);
			
			break;
	
	case LinkState.Star:
		if(CheckDoors() == 1) exit; //Descending if returns 1, so exit;
		CheckRoomTransition();
		if( InWater && !audio_is_playing(Sound_Water_Walk)) audio_play_sound(Sound_Water_Walk, 1, false);
		break;
		
	case LinkState.AutoMove:
			
			if(Castle_Entering && global.RoomFadeBlackOut){
				
				Castle_Entering = false;

				instance_destroy(oIntro);
				
				Dungeon_InitLevel(DungeonLevel.Castle);

				break;
			}
			
			if(House_Entering && global.RoomFadeBlackOut){

				House_OldX = x;
				House_OldY = y;	
				
				var _Room =  global.Level.DungeonTemplate.Rooms[House_RoomIndex];
				var HouseDoorX = _Room.x + _Room[$ "Doors"][0].x;
				var HouseDoorY = _Room.y + _Room[$ "Doors"][0].y;
				x = HouseDoorX + 16;
				y = HouseDoorY + 32;
				FloorLevel = GetFloorLevelID(x, y);
				FloorLevelStr = GetFloorLevelString(FloorLevel);
				LampDim = FloorLevel;
				UpdateState(LinkState.Standing);
				House_Inside = true;
				
				//Lighting_SetRoomData(House_RoomIndex, 1);
	
				oCamera.SetToRoomIndex(House_RoomIndex, true, true, House_X, House_Y);
				
				oRender.FadeIn();
				
				Link_SetAutoMove(0, -1, 0.5, 35);
				
				House_Entering = false;
			}

			if(House_Leaving && global.RoomFadeBlackOut){

				x = House_OldX;
				y = House_OldY;	
				
				FloorLevel = GetFloorLevelID(x, y);
				FloorLevelStr = GetFloorLevelString(FloorLevel);
				LampDim = FloorLevel;
				
				//Lighting_SetRoomData(House_OldRoomIndex, 1);	
				oCamera.SetToRoomIndex(House_OldRoomIndex, true, true, x - 128, y - 128);
					
				oRender.FadeIn();
				
				DoorPassage = House_DoorInst.PassageArea;

				Link_SetAutoMove(0, 1, 0.5, 40);

				House_Inside = false;
				
				if(House_Leaving){
					with(oWaterfall){
						LinkLeavingHouse = true;
					}
				}
				
				House_Leaving = false;
			}
			
			if(AutoMoveFrames != -1) AutoMoveFrames--
			
			vx = AutoMoveDirX * AutoMoveSpeed;
			vy = AutoMoveDirY * AutoMoveSpeed;

			if(AutoMoveFrames == 0){
		
				if(GoingThruClosedDoor){
					LastDoorID.Close = true;
					GoingThruClosedDoor = false;
					UpdateState(LinkState.Idle); //after door close, it will set back to standing state
					
					//check to make sure there's no rolling spikes right at the door rolling towards Link, these are unavoidable
					with(oEnemy_RollingSpike){
						switch(oLink.Facing){
							case UP:
								if(vy > 0) vy *= -1;
								break;
							case DOWN:
								if(vy < 0) vy *= -1;
								break;
							case LEFT:
								if(vx > 0) vx *= -1;
								break;
							case RIGHT:
								if(vx < 0) vx *= -1;
								break;
							
						}
					}
					
				}else{
					global.Paused = false;
					UpdateState(LinkState.Standing);					
				}				
				
			}
				
			CheckDoors();
				
			//if Room transition, Link is automoving with -1(infinite). Make Link stop at positions right before entrance door
			switch(oCamera.RoomTransition){
				case LEFT:	if(x <= global.CurrentRoom.x - 40 + (FloorLevel * 24)) UpdateState(LinkState.Idle); break;
				case RIGHT: if(x >= global.CurrentRoom.x + global.CurrentRoom.width + 40 - (FloorLevel * 24)) UpdateState(LinkState.Idle); break;
				case UP: if(y <= global.CurrentRoom.y - 28 + (FloorLevel * 24)) UpdateState(LinkState.Idle); break;
				case DOWN: if(y >= global.CurrentRoom.y + global.CurrentRoom.height + 45 - (FloorLevel * 24)) UpdateState(LinkState.Idle); break;
			}	

			break;
		
	case LinkState.Pushing:
		if(!PushingWall) UpdateState(LinkState.Standing);
		break;

	case LinkState.PickUp:
		
		if(ItemHolding == noone || !instance_exists(ItemHolding)){
			UpdateState(LinkState.Standing);
			ItemHolding = noone;
			break;
		}
		
		var img_index = floor(image_index);
		
		Link_PickupObjPos(img_index);
	
		if(img_index >= image_number - 1){
			UpdateState(LinkState.Standing);
			ItemHolding.mask_index = sEmptyMask;
		}
		break;
	
	case LinkState.PutDown:

		if(ItemHolding == noone || !instance_exists(ItemHolding)){
			UpdateState(LinkState.Standing);
			ItemHolding = noone;
			break;
		}
		
		var img_index = floor(image_index);
		
		Link_PickupObjPos(img_index);
		
		if(img_index <= 0){
			
			switch(ItemHolding.object_index){
				
				case oOrb:
				case oGem:
				case oBomb:
				case oWishStone:
					
					ItemHolding.x = x;
					ItemHolding.y = y;
					switch(oLink.Facing){
						case UP: ItemHolding.y -= 16; break;
						case DOWN: ItemHolding.y += 16; break;
						case LEFT: ItemHolding.x -= 16; break;
						case RIGHT: ItemHolding.x += 16; break;
					}
					
					var _FallInHole = false;
					with(ItemHolding){
						ObjSetY(y);
						if(Item_OverHole()){
							Item_FallInHole();
							_FallInHole = true;
						}
					}
					if(_FallInHole) break;
					
					var _Inst = instance_create_layer(ItemHolding.x, ItemHolding.y, oLink.layer, ItemFromObj(ItemHolding.object_index), {From : ItemFrom.Inventory, FloorLevel : ItemHolding.FloorLevel});
					with(_Inst){
						Item_SetIndex(oLink.ItemHolding.Index);
						Amount = 1;
						Setup = false;
					}

					break;
		
			}
			
			instance_destroy(ItemHolding);
			ItemHolding = noone;
			UpdateState(LinkState.Standing);
			
		}		
		break;
		
	case LinkState.Throwing:
		if(image_index >= image_number - 1) UpdateState(LinkState.Standing);
		break;


}

var _DoorInst = instance_place(x, y, oDoor);
InDoor = _DoorInst != noone;
InDoor_Full = false;
InDoor_Facing = false;
InDoor_BlockItem = false;
InDoor_Aligned = true;
InDoor_House = (instance_place(x, y, oHouseDoor) != noone || instance_place(x, y, oCastleWallDoor) != noone);

if(InDoor){
	InDoor_Full = (rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _DoorInst.bbox_left, _DoorInst.bbox_top, _DoorInst.bbox_right, _DoorInst.bbox_bottom) == 1 || InDoorPassage);
	InDoor_Facing = (Facing == Door_LocationToDir(_DoorInst.Location));
	_DoorInst.WallInst.BlockItems = InDoor_Facing;
	InDoor_BlockItem = _DoorInst.WallInst.BlockLinkCarry || InDoor_House;
	if(InDoor_Full){
		InDoor_Aligned = (InDoor_Facing || Facing == Door_LocationToOppositeDir(_DoorInst.Location));
	}
}





//UnderWalkway = (FloorLevel == LOWER && ObjTileCollision(self, global.TMID_Floor_Upper)); 
//layer = (FloorLevel == UPPER || (FloorLevel == LOWER && State == LinkState.Jumping && !UnderWalkway) ? global.LayerID_Objs_Upper : global.LayerID_Objs_Lower);

layer = (FloorLevel == UPPER ? global.LayerID_Objs_Upper : global.LayerID_Objs_Lower);

InWater = OnWaterTile(FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower, x, y);

StandingOnMap = false;
StandingOnCompass = false;

var _GravityBall = false;

if(State != LinkState.Hit && global.Level.Index != DungeonLevel.Start){
	
	if(CheckHoles()) exit;
	
	if(global.Level.Index == DungeonLevel.Aghanim2){
		_GravityBall = CheckGravityBall();
	}
	
	CheckEnemies();
	
	CheckMovingFloor();

	CheckSpikes();

}

if(BounceBack && InDoor){
	vx = 0;
	vy = 0;
}

//Walls

PushingWall = false;
PushingDirX = 0;
PushingDirY = 0;


var _checkwalls = (vx != 0);
if(DEBUG){
	if(global.Clip) _checkwalls = false;
}
if(_checkwalls){
	
	WallCollision(CollidedWallList, vx + sign(vx), 0, oWall)
	var Walls = ds_list_size(CollidedWallList);
	
	for(var i = 0; i < Walls; i++){
		var WallInst = CollidedWallList[| i];
		if((Action[ActionKey.Left] || Action[ActionKey.Right]) && !Action[ActionKey.Up] && !Action[ActionKey.Down] && ItemHolding == noone){
			PushingDirX = sign(vx);
			PushingWall = ( (Action[ActionKey.Left] && Facing == LEFT && PushingDirX < 0) || (Action[ActionKey.Right] && Facing == RIGHT && PushingDirX > 0) );
			break;
		}
	}

	if(Walls > 0){
		vx = 0;
		MoveAssist = true;	
	}
	
}
x += vx; 


var _checkwalls = (vy != 0);
if(DEBUG){
	if(global.Clip) _checkwalls = false;
}
if(_checkwalls){
	
	WallCollision(CollidedWallList, 0, vy + sign(vy), oWall)
	var Walls = ds_list_size(CollidedWallList);
	
	for(var i = 0; i < Walls; i++){
		var WallInst = CollidedWallList[| i];
		if((Action[ActionKey.Up] || Action[ActionKey.Down]) && !Action[ActionKey.Left] && !Action[ActionKey.Right] && ItemHolding == noone){
			PushingDirY = sign(vy);
			PushingWall = ( (Action[ActionKey.Up] && Facing == UP && PushingDirY < 0) || (Action[ActionKey.Down] && Facing == DOWN && PushingDirY > 0) );
			break;
		}
	}

	if(Walls > 0){
		vy = 0;
		MoveAssist = true;	
	}

}
y += vy; 

x = clamp(x, 0, DungeonW - 1);
y = clamp(y, 0, DungeonW - 1);

RoomIndex = Dungeon_GetRoomIndex(x, y);

//Check for switchblocks to lower if you have the moonpearl
if(global.Inventory.ItemData[ItemClass.MoonPearl].Owns[0]){
	ds_list_clear(CollidedWallList);
	var Walls = collision_circle_list(x, y, 32, oWall, false, true, CollidedWallList, false);
	var _PlayedSound = false;
	for(var i = 0; i < Walls; i++){
		var WallInst = CollidedWallList[| i];
		if(WallInst.IsSwitchBlock){
			if(WallInst.SwitchBlockInst.Raised){
				global.Level.SwitchBlock_ActiveColor = WallInst.SwitchBlockInst.Color;
				with(oSwitchBlock){
					if(!Toggle){
						Toggle = true;
						if(!_PlayedSound){
							audio_play_sound(Sound_DoorClose, 1, false);
							audio_play_sound(Sound_Cape_Off, 1, false, 1);							
							_PlayedSound = true;
						}
					}
				}
				break;
			}
		}
	}
}


if(State == LinkState.Hit || BounceBack) exit;


if(PushingWall){
	if(State != LinkState.Pushing && alarm[1] == -1 && MoveAssistDir == NONE && !_GravityBall) alarm[1] = 24;
}else{
	alarm[1] = -1;
}


CheckMoveAssist();

CheckStairs();

CheckItems();

CheckSpecialItems();

UpdateCarryItem();

