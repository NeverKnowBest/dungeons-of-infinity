enum DecorType{
	Mural,
	LargeMural,
	Column,
	Curtain,
	Lighting
}


enum CurtainType{
	Curtain,
	Vines
}

enum WallSegmentStatus{
	Invalid,
	Valid,
	Valid_NoColumn,
	Valid_MuralOnly
}

global.DecorTileW[DecorType.Mural] = 4;
global.DecorTileW[DecorType.LargeMural] = 8;
global.DecorTileW[DecorType.Column] = 2;
global.DecorTileW[DecorType.Curtain] = 4;
global.DecorTileW[DecorType.Lighting] = 4;

global.RoomLightsOn = 0; 
global.RoomLightsOn_Max = 0;
global.ReplacedMuralWithLight = false;

#macro LargeMuralPal ((global.Level.Index - DungeonLevel.Aghanim1) * 6)


function LevelCurtainType(_Level){
	
	//returns curtain type for level, -1 if no curtains are used
	switch(_Level){
		case DungeonLevel.Castle:
		case DungeonLevel.CastleJails:
		case DungeonLevel.Aghanim1:
		case DungeonLevel.Aghanim3:
			return CurtainType.Curtain;
			
		case DungeonLevel.Sewers:
		case DungeonLevel.Ruins1:
			return CurtainType.Vines;
		
	}
	
	return -1;
	
}


function Decor_Draw(_RoomIndex, _DecorType, _Wall, _Segment, _DecorStyle = 0){
	
	switch(_Wall.gid){
		case TemplateObjGID.WallSideT:
		case TemplateObjGID.WallSideB:
			var PosX = _Wall.x + (_Segment * 8);
			var PosY = _Wall.y;
			break;
		
		case TemplateObjGID.WallSideL:
		case TemplateObjGID.WallSideR:
			var PosX = _Wall.x;
			var PosY = _Wall.y + (_Segment * 8);
			break;		
	}	
	
	switch(_DecorType){
		case DecorType.Column:
			var Mirror = FlipCoin_Bool();
			switch(_Wall.gid){
				case TemplateObjGID.WallSideT:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 152, LevelTilesY, 2, 3, Mirror);	
					DrawTileBlock(global.TMID_Water_Upper, PosX, PosY+24, 152, LevelTilesY + 3, 2, 1, Mirror);	
					break;
					
				case TemplateObjGID.WallSideB:
					DrawTileBlock(global.TMID_Water_Upper, PosX, PosY - 8, 154, LevelTilesY, 2, 1, Mirror);	
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 154, LevelTilesY + 1, 2, 3, Mirror);	
					
					break;
					
				case TemplateObjGID.WallSideL:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 152, LevelTilesY + 4, 3, 2);
					DrawTileBlock(global.TMID_Water_Upper, PosX + 24, PosY, 155, LevelTilesY + 4, 1, 2);					
					break;
					
				case TemplateObjGID.WallSideR:
					DrawTileBlock(global.TMID_Water_Upper, PosX - 8, PosY, 148, LevelTilesY + 4, 1, 2);
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 149, LevelTilesY + 4, 3, 2);
					
					break;
					
			}
			break;
							
		case DecorType.Mural:
			switch(_Wall.gid){
				case TemplateObjGID.WallSideT:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 132 + (_DecorStyle * 10), LevelTilesY, 4, 3);
					break;
				case TemplateObjGID.WallSideB:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 132 + (_DecorStyle * 10), LevelTilesY + 3, 4, 3);
					break;
				case TemplateObjGID.WallSideL:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 136 + (_DecorStyle * 10), LevelTilesY, 3, 4);
					break;					
				case TemplateObjGID.WallSideR:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 139 + (_DecorStyle * 10), LevelTilesY, 3, 4);
					break;	
			}
			break;
			
		case DecorType.LargeMural:
			switch(_Wall.gid){
				case TemplateObjGID.WallSideT:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 122 + (_DecorStyle * 8), VillageTilesY + LargeMuralPal, 8, 3);
					break;
				case TemplateObjGID.WallSideB:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 122 + (_DecorStyle * 8), VillageTilesY + 3 + LargeMuralPal, 8, 3);
					break;
				case TemplateObjGID.WallSideL:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 138 + LargeMuralPal, VillageTilesY + (_DecorStyle * 8), 3, 8);
					break;					
				case TemplateObjGID.WallSideR:
					DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 141 + LargeMuralPal, VillageTilesY + (_DecorStyle * 8), 3, 8);
					break;	
			}
			break;
			
		case DecorType.Lighting:
			
			var CreateLight = true;
			var LightStatus = true;
			
			var LightsInProximity = false;
			var LightsInProximityList = ds_list_create();
			//first do wall lights
			var Lights = collision_circle_list(PosX + 16, PosY + 12, 50, oWallLight, true, true, LightsInProximityList, false);
			
			for(var i = 0; i < Lights; i++){
				//these lights are in proximity, but might be in different Rooms. If they are in the same Room, then they are flagged and will be destroyed
				var Light = LightsInProximityList[| i];
				if(point_in_rectangle(PosX, PosY, Room.x, Room.y, Room.x + Room.width - 1, Room.y + Room.height - 1)){
					LightsInProximity = true;
					break;
				}
			}
			//then check for torches
			ds_list_clear(LightsInProximityList);
			var Lights = collision_circle_list(PosX + 16, PosY + 12, 50, oTorch, true, true, LightsInProximityList, false);
			
			for(var i = 0; i < Lights; i++){
				//these lights are in proximity, but might be in different Rooms. If they are in the same Room, then they are flagged and will be destroyed
				var Light = LightsInProximityList[| i];
				if(point_in_rectangle(PosX, PosY, Room.x, Room.y, Room.x + Room.width - 1, Room.y + Room.height - 1)){
					LightsInProximity = true;
					break;
				}
			}
			ds_list_destroy(LightsInProximityList);
			
			if(LightsInProximity){
				CreateLight = false;
			}else{
			
				if(Room.Lighting){
					LightStatus = (Prob(Chance_Decor_Lights_Lit) || _DecorStyle == 1) && global.RoomLightsOn < global.RoomLightsOn_Max;
					if(LightStatus) global.RoomLightsOn++;
				}
				
			}
			
			if(CreateLight){
				switch(_Wall.gid){
					case TemplateObjGID.WallSideT:
						var LightInst = instance_create_layer(PosX, PosY + 8, "Objs_Upper", oWallLight, {Location : TOP, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideB:
						var LightInst = instance_create_layer(PosX, PosY, "Objs_Upper", oWallLight, {Location : BOTTOM, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideR:
						var LightInst = instance_create_layer(PosX, PosY, "Objs_Upper", oWallLight, {Location : RIGHT, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideL:
						var LightInst = instance_create_layer(PosX + 8, PosY, "Objs_Upper", oWallLight, {Location : LEFT, Status: LightStatus});
						break;					

				}
			}

			break;
			
	}	
	
}

function Decor_Draw_FillWall(_RoomIndex, _Wall, _DecorType, _Amount, _Style = 0){
	
	var WallTileLen = Decor_WallTileLen(_Wall);
	
	var TileW = global.DecorTileW[_DecorType];

	if(_Amount == 0) exit;
	
	var DecorSpaceW = _Amount * TileW;
	var Spaces = _Amount + 1;
	

	var SpaceW = floor((WallTileLen - DecorSpaceW) / Spaces) + 1;
	var TotalMuralSpace = DecorSpaceW + ((Spaces - 2) * SpaceW);
	var Segment = floor((WallTileLen - TotalMuralSpace) / 2);
	
	for(var i = 0; i < _Amount; i++){				
		if(Decor_Wall_GetSegmentStatus(_Wall, _DecorType, Segment, TileW)){
			Decor_Draw(_RoomIndex, _DecorType, _Wall, Segment, _Style);
			Decor_Wall_SetSegmentStatus(_Wall, Segment, TileW, WallSegmentStatus.Invalid);
		}
		Segment += (TileW + SpaceW);
	}
	
}



function Decor_FillWallFromSegment(_RoomIndex, _Wall, _DecorType, _Segment, _Spacing, _Dir, _DecorStyle = 0){

	var TileW = global.DecorTileW[_DecorType];
	
	while(Decor_Wall_GetSegmentStatus(_Wall, _DecorType, _Segment, TileW)){
		if(_DecorType == DecorType.Mural && !global.ReplacedMuralWithLight && Prob(Chance_Decor_ReplaceMuralWithLight)){
			//sometimes replace a mural with a light, but only once per wall
			Decor_Draw(_RoomIndex, DecorType.Lighting, _Wall, _Segment, _DecorStyle);
			global.ReplacedMuralWithLight = true;
		}else{
			Decor_Draw(_RoomIndex, _DecorType, _Wall, _Segment, _DecorStyle);
		}
		Decor_Wall_SetSegmentStatus(_Wall, _Segment, TileW, WallSegmentStatus.Invalid);
		_Segment += ((TileW + _Spacing) * _Dir);
	}

				
}


function Decor_WallTileLen(_Wall){
	
	switch(_Wall.gid){
		case TemplateObjGID.WallSideT:
		case TemplateObjGID.WallSideB:
			return _Wall.TileW;
			break;
		
		case TemplateObjGID.WallSideL:
		case TemplateObjGID.WallSideR:
			return _Wall.TileH;
			break;		
	}	
	
}


//function Decor_Wall_CalculateMaxDecors(_Wall, _DecorW, _Spacing){
	
//	var SpaceLeft = Decor_WallTileLen(_Wall);
//	var MaxDecors = 0;
//	while(SpaceLeft >= _DecorW){
//		MaxDecors++;
//		SpaceLeft -= (_DecorW + _Spacing);
//	}
	
//	return MaxDecors;
	
//}

function Decor_Wall_GetSegmentStatus(_Wall, _DecorType, _SegmentX, _Segments){
	
	//check if _Segments elements at _SegmentX are all valid
	//If any segment as code Invalid, the return false
	//If no invalid segment, but some Valid_NoColumn, return false if decortype is column, return true if mural/light
	//If no invalid segment, but some Valid_MuralOnly, return false if decortype isn't a mural
	//If all Valid codes, return true
	
	var WallTileLen = Decor_WallTileLen(_Wall);
	
	
	for(var i = 0; i < _Segments; i++){
		
		var SegmentIndex = _SegmentX + i;
		//check if segments added at _SegmentX will go over wall array width
		if( SegmentIndex >= WallTileLen || SegmentIndex < 0) return false;
		
		if(_Wall.WallSegments[SegmentIndex] == WallSegmentStatus.Invalid) return false;

		if(_DecorType == DecorType.Column && _Wall.WallSegments[SegmentIndex] == WallSegmentStatus.Valid_NoColumn) return false;
		
		if(_DecorType != DecorType.Mural && _DecorType != DecorType.LargeMural && _Wall.WallSegments[SegmentIndex] == WallSegmentStatus.Valid_MuralOnly) return false;
		
	}
	
	return true
}

function Decor_Wall_SetSegmentStatus(_Wall, _SegmentX, _Segments, _Code){
		
	var WallTileLen = Decor_WallTileLen(_Wall);
	
	//check if segments accessed at _SegmentX will go over wall array width. If so, set _Segments to be max that _Wall can hold
	if( (_SegmentX + _Segments) > WallTileLen ) _Segments = WallTileLen - _SegmentX;
	
	//sets the _Wall segments to _Code starting at _SegmentX for _Segment elements
	for(var i = 0; i < _Segments; i++){
		_Wall.WallSegments[_SegmentX + i] = _Code;		
	}

}