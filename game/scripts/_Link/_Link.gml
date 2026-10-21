enum LinkState{
	Idle,
	Standing,
	Walking,
	Hit,
	Dead,
	AutoMove,
	PickUp,
	TreasureOpening,
	HoldingItem,
	Throwing,
	Pushing,
	Sword,
	Bow,
	Boomerang,
	Hookshot,
	Rod,
	Powder,
	Shocked,
	Falling,
	FallingOverEdge,
	Descending,
	Warping,
	Inventory,
	Dialogue,
	VideoGame
	
}

enum ActionKey{
	Up,
	Down,
	Left,
	Right,
	Sword,
	Interact,
	Item,
	Jump,
	Strafe
}

enum LinkWeapon{
	Sword,
	Pot,
	Arrow,	
	Boomerang,
	Hookshot,
	Bomb,
	Fire,
	Ice,
	SwordBeam,
	Magic	
}
#macro LinkWeapons 10

function Link_SetStartingPos(){

	oCamera.SetCurrentRoom(global.Level.RoomIndex_Entrance);
	
	global.TransitionRoom = -1;
	global.TransitionRoomIndex = -1;
	
	var EntranceRoom = global.Level.DungeonTemplate.Rooms[global.Level.RoomIndex_Entrance];
	
	var RoomX = EntranceRoom.x;
	var RoomY = EntranceRoom.y;
	var RoomGridW = EntranceRoom.GridW;
	var RoomGridH = EntranceRoom.GridH;
	var EntranceDoorX = global.DoorCoordinates [GetRoomSizeIndex(RoomGridW, RoomGridH)][6].x;
	var EntranceDoorY = global.DoorCoordinates[GetRoomSizeIndex(RoomGridW, RoomGridH)][6].y;
	var EntranceX = RoomX + EntranceDoorX;
	if(Dungeon_StartDir(global.Level.Index) == UP){ //even dungeon #, start at bottom facing up
		var Facing = UP;
		var EntranceY = RoomY + EntranceDoorY;
		 oLink.y = EntranceY + 8;
		
	}else{ //odd dungeon #, start at top facing down
		var Facing = DOWN;		
		var EntranceY = RoomY + EntranceDoorY - (RoomGridH == 1 ? 194 : 450);
		oLink.y = EntranceY + 16;
	}
	
		
	oLink.x = EntranceX + 16;
	
	oLink.HitBox.x = oLink.x;
	oLink.HitBox.y = oLink.y;
	
	oLink.Facing = Facing;
	oLink.DominantDir = Facing;
	oLink.image_index = 0;
	oLink.image_speed = 1;
	oLink.FloorLevel = UPPER;
	oLink.LampDim = 1;
	Link_UpdateAttackDefence();
	oLink.GoingThruClosedDoorID = noone;
	
	global.VillageSpecialItem = noone;

	oLink.LampLightID = Lighting_CreateLight(x, y, oLink.LampLightR, oLink.LampLightG, oLink.LampLightB, 1 + (global.ItemData[oItem_Lamp].Index * 0.5), true);
	Lighting_UpdateLightStatus(oLink.LampLightID, 1.0);
	Lighting_UpdateLightPos(oLink.LampLightID, oLink.x, oLink.y);
	
	global.LightingData_RoomStatus[0] = global.CurrentRoom.Lighting;
	global.LightingData_RoomBoundary[0] = global.CurrentRoom.x;
	global.LightingData_RoomBoundary[1] = global.CurrentRoom.y;
	global.LightingData_RoomBoundary[2] = global.CurrentRoom.x + global.CurrentRoom.width - 1;
	global.LightingData_RoomBoundary[3] = global.CurrentRoom.y + global.CurrentRoom.height - 1;
	Lighting_UpdateInRooms();
	
	oCamera.X = RoomX;
	oCamera.Y = RoomY;
	oCamera.DungeonGridX = EntranceRoom.GridX;
	oCamera.DungeonGridY = EntranceRoom.GridY;

	oHUD.ShowLevelName = true;


	global.Level.Rooms[global.CurrentRoomIndex].Visited = true;
	Map_UpdateExploredRooms();
	
	if(global.Level.Index == DungeonLevel.Start) exit;

	oLink.FallSpawnX = oLink.x;
	oLink.FallSpawnY = oLink.y;
	
	//precalculate hole tiles for to speed up collision check
	global.HoleTileID_TL = GetTileID(102, LevelTilesY + 4); 
	global.HoleTileID_TM = GetTileID(104, LevelTilesY + 4); 					
	global.HoleTileID_TR = GetTileID(103, LevelTilesY + 4); 
	global.HoleTileID_ML = GetTileID(104, LevelTilesY + 5); 
	global.HoleTileID_MR = GetTileID(105, LevelTilesY + 4); 
	global.HoleTileID_BL = GetTileID(102, LevelTilesY + 5); 
	global.HoleTileID_BM = GetTileID(105, LevelTilesY + 5); 
	global.HoleTileID_BR = GetTileID(103, LevelTilesY + 5); 
	global.HoleTileID_ITL = GetTileID(106, LevelTilesY + 4);
	global.HoleTileID_ITR = GetTileID(107, LevelTilesY + 4);
	global.HoleTileID_IBL = GetTileID(106, LevelTilesY + 5);
	global.HoleTileID_IBR = GetTileID(107, LevelTilesY + 5); 

	
	for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
		Dungeon_RoomDeActivate(_RoomIndex);		
	}
	
	Dungeon_RoomActivate(global.CurrentRoomIndex);

	Lighting_SetRoomData(global.Level.RoomIndex_Entrance, 0);
	
	if(global.Level.Index == DungeonLevel.Castle || global.Continue){
		with(oLink){
			Link_SetAutoMove(0, Dungeon_StartDir(global.Level.Index) == UP ? -1 : 1, 0.5, 28);	
			if(global.Level.Index >= DungeonLevel.CastleBasement) GoingThruClosedDoor = true;
		}
		//global.RoomFadeBlackOut = true;
		//oRender.FadeIn();
	}
	
	
	
}

function UpdateState(NewState){
	
	State = NewState;
	
	image_index = 0;
	
	UpdateSprites();	
	
	alarm[1] = -1; //reset pushing timer
	
	if(instance_exists(oSword)) instance_destroy(oSword);
	
	switch(State){
		
		case LinkState.Standing:
			AutoMoveFrames = 0;	
			image_index = (instance_exists(ItemHolding) ? 1 : 0);
			break;
		
		case LinkState.Sword:
			var _FloorLevelStr = GetFloorLevelString(FloorLevel);
			var SwordInst = instance_create_layer(x, y, "Objs_" + _FloorLevelStr, oSword);
			SwordInst.FloorLevel = FloorLevel;
			audio_play_sound(asset_get_index("Sound_Sword" + string(global.ItemData[oItem_Sword].Index + 1)), 1, false);
			
			if(Skill_Check(Skill.MagicBeam)){
				if(Health > HealthMax - 0.25){
					if(!instance_exists(oSwordBeam)) instance_create_layer(x, y, "ObjsHigher_" + _FloorLevelStr, oSwordBeam);
				}
			}
			
			break;
		
		case LinkState.Bow:
			//var s = 0.5 + (global.ItemData[oItem_Bow].Index * 0.25);
			ObjSetImageSpeed(1);
			break;
		
		case LinkState.Powder:
			
			break;
			
		case LinkState.Throwing:
			switch(ItemHolding.object_index){
				case oPot:
					var PotInst = instance_create_layer(ItemHolding.x, ItemHolding.y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oPot_Thrown);
					PotInst.image_index = ItemHolding.image_index;
					PotInst.FloorLevel = FloorLevel;
					instance_destroy(ItemHolding);
					break;
				
				case oBush:
					var BushInst = instance_create_layer(ItemHolding.x, ItemHolding.y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oBush_Thrown);
					BushInst.image_index = ItemHolding.image_index;
					BushInst.FloorLevel = FloorLevel;
					instance_destroy(ItemHolding);
					break;
				
				case oBomb:
					var BombInst = instance_create_layer(ItemHolding.x, ItemHolding.y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oBomb_Thrown);
					with(BombInst){
						x = oLink.x;
						ObjSetY(oLink.y - 1);
						switch(oLink.Facing){
							case UP: vy = -2.5; break;
							case DOWN: vy = 2.5; break;
							case LEFT: vx = -2.5; break;
							case RIGHT: vx = 2.5; break;
						}
						alarm[0] = oLink.ItemHolding.alarm[0];
						alarm[1] = oLink.ItemHolding.alarm[1];
						ObjSetImageSpeed(oLink.ItemHolding.image_speed);
						image_index = oLink.ItemHolding.image_index;
						FloorLevel = oLink.FloorLevel;
					}
					instance_destroy(ItemHolding);
					break;

				case oOrb:
					var inst = instance_create_layer(ItemHolding.x, ItemHolding.y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oOrb_Thrown, {Index : ItemHolding.Index});
					with(inst){
						z = 18;
						vz = 1.5;
						x = oLink.x;
						ObjSetY(oLink.y - 1);
						switch(oLink.Facing){
							case UP: vy = -Speed; break;
							case DOWN: vy = Speed; break;
							case LEFT: vx = -Speed; break;
							case RIGHT: vx = Speed; break;
						}
						Orb_Init();
						LightTimer = other.ItemHolding.LightTimer;						
					}
					instance_destroy(ItemHolding);
					break;

				case oEnemy_Chicken:
					with(ItemHolding){
						Enemy_UpdateState(EnemyState.Jumping);
					}

					break;
					
			}
			ItemHolding = noone;
			audio_play_sound(Sound_Throw, 1, false);			
			break;
		
		case LinkState.Hit:
			Invincible = true;
			HitFlashingStatus = true;
			alarm[4] = HitFlashingLength; //Stay invincible/flashing for this long
			alarm[5] = HitFlashingDelay; //flashing alarm
			alarm[6] = HitSoundDelay;
			break;
		
		case LinkState.Dead:
			instance_create_layer(0, 0, "System", oLinkDeath);
			break;
			
		case LinkState.Descending:
			DescendingPhase = 1;
			x = floor(x); y = floor(y);
			var snd = audio_play_sound(Sound_StairsFloorDown, 1, false);
			audio_sound_gain(snd, 0, 2000);
			if(oMusic.SongPlaying_Index != global.Music_LevelSongIndex[global.Level.Index + 1]) oMusic.Fade = true;

			if(audio_is_playing(global.RainSound)) audio_sound_gain(global.RainSound, 0, 1000);

			
			break;
		
		case LinkState.Shocked:
			alarm[2] = 30;
			audio_play_sound(Sound_Hurt, 1, false);
			audio_play_sound(Sound_Shock, 1, false);
			break;
		
		case LinkState.Falling:
			audio_play_sound(Sound_LinkFall, 1, false);
			break;
			
	}	
	
}

function UpdateSprites(){
	
	switch(State){
		
		case LinkState.Standing:
		//case LinkState.BounceBack:
		case LinkState.Dialogue:
		case LinkState.Inventory:
		case LinkState.TreasureOpening:
		case LinkState.Warping:
		case LinkState.Idle:
			switch(Facing){
				case LEFT: sprite_index = (global.OldLinkSprites ? sLink_Stand_Left : global.LinkSpr_Stand_Left); break;
				case RIGHT: sprite_index = (global.OldLinkSprites ? sLink_Stand_Right : global.LinkSpr_Stand_Right); break;
				case UP: sprite_index = (global.OldLinkSprites ? sLink_Stand_Up : global.LinkSpr_Stand_Up); break;
				case DOWN: sprite_index = (global.OldLinkSprites ? sLink_Stand_Down : global.LinkSpr_Stand_Down); break;
			}
			image_index = (State == LinkState.Standing ? (instance_exists(ItemHolding) ? 1 : 0) : 0);
			break;
		
		case LinkState.Walking:
			switch(Facing){
				case LEFT: sprite_index = (instance_exists(ItemHolding) ? sLink_Carrying_Left : (global.OldLinkSprites ? sLink_Walk_Left : global.LinkSpr_Walk_Left)); break;
				case RIGHT: sprite_index = (instance_exists(ItemHolding) ? sLink_Carrying_Right : (global.OldLinkSprites ? sLink_Walk_Right : global.LinkSpr_Walk_Right)); break;
				case UP: sprite_index = (instance_exists(ItemHolding) ? sLink_Carrying_Up : (global.OldLinkSprites ? sLink_Walk_Up : global.LinkSpr_Walk_Up)); break;
				case DOWN: sprite_index = (instance_exists(ItemHolding) ? sLink_Carrying_Down: (global.OldLinkSprites ? sLink_Walk_Down : global.LinkSpr_Walk_Down) ); break;
			}
			break;

		case LinkState.Hit:
		case LinkState.Dead:
			switch(Facing){
				case LEFT: sprite_index = sLink_Hurt_Left; break;
				case RIGHT: sprite_index = sLink_Hurt_Right; break;
				case UP: sprite_index = sLink_Hurt_Up; break;
				case DOWN: sprite_index = sLink_Hurt_Down; break;
			}
			break;
			
		case LinkState.AutoMove:	
			switch(Facing){
				case LEFT: sprite_index = global.OldLinkSprites ? sLink_Walk_Left : global.LinkSpr_Walk_Left; break;
				case RIGHT: sprite_index = global.OldLinkSprites ? sLink_Walk_Right : global.LinkSpr_Walk_Right; break;
				case UP: sprite_index = global.OldLinkSprites ? sLink_Walk_Up : global.LinkSpr_Walk_Up; break;
				case DOWN: sprite_index = global.OldLinkSprites ? sLink_Walk_Down : global.LinkSpr_Walk_Down; break;
			}
			break;

		case LinkState.Pushing:
			switch(Facing){
				case LEFT: sprite_index = sLink_Push_Left; break;
				case RIGHT: sprite_index = sLink_Push_Right; break;
				case UP: sprite_index = sLink_Push_Up; break;
				case DOWN: sprite_index = sLink_Push_Down; break;
			}
			break;
		
		case LinkState.Falling:
			sprite_index = sLink_Falling;
			break;
			
		case LinkState.Sword:

			switch(Facing){
				case LEFT: sprite_index = (global.OldLinkSprites ? sLink_Sword_Left : global.LinkSpr_Sword_Left); break;
				case RIGHT: sprite_index = (global.OldLinkSprites ? sLink_Sword_Right : global.LinkSpr_Sword_Right); break;
				case UP: sprite_index = (global.OldLinkSprites ? sLink_Sword_Up : global.LinkSpr_Sword_Up); break;
				case DOWN: sprite_index = (global.OldLinkSprites ? sLink_Sword_Down : global.LinkSpr_Sword_Down); break;
			}
			break;
		
		case LinkState.Bow:
			switch(Facing){
				case LEFT: sprite_index = sLink_Bow_Left; break;
				case RIGHT: sprite_index = sLink_Bow_Right; break;
				case UP: sprite_index = sLink_Bow_Up; break;
				case DOWN: sprite_index = sLink_Bow_Down; break;
			}
			break;
		
		case LinkState.Boomerang:
			switch(Facing){
				case LEFT: sprite_index = sLink_Boomerang_Left; break;
				case RIGHT: sprite_index = sLink_Boomerang_Right; break;
				case UP: sprite_index = sLink_Boomerang_Up; break;
				case DOWN: sprite_index = sLink_Boomerang_Down; break;
			}
			break;
		
		case LinkState.Hookshot:
			switch(Facing){
				case LEFT: sprite_index = sLink_Hookshot_Left; break;
				case RIGHT: sprite_index = sLink_Hookshot_Right; break;
				case UP: sprite_index = sLink_Hookshot_Up; break;
				case DOWN: sprite_index = sLink_Hookshot_Down; break;
			}
			break;
			
		case LinkState.Rod:
			switch(Facing){
				case LEFT: sprite_index = sLink_Rod_Left; break;
				case RIGHT: sprite_index = sLink_Rod_Right; break;
				case UP: sprite_index = sLink_Rod_Up; break;
				case DOWN: sprite_index = sLink_Rod_Down; break;
			}
			break;
		
		case LinkState.Powder:
			switch(Facing){
				case LEFT: sprite_index = sLink_Powder_Left; break;
				case RIGHT: sprite_index = sLink_Powder_Right; break;
				case UP: sprite_index = sLink_Powder_Up; break;
				case DOWN: sprite_index = sLink_Powder_Down; break;
			}
			break;
		
		case LinkState.PickUp:
			switch(Facing){
				case LEFT: sprite_index = sLink_PickUp_Left; break;		
				case RIGHT: sprite_index = sLink_PickUp_Right; break;
				case UP: sprite_index = sLink_PickUp_Up; break;
				case DOWN: sprite_index = sLink_PickUp_Down; break;				
			}
			break;
			
		case LinkState.Throwing:
			switch(Facing){
				case LEFT: sprite_index = sLink_Throw_Left;	break;		
				case RIGHT:	sprite_index = sLink_Throw_Right; break;
				case UP: sprite_index = sLink_Throw_Up;	break;
				case DOWN: sprite_index = sLink_Throw_Down;	break;				
			}
			break;
			
		case LinkState.HoldingItem:
			sprite_index = (global.OldLinkSprites ? sLink_HoldingItem : global.LinkSpr_HoldingItem);
			break;
		
		case LinkState.Descending:
			if(DescendingLocation == TOP) sprite_index = (global.OldLinkSprites ? sLink_Descending_Top1 : global.LinkSpr_Descending_Top1);
			else sprite_index = (global.OldLinkSprites ? sLink_Descending_Bottom1 : global.LinkSpr_Descending_Bottom1);
			break;
		
		case LinkState.Shocked:
			sprite_index = sLink_Shock;
			break;
			
			
	}
	
}

function Facing_Check(){
	
	if(MoveAssistDir != NONE || BounceBack || Action[ActionKey.Strafe]) exit;
	
	if(vx == 0){
		if(vy < 0) {Facing = UP; exit;}
		if(vy > 0) {Facing = DOWN; exit;}
	}
	if(vy == 0){
		if(vx < 0) {Facing = LEFT; exit;}
		if(vx > 0) {Facing = RIGHT;	exit;}
	}
	if(Facing == LEFT && vx > 0){
		if(vy > 0) {Facing = choose(RIGHT, DOWN); exit;}
		if(vy < 0) {Facing = choose(RIGHT, UP); exit;}
	}
	if(Facing == RIGHT && vx < 0){
		if(vy > 0) {Facing = choose(LEFT, DOWN); exit;}
		if(vy < 0) {Facing = choose(LEFT, UP); exit;}
	}
	if(Facing == UP && vy > 0){
		if(vx > 0) {Facing = choose(LEFT, DOWN); exit;}
		if(vx < 0) {Facing = choose(RIGHT, DOWN); exit;}
	}
	if(Facing == DOWN && vy < 0){
		if(vx > 0) {Facing = choose(LEFT, UP); exit;}
		if(vx < 0) {Facing = choose(RIGHT, UP); exit;}
	}
	
}

function CheckMoveAssist(){

	MoveAssistDir = NONE;
	if(MoveAssist){ 
	
		MoveAssist = false;
	
		//check move assist with wall objects
	
		if(!keyLeft && !keyRight){
		
			KeyState[0] = keyUp; KeyState[1] = keyDown;
			Position1[0] = bbox_top - 1; Position1[1] = bbox_bottom + 1;
			for(var i = 0; i <= 1; i++){
				if(KeyState[i] && vy == 0){
					var WallInst1 = ObjCollision_Position(x - 1, Position1[i], oWall, FloorLevel); //adding 2 offset by 1 both ways makes for better moveassist for certain stair situations
					var WallInst2 = ObjCollision_Position(x + 1, Position1[i], oWall, FloorLevel); //no need to do 2 for y assist in next section below
					var WallCollide = false;
					if((WallInst1 != noone && (WallInst1.BlockLink || (WallInst1.BlockLinkCarry && ItemHolding != noone))) && (WallInst2 != noone && (WallInst2.BlockLink || (WallInst2.BlockLinkCarry && ItemHolding != noone)))) WallCollide = true;
					if(!WallCollide){
						Position2[0] = bbox_left; Position2[1] = bbox_right;
						for(var j = 0; j <= 1; j++){
							WallInst = ObjCollision_Position(Position2[j], Position1[i], oWall, FloorLevel);
							WallCollide = false;
							if(WallInst != noone && WallInst.BlockLink) WallCollide = true;
							if(WallCollide){
								if(j == 0) MoveAssistDir = RIGHT;
								else       MoveAssistDir = LEFT;
								break;
							}
						}
						if(MoveAssistDir == LEFT || MoveAssistDir == RIGHT) break;
					}
				}
			}

		}

		if(!keyDown && !keyUp){
		
			KeyState[0] = keyLeft; KeyState[1] = keyRight;
			Position1[0] = bbox_left - 1; Position1[1] = bbox_right + 1;
			for(var i = 0; i <= 1; i++){
				if(KeyState[i] && vx == 0){
					var WallInst = ObjCollision_Position(Position1[i], y - 6, oWall, FloorLevel);
					var WallCollide = false;
					if(WallInst != noone && (WallInst.BlockLink || (WallInst.BlockLinkCarry && ItemHolding != noone))) WallCollide = true;
					if(!WallCollide){
						Position2[0] = bbox_bottom; Position2[1] = bbox_top;
						for(var j = 0; j <= 1; j++){
							WallInst = ObjCollision_Position(Position1[i], Position2[j], oWall, FloorLevel);
							WallCollide = false;
							if(WallInst != noone && WallInst.BlockLink) WallCollide = true;
							if(WallCollide){
								if(j == 0) MoveAssistDir = UP;
								else       MoveAssistDir = DOWN;
								break;
							}
						}
						if(MoveAssistDir == UP || MoveAssistDir == DOWN) break;
					}
				}
			}

		}

	}
}

function CheckRoomTransition(){
	
	if(oGame.Clip) exit;
	//Check for Room edges while going thru doors
	//FloorLevel adjustments are because lower level doors are at different positions than upper floor doors
	
	var OpenTransition = false; //if the transition is in an open area without walls (village)
	
	if(oCamera.RoomTransition == NONE){		

		var DoorInst = instance_place(x, y, oDoor);
		
		if(DoorInst != noone){
			
			if(House_Inside){
				if (vy > 0 && y > global.CurrentRoom.y + global.CurrentRoom.height - 30 + (FloorLevel * 24)){
					
					Link_SetAutoMove (0, 1, 0.4);

					//HouseDoorInst.alarm[0] = 70;
					//HouseDoorInst.Warp = true;
					//Music_Play(global.Level.Rooms[House_OldRoomIndex].RoomSongIndex);
					House_Leaving = true;
					oRender.FadeOut();
				}
			}else{
			
				AutoMoveSpeed = (FloorLevel == UPPER ? 0.5 : 1.25);
				if(vx < 0 && x < global.CurrentRoom.x + 40 - (FloorLevel * 24)) oCamera.Cam_InitTransitionRoom(LEFT);
				else if (vx > 0 && x > global.CurrentRoom.x + global.CurrentRoom.width - 40 + (FloorLevel * 24)) oCamera.Cam_InitTransitionRoom(RIGHT);
				else if (vy < 0 && y < global.CurrentRoom.y + 52 - (FloorLevel * 24)){
					AutoMoveSpeed = (FloorLevel == UPPER ? 0.55 : 1.32);
					oCamera.Cam_InitTransitionRoom(UP);					
				}else if (vy > 0 && y > global.CurrentRoom.y + global.CurrentRoom.height - 30 + (FloorLevel * 24)) oCamera.Cam_InitTransitionRoom(DOWN);
				oCamera.MoveSpeed = 4;
			}
		}else{
			//if no door is detected it means we're walking off the edge of an open Room with no wall (village)
			OpenTransition = true;
			
			if(vx < 0 && x < global.CurrentRoom.x + 16){
				AutoMoveSpeed = 0.8;
				oCamera.Cam_InitTransitionRoom(LEFT);
			}else if (vx > 0 && x > global.CurrentRoom.x + global.CurrentRoom.width - 16){
				AutoMoveSpeed = 0.8;
				oCamera.Cam_InitTransitionRoom(RIGHT);
			}else if (vy < 0 && y < global.CurrentRoom.y + 28){
				AutoMoveSpeed = 1.4;
				oCamera.Cam_InitTransitionRoom(UP);
			}else if (vy > 0 && y > global.CurrentRoom.y + global.CurrentRoom.height - 28){
				AutoMoveSpeed = 1.4;
				oCamera.Cam_InitTransitionRoom(DOWN);
			}
			oCamera.MoveSpeed = 8;
			
		}
		
	}

	if(oCamera.RoomTransition != NONE){
		
		if(!OpenTransition){
			if(LastDoorID.LinkedDoor.Status = DoorStatus.Closed){
				GoingThruClosedDoor = true;
				GoingThruClosedDoorID = LastDoorID.LinkedDoor;
				LastDoorID.LinkedDoor.Status = DoorStatus.Open;
				LastDoorID.LinkedDoor.UpdateStatus = true;
				LastDoorID.LinkedDoor.WallInst.BlockLink = true;
				LastDoorID.LinkedDoor.WallInst.BlockProjectiles = true;
			}
			//open any curtain if going through one
			if(LastDoorID.LinkedDoor.CurtainInst != noone){
				LastDoorID.LinkedDoor.CurtainInst.Revealed = true;
			}
		}else{
			if(ItemHolding != noone){
				if(ItemHolding.object_index == oEnemy_Chicken){
					with(ItemHolding){
						PickedUp = false;
						z = 18;
						ObjSetY(oLink.y - 1);
						
					}
				}else{
					instance_destroy(ItemHolding);
				}
				ItemHolding = noone;
			}
		}
				
	}		
}

function CheckDoors(){
	

	var DoorInst = instance_place(x + vx, y + vy, oDoor);
	if(DoorInst != noone){
	
		LastDoorID = DoorInst;

		//Check for locked doors					
		switch(DoorInst.Status){
			case DoorStatus.Locked:	
				if(global.Level.Index == DungeonLevel.Village){
					if(global.VillageSpecialItem == oItem_Key_Special){
						UnlockDoor(DoorInst);
						global.VillageSpecialItem = noone;
					}
				}else{
					if( Keys > 0 || global.ItemData[oItem_Key_Master].Owns[0]) UnlockDoor(DoorInst); 
				}
				
				break;
		}
		
		if(DoorInst.Status == DoorStatus.Down1){
			if(DoorInst.Location == "Top" && y < DoorInst.y + 24){
				DescendingLocation = TOP;
				UpdateState(LinkState.Descending);
				return 1;
			}
			else if(DoorInst.Location == "Bottom" && y > DoorInst.y + 4){
				DescendingLocation = BOTTOM;
				UpdateState(LinkState.Descending);
				return 1;
			}		
		}

		InDoorPassage = rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, DoorPassage[0], DoorPassage[1], DoorPassage[2], DoorPassage[3]);
		DoorPassage = DoorInst.PassageArea;	
		switch(DoorInst.Location){
			case "Top":
			case "Bottom":
				PassageOrientation = TOP_BOTTOM;
				break;
			case "Left":
			case "Right":
				PassageOrientation = LEFT_RIGHT;
				break;
		}


	}
	
	//Check for locked key blocks
	var KeyBlockInst = instance_place(x + vx, y + vy, oKeyBlock);
	if(KeyBlockInst != noone){
		if( Keys > 0 || global.ItemData[oItem_Key_Master].Owns[0]){
			if(!KeyBlockInst.Unlocked){
				if(!global.ItemData[oItem_Key_Master].Owns[0]) KeyAdd(-1);
				KeyBlockInst.alarm[0] = 6; //destroy timer, so it doesn't destroy instantly
				audio_play_sound(Sound_DoorUnlock, 1, false);
				KeyBlockInst.Unlocked = true;
			}
		}
	}

	//Check for House doors
	var HouseDoorInst = instance_place(x, y + 6, oHouseDoor);
	if(HouseDoorInst != noone){
		if(State != LinkState.AutoMove && vy < 0){
			
			House_DoorInst = HouseDoorInst; //keep the inst for later
		
			DoorPassage = House_DoorInst.PassageArea;
		
			if(House_DoorInst.image_index != 2){
				House_DoorInst.image_index = 2;
				audio_play_sound(Sound_DoorOpen, 1, false);
			}
		
			Link_SetAutoMove(0, -1, 0.4);
			//House_DoorInst.alarm[0] = 70;
			//House_DoorInst.Warp = true;
			House_RoomIndex = House_DoorInst.House_RoomIndex;
			House_OldRoomIndex = global.CurrentRoomIndex;
			House_X = House_DoorInst.House_X;
			House_Y = House_DoorInst.House_Y;
			House_Entering = true;
			
			Music_Play(global.Level.Rooms[House_RoomIndex].RoomSongIndex);
		
			oRender.FadeOut();
		}

	}
	
	//Check for Castle Wall doors
	var CastleWallDoorInst = instance_place(x, y + 6, oCastleWallDoor);
	if(CastleWallDoorInst != noone){
		if(State != LinkState.AutoMove && vy < 0){
		
			DoorPassage = CastleWallDoorInst.PassageArea;
		
			if(y <= CastleWallDoorInst.y + 16){
				Link_SetAutoMove(0, -1, 0.4);
				oMusic.Fade = true;
				oRender.FadeOut();
				Castle_Entering = true;
			}
		}

	}
}

function CheckStairs(){
	
	var OnStairs = NONE;
	if(vy != 0){ //TOP && BOTTOM
		if(CollideTileBlock(global.TMID_Walls_Lower, x, y, 54, LevelTilesY + 2, 2, 4)) OnStairs = TOP;
		if(CollideTileBlock(global.TMID_Walls_Lower, x, y, 56, LevelTilesY + 2, 2, 4)) OnStairs = BOTTOM;
	}
	
	if(StairsAutoMove){
	
		var LampDimInc = (1 - LampDimMin) / 55;
		switch(StairsFloorLevelDir){
			case UPPER:
				LampDim += LampDimInc;
				if(LampDim > 1) LampDim = 1;
				break;
			case LOWER:
				LampDim -= LampDimInc;
				if(LampDim < LampDimMin) LampDim = LampDimMin;
				break;
		}
		
		if(OnStairs == NONE){
		
			StairsAutoMove = false;
			AutoMoveDirX = 0;
			AutoMoveDirY = sign(vy);
			AutoMoveSpeed = WalkSpeed;
			if(vy > 0) AutoMoveFrames = 9;
			if(vy < 0) AutoMoveFrames = 2;
			if(vy == 0) AutoMoveFrames = 6;
			UpdateState(LinkState.AutoMove);
			
			//if we're on floor 1 and there's not an upper floor after stairs, we went down(switched to 1 earlier), so switch to FloorLevel 0 now
			if(FloorLevel == 1 && tilemap_get_at_pixel(global.TMID_Floor_Upper, x, y) == 0) FloorLevel = 0;
		
			global.Paused = false;
		
		}
	}else{
		
		if(OnStairs != NONE){
			
			Link_SetAutoMove (0, sign(vy), StairSpeed);
			
			StairsAutoMove = true;
			MoveAssist = false;
		
			//always switch to level 1 first thing if starting from lovel 0 to prevent top floors from covering head before reaching top
			if(FloorLevel == 0)	FloorLevel = 1;	
		

			if( (OnStairs == TOP && Facing == UP) || (OnStairs == BOTTOM && Facing == DOWN)){
				//Going Up
				StairsFloorLevelDir = UPPER;
				audio_play_sound(Sound_StairsUp, 1, false)
			}else if( (OnStairs == TOP && Facing == DOWN) || (OnStairs == BOTTOM && Facing == UP)){
				//Going Down
				StairsFloorLevelDir = LOWER;
				audio_play_sound(Sound_StairsDown, 1, false);
			}
		
			global.Paused = true;

		
		}
		
	}		
	
}

function Link_SetAutoMove (_DirX, _DirY, _Speed, _Frames = -1){

	AutoMoveDirX = _DirX;
	AutoMoveDirY = _DirY;
	AutoMoveSpeed = _Speed;	
	AutoMoveFrames = _Frames; //-1 = infinite

	if(AutoMoveDirX < 0) Facing = LEFT;
	if(AutoMoveDirX > 0) Facing = RIGHT;
	if(AutoMoveDirY < 0) Facing = UP;
	if(AutoMoveDirY > 0) Facing = DOWN; 
	
	UpdateState(LinkState.AutoMove);			
	
}

function CheckMovingFloor(){
	
	var CheckPosX = x;
	var CheckPosY = y;

	var CheckPosAheadX = CheckPosX;
	var CheckPosAheadY = CheckPosY;
	//This is so we check a bit further for the edge of the moving floor based on where we're pointing so we can stop just before the edge
	if(Facing == LEFT) CheckPosAheadX -= 8; 
	if(Facing == RIGHT) CheckPosAheadX += 8;
	if(Facing == UP) CheckPosAheadY -= 8;
	if(Facing == DOWN) CheckPosAheadY += 8;
	
	
	//To-fix: no longer using hole edge objects, so make function to check for hole edge tiles
	
	//var MovingFloorInst = instance_position(CheckPosX, CheckPosY, oMovingFloor);
	//if(MovingFloorInst != noone){
	//	var MovingFloorAheadInst = instance_position(CheckPosAheadX, CheckPosAheadY, oMovingFloor);
	//	var HoleEdgeAheadInst = instance_position(CheckPosAheadX, CheckPosAheadY, oHoleEdge);
	//	if(MovingFloorAheadInst != noone || HoleEdgeAheadInst != noone){
	//		vx += (MovingFloorInst.DirX * 0.5);	
	//		vy += (MovingFloorInst.DirY * 0.5);
	//	}
	//}
	
}

function CheckHoles(){
	
	var HoleEdgeID = tilemap_get_at_pixel(global.TMID_Floor_Upper, x, y);
		
	switch(HoleEdgeID){
		case global.HoleTileID_TL: 
		case global.HoleTileID_ITL:
			var FallDir = 315;
			var FallPointX = 8; var FallPointY = 8;
			break;

		case global.HoleTileID_TM:
			var FallDir = 270;
			var FallPointX = 0; var FallPointY = 8;
			break;

		case global.HoleTileID_TR:
		case global.HoleTileID_ITR:
			var FallDir = 225;
			var FallPointX = -8; var FallPointY = 8;
			break;

		case global.HoleTileID_ML:
			var FallDir = 0;
			var FallPointX = 8; var FallPointY = 0;
			break;

		case global.HoleTileID_MR:
			var FallDir = 180;
			var FallPointX = -8; var FallPointY = 0;
			break;

		case global.HoleTileID_BL:
		case global.HoleTileID_IBL:
			var FallDir = 45;
			var FallPointX = 8; var FallPointY = -8;
			break;

		case global.HoleTileID_BM:
			var FallDir = 90;
			var FallPointX = 0; var FallPointY = -8;
			break;

		case global.HoleTileID_BR:
		case global.HoleTileID_IBR:
			var FallDir = 135;
			var FallPointX = -8; var FallPointY = -8;
			break;

		
		default: return false;
			
	}

	UpdateState(LinkState.FallingOverEdge);
	//calculate vx and vy based on FallPoint from HoleEdge
	//FallPointX = x + FallPointX;
	//FallPointY = y + FallPointY;
	//var Dir = point_direction(x, y, FallPointX, FallPointY);
	//var Dist = point_distance(x, y, FallPointX, FallPointY);
	var LenDirX = lengthdir_x(8, FallDir);
	var LenDirY = lengthdir_y(8, FallDir);
	var time = 10;
	vx = LenDirX / time;
	vy = LenDirY / time;
	FallOverEdgeDelay = time;
		
	return true;

}

function LinkBounceBack(_BounceDir, _Speed, _Time, _VZ, _Sound = true){
	
	BounceBack = true;
	vx = lengthdir_x(_Speed, _BounceDir);
	vy = lengthdir_y(_Speed, _BounceDir);
	vz = _VZ;
	alarm[2] = _Time;
	if(_Sound && !audio_is_playing(Sound_Bounce)) audio_play_sound(Sound_Bounce, 1, false);
	
}

function CheckEnemies(){

	HitBox.x = x + vx;
	HitBox.y = y + vy;
		
	var Inst = noone;
		
	with(HitBox){
		var Inst = instance_place(x, y, oEnemy);
	}
	if(Inst != noone){
		if(Inst.CanHurtLink && (Inst.FloorLevel == FloorLevel || Inst.FloorLevel == UPPERLOWER) && Inst.State != EnemyState.KnockBack && Inst.State != EnemyState.Idle && Inst.State != EnemyState.Wake && Inst.State != EnemyState.Sleep && Inst.State != EnemyState.Stunned && Inst.State != EnemyState.Frozen && Inst.State != EnemyState.OnFire && Inst.State != EnemyState.StopWatch){
			switch(Inst.object_index){
				case oEnemy_RollingSpike:
						
					LinkHit(point_direction(Inst.x, Inst.y, Inst.x + Inst.vx, Inst.y + Inst.vy), 1.25, 12, 1, Inst.Attack);
					break;
				default:
					LinkHit(point_direction(Inst.x, Inst.y, x, y), 1.25, 12, 1, Inst.Attack);
					break;
			}
			exit;
		}
	}
		
	//to-do: soldier weapon should be an enemy obj instead
	//with(HitBox){
	//	var Inst = instance_place(x, y, oSoldierWeapon);
	//}
	//if(Inst != noone){
	//	if(Inst.FloorLevel == FloorLevel && Inst.SoldierInst.State != EnemyState.KnockBack && Inst.SoldierInst.State != EnemyState.Stunned && Inst.SoldierInst.State != EnemyState.Frozen && Inst.SoldierInst.State != EnemyState.OnFire){
	//		LinkHit(Inst.x, Inst.y, 1.25, 12, 1, Inst.SoldierInst.Attack);
	//		exit;
	//	}
	//}
				

	var Inst = instance_place(x, y, oProjectile);
	if(Inst != noone){
		if(Inst.Enemy && Inst.FloorLevel == FloorLevel){
			LinkHit(point_direction(Inst.x, Inst.y, x, y), 1.25, 12, 1, Inst.Damage); //to-do: attack value should be different depending on projectile type
			exit;
		}
	}
		

}

function LinkHit(_Dir, _Speed, _Time, _VZ, _MaxAttackPoints){
	
	if(State == LinkState.Hit || Invincible) exit;
	
	var _Damage = Enemy_Attack(_MaxAttackPoints);
	
	HealthAdd(-_Damage);
	
	if(Health <= 0){
		UpdateState(LinkState.Dead);
	}else{
		UpdateState(LinkState.Hit);
		LinkBounceBack(_Dir, _Speed, _Time, _VZ, false);	
	}
	
}

function CheckSpikes(){
	
	if(Pendant_Check(Pendant.Protection)) exit;
	
	var SpikeBlockInst = instance_place(x + vx, y + vy, oSpikeBlock);
	if(SpikeBlockInst != noone){
		LinkHit(point_direction(SpikeBlockInst.x, SpikeBlockInst.y, x, y), CarryingSpeed, 12, 1, 0.75);
		exit;
	}
		
	if(tilemap_get_at_pixel(GetFloorLevelTMID("Tiles_Floor", x, y), x, y) == global.SpikeTileID){
		LinkHit(-0, 0, 1, 0, 0.75);
	}	
	
}

function CheckItems(){
	
	if(instance_exists(oInventory)) exit;
	
	FlashInventoryFull = false;
	
	ObjCollision_List(CollidedObjList, x, y, oItem);

	for(var i = 0; i < ds_list_size(CollidedObjList); i++){
		var ItemInst = CollidedObjList[| i];
			
		if((!ItemInst.Spawning || ItemInst.Get_Allowed) && !ItemInst.Dropped && !ItemInst.ShopItem && ItemInst.Get_WhenLinkCollides){
			switch(ItemInst.object_index){
				
				default:
					var ItemGot = ItemGet(ItemInst);
					if(!ItemGot) FlashInventoryFull = true;

					break;

				case oItem_Crystal:
					ItemInst.SpawnAnimation = false;
					ItemInst.SpawnAnimationFinish = true;
					Music_Stop();
					audio_play_sound(Music_Boss_Defeated, 1, false);
					HoldUpItem(ItemInst, false, false, false, false);		
					break;
			}
			
		}
	}

}

function CheckSpecialItems(){

	//1st level Entrance Wall
	if(global.Level.Index <= DungeonLevel.Castle){
		if(AllowCastleEntranceWallCollide){
			var EntranceWallInst = instance_position(x, y + 4, Castle_EntranceWallInst);
			if(EntranceWallInst != noone){
				AllowCastleEntranceWallCollide = false;
				MsgBox("Where are you going? The action is the other way!");
			}
		}else{
			if(!instance_position(x, y + 4, Castle_EntranceWallInst)) AllowCastleEntranceWallCollide = true;
		
		}
	}
	
	if(global.CurrentRoomIndex == -1) exit;
	
	//Store
	if(oLink.Facing == UP){
		var WallInst = instance_place(x, y - 6, oWall);
		if(WallInst != noone && WallInst.BlockLink){
			var ShopInst = WallInst.ShopInst;
			if(AllowShopItemLook && ShopInst != noone){
				//we have to check all items in front of shop and make sure they are FromShop, since other dropped items may be sitting in front also.
				ds_list_clear(CollidedShopItemList);
				var _ShopItems = collision_rectangle_list(x - 4, y - 30, x + 4, y - 16, oItem, false, true, CollidedShopItemList, false);
				for(var i = 0; i < _ShopItems; i++){
					ShopItemLook = CollidedShopItemList[| i];
					if(ShopItemLook != noone){
						if(ShopItemLook.From == ItemFrom.Shop){
							ShopInst.DB_Init = true;					
							AllowShopItemLook = false;
							break;
						}
					}
				}
			}
		}else AllowShopItemLook = true;
	
	}else AllowShopItemLook = true;



	//HeartGuy
	switch(Facing){
		case LEFT: var HeartGuyInst = instance_position(bbox_left - 5, y - 6, oHeartGuy); break
		case RIGHT: var HeartGuyInst = instance_position(bbox_right + 5, y - 6, oHeartGuy); break
		case UP: var HeartGuyInst = instance_position(x, bbox_top - 3, oHeartGuy); break;
		case DOWN: var HeartGuyInst = instance_position(x, bbox_bottom + 3, oHeartGuy); break
	}
	
	if(HeartGuyInst != noone){
		if(AllowHeartGuy){
			HeartGuyInst.DB_Init = true;
			AllowHeartGuy = false;
		}
	}else AllowHeartGuy = true;


	//Dead Guy
	switch(Facing){
		case LEFT: var DeadGuyInst = instance_position(bbox_left - 5, y - 6, oDeadGuy); break
		case RIGHT: var DeadGuyInst = instance_position(bbox_right + 5, y - 6, oDeadGuy); break
		case UP: var DeadGuyInst = instance_position(x, bbox_top - 3, oDeadGuy); break;
		case DOWN: var DeadGuyInst = instance_position(x, bbox_bottom + 3, oDeadGuy); break
	}
	
	if(DeadGuyInst != noone){
		if(AllowDeadGuy){
			DeadGuyInst.DB_Init = true;
			AllowDeadGuy = false;
		}
	}else AllowDeadGuy = true;
	
	
	//PopMachine
	if(global.Level.Rooms[global.CurrentRoomIndex].Name == "Arcade"){
		if(oLink.Facing == UP){
			var PopMachineInst = instance_position(x, bbox_top + 6, oPopMachine);
			if(PopMachineInst != noone){
				if(AllowPopMachine){
					PopMachineInst.DB_Init = true;
					AllowPopMachine = false;
				}
			}else AllowPopMachine = true;
		}
	}
	
	
	//Fairy_Health
	if(global.Level.Rooms[global.CurrentRoomIndex].Name == "Fairy"){
		var FairyInst = collision_circle(x, y, 50, oFairy_Health, false, true);

		if(FairyInst != noone){
			if(AllowFairy){
				FairyInst.DB_Init = true;
				AllowFairy = false;
			}
		}else AllowFairy = true;
	}
	
	
	//Kinstones
	if(Facing == DOWN){
		
		var KinstoneInst = instance_position(x, bbox_bottom - 9, oItem_Kinstone_Main); 

		if(KinstoneInst != noone){
			if(AllowKinstone){
				KinstoneInst.DB_Init = true;
				AllowKinstone = false;
			}
		}else AllowKinstone = true;
	
	}


	//Prisoners
	if(global.Level.Index == DungeonLevel.CastleJails){
		if(Facing == UP){
			
			var PrisonerInst = collision_rectangle(x - 20, y - 48, x + 20, y, oPrisoner, false, true);
			if(PrisonerInst != noone && AllowPrisoner){
				PrisonerInst.DB_Init = true;
				AllowPrisoner = false;				
			}			
		
		}else AllowPrisoner = true;
	}
	
	//Floor Switches
	var SwitchInst = instance_position(x, y - 2, oFloorSwitch);
	if(SwitchInst != noone && SwitchInst.FloorLevel == FloorLevel){
		SwitchInst.Activated = true;
	}
	
	//Warps
	var WarpInst = instance_position(x, y - 4, oWarp);
	if(WarpInst != noone && WarpInst.FloorLevel == FloorLevel){
		
		Warp_RoomIndex_From = global.CurrentRoomIndex;
		Warp_RoomIndex_To = WarpInst.DestRoomIndex;
		
		Mosaic(MosaicType.Warp);		
		
		Dungeon_RoomActivate(Warp_RoomIndex_To);
		
		audio_play_sound(Sound_Warp, 1, false);
		
	}

}

function UnlockDoor(DoorInst){
	
	DoorInst.Unlock = true;
	
	if(global.Level.Index == DungeonLevel.Village){
		Inventory_DeleteObj(oItem_Key_Special);
	}else{
		if(!global.ItemData[oItem_Key_Master].Owns[0]) KeyAdd(-1); //only subtract a key if you don't own the master key
	}	
	
	audio_play_sound(Sound_DoorUnlock, 1, false);	
}

function FixV(){
	//This alligns Link after the stairs and during move assist a bit better
	vx = vx - (frac(x + vx) * sign(vx));
	vy = vy - (frac(y + vy) * sign(vy));	
}

function UpdateCarryItem(){

	if(!instance_exists(ItemHolding) || State == LinkState.PickUp) exit;
	
	ItemHolding.x = x;
	var NewY = y - 18 + (vx != 0 || vy != 0 ? floor(image_index mod 3) : 0); //if moving, make the item go up and down relative to link's head	
	
	switch(ItemHolding.id){
		case oEnemy_Chicken:
			ObjSetY(NewY);
			break;
		default:
			ItemHolding.y = NewY; 
			break;
	}
	

}

function Do_Item(_InvItem){
	
	if(_InvItem == -1) exit;
	
	var _ObjectIndex = global.Inventory[_InvItem][0];
	var _ItemIndex = global.Inventory[_InvItem][1];
	
	switch(_ObjectIndex){
		
		case oItem_Bow: 
			if(Arrows > 0){
				UpdateState(LinkState.Bow);
				if(instance_exists(oSword)) instance_destroy(oSword);
			}else{
				audio_play_sound(Sound_Error, 1, false);
			}	
			break;
			
		case oItem_Boomerang: 
			if(!instance_exists(oBoomerang)){

				UpdateState(LinkState.Boomerang);
				if(instance_exists(oSword)) instance_destroy(oSword);
				instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oBoomerang);

			}		
			break;
			
		case oItem_Hookshot: 
			
			UpdateState(LinkState.Hookshot);
			if(instance_exists(oSword)) instance_destroy(oSword);
			instance_create_layer(x, y - 5, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oHookshot);
		
			break;
		
		case oItem_Rod: 
			
			if(MagicUse(floor(MagicMax / 12))){
				UpdateState(LinkState.Rod);
				if(instance_exists(oSword)) instance_destroy(oSword);
				RodIndex = _ItemIndex;
				var inst = instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), RodBeamObj[RodIndex]);
				Rod_InitPos(inst);
				audio_play_sound(Sound_Rod, 1, false);
			}
			break;
		
		case oItem_Powder:
			if(MagicUse(floor(MagicMax / 16))){
				UpdateState(LinkState.Powder);
				if(instance_exists(oSword)) instance_destroy(oSword);
				var FloorLevelStr = GetFloorLevelString(FloorLevel);
				switch(Facing){
					case LEFT: 
						var PowderInst = instance_create_layer(x - 12, y - 6, "ObjsHigher_" + FloorLevelStr, oPowder);
						PowderInst.sprite_index = sPowder_Left;
						 break;
					case RIGHT: 
						var PowderInst = instance_create_layer(x + 12, y - 6, "ObjsHigher_" + FloorLevelStr, oPowder); 
						PowderInst.sprite_index = sPowder_Right;
						break;
					case UP: 
						var PowderInst = instance_create_layer(x, y - 29, "ObjsHigher_" + FloorLevelStr, oPowder); 
						PowderInst.sprite_index = sPowder_Up;
						break;
					case DOWN: 
						var PowderInst = instance_create_layer(x, y + 2, "ObjsHigher_" + FloorLevelStr, oPowder); 
						PowderInst.sprite_index = sPowder_Down;
						break;
				}
				audio_play_sound(Sound_Powder, 1, false);
				audio_play_sound(Sound_FairySprinkle, 1, false);
			}
			break;
			
		case oItem_Bombs:
			if(instance_exists(oSword)) instance_destroy(oSword);
			var FloorLevelStr = GetFloorLevelString(FloorLevel);
			switch(Facing){
				case LEFT: var BombInst = instance_create_layer(x - 14, y, "Objs_" + FloorLevelStr, oBomb); break;
				case RIGHT: var BombInst = instance_create_layer(x + 14, y, "Objs_" + FloorLevelStr, oBomb); break;
				case UP: var BombInst = instance_create_layer(x, y - 12, "Objs_" + FloorLevelStr, oBomb); break;
				case DOWN: var BombInst = instance_create_layer(x, y + 12, "Objs_" + FloorLevelStr, oBomb); break;
			}
			BombsAdd(-1);
			break;

		case oItem_Medallion:
			
			if(MagicUse(floor(MagicMax / 4))){
				
				instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oMedallion);
				
			}

			break;
		
		case oItem_Cape:
			if(Cape){
				instance_destroy(oCape);
			}else{
				if(Magic < 1){
					audio_play_sound(Sound_Error, 1, false);
					break;
				}
				if(instance_exists(oSword)) instance_destroy(oSword);
				instance_create_layer(x, y, "ObjsHigher_Upper", oCape);
			}
			break;
			
		default: 
			if(Item_CanUse(_ObjectIndex, _ItemIndex)){
				ItemUse(_ObjectIndex, _ItemIndex);
				Inventory_DeleteSlot(_InvItem);
			}else audio_play_sound(Sound_Error, 1, false);
			break;
			
		
	}
	
}

function Interact(){
	
	if(ItemHolding != noone){
		
		UpdateState(LinkState.Throwing);

	}else{

		//Treasure Small
		var TreasureInst = instance_position(x, bbox_top - 3, oItem_Treasure); 
		if(TreasureInst != noone && Facing == UP && !TreasureInst.Opened && TreasureInst.visible && TreasureInst.sprite_index != sItem_TreasureBlock){
			UpdateState(LinkState.TreasureOpening);
			Treasure_Open(TreasureInst);
			exit;		
		}	

		//Treasure Large
		var TreasureInst = instance_position(x, bbox_top - 3, oTreasureLarge); 
		if(TreasureInst != noone && Facing == UP && !TreasureInst.Opened && TreasureInst.visible){
			UpdateState(LinkState.TreasureOpening);
			TreasureLarge_Open(TreasureInst);
			exit;		
		}	
		
		//Pickup Item
		switch(Facing){
			case LEFT: var Inst = instance_place(bbox_left, y, oPickupObj); break
			case RIGHT: var Inst = instance_place(bbox_right, y, oPickupObj); break
			case UP: var Inst = instance_place(x, bbox_top + 9, oPickupObj); break
			case DOWN: var Inst = instance_place(x, bbox_bottom + 2, oPickupObj); break
		}
		if(Inst != noone){
			PickupItem(Inst);
			exit;
		}	

		
		//Light Torch
		if(!instance_exists(oLampFlame)){
			var Inst = noone;
			switch(Facing){
				case LEFT: var Inst = instance_place(bbox_left, y, oTorch); break;
				case RIGHT: var Inst = instance_place(bbox_right, y, oTorch); break;
				case UP: var Inst = instance_place(x, bbox_top + 9, oTorch); break;
				case DOWN: var Inst = instance_place(x, bbox_bottom + 2, oTorch); break;
			}
			if(Inst != noone) Inst.Lighting = true;
		}

		if(global.Level.Index == DungeonLevel.Village){
		
			//Old Lady NPC
			//if(AllowOldLadyNPC){
			//	if(Facing == LEFT){
			//		var OldLadyInst = instance_position(bbox_left - 9, y - 6, oNPC_OldLady); 
			//		if(OldLadyInst != noone){
			//			OldLadyInst.Wake_Init = true;
			//			global.Paused = true;
			//			UpdateState(LinkState.Idle);
			//			AllowOldLadyNPC = false;
			//		}
			//	}
			//}

			//Simple NPC
		
			switch(Facing){
				case LEFT: var NPCInst = instance_position(bbox_left - 5, y - 6, oNPC); break
				case RIGHT: var NPCInst = instance_position(bbox_right + 5, y - 6, oNPC); break
				case UP: var NPCInst = instance_position(x, bbox_top - 5, oNPC); break;
				case DOWN: var NPCInst = instance_position(x, bbox_bottom + 5, oNPC); break
			}

			if(NPCInst != noone)NPCInst.DB_Init = true;

			switch(Facing){
				case LEFT: var Inst = instance_place(bbox_left, y, oEnemy_Chicken); break
				case RIGHT: var Inst = instance_place(bbox_right, y, oEnemy_Chicken); break
				case UP: var Inst = instance_place(x, bbox_top - 5, oEnemy_Chicken); break
				case DOWN: var Inst = instance_place(x, bbox_bottom + 2, oEnemy_Chicken); break
			}
			if(Inst != noone){
				PickupItem(Inst);
				exit;
			}	

			switch(Facing){
				case UP: var Inst = instance_place(x, bbox_top - 32, oVillager_Sitting_ChessPlayer); break
			}
			if(Inst != noone){
				Inst.OfferGame = true;
				exit;
			}	
			
		}

		//Sign
		if(Facing == UP){
			var SignInst = instance_position(x, bbox_top - 3, oSign); 
			if(SignInst != noone) SignInst.DB_Init = true;	
		}
	
	}	
}

function PickupItem(_Inst){
	
	UpdateState(LinkState.PickUp);
	ItemHolding = _Inst;
	ItemHolding.layer = layer_get_id("ObjsHigher_" + GetFloorLevelString(FloorLevel));
	switch(_Inst.object_index){
		case oPot:
			instance_destroy(_Inst.WallObj);
			if(_Inst.ContentsObj != noone) ItemSpawn(_Inst.ContentsObj, _Inst.x, _Inst.y, ItemFrom.Pot, ItemSpawnType.DropShort, FloorLevel);					
			break;
		
		case oBush:
			instance_destroy(_Inst.WallObj);
			if(_Inst.ContentsObj != noone) ItemSpawn(_Inst.ContentsObj, _Inst.x, _Inst.y, ItemFrom.Pot, ItemSpawnType.DropShort, FloorLevel);					
			break;
			
		case oEnemy_Chicken:
			with(_Inst){
				PickedUp = true;
				vx = 0;
				vy = 0;
				Chicken_SetScared();
			}
			break;
	}

	audio_play_sound(Sound_Pickup, 1, false);	
}

function HoldUpItem(_Inst, _UpdateTreasureLimiter = true, _From = ItemFrom.Treasure, _PlayFanfare = true, _Alarm = true){

	with(oLink){
		UpdateState(LinkState.HoldingItem);
		ItemHolding = _Inst
		ItemHolding.From = _From;	
		ItemHolding.FloorLevel = UPPER;
		ItemHolding.ShowShadow = false;
		ItemHolding.ShowPrice = false;
		ItemHolding.Get_Sound = noone;
		ItemHolding.Lighting = false;
		ItemHolding.x = x + 6;
		ItemHolding.y = y - 19;
		if(_UpdateTreasureLimiter) TreasureLimiter_Update(_Inst.object_index);
		if(_Alarm) alarm[0] = 92; //how long for the obj to disappear from Link's hands. 92 since that's how long items from treasures spawn so it has to be the same
	}
	
	if(_PlayFanfare) audio_play_sound(Sound_ItemGetFanfare, 1, false);
	
}

function ATTACK(){
	
	//returns total attack points after factoring all conditions
	
	var SwordPoints = global.ItemData[oItem_Sword].Index + 1;
	var GlovePoints = global.ItemData[oItem_Gloves].Index; 
	
	var AttackPoints = (SwordPoints + GlovePoints);
	
	if(Curse_Check(CurseEffects.AttackReduced)) AttackPoints = ceil(AttackPoints / 2);
	
	return AttackPoints;
	
}
	
function DEFENSE(){
	
	//return total defense points after factoring all conditions
	
	var TunicPoints = global.ItemData[oItem_Tunic].Index;
	var ShieldPoints = global.ItemData[oItem_Shield].Index + 1;
	var GlovePoints = global.ItemData[oItem_Gloves].Index >= 0 ? 1 : 0; 
		
	var DefensePoints = TunicPoints + ShieldPoints + GlovePoints;
	
	if(Curse_Check(CurseEffects.DefenseReduced)) DefensePoints = ceil(DefensePoints / 2);
	
	return DefensePoints;
	
}

function Link_UpdateAttackDefence(){
	oLink.AttackPoints = ATTACK();
	oLink.DefensePoints = DEFENSE();	
}

function HealthAdd(Amount){
	
	if(Amount > 0){	
		if(Curse_Check(CurseEffects.HealthNoValue)) exit;
		if(Pendant_Check(Pendant.Health)) Amount *= 1.25;
	}
	
	var OriginalAmount = Amount; //Before modifying it, remember the original amount since will add to oHUD only if the original amount is higher than 1
	
	if(oLink.Health + Amount > oLink.HealthMax) Amount = oLink.HealthMax - oLink.Health; //make Amount the exact amount that will be added to HUD
	
	oLink.Health = max(0, oLink.Health + Amount);	
	
	if(OriginalAmount > 1) oHUD.AddHealth = Amount;	
	
	if(oLink.Health < 2){
		if(!audio_is_playing(oLink.LowHealthSound)) oLink.LowHealthSound = audio_play_sound(Sound_LowHealth_Minimal, 1, true);
	}else audio_stop_sound(oLink.LowHealthSound);
		
}

function MagicAdd(Amount){

	if(Curse_Check(CurseEffects.MagicNoValue)) exit;
	
	if(oLink.Magic + Amount > oLink.MagicMax) Amount = oLink.MagicMax - oLink.Magic; //make Amount the exact amount that will be added to HUD
	
	oLink.Magic += Amount;
	
	oHUD.AddMagic += Amount;

}

function MagicUse(Amount, SoundOnEmpty = true){
	
	if(Pendant_Check(Pendant.Magic)) Amount *= 0.5;
	if(Curse_Check(CurseEffects.MagicUsesDouble)) Amount *= 2;	
	
	if(Amount > oLink.Magic){
		if(SoundOnEmpty) audio_play_sound(Sound_Error, 1, false);
		return false;
	}else{
		oLink.Magic -= Amount;
		return true;
	}
	
	
	
}

function HeartPieceAdd(){
	
	if(oLink.HealthMax == MaxHearts) exit; //fail safe, don't do anything if for some reason you get an extra heart but you're already at max. This shouldn't happen, but still
	
	oLink.HealthMax++;
	if(oLink.HealthMax >= MaxHearts){
		oLink.HealthMax = MaxHearts;
	}
	HealthAdd(oLink.HealthMax);
}

function RupeesAdd(Amount){	
	
	oLink.Rupees += Amount;

	if(oLink.Rupees <= 0){
		oLink.Rupees = 0;
		oHUD.AddRupees = 0;
		oHUD.AddRupeesCount = 0;
	}
	
}

function KeyAdd(Amount){
	oLink.Keys+=Amount;
	if(oLink.Keys > oLink.MaxKeys) oLink.Keys = oLink.MaxKeys;
	if(oLink.Keys <= 0) oLink.Keys = 0;
	
}

function ArrowsAdd(Amount){

	oLink.Arrows += Amount;
	
	var _MaxArrows = Inventory_MaxArrows();
	if(oLink.Arrows > _MaxArrows) oLink.Arrows = _MaxArrows;
	
	if(oLink.Arrows <= 0){
		oLink.Arrows = 0;
		Inventory_DeleteObj(oItem_Arrows);
	}
	
}

function BombsAdd(Amount){
	
	oLink.Bombs += Amount;
	
	var _MaxBombs = Inventory_MaxBombs();
	if(oLink.Bombs > _MaxBombs) oLink.Bombs = _MaxBombs;
	
	if(oLink.Bombs <= 0){
		oLink.Bombs = 0;
		Inventory_DeleteObj(oItem_Bombs);
	}
	
}

function InFrontOfLink(_x, _y){
	
	switch(oLink.Facing){
		case UP:
			if(_y <= oLink.y) return true; 
			break;
		case DOWN:  
			if(_y >= oLink.y) return true;
			break; 
		case LEFT:  
			if(_x <= oLink.x) return true;
			break;
		case RIGHT: 
			if(_x >= oLink.x) return true;
			break; 		
	}
	return false;
}

function GetLinkWeaponIndex(_ObjIndex){
	switch(_ObjIndex){
		case oSword: return LinkWeapon.Sword;
		case oPot_Thrown: return LinkWeapon.Pot;
		case oArrow: return LinkWeapon.Arrow;
		case oBoomerang: return LinkWeapon.Boomerang;
		case oBombExplosion: return LinkWeapon.Bomb;
		case oHookshot: return LinkWeapon.Hookshot;
		case oFireRodBeam: 
		case oFireTower: 
			return LinkWeapon.Fire;
		case oIceRodBeam: 
		case oIceTower: 
			return LinkWeapon.Ice;
		case oSwordBeam: return LinkWeapon.SwordBeam;
		//case oMagic: return LinkWeapon.Magic;
		
	}
	
}

function GetStateName(State){ //temp, only used for debug text in Render obj
	switch(State){
		case LinkState.Idle: return "Idle";	
		case LinkState.Standing: return "Standing";	
		case LinkState.Walking: return "Walking";	
		case LinkState.Hit: return "Hit";	
		case LinkState.AutoMove: return "AutoMove";	
		case LinkState.Sword: return "Sword";	
		case LinkState.Bow: return "Bow";	
		case LinkState.PickUp: return "PickUp";	
		case LinkState.TreasureOpening: return "TreasureOpening";	
		case LinkState.HoldingItem: return "HoldingItem";	
		case LinkState.Throwing: return "Throwing";	
		case LinkState.Pushing: return "Pushing";	
		case LinkState.Boomerang: return "Boomerang";	
		case LinkState.Hookshot: return "Hookshot";	
		case LinkState.Rod: return "Rod";	
		case LinkState.Powder: return "Powder";	
		case LinkState.Shocked: return "Shocked";
		case LinkState.Warping: return "Warping";
		case LinkState.Falling: return "Falling";	
		case LinkState.FallingOverEdge: return "FallingOverEdge";	
		case LinkState.Descending: return "Descending";	
		case LinkState.Inventory: return "Inventory";
		case LinkState.Dialogue: return "Dialogue";
		case LinkState.VideoGame: return "VideoGame";	
	}

}

