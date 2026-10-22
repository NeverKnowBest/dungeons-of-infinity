// Feather disable GM2064
enum JailType{
	Prisoner,
	Open,
	Locked	
}

function Dungeon_Draw_Jail(_RoomIndex, _X, _Y, _TileW, _TileH, _Type){

	DrawTileBlock(global.TMID_Tiles_Highest, _X, _Y, 56, 0, 1, 1); //TL
	//top beam
	for(var i = 0; i < _TileW - 2; i++){
		DrawTileBlock(global.TMID_Tiles_Highest, _X + 8 + (i * 8), _Y, 57, 0, 1, 1);
	}
	DrawTileBlock(global.TMID_Tiles_Highest, _X + ((_TileW - 1) * 8), _Y, 61, 0, 1, 1); //TR

	//tile widths for each side of entrance including half of entrance width
	var TilesW_LeftSide = floor(_TileW / 2);
	var TilesW_RightSide = _TileW - TilesW_LeftSide;
	var RightSideX = _X + (TilesW_LeftSide * 8);
	
	var _W = _TileW * 8;
	
	var _ChecksX = _X + (_W / 2);
	var _ChecksY = _Y + 32;
	
	var FloorLevelStr = GetFloorLevelString(_ChecksX, _ChecksY);
	var JailBaseWallLayer = GetFloorLevelTMID("Tiles_Walls", _ChecksX, _ChecksY);
	
	
	var JailIsInSection = InSectionArea(_RoomIndex, _ChecksX, _ChecksY, Room.Section_ID, true);
	
	var _Index, WallInst;
	switch(_Type){
		
		case JailType.Prisoner:

			//top vertical bars
			for(var i = 0; i < _TileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, _X + 16 + (i * 8), _Y + 8, 57, 1, 1, 1);
			}				

			//top horizontal bars
			DrawTileBlock(global.TMID_Tiles_Higher, _X + 8, _Y + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), _Y + 16, 61, 2, 1, 1);
			for(var i = 0; i < _TileW - 4; i++){ //left side
				DrawTileBlock(global.TMID_Tiles_Higher, _X + 16 + (i * 8), _Y + 16, 57, 2, 1, 1);
			}

			//bottom bars
			for(var i = 0; i < _TileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Decor_Upper, _X + 16 + (i * 8), _Y + 24, 57, 3, 1, 1);
			}
			DrawTileBlock(global.TMID_Decor_Upper, RightSideX - 8, _Y + 16, 58, 2, 1, 1);
			DrawTileBlock(global.TMID_Decor_Upper, RightSideX - 8, _Y + 24, 58, 3, 1, 1);
			
			//left base walls
			DrawTileBlock(JailBaseWallLayer, _X + 24, _Y + 32, 56, 3, 1, 1);
			for(var i = 0; i < _TileW - 8; i++){ 
				DrawTileBlock(JailBaseWallLayer, _X + 32 + (i * 8), _Y + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, _X + _W - 32, _Y + 32, 56, 3, 1, 1);
		
			WallInst = WallObj_Create("Objs_" + FloorLevelStr, _X + 24, _Y + 24, _TileW - 6, 2);
			
			//Light
			if(Room.Lighting && global.ChallengeOptions[ChallengeOption.Darkness] != ChallengeOption_Darkness.NoLights){
				instance_create_layer(_X + (TilesW_LeftSide * 8) - 16, _Y - 32, "ObjsDoors_Upper", oWallLight, {RoomIndex : _RoomIndex, Location : TOP, Status: true});
			}
			
			AddUsedSpace(_RoomIndex, _X + 24, _Y - 16, _X + _W - 25, _Y - 1, UsedSpaceType.Obj, JailIsInSection);
			
			//prisoner
			if(ds_list_size(global.UnusedPrisoners) == 0){
				//if all prisoners were used, just use dead prisoner
				_Index = choose(Prisoner.Dead1, Prisoner.Dead2, Prisoner.Dead3);
			}else{
				//pick first prisoner index from shuffled list, then delete it from the list so it's not picked twice
				_Index = global.UnusedPrisoners[| 0];
				ds_list_delete(global.UnusedPrisoners, 0);
				
				if(_Index = Prisoner.WetBandits){
					Room.WetBandits = true;
					Dungeon_Draw_Water(_RoomIndex);
				}
				
			}

			
			if(!global.Gore && (_Index == Prisoner.Dead1 || _Index == Prisoner.Dead2 || _Index == Prisoner.Dead3)) break;


			var _BufferW = (_W - 96) / 2;
			instance_create_layer(_ChecksX + irandom_range(-_BufferW, _BufferW), _Y + 8, "Objs_" + FloorLevelStr, oPrisoner, {Index : _Index});				
			
			break;
		
		case JailType.Open:
		case JailType.Locked:

			//top vertical bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, _X + 16 + (i * 8), _Y + 8, 57, 1, 1, 1);
			}		
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Tiles_Higher, _X + (TilesW_LeftSide * 8) + 8 + (i * 8), _Y + 8, 60, 1, 1, 1);
			}

			//top horizontal bars
			DrawTileBlock(global.TMID_Tiles_Higher, _X + 8, _Y + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), _Y + 16, 61, 2, 1, 1);
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //left side
				DrawTileBlock(global.TMID_Tiles_Higher, _X + 16 + (i * 8), _Y + 16, 57, 2, 1, 1);
			}
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //right side
				DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + 8 + (i * 8), _Y + 16, 59, 2, 1, 1);
			}
		
			//bottom bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Decor_Upper, _X + 16 + (i * 8), _Y + 24, 57, 3, 1, 1);
			}			
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Decor_Upper, RightSideX + 8 + (i * 8), _Y + 24, 59, 3, 1, 1);
			}

			//left base walls
			DrawTileBlock(JailBaseWallLayer, _X + 24, _Y + 32, 56, 3, 1, 1);
			for(var i = 0; i < TilesW_LeftSide - 6; i++){ 
				DrawTileBlock(JailBaseWallLayer, _X + 32 + (i * 8), _Y + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, _X + (TilesW_LeftSide * 8) - 16, _Y + 32, 56, 3, 1, 1);
		
			//right base wall
			DrawTileBlock(JailBaseWallLayer, RightSideX + 8, _Y + 32, 56, 3, 1, 1);
			for(var i = 0; i < TilesW_RightSide - 6; i++){ 
				DrawTileBlock(JailBaseWallLayer, RightSideX + 16 + (i * 8), _Y + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, RightSideX + (TilesW_RightSide * 8) - 32, _Y + 32, 56, 3, 1, 1);
		
			WallInst = WallObj_Create("Objs_" + FloorLevelStr, _X + 24, _Y + 24, TilesW_LeftSide - 4, 2);
			WallInst = WallObj_Create("Objs_" + FloorLevelStr, RightSideX + 8, _Y + 24, TilesW_RightSide - 4, 2);

		
			//Lock
			if(_Type == JailType.Locked){
				var KeyBlockInst = instance_create_layer(RightSideX - 8, _Y + 16, "Objs_" + FloorLevelStr, oKeyBlock);	
				KeyBlockInst.RoomIndex = _RoomIndex;
				//add key block to map items list. Any locked door above was already removed from that list
				ds_list_add(global.LargeMapItems, KeyBlockInst);
			
			}

			//add used space in front of jail entrance.
			AddUsedSpace(_RoomIndex, RightSideX - 8, _Y + 32, RightSideX + 8, _Y + 64, UsedSpaceType.Obj, JailIsInSection);
		
			break;
		
	}
			
	AddUsedSpace(_RoomIndex, _X + 24, _Y, _X + _W - 25, _Y + 31, UsedSpaceType.Obj, JailIsInSection);

		
}