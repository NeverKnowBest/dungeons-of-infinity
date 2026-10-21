

function Dungeon_Draw_WallDecor(_RoomIndex){
	
	switch(global.Level.Index){
		case DungeonLevel.Start:
		case DungeonLevel.Village:
		case DungeonLevel.Aghanim4:
			exit;		
	}
		
		
	//goal:
	//gather information about each blank wall from the template data. Create arrays representing each 8x24px wall segment, 
	//where each array element has a code to represent if it's safe to place a decor there. 
	
	var WallArray = TemplateRoom.WallsUpper;
	var Walls = array_length(WallArray);
	WallData = array_create(0);
	
	for(var WallIndex = 0; WallIndex < Walls; WallIndex++){
	
		var WallX = Room.x + WallArray[WallIndex].x;
		var WallY = Room.y + WallArray[WallIndex].y;
		var GID = WallArray[WallIndex].gid;
		var WallTileW = WallArray[WallIndex].width / 8;
		var WallTileH = WallArray[WallIndex].height / 8;	
				
		//if wall is a side wall, add the whole wall struct to WallData array
		if(GID == TemplateObjGID.WallSideT || GID == TemplateObjGID.WallSideB || GID == TemplateObjGID.WallSideL || GID == TemplateObjGID.WallSideR){

			//if the wall segment won't be wide enough to put a decor, then pass to the next one
			if((GID == TemplateObjGID.WallSideT || GID == TemplateObjGID.WallSideB) && WallTileW < 4) continue;
			if((GID == TemplateObjGID.WallSideL || GID == TemplateObjGID.WallSideR) && WallTileH < 4) continue;
		
		
			var WallDataIndex = array_length(WallData);
			array_insert(WallData, WallDataIndex, StructCopy(WallArray[WallIndex]));
			
			var Wall = WallData[WallDataIndex];
			//replace x/y of the struct data with real world data x/y
			Wall.x = WallX;
			Wall.y = WallY;
			Wall[$ "TileW"] = WallTileW;
			Wall[$ "TileH"] = WallTileH;
			
			Wall[$ "Doors"] = array_create(0); //keep track of the doors that are on the wall
			
			//create array in the wall struct with WallTileW elements, where each element will hold data which will determine if we can place a decor at that location
			//Create the array will all Trues(meaning safe to place a decor). Will set back to false once conditions are met that can't place a decor there
			Wall[$ "WallSegments"] = array_create(((GID == TemplateObjGID.WallSideT || GID == TemplateObjGID.WallSideB) ? WallTileW : WallTileH), true);
			
		}
		
		
	}
	
	var WallDataCount = array_length(WallData);
	
	var _CurtainType = LevelCurtainType(global.Level.Index);
	
	//check all created doors to see if they overlap the walls, and set those positions in the WallData to false;
	with(oDoor){
		
		if(FloorLevel == LOWER) continue;
		
		var DoorPosX = x;
		var DoorPosY = y;		
		
		//if door is not in Room, go to next
		if(!point_in_rectangle(DoorPosX, DoorPosY, Room.x, Room.y, Room.x + Room.width - 1, Room.y + Room.height - 1)) continue;


		//for each door, check each WallData to see if any of the doors overlap. 
		//If so, add false values at the appropriate WallData element positions to signify that those spots are taken by doors
		for(var WallDataIndex = 0; WallDataIndex < WallDataCount; WallDataIndex++){
			
			var Wall = other.WallData[WallDataIndex];
			var WallX = Wall.x;
			var WallY = Wall.y;
			var WallW = Wall.width;
			var WallH = Wall.height;
			var WallTileW = array_length(Wall.WallSegments);
			var WallGID = Wall.gid;
			
			if(point_in_rectangle(DoorPosX, DoorPosY, WallX, WallY, WallX + WallW - 1, WallY + WallH - 1)){
				//Door is coliding with wall, add false values to WallData WallSegments
				if(WallGID == TemplateObjGID.WallSideT || WallGID == TemplateObjGID.WallSideB){
					var SegmentIndex = (DoorPosX - WallX) / 8;
				}else{
					var SegmentIndex = (DoorPosY - WallY) / 8;
				}
				Decor_Wall_SetSegmentStatus(Wall, SegmentIndex, 4, WallSegmentStatus.Invalid);
				
				//add door instance to door array
				array_insert(Wall.Doors, array_length(Wall.Doors), self);
				
			}
		}
		
		
		//put random vines on doors if it's a vine level
		//If it's a cutain level, then do it more systematically (if there's only 1 door, draw columns on each side, etc)
		if(_CurtainType == CurtainType.Vines){
			if(Prob(Chance_Decor_CurtainOverDoor) && Location != "Bottom" && !Entrance && Status == DoorStatus.Open){
				var PosX = x;
				var PosY = y;
				var DoorLocation = Location;
				switch(Location){
					case "Bottom": PosY -= 8; break;
					case "Right":  PosX -= 8; break;			
				}
				var _CurtainInst = instance_create_layer(PosX, PosY, "Objs_Upper", oCurtain, {Location : DoorLocation, DoorInst : id});
			}
		}
		
		
		
	}

	//check each segment for each wall for obj collisions like walls, wall lights, etc
	for(var WallDataIndex = 0; WallDataIndex < WallDataCount; WallDataIndex++){
			
		var Wall = WallData[WallDataIndex];
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
					if( collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oWallLight, false, true) ||
					    collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oCurtain, false, true)){
							Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
							break;
					}

					//check for shop carpet edge, doesn't look good when column is on top of carpet
					if(tilemap_get_at_pixel(global.TMID_Floor_Upper, SegPosX, WallY + 24) == GetTileID(28, 0)){
						Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
						break;
					}					
					
					//check below segment to see if there's a wall or no lower floor, in which case don't add column there
					if(collision_rectangle(SegPosX, WallY + 24, SegPosX + 7, WallY + 32, oWall, false, true) ||
					   tilemap_get_at_pixel(global.TMID_Floor_Upper, SegPosX, WallY + 24) == 0){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
						   break;
					}

					break;
					
				case TemplateObjGID.WallSideB:
					var SegPosX = WallX + (SegIndex * 8);
					if(collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oWallLight, false, true) ||
					   collision_rectangle(SegPosX, WallY, SegPosX + 7, WallY + 24, oCurtain, false, true)){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
						   break;
					}
					
					if(collision_rectangle(SegPosX, WallY - 8, SegPosX + 7, WallY - 1, oWall, false, true) ||
					   tilemap_get_at_pixel(global.TMID_Floor_Upper, SegPosX, WallY - 1) == 0){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
						   break;
					}
					
					break;
					
				case TemplateObjGID.WallSideL:
					var SegPosY = WallY + (SegIndex * 8);
					if(collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oWallLight, false, true) ||
					   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oCurtain, false, true)){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
						   break;
					}

					//check for shop carpet edge, doesn't look good when column is on top of carpet
					if(tilemap_get_at_pixel(global.TMID_Floor_Upper, WallX + 24, SegPosY) == GetTileID(27, 1)){
						Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
						break;
					}
					
					
					if(collision_rectangle(WallX + 24, SegPosY, WallX + 32, SegPosY + 7, oWall, false, true) ||
					   tilemap_get_at_pixel(global.TMID_Floor_Upper, WallX + 24, SegPosY) == 0){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
						   break;
					}

					break;
					
				case TemplateObjGID.WallSideR:
					var SegPosY = WallY + (SegIndex * 8);
					if(collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oWallLight, false, true) ||
					   collision_rectangle(WallX, SegPosY, WallX + 24, SegPosY + 7, oCurtain, false, true)){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Invalid);
						   break;
					}

					//check for shop carpet edge, doesn't look good when column is on top of carpet
					if(tilemap_get_at_pixel(global.TMID_Floor_Upper, WallX - 1, SegPosY) == GetTileID(29, 1)){
						Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_MuralOnly);
						break;
					}
					
					
					if(collision_rectangle(WallX - 8, SegPosY, WallX - 1, SegPosY + 7, oWall, false, true) ||
					   tilemap_get_at_pixel(global.TMID_Floor_Upper, WallX - 1, SegPosY) == 0){
						   Decor_Wall_SetSegmentStatus(Wall, SegIndex, 1, WallSegmentStatus.Valid_NoColumn);
						   break;
					}

					break;
					
			}
	
			
		}

	}
	

	//draw decor on walls
	
	global.RoomLightsOn = 0; 
	global.RoomLightsOn_Max = min(3 * Room.GridW * Room.GridH, 8);
	//if more than 3 lights are used, then always set remaining to off. We shuffle position list so it's not always the same lights that get turned off.
	
	global.ReplacedMuralWithLight = false; //sometimes replace a mural with a light. Only should be done once so keep track with this variable
	
	for(var WallDataIndex = 0; WallDataIndex < WallDataCount; WallDataIndex++){
			
		var Wall = WallData[WallDataIndex];
		var WallX = Wall.x;
		var WallY = Wall.y;
		var WallW = Wall.width;
		var WallH = Wall.height;
		var WallTileW = array_length(Wall.WallSegments);
		var WallGID = Wall.gid;
		
		var Doors = array_length(Wall.Doors);
		
		var ColumnCount = floor(WallTileW / 3.5);
		
		var Prisoner_AddLight = Room.Lighting && collision_rectangle(WallX, WallY + 24, WallX + WallW - 1, WallY + 64, oPrisoner, false, true);
		
		if(Doors == 0){
			
			if(global.Level.Index >= DungeonLevel.Aghanim1){
				var _DecorType = choose(DecorType.Mural, DecorType.LargeMural, DecorType.Column, DecorType.Lighting, DecorType.Lighting, DecorType.Lighting);
			}else{
				var _DecorType = Prisoner_AddLight ? DecorType.Lighting : choose(DecorType.Mural, DecorType.Column, DecorType.Lighting, DecorType.Lighting, DecorType.Lighting);
			}
			
			switch(_DecorType){
				case DecorType.Mural:
					
					var MuralStyle = choose(0, 1);	
					
					switch(global.Level.Index){
						case DungeonLevel.Catacombs:
							Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, floor(WallTileW / 5), MuralStyle);
							break;
				
						default:
							Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, choose(0, irandom(floor(WallTileW / 7))), MuralStyle);	
							break;
					}
					break;
				
				case DecorType.LargeMural:
					var MuralStyle = choose(0, 1);
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, 1, MuralStyle);
					break;
					
				case DecorType.Column:
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, ColumnCount);
					break;
					
				case DecorType.Lighting:
					Decor_Draw_FillWall(_RoomIndex, Wall, _DecorType, Prisoner_AddLight ? 1 : floor(WallTileW / 22), 1);
					break;

			}
	
			
		}else if(Doors == 1){
			
			var _DecorType = choose(DecorType.Mural, DecorType.Column);
			var _DecorTileW = global.DecorTileW[_DecorType];
			
			var _Door = Wall.Doors[0];
			
			var DoorPosX = _Door.x;
			var DoorPosY = _Door.y;	

			if(WallGID == TemplateObjGID.WallSideT || WallGID == TemplateObjGID.WallSideB){
				var SegmentIndex = (DoorPosX - WallX) / 8;
			}else{
				var SegmentIndex = (DoorPosY - WallY) / 8;
			}
			
			Decor_FillWallFromSegment(_RoomIndex, Wall, _DecorType, SegmentIndex + 6, 4, 1);			
			
			Decor_FillWallFromSegment(_RoomIndex, Wall, _DecorType, SegmentIndex - _DecorTileW - 2, 4, -1);
			
		}

		
	}
	
	
	//Draw random vines
	
	for(var WallDataIndex = 0; WallDataIndex < WallDataCount; WallDataIndex++){

		if(LevelCurtainType(global.Level.Index) != CurtainType.Vines || Wall.gid == TemplateObjGID.WallSideB) continue; //they don't look as good on the bottom, curtains only
		
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
						var _CurtainInst = instance_create_layer(WallPosX + (Segment * 8), WallPosY, "Objs_Upper", oCurtain, {Location : Wall.gid == TemplateObjGID.WallSideT ? "Top" : "Bottom", DoorInst : noone});
					}
					break;
				
				case TemplateObjGID.WallSideR:
					WallPosX -= 8;
				case TemplateObjGID.WallSideL:
					if(Decor_Wall_GetSegmentStatus(Wall, DecorType.Curtain, Segment, 4)){
						Decor_Wall_SetSegmentStatus(Wall, Segment, 4, WallSegmentStatus.Invalid);
						var _CurtainInst = instance_create_layer(WallPosX, WallPosY + (Segment * 8), "Objs_Upper", oCurtain, {Location : Wall.gid == TemplateObjGID.WallSideL ? "Left" : "Right", DoorInst : noone});
					}
					break;

			
			}
		
			if(_CurtainInst != noone){
				//check if curtain collides with other objects. If so, destroy it
				with(_CurtainInst){
					if(instance_place(x, y, oPot) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oItem) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oCurtain) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
					if(instance_place(x, y, oWallLight) != noone){ instance_destroy(self); _CurtainInst = noone; break;}
				}	
						
			}
		}
	}

	
	WallData = 0;
	

	
}

