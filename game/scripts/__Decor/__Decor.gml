enum DecorType{
	Mural,
	LargeMural,
	Column,
	Curtain,
	Lighting,
	Cracks
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

			DrawTileBlock(global.TMID_Decor_Upper, PosX, PosY, 118 + ((_DecorStyle * 8)), VillageTilesY + 8, 8, 3);
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
					LightStatus = (Prob(Chance_Decor_Lights_Lit) || _DecorStyle == 1) && global.RoomLightsOn < global.RoomLightsOn_Max && global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights;
					if(LightStatus) global.RoomLightsOn++;
				}
				
			}
			
			if(CreateLight){
				switch(_Wall.gid){
					case TemplateObjGID.WallSideT:
						var LightInst = instance_create_layer(PosX, PosY + 8, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : TOP, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideB:
						var LightInst = instance_create_layer(PosX, PosY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : BOTTOM, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideR:
						var LightInst = instance_create_layer(PosX, PosY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : RIGHT, Status: LightStatus});
						break;
					case TemplateObjGID.WallSideL:
						var LightInst = instance_create_layer(PosX + 8, PosY, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : LEFT, Status: LightStatus});
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
	var SpaceW = floor((WallTileLen - DecorSpaceW) / Spaces) + 2;
	
	var TotalSpace = DecorSpaceW + ((Spaces - 2) * SpaceW);
	var Segment = floor((WallTileLen - TotalSpace) / 2);
	
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

function LevelCurtainType(_Level){
	
	//returns curtain type for level, -1 if no curtains are used
	switch(_Level){
		case DungeonLevel.Castle:
		case DungeonLevel.CastleJails:
		case DungeonLevel.Aghanim1:
			return CurtainType.Curtain;
			
		case DungeonLevel.Sewers:
		case DungeonLevel.Ruins:
			return CurtainType.Vines;
		
	}
	
	return -1;
	
}

function Decor_Monuments_AllowedStyle(_MonumentX, _MonumentY, _ForceSafe = false){

	var _StyleList = ds_list_create_sequence(0, 3);
			
	//make sure certain styles aren't picked if monument is below a certain y coordinate (chairs, certain statues)
	var _BottomSpaceCheck = (collision_rectangle(_MonumentX, _MonumentY + 32, _MonumentX + 31, _MonumentY + 71, oWall, false, true));
	if(_BottomSpaceCheck || _ForceSafe){//remove any stlye from list that shouldn't be too far below or close to a wall (chairs)
		switch(global.Level.Index){
			case DungeonLevel.Castle: 
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				break;
			case DungeonLevel.Catacombs:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				ds_list_finddelete(_StyleList, 2);
				break;
			case DungeonLevel.LanmolasLair:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);				
				break;						
			case DungeonLevel.Ruins:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				ds_list_finddelete(_StyleList, 2);
				break;		
			case DungeonLevel.WaterTemple:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				ds_list_finddelete(_StyleList, 2);
				break;		
			case DungeonLevel.MoldormsLair:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				break;
			case DungeonLevel.Aghanim1:
				ds_list_finddelete(_StyleList, 0);
				ds_list_finddelete(_StyleList, 1);
				ds_list_finddelete(_StyleList, 2);
				break;
		}
	}
	
	if(global.Level.Index == DungeonLevel.Catacombs && !global.Level.CatacombGrave){
		if(ds_list_find_index(_StyleList, 2) != -1){
			ds_list_destroy(_StyleList);
			return 2 //force grave if available and not used in level, as it's only used once and we want it every time
		}
	}
	
	if(global.Level.Index == DungeonLevel.Aghanim1 && !global.Gore){
		ds_list_finddelete(_StyleList, 3);
		if(ds_list_size(_StyleList) == 0){
			ds_list_add(_StyleList, 1, 2); //last resort, these are decent anywhere if none are available
		}
	}
	
	ds_list_shuffle(_StyleList);
	var _Style = _StyleList[| 0];
	ds_list_destroy(_StyleList);
	
	return _Style;
}

function Cracks_MaxAmount(){
	
	var _Amount = 0;
	var _P = 0;
	
	switch(global.Level.Index){
		
		case DungeonLevel.CastleBasement:
			_Amount = 1;
			_P = 0.05;
			break;
			
		case DungeonLevel.CastleJails:
			_Amount = choose(1, 1, 1, 1, 2, 2, 3);
			_P = 0.1;
			break;
			
		case DungeonLevel.Sewers:
		case DungeonLevel.LanmolasLair:
		case DungeonLevel.WaterTemple:
		case DungeonLevel.Aghanim1:
			_Amount = irandom_range(1, 5);
			_P = 0.15;
			break;			
		
		case DungeonLevel.Catacombs:
			_Amount = irandom_range(1, 12);
			_P = 0.35;
			break;
		
		case DungeonLevel.Ruins:
		case DungeonLevel.MoldormsLair:
			_Amount = irandom_range(1, 20);
			_P = 0.6;
			break;			

	}
	
	return Prob(_P) ? _Amount : 0;	
	
}

function Decor_MonumentItems(_TMID, _MonumentX, _MonumentY, _MonumentStyle, _Mirrored){
	
	var _PosX = _MonumentX;
	var _PosY = _MonumentY + 8;
	var _TileX = 116 + (_MonumentStyle * 4);
	var _TileW = 4;
	var _ItemStyle = 0;
	
	switch(global.Level.Index){
		
		default: exit;
		
		case DungeonLevel.Castle:
			if(Prob(0.85)) exit;
			_PosY = _MonumentY;
			break;
			
		case DungeonLevel.CastleBasement:
			if(Prob(0.75)) exit;
			break;
		
		case DungeonLevel.CastleJails:
			
			if(Prob(0.6) && _MonumentStyle != 2) exit; //always put something on the metal/grey table
			
			if(!global.Gore){
				if(Prob(0.6)) exit; //exit more often if no gore, that way it's not full of hammers
			}
			
			var _ItemList = ds_list_create_sequence(0, 3);

			if(global.Level.JailMonumentItem_DeadFemale || !global.Gore) ds_list_finddelete(_ItemList, 1);
			if(global.Level.JailMonumentItem_DeadMale || !global.Gore) ds_list_finddelete(_ItemList, 2);
			if(!global.Gore){
				ds_list_finddelete(_ItemList, 3);
			}

			if(_MonumentStyle == 3) ds_list_finddelete(_ItemList, 0); //don't put the tools on the platform
			
			if(ds_list_size(_ItemList) == 0) exit;
			
			ds_list_shuffle(_ItemList);
			_ItemStyle = _ItemList[| 0];
			ds_list_destroy(_ItemList);
			
			switch(_ItemStyle){
				case 0: //hammer & pliers
					_TileX = 116;
					break;
				case 1: //female
					_TileX = 120;
					global.Level.JailMonumentItem_DeadFemale = true;
					break;
				case 2: //male
					_TileX = 124;
					global.Level.JailMonumentItem_DeadMale = true;
					break;
				case 3: //sword
					_TileX = 128;
					break;
						
			}
			
			break;			
		
		
		case DungeonLevel.Catacombs:
			
			switch(_MonumentStyle){
				case 0:
					exit;
					break;
				case 1: //tomb
					_ItemStyle = irandom(3);
					var _PosX = _MonumentX + 8;
					_TileX = 116 + (_ItemStyle * 2);
					_TileW = 2;
					break;
				case 2: //grave
					if(global.Level.CatacombGrave){
						_ItemStyle = 0;
					}else{

						_ItemStyle = 1;
						
						var _HeadingIndex = DialogueCycle(global.CatacombGraveHeadings, global.Users[global.UserIndex].UsedCatacombGraveHeadings)

						SignCreate(_MonumentX + 16, _MonumentY + 32, global.CatacombGraveHeadings[_HeadingIndex], true); //grave sign
						
						global.Level.CatacombGrave = true;

					}
					_PosX = _MonumentX + 8;
					_TileX = 124 + (_ItemStyle * 2);
					_TileW = 2;
					break;
				case 3: //platform
					if(Prob(0.75)) exit;
					_ItemStyle = irandom(1);
					var _PosX = _MonumentX + 8;
					_PosY = _MonumentY;
					_TileX = 128 + (_ItemStyle * 2);
					_TileW = 2;					
					break;
			}			

			break;
			
		case DungeonLevel.Mines:

			switch(_MonumentStyle){
				case 0: //blacksmith
					if(Prob(0.5)) exit;
					break;
				case 1: //Gem table
					_ItemStyle = irandom(2);
					_TileX = 120 + (_ItemStyle * 4);
					break;
				case 2: //rock
				case 3: //vase
					exit			
					break;
			}	
			break;
			
	}
	
	DrawTileBlock(_TMID, _PosX, _PosY, _TileX, LevelTilesY + 4, _TileW, 2, _Mirrored);
	
	return _ItemStyle;
	
}