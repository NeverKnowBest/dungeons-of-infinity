

function Dungeon_Draw_WallDecor(){
	
	//#macro Room global.Dungeon[$ "Rooms"][global.RoomIndex]
	
	var DecorType = Prob(Chance_Decor_LightsForMurals) ? 1 : 0;
	
	var ForceLighting = false;
	
	if(global.DungeonDepth == DungeonLevel.Village && (global.RoomIndex == 6 || global.RoomIndex == 17)){
		//dark hallways in village should be dark and lit
		ForceLighting = true;
		DecorType = 1;
	}
	
	
	
	var PositionGroup = GetPositionGroups();

	if(PositionGroup == -1) exit;
	
	//Get additional mural data
	var MuralArray = global.Data_RoomTemplates[global.RoomTemplate].Decor;
	var MuralCount = array_length(MuralArray);
	
	for(var MuralIndex = 0; MuralIndex < MuralCount; MuralIndex++){
		var Mural = MuralArray[MuralIndex];
		var MuralProperties = Mural.properties;
		
		switch(Mural.gid){
			case TemplateObjGID.WallMuralT: var MuralLocation = "Top"; break;
			case TemplateObjGID.WallMuralB: var MuralLocation = "Bottom"; break;
			case TemplateObjGID.WallMuralL: var MuralLocation = "Left"; break;
			case TemplateObjGID.WallMuralR: var MuralLocation = "Right"; break;
			
		}
		MuralData[MuralIndex] = {
			ID : ord(GetPropertyValue(MuralProperties, "ID")) - 65,
			PositionX : Mural.x,
			PositionY : Mural.y,
			Location : MuralLocation,
			GID : Mural.gid			
		}
		
	}


	var Groups = array_length(PositionGroup);
	if(Groups == 0) exit;
	
	var PositionGroupOrder = ds_list_create(); //will hold a shuffled list of 0 to Groups - 1 so we don't always check the same order of position groups
	for(var i = 0; i < Groups; i++){
		ds_list_add(PositionGroupOrder, i);
	}
	ds_list_shuffle(PositionGroupOrder);		
	
	var RoomSizeIndex = GetRoomSizeIndex(Room.GridW, Room.GridH);
	
	//Check if positions in group has empty spots. If not try next group
	for(var PositionGroupOrderIndex = 0; PositionGroupOrderIndex < Groups; PositionGroupOrderIndex++){
			
		var PositionGroupIndex = PositionGroupOrder[| PositionGroupOrderIndex];
			
		var Positions = ds_list_size(PositionGroup[PositionGroupIndex]);
		
		var PositionsValid = true;

		for(var PositionIndex = 0; PositionIndex < Positions; PositionIndex++){
			
			var DoorPositionStr = PositionGroup[PositionGroupIndex][| PositionIndex];
			
			//position might be a letter for the extra murals. If it's a letter, we use MuralData, otherwise use door data
			var DoorPositionStr_Num = string_digits(DoorPositionStr);
			var DoorPositionStr_Let = string_letters(DoorPositionStr);
			
			if(DoorPositionStr_Num != ""){ //if it's a number(door position), then check for doors
				var DoorPosition = real(DoorPositionStr_Num);
				if(DoorPosition > 100) DoorPosition -= 100; //positions that are for large murals have 100 added(112 would be a large mural at position 12)
				var DoorPositionX = global.DoorCoordinates[RoomSizeIndex][DoorPosition].x;
				var DoorPositionY = global.DoorCoordinates[RoomSizeIndex][DoorPosition].y;
				var DoorLocation = global.DoorCoordinates[RoomSizeIndex][DoorPosition].Location;
			}else{
				var MuralIndex = ord(string_upper(DoorPositionStr_Let)) - 65; //for letters used for extra murals, lower case means no large murals allowed, upper case means large murals allowed
				if(MuralIndex >= 32) MuralIndex -= 32;
				var DoorPositionX = MuralData[MuralIndex].PositionX;
				var DoorPositionY = MuralData[MuralIndex].PositionY;
				var DoorLocation = MuralData[MuralIndex].Location;				
			}

			var DoorCoordinateX = Room[$ "x"] + DoorPositionX;
			var DoorCoordinateY = Room[$ "y"] + DoorPositionY;
			
			var DoorInst = instance_position(DoorCoordinateX + 8, DoorCoordinateY + 8, oDoor);
			if(DoorInst != noone){
				if(DoorInst.SecretType != SecretDoor.Blank && DoorInst.SecretType != SecretDoor.Illusion){
					PositionsValid = false;
					break;
				}
			}
			
			var CurtainInst = collision_rectangle(DoorCoordinateX, DoorCoordinateY, DoorCoordinateX + 32, DoorCoordinateY + 24, oCurtain, false, true);
			if(CurtainInst != noone) PositionsValid = false;
			
			
			//Check if room is dark(using lighting). If so, check for stores since they add a wall light above them.
			//We don't want any lights added above or next to them, and no murals added above them since they may overlap
			//Check for Shop's hidden wall since shop obj doesn't have collision mask.
			if(Room.Lighting && DecorType == 1){
				var ShopWallInst = noone;
				switch(DoorLocation){
					case "Top":	var ShopWallInst = collision_rectangle(DoorCoordinateX - 16, DoorCoordinateY + 32, DoorCoordinateX + 47, DoorCoordinateY + 64, oWall, false, true);	break;		
					case "Left": var ShopWallInst = collision_rectangle(DoorCoordinateX + 24, DoorCoordinateY - 16, DoorCoordinateX + 48, DoorCoordinateY + 47, oWall, false, true); break;				
					case "Right": var ShopWallInst = collision_rectangle(DoorCoordinateX - 48, DoorCoordinateY - 16, DoorCoordinateX - 24, DoorCoordinateY + 47, oWall, false, true); break;
				}
				if(ShopWallInst != noone){
					if(ShopWallInst.ShopInst != noone)	PositionsValid = false;
				}	
			}
			
			if(!PositionsValid) break; 
			
		}
					
		if(PositionsValid) break; 
		
	}
	
	if(!PositionsValid) exit; //no valid groups were found
	
	var MuralStyle = FlipCoin_Bin();
	var LargeMuralStyleH = 122 + (FlipCoin_Bool() ? 8 : 0);
	var LargeMuralStyleV = 92 + (FlipCoin_Bool() ? 8 : 0);
	var LargeMuralPal = ((global.DungeonDepth - DungeonLevel.Aghanim1) * 6);
	
	ds_list_shuffle(PositionGroup[PositionGroupIndex]);
	
	var LightCount = 0; 
	var MaxLights = min(3 * Room.GridW * Room.GridH, 8);
	//if more than 3 lights are used, then always set remaining to off. We shuffle position list so it's not always the same lights that get turned off.
	//Positions in group are valid, draw decor at those positions

	
	for(var PositionIndex = 0; PositionIndex < Positions; PositionIndex++){
		
		var LargeMural = false;
		
		var DoorPositionStr = PositionGroup[PositionGroupIndex][| PositionIndex];
		
		//position might be a letter for the extra murals. If it's a letter, we use MuralData, otherwise use door data
		var DoorPositionStr_Num = string_digits(DoorPositionStr);
		var DoorPositionStr_Let = string_letters(DoorPositionStr);
			
		if(DoorPositionStr_Num != ""){ //if it's a number(door position), then check for doors
			var DoorPosition = real(DoorPositionStr_Num);
			if(DoorPosition > 100){ //positions that are for large murals have 100 added(112 would be a large mural at position 12)
				LargeMural = true;
				DoorPosition-=100;
			}
			var DoorPositionX = global.DoorCoordinates[RoomSizeIndex][DoorPosition].x;
			var DoorPositionY = global.DoorCoordinates[RoomSizeIndex][DoorPosition].y;
			var DoorLocation = global.DoorCoordinates[RoomSizeIndex][DoorPosition].Location;
			
		}else{
			
			var MuralIndex = ord(DoorPositionStr_Let) - 65;
			if(MuralIndex < 32){ //Upper case letter, large mural allowed
				LargeMural = true;
			}else MuralIndex -= 32;
			var DoorPositionX = MuralData[MuralIndex].PositionX;
			var DoorPositionY = MuralData[MuralIndex].PositionY;
			var DoorLocation = MuralData[MuralIndex].Location;				
		}

		var DoorCoordinateX = Room[$ "x"] + DoorPositionX;
		var DoorCoordinateY = Room[$ "y"] + DoorPositionY;
		
		if(global.DungeonDepth < DungeonLevel.Aghanim1) LargeMural = false;
		
		switch(DoorLocation){
			case "Top":
						
				if(DecorType == 0){ //mural
					if(LargeMural)
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX - 16, DoorCoordinateY, LargeMuralStyleH, 92 + LargeMuralPal, 8, 3);
					else
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY, 132 + (MuralStyle * 10), LevelTilesY, 4, 3);					
				}else{ //lights
					var LightInst = instance_create_layer(DoorCoordinateX, DoorCoordinateY + 8, "Objs_Upper", oWallLight);
					LightInst.Location = TOP;								
				}
	
				break;
				
			case "Bottom":

				if(DecorType == 0){ //mural
					if(LargeMural)
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX - 16, DoorCoordinateY, LargeMuralStyleH, 95 + LargeMuralPal, 8, 3);
					else					
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY, 132 + (MuralStyle * 10), LevelTilesY + 3, 4, 3);
				}else{ //lights
					var LightInst = instance_create_layer(DoorCoordinateX, DoorCoordinateY, "Objs_Upper", oWallLight);
					LightInst.Location = BOTTOM;	
				}
				
				break;			
				
			case "Left":

				if(DecorType == 0){ //mural
					if(LargeMural)
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY - 16, 138 + LargeMuralPal, LargeMuralStyleV, 3, 8);
					else	
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY, 136 + (MuralStyle * 10), LevelTilesY, 3, 4);
				}else{ //lights
					var LightInst = instance_create_layer(DoorCoordinateX + 8, DoorCoordinateY, "Objs_Upper", oWallLight);
					LightInst.Location = LEFT;	
				}

				break;

				
			case "Right":
						
				if(DecorType == 0){ //mural
					if(LargeMural)
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY - 16, 141 + LargeMuralPal, LargeMuralStyleV, 3, 8);
					else	
						DrawTileBlock(global.TMID_Tiles_Decor_Upper, DoorCoordinateX, DoorCoordinateY, 139 + (MuralStyle * 10), LevelTilesY, 3, 4);
				}else{ //lights
					var LightInst = instance_create_layer(DoorCoordinateX, DoorCoordinateY, "Objs_Upper", oWallLight);
					LightInst.Location = RIGHT;	
				}

				break;
		}
		if(DecorType == 1){
			if(Room.Lighting){
				LightInst.Status = (Prob(Chance_Decor_Lights_Lit) || ForceLighting) && LightCount < MaxLights;
				if(LightInst.Status) LightCount++;
			}else{
				LightInst.Status = true;
			}
		}
			
		
	}


	ds_list_destroy(PositionGroupOrder);
	
	for(var i = 0; i < Groups; i++){
		ds_list_destroy(PositionGroup[i]);
		PositionGroup[i] = 0;
	}
	
}


function GetPositionGroups(){
	
	//returns an array holding all the decor position groups as lists
	var PositionGroupStr = GetPropertyValue(global.Data_RoomTemplates[global.RoomTemplate][$ "properties"], "DecorGroups");
	if(PositionGroupStr != -1){
					
		var _PositionGroups = SplitStrToArray(PositionGroupStr, "\n"); //this now holds the csv's at each index, we still need to sepearate those into lists
		
		var RoomTransformation = global.Data_RoomTemplates[global.RoomTemplate].RoomTransformation;

		var Groups = array_length(_PositionGroups);
		var PositionGroups = array_create(0);
		for(var PositionGroupIndex = 0; PositionGroupIndex < Groups; PositionGroupIndex++){
			var CSV = _PositionGroups[PositionGroupIndex];
			array_insert(PositionGroups, PositionGroupIndex, CSVToList(CSV));
			
			//transform positions based on room transform
			var Positions = ds_list_size(PositionGroups[PositionGroupIndex])
			for(var PosIndex = 0; PosIndex < Positions; PosIndex++){
				var Pos = PositionGroups[PositionGroupIndex][| PosIndex];
				var PosStr_Num = string_digits(Pos);
				if(PosStr_Num != ""){
					PosStr_Num = real(PosStr_Num);
					var PosStr_Num_Original = PosStr_Num;
					if(PosStr_Num > 100) PosStr_Num -= 100; //large murals will have 100 added, so subtract 100 for now to get the position, then add it back on
					PosStr_Num = GetTransformedDoorPosition(PosStr_Num, RoomTransformation);
					if(PosStr_Num_Original > 100) PosStr_Num += 100;
					ds_list_replace(PositionGroups[PositionGroupIndex], PosIndex, string(PosStr_Num));
				}
			}

			
		}
		return PositionGroups;
	}
	
	return -1;
	
}

