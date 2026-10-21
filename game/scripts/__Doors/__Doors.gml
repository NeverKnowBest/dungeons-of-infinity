enum DoorStatus{
	Open,
	Closed,
	Locked,
	Entrance,
	Exit,
	MainEntrance,
	ClosedHalf,
	LockedHalf,
	Secret_Closed,
	Secret_Open,
	Curtain,
	Unused
}

enum SecretDoor{
	Crack,
	Blank,
	Illusion	
}

enum OpenDoorSprite{
	LightCurrentLightNext,
	LightCurrentDarkNext,
	DarkCurrentLightNext,
	DarkCurrentDarkNext
}


function Dungeon_CreateDoors(_RoomIndex){

	if(global.Level.Index == DungeonLevel.Start) exit;
	
	
	//To draw sprite of all doors for oMapRoom
	var DoorsSprSurface = surface_create(Room.width / 8, Room.height / 8);
	surface_set_target(DoorsSprSurface);
	draw_clear_alpha(c_black, 0);
	
	for(var DoorIndex = 0; DoorIndex < Room.DoorCount; DoorIndex++){
		
		//var DungeonDoor = DungeonRoom.Doors[DoorIndex];
		var _Door = Room.Doors[DoorIndex];
		
		if(_Door.Status == DoorStatus.Unused){
			continue;
		}
		
		var TLCornerX = Room.x + _Door.x;
		var TLCornerY = Room.y + _Door.y;

		var FloorLevelStr = GetFloorLevelString(_Door.Level);
		
		var _DoorInst = instance_create_layer(TLCornerX, TLCornerY, "ObjsDoors_" + FloorLevelStr, oDoor);
		_DoorInst.RoomIndex = _RoomIndex;
		_DoorInst.FloorLevel = _Door.Level;		
		_DoorInst.Location = _Door.Location;
		_DoorInst.Position = _Door.Position;
		_DoorInst.Status = _Door.Status;
		
		
		if(_DoorInst.Status == DoorStatus.Entrance) _DoorInst.Entrance = true;
		_DoorInst.ConnectedRoomIndex = _Door.ConnectedRoomIndex;
		

		if(_DoorInst.Status == DoorStatus.Secret_Closed){
			
			_DoorInst.SecretType = -1;
			
			//Secret door types for specific cases/levels
			switch(global.Level.Index){
				
				case DungeonLevel.Castle:
					_DoorInst.SecretType = SecretDoor.Crack;
					break;
				
				case DungeonLevel.Sewers:
					if(	TemplateCheck(_DoorInst.ConnectedRoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "TMNT") || 
						TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "TMNT")){
							_DoorInst.SecretType = SecretDoor.Crack;
						}
					break;
				
				case DungeonLevel.Village:
				case DungeonLevel.Mines:
					_DoorInst.SecretType = SecretDoor.Blank;
					break;

					
			}

			if(_DoorInst.SecretType == -1){
				
				if(TemplateCheck(_DoorInst.ConnectedRoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.TreasureLarge) || 
					TemplateCheck(_RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.TreasureLarge)){
						_DoorInst.SecretType = choose(SecretDoor.Blank, SecretDoor.Illusion);
				}else{
					_DoorInst.SecretType = Prob(Chance_SecretDoorCrack) ? SecretDoor.Crack : choose(SecretDoor.Blank, SecretDoor.Illusion);
				}
				
			}
			
		}
		
		if(global.Level.Index == DungeonLevel.Mines){
			if(	global.MainTemplates_Mine[Room.GridY][Room.GridX] == 1 || global.MainTemplates_Mine[Room.GridY][Room.GridX] >= 7){
				_DoorInst.Status = DoorStatus.Secret_Closed;
				_DoorInst.SecretType = SecretDoor.Blank;
			}
		}
		
		//If we're on a boss level, make the inside doors of the boss Room closed. Otherwise, the outside doors of the boss Room are turned into stairwells, bypassing the boss Room
		if(global.Level.IsBossLevel && _RoomIndex == global.Level.RoomIndex_Boss){
			_DoorInst.Status = DoorStatus.Closed; //close all doors if we're in the boss Room
		}	
		
		if(_DoorInst.Status == DoorStatus.Locked || _DoorInst.Status == DoorStatus.Exit) ds_list_add(global.LargeMapItems, _DoorInst); //certain doors to large map items so we can draw the icon if Link has a compass

		//Clear walls for pathway

		if(_DoorInst.FloorLevel == UPPER){
			//var TMID_Floors_Common = global.TMID2_Upper;
			var TMID_Walls = global.TMID_Walls_Upper;	
			var TMID_Decor = global.TMID_Decor_Upper;
		}else{
			//var TMID_Floors_Common = global.TMID2_Lower;
			var TMID_Walls = global.TMID_Walls_Lower;
			var TMID_Decor = global.TMID_Decor_Lower;
		}

		switch(_DoorInst.Location){
			case "Top":
				if(global.Level.Index == DungeonLevel.Aghanim2){
					//clear larger area for the large door frames
					ClearTileBlock(TMID_Walls, TLCornerX, TLCornerY - 16, 4, 5);
					//draw back ceiling on top left/right corners
					//DrawTileBlock(global.TMID_Tiles_Ceiling, TLCornerX, TLCornerY, 8, LevelTilesY + 2, 1, 1);
					//DrawTileBlock(global.TMID_Tiles_Ceiling, TLCornerX + 24, TLCornerY, 8, LevelTilesY + 2, 1, 1);
				}else
					ClearTileBlock(TMID_Walls, TLCornerX + 8, TLCornerY + 8, 2, 2);

				var WallObjInst = collision_point(TLCornerX + 4, TLCornerY + 4, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_H(WallObjInst, TLCornerX + 8, TLCornerX + 23);
				
				break;
				
			case "Bottom":	
				ClearTileBlock(TMID_Walls, TLCornerX + 8, TLCornerY, 2, 2);
				
				var WallObjInst = collision_point(TLCornerX + 4, TLCornerY + 4, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_H(WallObjInst, TLCornerX + 8, TLCornerX + 23);

				break;
		
			case "Left":
			case "Right":
				ClearTileBlock(TMID_Walls, TLCornerX + (_DoorInst.Location == "Left" ? 8 : 0), TLCornerY + 8, 2, 2);
				var WallObjInst = collision_point(TLCornerX + 4, TLCornerY + 4, oWall, false, true);
				if(WallObjInst != noone) WallObj_Cutout_V(WallObjInst, TLCornerY + 8, TLCornerY + 23);
				break;
		}
		
		Door_SetPassageArea(_DoorInst);
	
		//Place an enemy door blocker at every door to prevent enemies from going through them
		switch(_DoorInst.Location){
			case "Top":
				var WallX = TLCornerX + 8;
				var WallY = TLCornerY;
				var WallGID = _DoorInst.FloorLevel == UPPER ? TemplateObjGID.WallSideT : TemplateObjGID.WallLowerSideT;
				var ScaleX = 2;
				var ScaleY = 3;
				var Position = TOP;
				break;
				
			case "Left":
				var WallX = TLCornerX;
				var WallY = TLCornerY + 8;
				var WallGID = _DoorInst.FloorLevel == UPPER ? TemplateObjGID.WallSideL : TemplateObjGID.WallLowerSideL;
				var ScaleX = 3;
				var ScaleY = 2;
				var Position = LEFT;
				break;
			
			case "Bottom":
				var WallX = TLCornerX + 8;
				var WallY = TLCornerY;
				var WallGID = _DoorInst.FloorLevel == UPPER ? TemplateObjGID.WallSideB : TemplateObjGID.WallLowerSideB;
				var ScaleX = 2;
				var ScaleY = 3;
				var Position = BOTTOM;
				break;
			
			case "Right":
				var WallX = TLCornerX;
				var WallY = TLCornerY + 8;
				var WallGID = _DoorInst.FloorLevel == UPPER ? TemplateObjGID.WallSideR : TemplateObjGID.WallLowerSideR;
				var ScaleX = 3;
				var ScaleY = 2;
				var Position = RIGHT;
				break;
			
		}
		var inst = WallObj_Create("Objs_" + FloorLevelStr, WallX, WallY, ScaleX, ScaleY, _DoorInst.Location, WallGID);
		inst.FloorLevel = _DoorInst.FloorLevel;
		inst.BlockLink = false;
		inst.BlockLinkCarry = (_DoorInst.Status == DoorStatus.Exit);
		inst.BlockItems = true;
		inst.IsDoorEntrance = true;
		inst.Position = Position;
		_DoorInst.WallInst = inst;
		

		//Draw Map Doors onto MapRoomInst spr
		if(_DoorInst.SecretType != -1) continue; //don't draw the door on the map if it connects to a secret Room
		
		if(global.Level.Index == DungeonLevel.Mines){
			if(Room.GridX == 4 && Room.GridY == 4 && _DoorInst.Location != "Top" && _DoorInst.Location != "Right") continue; //secret doors in the mine caves entrance
			if(Room.GridX == 6 && Room.GridY == 0 && _DoorInst.Location == "Left") continue; //secret door at the entrance to the treasure map
		}
		
		var MapDoorX = (TLCornerX - Room.x) / 8;
		var MapDoorY = (TLCornerY - Room.y) / 8;
		switch(_DoorInst.Location){
			case "Top":
				var Dx = MapDoorX;	var Dy = MapDoorY - 5; var Dw = 4; var Dh = 8;
				break;
			case "Bottom":
				var Dx = MapDoorX;	var Dy = MapDoorY; var Dw = 4; var Dh = 8;
				break;
			case "Left":
				var Dx = MapDoorX - 5;	var Dy = MapDoorY; var Dw = 8; var Dh = 4;
				break;
			case "Right":
				var Dx = MapDoorX;	var Dy = MapDoorY; var Dw = 8; var Dh = 4;
				break;
		}
						
		draw_sprite_ext(sPixel, 0, Dx, Dy, Dw, Dh, 0, make_color_rgb(110,110,110), 1);
		
	}
	
	surface_reset_target();
	
	Room.MapSpr_Doors = sprite_create_from_surface(DoorsSprSurface, 0, 0, Room.MapW, Room.MapH, false, false, 0, 0);	
		
	surface_free(DoorsSprSurface);
		
			
}

function Door_DrawTiles(Inst){

	
	with(Inst){
		
		var TMID_Decor = (FloorLevel == UPPER ? global.TMID_Decor_Upper : global.TMID_Decor_Lower);
		var TMID_Walls = (FloorLevel == UPPER ? global.TMID_Walls_Upper : global.TMID_Walls_Lower);
		var TMID_Floor = (FloorLevel == UPPER ? global.TMID_Floor_Upper : global.TMID_Floor_Lower);
		var WallLevel = (FloorLevel == UPPER ? 0 : 1);
		var TilesY = global.Level.Rooms[RoomIndex].ForcedTheme != -1 && global.Level.Rooms[RoomIndex].ForcedTheme <= 11 ? 4 + (global.Level.Rooms[RoomIndex].ForcedTheme * 6) : (global.Level.Index == DungeonLevel.Aghanim2 ? LevelTilesY_Aghanim2 : LevelTilesY);
		var TMID_Beam = (FloorLevel == UPPER ? global.TMID_Tiles_Highest : global.TMID_Walls_Upper);
		
		switch(Location){
		
			case "Top":

				//draw boss Room entrance
				if(!global.SaveLevel && (global.Level.IsBossLevel && global.Level.Index != DungeonLevel.Aghanim2) && ConnectedRoomIndex == global.Level.RoomIndex_Boss){ 
					

					DrawTileBlock(TMID_Floor, x, y + 32, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x + 16, y + 32, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x, y + 48, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x + 16, y + 48, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x - 16, y + 32, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x - 16, y + 48, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x + 32, y + 32, 52, 2, 2, 2);
					DrawTileBlock(TMID_Floor, x + 32, y + 48, 52, 2, 2, 2);						

					//Skull emblem
					DrawTileBlock(TMID_Decor, x, y + 40, 52, 0, 4, 2);
						
					//add door frames
					var TileX = (global.Level.Index == DungeonLevel.CastleJails ? 40 : (global.Level.Index == DungeonLevel.LanmolasLair ? 44 : 48))
					DrawTileBlock(TMID_Decor, x - 16, y, TileX, 0, 2, 4);		
					DrawTileBlock(TMID_Decor, x + 32, y, TileX + 2, 0, 2, 4);	
						
				}
				
				if(Status != DoorStatus.Secret_Closed && Status != DoorStatus.Secret_Open){

					//Sides
					DrawTileBlock(TMID_Decor, x, y + 8, 70, TilesY, 1, 2);
					DrawTileBlock(TMID_Decor, x + 24, y + 8, 71, TilesY, 1, 2);
					
					//Door beam
					switch(Status){
						case DoorStatus.Exit:
							DrawTileBlock(TMID_Beam, x, y, 58, TilesY, 4, 1);
							break;
						default:
							if(RoomIndex == global.Level.RoomIndex_Boss){
								DrawTileBlock(TMID_Decor, x, y, 50 + (FloorLevel == LOWER ? 4 : 0), TilesY, 4, 1); //because bosses jump higher and the beams are above them. Link doesn't go through these doors anyways
							}else{
								DrawTileBlock(TMID_Beam, x, y, 50 + (FloorLevel == LOWER ? 4 : 0), TilesY, 4, 1);
							}
					}
				

				}
				
				switch(Status){
		
					case DoorStatus.Open:
					case DoorStatus.Curtain:
						if(AddTracks){ //for mine level only
							DrawTileBlock(TMID_Decor, x + 8, y + 8, 128, VillageTilesY, 2, 2); break;
						}else{
							switch(LightingFrame){
								case OpenDoorSprite.LightCurrentLightNext:
								case OpenDoorSprite.DarkCurrentLightNext:
									DrawTileBlock(TMID_Decor, x + 8, y + 8, 72, 2, 2, 2); break;
								case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 70, 0, 2, 2); break;							
								case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 74, TilesY, 2, 2); break;
							}
						}
						break;

					case DoorStatus.Closed:
						DrawTileBlock(TMID_Decor, x, y + 8, 70, TilesY + 4, 4, 2);
						break;
					
					case DoorStatus.ClosedHalf:
						DrawTileBlock(TMID_Decor, x, y + 8, 74, TilesY + 4, 4, 2);
						break;

					case DoorStatus.Locked:
						DrawTileBlock(TMID_Decor, x, y + 8, 86, TilesY, 4, 2);
						break;

					case DoorStatus.LockedHalf:
						DrawTileBlock(TMID_Decor, x, y + 8, 86, TilesY + 2, 4, 2);
						break;

					case DoorStatus.Secret_Closed:
						
						switch(Inst.SecretType){
							case SecretDoor.Crack:
						
								//Draw back wall
								DrawTileBlock(TMID_Walls, x + 8, y, 6 + (WallLevel * 17), TilesY, 2, 3); 
								
								//Crack
								DrawTileBlock(TMID_Decor, x + 8, y + 8, 94, TilesY + 4, 2, 2);
								break;
							
							case SecretDoor.Blank:
								//draw back wall
								DrawTileBlock(TMID_Walls, x + 8, y, 6 + (WallLevel * 17), TilesY, 2, 3); 
								break;
								
						}
						break;

					case DoorStatus.Secret_Open:
						
						switch(Inst.SecretType){
							case SecretDoor.Blank:
							case SecretDoor.Crack:

								ClearTileBlock(TMID_Walls, x + 8, y + 8, 2, 2);
								ClearTileBlock(TMID_Decor, x + 8, y + 8, 2, 2);
								
								switch(Inst.FloorLevel){
									case UPPER:

										//Sides
										DrawTileBlock(TMID_Decor, x, y + 8, 98, TilesY, 1, 2);
										DrawTileBlock(TMID_Decor, x + 24, y + 8, 99, TilesY, 1, 2);

										//Top
										DrawTileBlock(TMID_Beam, x, y, 62, TilesY + 4, 4, 1);

										break;
										
									case LOWER:
								
										//Sides
										DrawTileBlock(TMID_Decor, x, y + 8, 102, TilesY, 1, 2);
										DrawTileBlock(TMID_Decor, x + 24, y + 8, 103, TilesY, 1, 2);

										//Top
										DrawTileBlock(TMID_Beam, x, y, 66, TilesY + 4, 4, 1);
										
										break;
						
								}

								switch(LightingFrame){
									case OpenDoorSprite.LightCurrentLightNext:
									case OpenDoorSprite.DarkCurrentLightNext:
										DrawTileBlock(TMID_Decor, x + 8, y + 8, 72, 2, 2, 2); break;
									case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 70, 0, 2, 2); break;							
									case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 106, TilesY, 2, 2); break;
								}
								break;
							
							case SecretDoor.Illusion:
								//Draw back wall
								for(var i = 0; i < 4; i++){
									var _x = x + (i * 8);
									var _TileX =  6 + (_x mod 16 == 0 ? 1 : 0) + (WallLevel * 17);
									DrawTileBlock(TMID_Beam, _x, y, _TileX, TilesY, 1, 1); 
									DrawTileBlock(TMID_Walls, _x, y + 8, _TileX, TilesY + 1, 1, 2); 
								}
								break;
						}
						break;
						
					case DoorStatus.Exit:
						DrawTileBlock(TMID_Decor, x + 8, y + 8, 60, TilesY + 2, 2, 2);
						break;

					
				}
				
				break;
		
			case "Bottom":
				
				if(Status == DoorStatus.Entrance && global.Level.Index == DungeonLevel.Castle){
					
					//draw entrance
					
					//floor
					DrawTileBlock(TMID_Floor, x + 8, y, 63, 1, 2, 2);
					
					//Sides
					DrawTileBlock(TMID_Decor, x, y, 62, 1, 1, 2);
					DrawTileBlock(TMID_Decor, x + 24, y, 65, 1, 1, 2);
					
					//top
					DrawTileBlock(TMID_Beam, x + 8, y + 16, 9, 8, 2, 1);
					
					oLink.Castle_EntranceWallInst = WallObj_Create("Objs_Upper", x, y + 24, 4, 2);
					oLink.Castle_EntranceWallInst.IsDoorEntrance = true;
					
						
				}else{

					if(Status != DoorStatus.Secret_Closed && Status != DoorStatus.Secret_Open){
						//Door beam
						switch(Status){
							case DoorStatus.Exit:
								DrawTileBlock(TMID_Beam, x, y + 16, 58, TilesY, 4, 1);
								break;
							default:
								DrawTileBlock(TMID_Beam, x, y + 16, 50 + (FloorLevel == LOWER ? 4 : 0), TilesY + 1 , 4, 1);
						}	
				
						//Sides
						DrawTileBlock(TMID_Decor, x, y, 72, TilesY + 2, 1, 2);
						DrawTileBlock(TMID_Decor, x + 24, y, 73, TilesY + 2, 1, 2);
					}
				
					switch(Status){
		
						case DoorStatus.Open:
						case DoorStatus.Curtain:
							if(AddTracks){ //for mine level only
								DrawTileBlock(TMID_Decor, x + 8, y, 130, VillageTilesY + 2, 2, 2); break;
							}else{
								switch(LightingFrame){
									case OpenDoorSprite.LightCurrentLightNext: 
									case OpenDoorSprite.DarkCurrentLightNext:
										DrawTileBlock(TMID_Decor, x + 8, y, 70, 0, 2, 2); break;
									case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y, 72, 2, 2, 2); break;
									case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y, 76, TilesY + 2, 2, 2); break;
								}
							}
							break;

						case DoorStatus.Closed:
							DrawTileBlock(TMID_Decor, x, y, 78, TilesY + 4, 4, 2);
							break;
					
						case DoorStatus.ClosedHalf:
							DrawTileBlock(TMID_Decor, x, y, 82, TilesY + 4, 4, 2);
							break;

						case DoorStatus.Locked:
							DrawTileBlock(TMID_Decor, x, y, 86, TilesY + 4, 4, 2);
							break;

						case DoorStatus.LockedHalf:
							DrawTileBlock(TMID_Decor, x, y, 90, TilesY + 4, 4, 2);
							break;

						case DoorStatus.Secret_Closed:
						
							switch(Inst.SecretType){
								case SecretDoor.Crack:
						
									//draw back wall
									DrawTileBlock(TMID_Walls, x + 8, y, 9 + (WallLevel * 17), TilesY + 2, 2, 3); 
								
									//Crack
									DrawTileBlock(TMID_Decor, x + 8, y, 96, TilesY + 4, 2, 2);
								
									break;
							
								case SecretDoor.Blank:
									//draw back wall
									DrawTileBlock(TMID_Walls, x + 8, y, 9 + (WallLevel * 17), TilesY + 2, 2, 3); 
									break;
							}
						break;

					case DoorStatus.Secret_Open:
						
						switch(Inst.SecretType){
							case SecretDoor.Blank:
							case SecretDoor.Crack:
						
								ClearTileBlock(TMID_Walls, x + 8, y, 2, 2);
								ClearTileBlock(TMID_Decor, x + 8, y, 2, 2);


								switch(Inst.FloorLevel){
									case UPPER:

										//Sides
										DrawTileBlock(TMID_Decor, x, y, 100, TilesY + 2, 1, 2);
										DrawTileBlock(TMID_Decor, x + 24, y, 101, TilesY + 2, 1, 2);
						
										//Top
										DrawTileBlock(TMID_Beam, x, y + 16, 62, TilesY + 5, 4, 1);
								
										break;
										
									case LOWER:
								
										//Sides
										DrawTileBlock(TMID_Decor, x, y, 104, TilesY + 2, 1, 2);
										DrawTileBlock(TMID_Decor, x + 24, y, 105, TilesY + 2, 1, 2);
						
										//Top
										DrawTileBlock(TMID_Beam, x, y + 16, 66, TilesY + 5, 4, 1);
										
										break;
						
								}
								


								switch(LightingFrame){
									case OpenDoorSprite.LightCurrentLightNext:
									case OpenDoorSprite.DarkCurrentLightNext:
										DrawTileBlock(TMID_Decor, x + 8, y, 70, 0, 2, 2); break;
									case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y, 72, 2, 2, 2); break;							
									case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y, 108, TilesY + 2, 2, 2); break;
								}
								break;
							
							case SecretDoor.Illusion:
								//draw back wall
								for(var i = 0; i < 4; i++){
									var _x = x + (i * 8);
									var _TileX =  9 + (_x mod 16 == 0 ? 1 : 0) + (WallLevel * 17);
									DrawTileBlock(TMID_Walls, _x, y, _TileX, TilesY + 2, 1, 2); 
									DrawTileBlock(TMID_Beam, _x, y + 16, _TileX, TilesY + 4, 1, 1); 
								}
								
								break;
						}
						break;
						
						case DoorStatus.Exit:
							DrawTileBlock(TMID_Decor, x + 8, y, 58, TilesY + 4, 2, 2);
							break;

					
					}
				}
						
				break;
		
			case "Left":

				if(Status != DoorStatus.Secret_Closed && Status != DoorStatus.Secret_Open){
						
					//Door beam
					DrawTileBlock(TMID_Beam, x, y, 62 + (FloorLevel == LOWER ? 2 : 0), TilesY, 1, 4);
				
					//Sides
					DrawTileBlock(TMID_Decor, x + 8, y, 70, TilesY + 2, 2, 1);
					DrawTileBlock(TMID_Decor, x + 8, y + 24, 70, TilesY + 3, 2, 1);
					
				}
				
				switch(Status){
		
					case DoorStatus.Open:
					case DoorStatus.Curtain:
						if(AddTracks){ //for mine level only
							DrawTileBlock(TMID_Decor, x + 8, y + 8, 128, VillageTilesY + 2, 2, 2); break;
						}else{
							switch(LightingFrame){
								case OpenDoorSprite.LightCurrentLightNext: 
								case OpenDoorSprite.DarkCurrentLightNext:
									DrawTileBlock(TMID_Decor, x + 8, y + 8, 72, 0, 2, 2); break;
								case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 70, 2, 2, 2); break;
								case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 74, TilesY + 2, 2, 2); break;
							}
						}
						break;

					case DoorStatus.Closed:
						DrawTileBlock(TMID_Decor, x + 8, y, 78, TilesY, 2, 4);
						break;
					
					case DoorStatus.ClosedHalf:
						DrawTileBlock(TMID_Decor, x + 8, y, 80, TilesY, 2, 4);
						break;

					case DoorStatus.Locked:
						DrawTileBlock(TMID_Decor, x + 8, y, 90, TilesY, 2, 4);
						break;

					case DoorStatus.LockedHalf:
						DrawTileBlock(TMID_Decor, x + 8, y, 92, TilesY, 2, 4);
						break;

					case DoorStatus.Secret_Closed:
						
						switch(Inst.SecretType){
							case SecretDoor.Crack:
						
								//draw back wall
								DrawTileBlock(TMID_Walls, x, y + 8, 6 + (WallLevel * 17), TilesY + 3, 3, 2);  
								
								//Crack
								DrawTileBlock(TMID_Decor, x + 8, y + 8, 98, TilesY + 4, 2, 2);
								break;
								
							case SecretDoor.Blank:
								//draw back wall
								DrawTileBlock(TMID_Walls, x, y + 8, 6 + (WallLevel * 17), TilesY + 3, 3, 2);  

								break;
								
						}
						break;

					case DoorStatus.Secret_Open:
						
						switch(Inst.SecretType){
							case SecretDoor.Blank:
							case SecretDoor.Crack:
						
								ClearTileBlock(TMID_Walls, x + 8, y + 8, 2, 2);
								ClearTileBlock(TMID_Decor, x + 8, y + 8, 2, 2);

								switch(Inst.FloorLevel){
									case UPPER:

										//Sides
										DrawTileBlock(TMID_Decor, x + 8, y, 98, TilesY + 2, 2, 1);
										DrawTileBlock(TMID_Decor, x + 8, y + 24, 98, TilesY + 3, 2, 1);
						
										//Top
										DrawTileBlock(TMID_Beam, x, y, 66, TilesY, 1, 4);
								
										break;
										
									case LOWER:
								
										//Sides
										DrawTileBlock(TMID_Decor, x + 8, y, 102, TilesY + 2, 2, 1);
										DrawTileBlock(TMID_Decor, x + 8, y + 24, 102, TilesY + 3, 2, 1);
						
										//Top
										DrawTileBlock(TMID_Beam, x, y, 68, TilesY, 1, 4);
										
										break;
						
								}

								switch(LightingFrame){
									case OpenDoorSprite.LightCurrentLightNext:
									case OpenDoorSprite.DarkCurrentLightNext:
										DrawTileBlock(TMID_Decor, x + 8, y + 8, 72, 0, 2, 2); break;
									case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 70, 2, 2, 2); break;							
									case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x + 8, y + 8, 106, TilesY + 2, 2, 2); break;
								}
								break;
							
							case SecretDoor.Illusion:
								//draw back wall								
								for(var i = 0; i < 4; i++){
									var _y = y + (i * 8);
									var _TileY =  TilesY + 3 + (_y mod 16 == 0 ? 1 : 0);
									DrawTileBlock(TMID_Beam, x, _y, 6 + (WallLevel * 17), _TileY, 1, 1); 									
								}
								for(var i = 0; i < 2; i++){
									var _y = y + 8 + (i * 8);
									var _TileY =  TilesY + 3 + (_y mod 16 == 0 ? 1 : 0);
									DrawTileBlock(TMID_Walls, x + 8, _y, 7 + (WallLevel * 17), _TileY, 2, 1); 
								}
								
								break;

						}
						break;
						

				}
				
				//draw back ceilings above to cover any items Link is carrying while walking through
				for(var i = 0; i < 2; i++){
					var _TileY = y - 16 + (i * 8);
					DrawTileBlock(TMID_Beam, x, _TileY, 6 + (WallLevel * 17), TilesY + 3 + (_TileY mod 16 == 0 ? 1 : 0), 1, 1);  
				}
				
				break;
		
			case "Right":

				if(Status != DoorStatus.Secret_Closed && Status != DoorStatus.Secret_Open){
					
					//Door beam
					DrawTileBlock(TMID_Beam, x + 16, y,  63 + (FloorLevel == LOWER ? 2 : 0), TilesY, 1, 4);
				
					//Sides
					DrawTileBlock(TMID_Decor, x, y, 72, TilesY, 2, 1);
					DrawTileBlock(TMID_Decor, x, y + 24, 72, TilesY + 1, 2, 1);
				
				}
				
				switch(Status){
		
					case DoorStatus.Open:
					case DoorStatus.Curtain:
						if(AddTracks){ //for mine level only
							DrawTileBlock(TMID_Decor, x, y + 8, 130, VillageTilesY, 2, 2); break;
						}else{
							switch(LightingFrame){
								case OpenDoorSprite.LightCurrentLightNext: 
								case OpenDoorSprite.DarkCurrentLightNext:
									DrawTileBlock(TMID_Decor, x, y + 8, 70, 2, 2, 2); break;
								case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x, y + 8, 72, 0, 2, 2); break;
								case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x, y + 8, 76, TilesY, 2, 2); break;
							}
						}
						break;

					case DoorStatus.Closed:
						DrawTileBlock(TMID_Decor, x, y, 82, TilesY, 2, 4);
						break;
					
					case DoorStatus.ClosedHalf:
						DrawTileBlock(TMID_Decor, x, y, 84, TilesY, 2, 4);
						break;

					case DoorStatus.Locked:
						DrawTileBlock(TMID_Decor, x, y, 94, TilesY, 2, 4);
						break;

					case DoorStatus.LockedHalf:
						DrawTileBlock(TMID_Decor, x, y, 96, TilesY, 2, 4);
						break;

					case DoorStatus.Secret_Closed:
						
						switch(Inst.SecretType){
							case SecretDoor.Crack:
						
								//draw back wall
								DrawTileBlock(TMID_Walls, x, y + 8, 8 + (WallLevel * 17), TilesY, 3, 2); 
								
								//Crack
								DrawTileBlock(TMID_Decor, x, y + 8, 100, TilesY + 4, 2, 2);
								break;
								
							case SecretDoor.Blank:
								//draw back wall
								DrawTileBlock(TMID_Walls, x, y + 8, 8 + (WallLevel * 17), TilesY, 3, 2); 	
								break;
								
															
						}
						break;

					case DoorStatus.Secret_Open:
						
						switch(Inst.SecretType){
							case SecretDoor.Blank:
							case SecretDoor.Crack:
						
								ClearTileBlock(TMID_Walls, x, y + 8, 2, 2);
								ClearTileBlock(TMID_Decor, x, y + 8, 2, 2);

								switch(Inst.FloorLevel){
									case UPPER:

										//Sides
										DrawTileBlock(TMID_Decor, x, y, 100, TilesY, 2, 1);
										DrawTileBlock(TMID_Decor, x, y + 24, 100, TilesY + 1, 2, 1);
						
										//Top
										DrawTileBlock(TMID_Beam, x + 16, y, 67, TilesY, 1, 4);
								
										break;
										
									case LOWER:
								
										//Sides
										DrawTileBlock(TMID_Decor, x, y, 104, TilesY, 2, 1);
										DrawTileBlock(TMID_Decor, x, y + 24, 104, TilesY + 1, 2, 1);
						
										//Top
										DrawTileBlock(TMID_Beam, x + 16, y, 69, TilesY, 1, 4);
										
										break;
						
								}

								switch(LightingFrame){
									case OpenDoorSprite.LightCurrentLightNext:
									case OpenDoorSprite.DarkCurrentLightNext:
										DrawTileBlock(TMID_Decor, x, y + 8, 70, 2, 2, 2); break;
									case OpenDoorSprite.LightCurrentDarkNext: DrawTileBlock(TMID_Decor, x, y + 8, 72, 0, 2, 2); break;							
									case OpenDoorSprite.DarkCurrentDarkNext: DrawTileBlock(TMID_Decor, x, y + 8, 108, TilesY, 2, 2); break;
								}
								break;
							
							case SecretDoor.Illusion:
								//draw back wall
								for(var i = 0; i < 2; i++){
									var _y = y + 8 + (i * 8);
									var _TileY =  TilesY + (_y mod 16 == 0 ? 1 : 0);
									DrawTileBlock(TMID_Walls, x, _y, 8 + (WallLevel * 17), _TileY, 2, 1); 
								}
								for(var i = 0; i < 4; i++){
									var _y = y + (i * 8);
									var _TileY =  TilesY + (_y mod 16 == 0 ? 1 : 0);
									DrawTileBlock(TMID_Beam, x + 16, _y, 10 + (WallLevel * 17), _TileY, 1, 1); 									
								}

								
								break;

						}
						break;
						

				}
				
				//draw back ceilings above to cover any items Link is carrying while walking through
				for(var i = 0; i < 2; i++){
					var _TileY = y - 16 + (i * 8);
					DrawTileBlock(TMID_Beam, x + 16, _TileY, 10 + (WallLevel * 17), TilesY + (_TileY mod 16 == 0 ? 1 : 0), 1, 1); 
				}				
				break;
		}
		
	}
	
}

function Dungeon_InitDoors(){


	with(oDoor){
		
		var RoomGridX = floor(x / 256);
		var RoomGridY = floor(y / 256);

		var DoorDist = (FloorLevel == UPPER ? 56 : 104);
		var DirX = 0;	
		var DirY = 0;
		
		switch(Location){
			case "Top": DirY = -1;	break;
			case "Bottom": DirY = 1; break;				
			case "Left": DirX = -1; break;
			case "Right": DirX = 1; break;
		}

		LinkedDoor = instance_place(x + (DirX * DoorDist), y + (DirY * DoorDist), oDoor);
		
		var ConnectedRoomGridX = RoomGridX + DirX;
		var ConnectedRoomGridY = RoomGridY + DirY;
				
		//Make sure the door and linked door is the same secret type
		if(SecretType != -1 && LinkedDoor.SecretType != SecretType){
			LinkedDoor.Status = DoorStatus.Secret_Closed;
			LinkedDoor.SecretType = SecretType;
		}
		
		if(global.Level.Rooms[RoomIndex].TemplateName == "Arcade") continue;
		
		if(ConnectedRoomGridX >= 0 && ConnectedRoomGridX <= 7 && ConnectedRoomGridY >= 0 && ConnectedRoomGridY <= 7){
			var ConnectedRoomIndex = global.Level.Map_RoomIndex[ConnectedRoomGridY][ConnectedRoomGridX];
			if(ConnectedRoomIndex != -1 && ConnectedRoomIndex != undefined && !Entrance && Status != DoorStatus.Entrance && Status != DoorStatus.Exit){
				var ConnectedLightingStatus = global.Level.Rooms[ConnectedRoomIndex].Lighting;
				if(global.Level.Rooms[RoomIndex].Lighting == 0.0){
					if(ConnectedLightingStatus == 0.0)
						LightingFrame = OpenDoorSprite.LightCurrentLightNext;
					else
						LightingFrame = OpenDoorSprite.LightCurrentDarkNext;
				}else{
					if(ConnectedLightingStatus == 0.0){
						LightingFrame = OpenDoorSprite.DarkCurrentLightNext;
						var C = 0.6;
						var E = 0.47;
						var S = 0.7;
						switch(Location){
							case "Top":
								EntranceLight = Lighting_CreateLight(RoomIndex, x + 16, y + 16, E, [C, C, C]);	
								FloorLight = Lighting_CreateLight(RoomIndex, x + 16, y + 16, S, [C, C,C]);	
								break;
							case "Bottom":
								EntranceLight = Lighting_CreateLight(RoomIndex, x + 16, y + 11, E, [C, C, C]);	
								FloorLight = Lighting_CreateLight(RoomIndex, x + 16, y + 10, S, [C, C, C]);	
								break;							
							case "Left":
								EntranceLight = Lighting_CreateLight(RoomIndex, x + 16, y + 16, E, [C, C, C]);	
								FloorLight = Lighting_CreateLight(RoomIndex, x + 16, y + 16, S, [C, C, C]);
								break;							
							case "Right":
								EntranceLight = Lighting_CreateLight(RoomIndex, x + 9, y + 16, E, [C, C, C]);
								FloorLight = Lighting_CreateLight(RoomIndex, x + 8, y + 16, S, [C, C, C]);
								break;							
						}
						
					}else LightingFrame = OpenDoorSprite.DarkCurrentDarkNext;
				}
			}
		}

		Door_UpdateLights();
	
	}
	
	with(oDoor){

		Door_DrawTiles(id);
		if(SecretType == SecretDoor.Illusion){
			if(global.Level.Rooms[LinkedDoor.RoomIndex].Secret == 1) global.Level.Rooms[LinkedDoor.RoomIndex].Secret = 2; //to notify the camera to play sound when transitioning. 
			Status = DoorStatus.Secret_Open;
			EntranceLight = Lighting_DestroyLight(RoomIndex, EntranceLight);
			FloorLight = Lighting_DestroyLight(RoomIndex, FloorLight);
		}

	}
	
}

function Door_OpenSecretDoor(_Inst){
	
	with(_Inst){
		Status = DoorStatus.Secret_Open;
		UpdateStatus = true;
		LinkedDoor.Status = DoorStatus.Secret_Open;
		LinkedDoor.SecretType = SecretType;
		LinkedDoor.UpdateStatus = true;	
	}
	
}

function Door_SetPassageArea(_DoorInst){
	
	with(_DoorInst){
		switch(Location){
		
			case "Top":
				
				sprite_index = sDoorMaskH;
				PassageArea[0] = x - 4;
				PassageArea[1] = y - 48 - (FloorLevel == LOWER ? 48 : 0);
				PassageArea[2] = x + 35;
				PassageArea[3] = y + 7;
					
				break;
			
			case "Bottom":

				sprite_index = sDoorMaskH;
				PassageArea[0] = x - 4;
				PassageArea[1] = y + 15;
				PassageArea[2] = x + 35;
				PassageArea[3] = y + 63 + (FloorLevel == LOWER ? 48 : 0);
				
				break;
			
			case "Left":

				sprite_index = sDoorMaskV;
				PassageArea[0] = x - 48 - (FloorLevel == LOWER ? 48 : 0);;
				PassageArea[1] = y - 12;
				PassageArea[2] = x + 8;
				PassageArea[3] = y + 35;

				break;
			
			case "Right":

				sprite_index = sDoorMaskV;
				PassageArea[0] = x + 16;
				PassageArea[1] = y - 12;
				PassageArea[2] = x + 63 + (FloorLevel == LOWER ? 48 : 0);
				PassageArea[3] = y + 35;

				break;
	
		}
	}
		
}

function Door_GetConnectedPos(ARGridX, ARGridY, ARSize, CRGridX, CRGridY, CRSize, ARDoorPos){
	
	//AR = Active Room
	//CR = Connected Room
	
	var A = (ARDoorPos > 12 ? 12 : 0); //A stands for 'Add 12'
	
	switch(ARSize){
		case RoomSize._1x1:
			
			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
				
			break;
		
		case RoomSize._1x2:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 1 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 5 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 1 + A;;
						case 6: case 18: return 12 + A;
						case 7: case 19: return 11 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 7 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
			
		case RoomSize._2x1:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: return 12 + A;;
						case 7: case 19: return 12 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 10 + A;
						case 3: case 15: return 9 + A;
						case 4: case 16: return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: return 12 + A;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 4 + A;
						case 9: case 21: return 3 + A;
						case 10: case 22: return 2 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
		case RoomSize._2x2:

			switch(CRSize){
				case RoomSize._1x1:
						
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
						
				case RoomSize._1x2:
				
					switch(ARDoorPos){
						case 1: case 13: return 6 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15:  if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: return 12 + A;
						case 7: case 19: return 12 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: return 6 + A;
						default: return -1;
								
					}
					break;
					
				case RoomSize._2x1:

					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: return 9 + A;
						case 4: case 16: return 9 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: return 3 + A;
						case 10: case 22: return 3 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
						
				case RoomSize._2x2:
				
					switch(ARDoorPos){
						case 1: case 13: if(ARGridX == CRGridX) return 5 + A; else return 7 + A;
						case 2: case 14: if(ARGridY == CRGridY) return 10 + A; else return 8 + A;
						case 3: case 15: if(ARGridY == CRGridY) return 9 + A; else return -1;
						case 4: case 16: if(ARGridY == CRGridY) return 8 + A; else return 10 + A;
						case 5: case 17: if(ARGridX == CRGridX) return 1 + A; else return 11 + A;
						case 6: case 18: if(ARGridX == CRGridX) return 12 + A; else return -1;
						case 7: case 19: if(ARGridX == CRGridX) return 11 + A; else return 1 + A;
						case 8: case 20: if(ARGridY == CRGridY) return 4 + A; else return 2 + A;
						case 9: case 21: if(ARGridY == CRGridY) return 3 + A; else return -1;
						case 10: case 22: if(ARGridY == CRGridY) return 2 + A; else return 4 + A;
						case 11: case 23: if(ARGridX == CRGridX) return 7 + A; else return 5 + A;
						case 12: case 24: if(ARGridX == CRGridX) return 6 + A; else return -1;
						default: return -1;
								
					}
					break;
			}
			
			break;
			
	}
		
	
}

function Door_UpdateLights(){
	
	var LightStatus = (Status != DoorStatus.Closed && Status != DoorStatus.Locked && Status != DoorStatus.Secret_Closed && Status != DoorStatus.Curtain);
	Lighting_UpdateLight_Visible(RoomIndex, FloorLight, LightStatus);
	Lighting_UpdateLight_Visible(RoomIndex, EntranceLight, LightStatus);
	
}

function Door_LocationToDir(_Location){
	switch(_Location){
		case "Top": return UP
		case "Bottom": return DOWN
		case "Left": return LEFT
		case "Right": return RIGHT
		
	}
	
	return -1;
	
}
function Door_LocationToOppositeDir(_Location){
	switch(_Location){
		case "Top": return DOWN
		case "Bottom": return UP
		case "Left": return RIGHT
		case "Right": return LEFT
		
	}
	
	return -1;
	
}