
function Dungeon_Draw_WallDecor(_RoomIndex){
	
	switch(global.Level.Index){
		case DungeonLevel.Start:
		case DungeonLevel.Village:
		case DungeonLevel.Mines:
		case DungeonLevel.Aghanim2:
			exit;	
		
		case DungeonLevel.Sewers:
			if(TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Unique, "TMNT")) 
				exit;
			break;
		
		case DungeonLevel.MoldormsLair:
			if(TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss, "Moldorm"))
				exit;
			break;
	}
		
	
	//goal:
	//gather information about each blank wall from the template data. Create arrays representing each 8x24px wall segment, 
	//where each array element has a code to represent if it's safe to place a decor there. 
	
	WallArray[0] = struct_exists(Room.Template, "WallsLower") ? Room.Template.WallsLower : array_create(0);
	WallArray[1] = Room.Template.WallsUpper;
	Walls[0] = array_length(WallArray[0]);
	Walls[1] = array_length(WallArray[1]);
	WallData[0] = array_create(0);
	WallData[1] = array_create(0);
	
	for(var _FloorLevel = 0; _FloorLevel < 2; _FloorLevel++){
		
		if(Walls[_FloorLevel] == 0) continue;
		
		for(var WallIndex = 0; WallIndex < Walls[_FloorLevel]; WallIndex++){

			if(GetPropertyValue(WallArray[_FloorLevel][WallIndex].properties, "NoDecor") != -1) continue;
			
			var Wall = WallArray[_FloorLevel][WallIndex];
			var WallX = Room.x + Wall.x;
			var WallY = Room.y + Wall.y;
			var GID = Wall.gid;
			var WallTileW = Wall.width / 8;
			var WallTileH = Wall.height / 8;	

			var GID_T = (GID == TemplateObjGID.WallSideT || GID == TemplateObjGID.WallLowerSideT);
			var GID_B = (GID == TemplateObjGID.WallSideB || GID == TemplateObjGID.WallLowerSideB);
			var GID_L = (GID == TemplateObjGID.WallSideL || GID == TemplateObjGID.WallLowerSideL);
			var GID_R = (GID == TemplateObjGID.WallSideR || GID == TemplateObjGID.WallLowerSideR);
			
			var GID_TB = GID_T || GID_B;
			var GID_LR = GID_L || GID_R;
			
			//if wall is a side wall, add the whole wall struct to WallData array
			if(GID_TB || GID_LR){

				//if the wall segment won't be wide enough to put a decor, then pass to the next one
				if(GID_TB && WallTileW < 4) continue;
				if(GID_LR && WallTileH < 4) continue;
		
		
				var WallDataIndex = array_length(WallData[_FloorLevel]);
				array_insert(WallData[_FloorLevel], WallDataIndex, StructCopy(WallArray[_FloorLevel][WallIndex]));
			
				var Wall = WallData[_FloorLevel][WallDataIndex];
				//replace x/y of the struct data with real world data x/y
				Wall.x = WallX;
				Wall.y = WallY;
				Wall[$ "TileW"] = WallTileW;
				Wall[$ "TileH"] = WallTileH;
				
				Wall[$ "Doors"] = array_create(0); //keep track of the doors that are on the wall
			
				//create array in the wall struct with WallTileW elements, where each element will hold data which will determine if we can place a decor at that location
				//Create the array will all WallSegmentStatus.Valid(meaning safe to place a decor). Will set back to WallSegmentStatus.Invalid once conditions are met that can't place a decor there
				Wall[$ "WallSegments"] = array_create((GID_TB ? WallTileW : WallTileH), WallSegmentStatus.Valid);
			
			}
		
		
		}
	
	}
	
	WallDataCount[LOWER] = array_length(WallData[LOWER]);
	WallDataCount[UPPER] = array_length(WallData[UPPER]);
	
	var _CurtainType = LevelCurtainType(global.Level.Index);
	
	//check all created doors to see if they overlap the walls, and set those positions in the WallData to false;
	with(oDoor){

		//if door is not in Room, go to next
		if(!point_in_rectangle(x, y, Room.x, Room.y, Room.x + Room.width - 1, Room.y + Room.height - 1)) continue;

		//for each door, check each WallData to see if any of the doors overlap. 
		for(var WallDataIndex = 0; WallDataIndex < other.WallDataCount[FloorLevel]; WallDataIndex++){
			
			var Wall = other.WallData[FloorLevel][WallDataIndex];
			var WallTileW = array_length(Wall.WallSegments);
			var GID_T = (Wall.gid == TemplateObjGID.WallSideT || Wall.gid == TemplateObjGID.WallLowerSideT);
			var GID_B = (Wall.gid == TemplateObjGID.WallSideB || Wall.gid == TemplateObjGID.WallLowerSideB);
			
			if(point_in_rectangle(x, y, Wall.x, Wall.y, Wall.x + Wall.width - 1, Wall.y + Wall.height - 1)){
				//add door instance to door array
				array_push(Wall.Doors, id);			
				break;				
			}
		}
		
		//put random vines on doors if it's a vine level
		//If it's a curtain level, then do it more systematically (if there's only 1 door, draw columns on each side, etc)
		
		if(FloorLevel == LOWER || Status != DoorStatus.Open || Entrance) continue;
		
		if(_CurtainType == CurtainType.Vines){
			var ToSpecialRoom = false;
			if(ConnectedRoomIndex != -1){
				ToSpecialRoom = (global.Level.DungeonTemplate.Rooms[ConnectedRoomIndex].SpecialObj == SpecialDungeonObj.SpecialRoom);
			}
			if((Prob(Chance_Decor_CurtainOverDoor) || (ToSpecialRoom && Prob(Chance_Decor_CurtainOverDoorSecret)))){
				var PosX = x;
				var PosY = y;
				var DoorLocation = Location;
				switch(Location){
					case "Bottom": PosY -= 8; break;
					case "Right":  PosX -= 8; break;			
				}
				var _CurtainInst = instance_create_layer(PosX, PosY, "ObjsDoors_Upper", oCurtain, {Location : DoorLocation, DoorInst : id});
			}
		}
		
		
		
	}

	//check each segment for each wall for obj collisions like walls, wall lights, etc
	for(var _FloorLevel = 0; _FloorLevel < 2; _FloorLevel++){
		
		var _TMID = (_FloorLevel == 0 ? global.TMID_Floor_Lower : global.TMID_Floor_Upper);
		
		for(var WallDataIndex = 0; WallDataIndex < WallDataCount[_FloorLevel]; WallDataIndex++){
			
			var Wall = WallData[_FloorLevel][WallDataIndex];
			var WallX = Wall.x;
			var WallY = Wall.y;
			var WallW = Wall.width;
			var WallH = Wall.height;
			var WallTileW = array_length(Wall.WallSegments);
			var WallGID = Wall.gid;
		
			for(var SegIndex = 0; SegIndex < WallTileW; SegIndex++){
			
				switch(Wall.gid){
					case TemplateObjGID.WallSideT:
						var SegPosX = WallX + (SegIndex * 8);
						if( collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oWallLight, false, true) != noone ||
						    collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oCurtain, false, true) != noone||
							collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oDoor, false, true) != noone) {
								Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
								break;
						}

						//check for shop carpet edge, doesn't look good when column is on top of carpet
						if(tilemap_get_at_pixel(_TMID, SegPosX, WallY + 24) == GetTileID(28, 0)){
							Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
							break;
						}					
					
						//check below segment to see if there's a wall or no lower floor, in which case don't add column there
						if(collision_rectangle(SegPosX, WallY + 24, SegPosX + 7, WallY + 32, oWall, false, true) != noone||
						   tilemap_get_at_pixel(_TMID, SegPosX, WallY + 24) == 0){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
							   break;
						}

						break;
					
					case TemplateObjGID.WallSideB:
						var SegPosX = WallX + (SegIndex * 8);
						if(collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oWallLight, false, true) != noone||
						   collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oCurtain, false, true) != noone||
						   collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oDoor, false, true) != noone){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
							   break;
						}
					
						if(collision_rectangle(SegPosX, WallY - 8, SegPosX + 7, WallY - 1, oWall, false, true) != noone||
						   tilemap_get_at_pixel(_TMID, SegPosX, WallY - 1) == 0){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
							   break;
						}
					
						break;
					
					case TemplateObjGID.WallSideL:
						var SegPosY = WallY + (SegIndex * 8);
						if(collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oWallLight, false, true) != noone ||
						   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oCurtain, false, true) != noone ||
						   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oDoor, false, true) != noone ){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
							   break;
						}

						//check for shop carpet edge, doesn't look good when column is on top of carpet
						if(tilemap_get_at_pixel(_TMID, WallX + 24, SegPosY) == GetTileID(27, 1)){
							Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
							break;
						}
					
					
						if(collision_rectangle(WallX + 24, SegPosY, WallX + 32, SegPosY + 7, oWall, false, true) != noone ||
						   tilemap_get_at_pixel(_TMID, WallX + 24, SegPosY) == 0){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
							   break;
						}

						break;
					
					case TemplateObjGID.WallSideR:
						var SegPosY = WallY + (SegIndex * 8);
						if(collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oWallLight, false, true) != noone ||
						   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oCurtain, false, true) != noone ||
						   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oDoor, false, true) != noone ){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
							   break;
						}

						//check for shop carpet edge, doesn't look good when column is on top of carpet
						if(tilemap_get_at_pixel(_TMID, WallX - 1, SegPosY) == GetTileID(29, 1)){
							Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
							break;
						}
					
					
						if(collision_rectangle(WallX - 8, SegPosY, WallX - 1, SegPosY + 7, oWall, false, true) != noone ||
						   tilemap_get_at_pixel(_TMID, WallX - 1, SegPosY) == 0){
							   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
							   break;
						}

						break;
					
				}
	
			
			}

		}
	
	}
	
	//Draw random cracks
	
	for(var _FloorLevel = 0; _FloorLevel < 2; _FloorLevel++){
		
		var _TMID = (_FloorLevel == LOWER ? global.TMID_Decor_Lower : global.TMID_Decor_Upper);
		
		for(var WallDataIndex = 0; WallDataIndex < WallDataCount[_FloorLevel]; WallDataIndex++){
		
			var Wall = WallData[_FloorLevel][WallDataIndex];
		
			var WallTileW = array_length(Wall.WallSegments);
			
			var _MaxCracks = min(floor(WallTileW / 2), Cracks_MaxAmount());
			var _Cracks = irandom(_MaxCracks);
			
			for(var i = 0; i < _Cracks; i++){
		
				Segment = irandom(WallTileW - 2);
			
				var _Mirror = FlipCoin_Bool();
				var _Flip = false;
				var _Rotate = false;
			
				if(Decor_Wall_GetSegmentStatus(Wall, DecorType.Cracks, Segment, 2)){
						
					switch(Wall.gid){
						case TemplateObjGID.WallSideT:
						case TemplateObjGID.WallLowerSideT:
							var PosX = Wall.x + (Segment * 8);
							var PosY = Wall.y + 8;
							break;
				
						case TemplateObjGID.WallSideB:
						case TemplateObjGID.WallLowerSideB:
							var PosX = Wall.x + (Segment * 8);
							var PosY = Wall.y;
							var _Flip = true;
							break;
				
						case TemplateObjGID.WallSideL:
						case TemplateObjGID.WallLowerSideL:
							var PosX = Wall.x + 8;
							var PosY = Wall.y + (Segment * 8);
							var _Flip = true;
							var _Rotate = true;
							break;
				
						case TemplateObjGID.WallSideR:
						case TemplateObjGID.WallLowerSideR:
							var PosX = Wall.x;
							var PosY = Wall.y + (Segment * 8);
							var _Rotate = true;
							break;

					}
				
					DrawTileBlock(_TMID, PosX, PosY, 94, LevelTilesY + 4, 2, 2, _Mirror, _Flip, _Rotate);
				
				}
			
			}

		}
	
	}
	
	//draw decor on walls
	
	global.RoomLightsOn = 0; 
	global.RoomLightsOn_Max = min(3 * Room.GridW * Room.GridH, 8);
	//if more than 3 lights are used, then always set remaining to off. We shuffle position list so it's not always the same lights that get turned off.
	
	global.ReplacedMuralWithLight = false; //sometimes replace a mural with a light. Only should be done once so keep track with this variable
	
	for(var WallDataIndex = 0; WallDataIndex < WallDataCount[UPPER]; WallDataIndex++){
			
		var Wall = WallData[UPPER][WallDataIndex];
		var WallX = Wall.x;
		var WallY = Wall.y;
		var WallW = Wall.width;
		var WallH = Wall.height;
		var WallTileW = array_length(Wall.WallSegments);
		var WallGID = Wall.gid;
		var PropertiesArray = Wall.properties;
		var Light = GetPropertyValue(PropertiesArray, "Light");
		
		var Doors = array_length(Wall.Doors);
		
		var ColumnCount = floor(WallTileW / 4);
		
		if(Doors == 0){
			
			var _Column = (ColumnCount > 2 ? DecorType.Column : DecorType.Mural);
			
			switch(global.Level.Index){
				default:
					var _DecorType = choose(DecorType.Mural, _Column, DecorType.Lighting, DecorType.Lighting, DecorType.Lighting)
					break;
				
				case DungeonLevel.Catacombs:
					var _DecorType = choose(DecorType.Mural, DecorType.Mural, _Column, DecorType.Lighting);
					break;
					
				case DungeonLevel.Aghanim1:
					if(WallGID == TemplateObjGID.WallSideT && WallTileW mod 2 == 0){
						var _DecorType = choose(DecorType.Mural, _Column, DecorType.LargeMural, DecorType.Lighting, DecorType.Lighting, DecorType.Lighting)
					}else{
						var _DecorType = choose(DecorType.Mural, _Column, DecorType.Lighting, DecorType.Lighting, DecorType.Lighting)
					}
					break;
				
			}
			
			if(Light != -1 && global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights){
				_DecorType = DecorType.Lighting;
			}
			
			switch(_DecorType){
				case DecorType.Mural:
					
					var MuralStyle = FlipCoin_Bin();	
					
					switch(global.Level.Index){
							
						case DungeonLevel.Catacombs:
							//if(WallGID == TemplateObjGID.WallSideB || Room.TemplateClass != RoomTemplateClass.Main_Upper) MuralStyle = 0 //in catacombs, mural 1 looks weird if not on top in main_upper template class
							Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, floor(WallTileW / 5), MuralStyle);
							break;
				
						default:
							Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, choose(0, irandom(floor(WallTileW / 7))), MuralStyle);	
							break;
					}
					break;
				
				case DecorType.LargeMural:
					var MuralStyle = FlipCoin_Bin();
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, irandom_range(1, floor(WallTileW / 11)), MuralStyle);
					break;
					
				case DecorType.Column:
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, ColumnCount);
					break;
					
				case DecorType.Lighting:
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, floor(WallTileW / 22), 1);
					break;

			}
	
			
		}else if(Doors == 1 && WallTileW >= 18){ //draw a decor on each side of the door
			
			var DecorStyle = 0;
			if(ColumnCount > 2)
				var _DecorType = choose(DecorType.Mural, DecorType.Column);
			else{
				var _DecorType = DecorType.Mural;
			}
			
			if(_DecorType == DecorType.Mural) DecorStyle = FlipCoin_Bin();
			
			var _DecorTileW = global.DecorTileW[_DecorType];
			
			var _Door = Wall.Doors[0];
			
			var DoorPosX = _Door.x;
			var DoorPosY = _Door.y;	

			if(WallGID == TemplateObjGID.WallSideT || WallGID == TemplateObjGID.WallSideB){
				var SegmentIndex = (DoorPosX - WallX) / 8;
			}else{
				var SegmentIndex = (DoorPosY - WallY) / 8;
			}
			
			Decor_FillWallFromSegment(_RoomIndex, Wall, _DecorType, SegmentIndex + 6, 4, 1, DecorStyle);			
			
			Decor_FillWallFromSegment(_RoomIndex, Wall, _DecorType, SegmentIndex - _DecorTileW - 2, 4, -1, DecorStyle);
			
		}

		
		
	}

	
	//Draw random vines
	
	var _LevelCurtainType = LevelCurtainType(global.Level.Index);
	
	for(var WallDataIndex = 0; WallDataIndex < WallDataCount[UPPER]; WallDataIndex++){
		
		var Wall = WallData[UPPER][WallDataIndex];
		
		if(_LevelCurtainType != CurtainType.Vines || Wall.gid == TemplateObjGID.WallSideB) continue; //they don't look as good on the bottom, curtains only
		
		var WallTileW = array_length(Wall.WallSegments);
		
		repeat(irandom(6 * min(Room.GridW * Room.GridH, 2))){ //double it if Room is either 2 wide or 2 high
			
			var _CurtainInst = noone;
			var WallPosX = Wall.x;
			var WallPosY = Wall.y;
			var Segment = irandom(WallTileW - 4);
					
			switch(Wall.gid){
				//case TemplateObjGID.WallSideB:
				//	WallPosY -= 8;
				case TemplateObjGID.WallSideT:
					if(Decor_Wall_GetSegmentStatus(Wall, DecorType.Curtain, Segment, 4)){
						Decor_Wall_SetSegmentStatus(Wall, Segment, 4, WallSegmentStatus.Invalid);
						var _CurtainInst = instance_create_layer(WallPosX + (Segment * 8), WallPosY, "ObjsDoors_Upper", oCurtain, {Location : (Wall.gid == TemplateObjGID.WallSideT ? "Top" : "Bottom"), DoorInst : noone});
					}
					break;
				
				case TemplateObjGID.WallSideR:
					WallPosX -= 8;
				case TemplateObjGID.WallSideL:
					if(Decor_Wall_GetSegmentStatus(Wall, DecorType.Curtain, Segment, 4)){
						Decor_Wall_SetSegmentStatus(Wall, Segment, 4, WallSegmentStatus.Invalid);
						var _CurtainInst = instance_create_layer(WallPosX, WallPosY + (Segment * 8), "ObjsDoors_Upper", oCurtain, {Location : (Wall.gid == TemplateObjGID.WallSideL ? "Left" : "Right"), DoorInst : noone});
					}
					break;

			
			}
		
			if(_CurtainInst != noone){
				//check if curtain collides with other objects. If so, destroy it
				with(_CurtainInst){
					if(instance_place(x, y, oPot) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oCrystalSwitch) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oItem) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oCurtain) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oWallLight) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
				}	
						
			}
		}
	}

	WallArray = 0;
	Walls = 0;
	WallData = 0;
	WallDataCount = 0;

	
}

