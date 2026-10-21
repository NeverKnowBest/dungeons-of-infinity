function Dungeon_SaveLevel(){

	//save each layer's tile data
	for(var _TileLayerIndex = 0; _TileLayerIndex < TileLayers; _TileLayerIndex++){
		for(_RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
			var RoomTileX = Room.GridX * 32;
			var RoomTileY = Room.GridY * 32;
			var RoomTileGridW = Room.GridW * 32;
			var RoomTileGridH = Room.GridH * 32;
			for(_TileY = 0; _TileY < RoomTileGridH; _TileY++){
				for(_TileX = 0; _TileX < RoomTileGridW; _TileX++){
					Room.Tiles[_TileLayerIndex][_TileY][_TileX] = tilemap_get(global.TMID[_TileLayerIndex], RoomTileX + _TileX, RoomTileY + _TileY);
				}
			}
		}
		
	}
	
	//Link

	global.Level.SaveData.Link_Health = oLink.Health;
	global.Level.SaveData.Link_HealthMax = oLink.HealthMax;
	global.Level.SaveData.Link_Magic = oLink.Magic;
	global.Level.SaveData.Link_Rupees = oLink.Rupees;
	global.Level.SaveData.Link_Keys = oLink.Keys;
	global.Level.SaveData.Link_Arrows = oLink.Arrows;
	global.Level.SaveData.Link_Bombs = oLink.Bombs;
	
	//Inventory
	for(var _Slot = 0; _Slot < global.Inventory_SlotLimit; _Slot++){
		global.Level.SaveData.Inventory[_Slot][0] = global.Inventory[_Slot][0];
		global.Level.SaveData.Inventory[_Slot][1] = global.Inventory[_Slot][1];		
	}
	
	//Wall Objs
	global.Level.SaveData.Objs_Walls = [];
	with(oWall){
		if(object_index != oKeyBlock && object_index != oPushBlock){
			array_push(global.Level.SaveData.Objs_Walls, [x, y, layer, image_xscale, image_yscale, FloorLevel, BlockLink, BlockLinkCarry, BlockEnemies, BlockProjectiles, BlockItems, Moved, IsHiddenTreasure, SwitchBlockInst, IsSwitchBlock, AllowedDir])
		}
	}
	
	//Door Objs
	global.Level.SaveData.Objs_Doors = [];
	with(oDoor){
		array_push(global.Level.SaveData.Objs_Doors, [x, y, layer, sprite_get_name(sprite_index), FloorLevel, Status, RoomIndex, Location, Position, Entrance, DownStairs, ConnectedRoomIndex, SecretType, PassageArea, WallInst.x, WallInst.y]);
	}

	//Curtain Objs
	global.Level.SaveData.Objs_Curtains = [];
	with(oCurtain){
		array_push(global.Level.SaveData.Objs_Curtains, [x, y, Location, Revealed, DoorInst != noone ? DoorInst.x : -1, DoorInst != noone ? DoorInst.y : -1]);
	}

	//Pot Objs
	global.Level.SaveData.Objs_Pots = [];
	with(oPot){
		array_push(global.Level.SaveData.Objs_Pots, [x, y, layer, FloorLevel, ContentsObj, WallObj.x, WallObj.y]);
	}

	//Treasure Objs
	global.Level.SaveData.Objs_Treasures = [];
	with(oItem_Treasure){
		array_push(global.Level.SaveData.Objs_Treasures, [x, y, layer, sprite_get_name(sprite_index), visible, FloorLevel, ContentsObj, Opened, IsSwitchTreasure, WallInst != noone ? WallInst.x : -1, WallInst != noone ? WallInst.y : -1]);
	}

	//Crystal Objs
	global.Level.SaveData.Objs_Crystals = [];
	with(oCrystalSwitch){
		array_push(global.Level.SaveData.Objs_Crystals, [x, y, layer, FloorLevel, RoomIndex]);
	}
	
	//Dead Guys
	global.Level.SaveData.Objs_DeadGuys = [];
	with(oDeadGuy){
		array_push(global.Level.SaveData.Objs_DeadGuys, [x, y, layer, image_index, ItemHolding, WallObj.x, WallObj.y]);
	}
	
	//Heart Guys
	global.Level.SaveData.Objs_HeartGuys = [];
	with(oHeartGuy){
		array_push(global.Level.SaveData.Objs_HeartGuys, [x, y, layer, Type, WallObj.x, WallObj.y]);
	}
	
	//Torch Objs
	global.Level.SaveData.Objs_Torches = [];
	with(oTorch){
		array_push(global.Level.SaveData.Objs_Torches, [x, y, layer, Lit, FloorLevel, GroupIndex, Action, Switch, TreasureInst != noone ? TreasureInst.x : -1, TreasureInst != noone ? TreasureInst.y : -1]);
	}
	
	//WallLight Objs
	global.Level.SaveData.Objs_WallLights = [];
	with(oWallLight){
		array_push(global.Level.SaveData.Objs_WallLights, [x, y, layer, Location, Status]);
	}


	//SwitchBlock Objs
	global.Level.SaveData.Objs_SwitchBlocks = [];
	with(oSwitchBlock){
		array_push(global.Level.SaveData.Objs_SwitchBlocks, [X1, Y1, layer, X2, Y2, Color, Raised, ImgIndex, 
															Corner_TL, Corner_TR, Corner_BL, Corner_BR, 
															Segment_L, Segment_R, Segment_T, Segment_B, 
															Segment_L_Y, Segment_L_H, Segment_R_Y, Segment_R_H, 
															Segment_T_X, Segment_T_W, Segment_B_X, Segment_B_W, 
															Segment_L_Wall != noone ? Segment_L_Wall.x : -1, Segment_L_Wall != noone ? Segment_L_Wall.y : -1, 
															Segment_R_Wall != noone ? Segment_R_Wall.x : -1, Segment_R_Wall != noone ? Segment_R_Wall.y : -1,
															Segment_T_Wall != noone ? Segment_T_Wall.x : -1, Segment_T_Wall != noone ? Segment_T_Wall.y : -1, 
															Segment_B_Wall != noone ? Segment_B_Wall.x : -1, Segment_B_Wall != noone ? Segment_B_Wall.y : -1]);
	}

	//Shop Objs
	global.Level.SaveData.Objs_Shops = [];
	with(oShop){
		array_push(global.Level.SaveData.Objs_Shops, [x, y, layer, RoomIndex, ShopW, ShopH, ShopType, ItemsSold]);
	}

	//ShopKeeper Objs
	global.Level.SaveData.Objs_ShopKeepers = [];
	with(oShopKeeper){
		array_push(global.Level.SaveData.Objs_ShopKeepers, [x, y, layer, ShopType, sprite_index]);
	}

	//Item Objs
	global.Level.SaveData.Objs_Items = [];
	with(oItem){
		if(object_index != oItem_Treasure){
			array_push(global.Level.SaveData.Objs_Items, [x, y, layer, object_index, Index, FloorLevel, Name, From, Amount, ShowAmount, Price, ShowPrice, ShopItem]);
		}
	}

	//Kinstone Objs
	global.Level.SaveData.Objs_Kinstones = [];
	with(oItem_Kinstone_Main){
		array_push(global.Level.SaveData.Objs_Kinstones, [x, y, layer, Index, RoomIndex]);
	}

	//KeyBlock Objs
	global.Level.SaveData.Objs_KeyBlocks = [];
	with(oKeyBlock){
		array_push(global.Level.SaveData.Objs_KeyBlocks, [x, y, layer, RoomIndex, Unlocked]);
	}

	//PushBlock Objs
	global.Level.SaveData.Objs_PushBlocks = [];
	with(oPushBlock){
		array_push(global.Level.SaveData.Objs_PushBlocks, [x, y, layer, Moved, Action, TreasureInst != noone ? TreasureInst.x : -1, TreasureInst != noone ? TreasureInst.y : -1]);
	}

	//FloorSwitch Objs
	global.Level.SaveData.Objs_FloorSwitches = [];
	with(oFloorSwitch){
		array_push(global.Level.SaveData.Objs_FloorSwitches, [x, y, layer, Action, TreasureInst != noone ? TreasureInst.x : -1, TreasureInst != noone ? TreasureInst.y : -1]);
	}

	
	//Ennemies
	global.Level.SaveData.Objs_Enemies = [];
	with(oEnemy){

		
		//skip the following enemies
		switch(object_index){
			case oBoss_Armos:
			case oBoss_Moldorm:
			case oEnemy_Guru:
			case oEnemy_Kyameron_Moving:	
				continue;
		}
			
		var SaveVariableStruct = {};
		for(var i = 0; i < array_length(SaveVariables); i++){
			var VarName = SaveVariables[i];
			variable_struct_set(SaveVariableStruct, VarName, variable_instance_get(self, VarName));
		}


		
		array_push(global.Level.SaveData.Objs_Enemies, [Reset_StartX, Reset_StartY, layer, object_index, FloorLevel, ItemHolding, RoomTemplate, SectionID, RoomX, RoomY, SaveVariableStruct]);
	}	
	
	//Enemy Traps
	global.Level.SaveData.Objs_EnemyTraps = [];
	with(oEnemyTrap){
		array_push(global.Level.SaveData.Objs_EnemyTraps, [x, y]);
	}
	
	//Guru Bars
	global.Level.SaveData.Objs_GuruBars = [];
	with(oEnemy_Guru_Bar){
		array_push(global.Level.SaveData.Objs_GuruBars, [x, y, layer, object_index, FloorLevel, ItemHolding, RoomTemplate, SectionID, RoomX, RoomY]);
	}

	//Fairies
	global.Level.SaveData.Objs_Fairies_Health = [];
	with(oFairy_Health){
		array_push(global.Level.SaveData.Objs_Fairies_Health, [x, y, layer, RoomIndex]);
	}

	//Prisoners
	global.Level.SaveData.Objs_Prisoners = [];
	with(oPrisoner){
		array_push(global.Level.SaveData.Objs_Prisoners, [x, y, layer, Index, GaveLetter, GaveRupees]);
	}
	
	global.Users[global.UserIndex].LevelData = StructCopy(global.Level);
	
}

function Dungeon_LoadLevel(){
	
	global.Level = StructCopy(global.Users[global.UserIndex].LevelData);
	
	//global.Users[global.UserIndex].LevelData.SaveData = 0;
	
	for(var _TileLayerIndex = 0; _TileLayerIndex < TileLayers; _TileLayerIndex++){
		for(var _RoomIndex = 0; _RoomIndex < global.Level.RoomCount; _RoomIndex++){
				
			global.Level.Map_TemplateIndex[Room.GridY][Room.GridX] = Room.TemplateIndex;
				
			var RoomTileX = Room.GridX * 32;
			var RoomTileY = Room.GridY * 32;
			var RoomTileGridW = Room.GridW * 32;
			var RoomTileGridH = Room.GridH * 32;
			for(_TileY = 0; _TileY < RoomTileGridH; _TileY++){
				for(_TileX = 0; _TileX < RoomTileGridW; _TileX++){
					tilemap_set(global.TMID[_TileLayerIndex], Room.Tiles[_TileLayerIndex][_TileY][_TileX], RoomTileX + _TileX, RoomTileY + _TileY);
				}
			}
		}
		
	}

	oLink.Health = global.Level.SaveData.Link_Health;
	oLink.HealthMax = global.Level.SaveData.Link_HealthMax;
	oLink.Magic = global.Level.SaveData.Link_Magic;
	oLink.Rupees = global.Level.SaveData.Link_Rupees;
	oLink.Keys = global.Level.SaveData.Link_Keys;
	oLink.Arrows = global.Level.SaveData.Link_Arrows;
	oLink.Bombs = global.Level.SaveData.Link_Bombs;
	
	//Inventory
	for(var _Slot = 0; _Slot < global.Inventory_SlotLimit; _Slot++){
		var _ObjIndex = global.Level.SaveData.Inventory[_Slot][0];
		var _ItemIndex = global.Level.SaveData.Inventory[_Slot][1];
		if(_ObjIndex != -1) Inventory_Add(_ObjIndex, _ItemIndex, _Slot);	
	}
	
	var _WallCount = array_length(global.Level.SaveData.Objs_Walls);
	for(var _WallIndex = 0; _WallIndex < _WallCount; _WallIndex++){
		var _Wall = global.Level.SaveData.Objs_Walls[_WallIndex];
		var WallInst = instance_create_layer(_Wall[0], _Wall[1], _Wall[2], oWall);
		var i = 3;
		WallInst.image_xscale = _Wall[i++];
		WallInst.image_yscale = _Wall[i++];			
		WallInst.FloorLevel = _Wall[i++];
		WallInst.BlockLink = _Wall[i++];
		WallInst.BlockLinkCarry = _Wall[i++];
		WallInst.BlockEnemies = _Wall[i++];
		WallInst.BlockProjectiles = _Wall[i++];
		WallInst.BlockItems = _Wall[i++];
		WallInst.Moved = _Wall[i++];
		WallInst.IsHiddenTreasure = _Wall[i++];
		WallInst.SwitchBlockInst = _Wall[i++];
		WallInst.IsSwitchBlock = _Wall[i++];
		WallInst.AllowedDir = _Wall[i++];
		
	}


	var _DoorCount = array_length(global.Level.SaveData.Objs_Doors);
	for(var _DoorIndex = 0; _DoorIndex < _DoorCount; _DoorIndex++){
		var _Door = global.Level.SaveData.Objs_Doors[_DoorIndex];
		var DoorInst = instance_create_layer(_Door[0], _Door[1], _Door[2], oDoor);
		var i = 3;
			
		DoorInst.sprite_index = asset_get_index(_Door[i++]);
		DoorInst.FloorLevel = _Door[i++];
		DoorInst.Status = _Door[i++];
		DoorInst.RoomIndex = _Door[i++];
		DoorInst.Location = _Door[i++];
		DoorInst.Position = _Door[i++];
		DoorInst.Entrance = _Door[i++];
		DoorInst.DownStairs = _Door[i++];
		DoorInst.ConnectedRoomIndex = _Door[i++];
		DoorInst.SecretType = _Door[i++];
		DoorInst.PassageArea = _Door[i++];
			
		var WallInstX = _Door[i++];
		var WallInstY = _Door[i++];
		with(oWall){
			if(x == WallInstX && y == WallInstY){
				DoorInst.WallInst = id;
				break;
			}
		}
	}
		
	var _PotCount = array_length(global.Level.SaveData.Objs_Pots);
	for(var _PotIndex = 0; _PotIndex < _PotCount; _PotIndex++){
		var _Pot = global.Level.SaveData.Objs_Pots[_PotIndex];
		var PotInst = instance_create_layer(_Pot[0], _Pot[1], _Pot[2], oPot);
		PotInst.FloorLevel = _Pot[3];
		PotInst.ContentsObj = _Pot[4];
		var WallInstX = _Pot[5];
		var WallInstY = _Pot[6];
		with(oWall){
			if(x == WallInstX && y == WallInstY){
				PotInst.WallObj = id;
				break;
			}
		}
	}
		
	//[x, y, layer, sprite_get_name(sprite_index), visible, FloorLevel, ContentsObj, Opened, IsSwitchTreasure, WallInst != noone ? WallInst.x : -1, WallInst != noone ? WallInst.y : -1]
	var _TreasureCount = array_length(global.Level.SaveData.Objs_Treasures);
	for(var _TreasureIndex = 0; _TreasureIndex < _TreasureCount; _TreasureIndex++){
		var _Treasure = global.Level.SaveData.Objs_Treasures[_TreasureIndex];
		var TreasureInst = instance_create_layer(_Treasure[0], _Treasure[1], _Treasure[2], oItem_Treasure);
		var i = 3;
		TreasureInst.sprite_index = asset_get_index(_Treasure[i++]);
		TreasureInst.visible = _Treasure[i++];
		TreasureInst.FloorLevel = _Treasure[i++];
		TreasureInst.ContentsObj = _Treasure[i++];
		TreasureInst.Opened = _Treasure[i++];
		if(TreasureInst.Opened) TreasureInst.image_index = 1;
		TreasureInst.IsSwitchTreasure = _Treasure[i++];
		
		var WallInstX = _Treasure[i++];
		var WallInstY = _Treasure[i++];
		if(WallInstX != -1 && WallInstY != -1){
			with(oWall){
				if(x == WallInstX && y == WallInstY){
					TreasureInst.WallInst = id;
					break;
				}
			}
		}

	}
		

	var _CrystalCount = array_length(global.Level.SaveData.Objs_Crystals);
	for(var _CrystalIndex = 0; _CrystalIndex < _CrystalCount; _CrystalIndex++){
		var _Crystal = global.Level.SaveData.Objs_Crystals[_CrystalIndex];
		var CrystalInst = instance_create_layer(_Crystal[0], _Crystal[1], _Crystal[2], oCrystalSwitch);
		CrystalInst.FloorLevel = _Crystal[3];
		CrystalInst.RoomIndex = _Crystal[4];
	}		
	
	//[x, y, layer, image_index, ItemHolding, WallObj.x, WallObj.y]
	var _DeadGuyCount = array_length(global.Level.SaveData.Objs_DeadGuys);
	for(var _DeadGuyIndex = 0; _DeadGuyIndex < _DeadGuyCount; _DeadGuyIndex++){
		var _DeadGuy = global.Level.SaveData.Objs_DeadGuys[_DeadGuyIndex];
		var DeadGuyInst = instance_create_layer(_DeadGuy[0], _DeadGuy[1], _DeadGuy[2], oDeadGuy);
		DeadGuyInst.image_index = _DeadGuy[3];
		DeadGuyInst.ItemHolding = _DeadGuy[4];
		var WallInstX = _DeadGuy[5];
		var WallInstY = _DeadGuy[6];
		with(oWall){
			if(x == WallInstX && y == WallInstY){
				DeadGuyInst.WallObj = id;
				break;
			}
		}
	}
	
	var _HeartGuyCount = array_length(global.Level.SaveData.Objs_HeartGuys);
	for(var _HeartGuyIndex = 0; _HeartGuyIndex < _HeartGuyCount; _HeartGuyIndex++){
		var _HeartGuy = global.Level.SaveData.Objs_HeartGuys[_HeartGuyIndex];
		var HeartGuyInst = instance_create_layer(_HeartGuy[0], _HeartGuy[1], _HeartGuy[2], oHeartGuy, {Type : _HeartGuy[3]});
		var WallInstX = _HeartGuy[4];
		var WallInstY = _HeartGuy[5];
		with(oWall){
			if(x == WallInstX && y == WallInstY){
				HeartGuyInst.WallObj = id;
				break;
			}
		}
	}
	
	var _TorchCount = array_length(global.Level.SaveData.Objs_Torches);
	for(var _TorchIndex = 0; _TorchIndex < _TorchCount; _TorchIndex++){
		var _Torch = global.Level.SaveData.Objs_Torches[_TorchIndex];
		var TorchInst = instance_create_layer(_Torch[0], _Torch[1], _Torch[2], oTorch, {Lit: _Torch[3]});
		var i = 4;
		TorchInst.FloorLevel = _Torch[i++];
		TorchInst.GroupIndex = _Torch[i++];
		TorchInst.Action = _Torch[i++];
		TorchInst.Switch = _Torch[i++];
			
		var TreasureInstX = _Torch[i++];
		var TreasureInstY = _Torch[i++];
		if(TreasureInstX != -1 && TreasureInstY != -1){
			with(oItem_Treasure){
				if(x == TreasureInstX && y == TreasureInstY){
					TorchInst.TreasureInst = id;
					break;
				}
			}
		}
	}


	
	//[x, y, layer, Location, Status]
	var _WallLightCount = array_length(global.Level.SaveData.Objs_WallLights);
	for(var _WallLightIndex = 0; _WallLightIndex < _WallLightCount; _WallLightIndex++){
		var _WallLight = global.Level.SaveData.Objs_WallLights[_WallLightIndex];
		instance_create_layer(_WallLight[0], _WallLight[1], _WallLight[2], oWallLight, {Location: _WallLight[3], Status : _WallLight[4]});
	}
	
	var _CurtainCount = array_length(global.Level.SaveData.Objs_Curtains);
	for(var _CurtainIndex = 0; _CurtainIndex < _CurtainCount; _CurtainIndex++){
		var _Curtain = global.Level.SaveData.Objs_Curtains[_CurtainIndex];
			
		var _DoorInst = noone;
		var _DoorInstX = _Curtain[4];
		var _DoorInstY = _Curtain[5];
		if(_DoorInstX != -1 && _DoorInstY != -1){
			with(oDoor){
				if(x == _DoorInstX && y == _DoorInstY){
					_DoorInst = id;
					break;
				}
			}
		}
		var CurtainInst = instance_create_layer(_Curtain[0], _Curtain[1], "Objs_Upper", oCurtain, {Location : _Curtain[2], DoorInst : _DoorInst});
		CurtainInst.Revealed = _Curtain[3];

	}		
		

												//[X1, Y1, layer, X2, Y2, Color, Raised, ImgIndex, 
												//Corner_TL, Corner_TR, Corner_BL, Corner_BR, 
												//Segment_L, Segment_R, Segment_T, Segment_B, 
												//Segment_L_Y, Segment_L_H, Segment_R_Y, Segment_R_H, 
												//Segment_T_X, Segment_T_W, Segment_B_X, Segment_B_W, 
												//Segment_L_Wall.x, Segment_L_Wall.y, Segment_R_Wall.x, Segment_R_Wall.y,
												//Segment_T_Wall.x, Segment_T_Wall.y, Segment_B_Wall.x, Segment_B_Wall.y]

	var _SBCount = array_length(global.Level.SaveData.Objs_SwitchBlocks);
	for(var _SBIndex = 0; _SBIndex < _SBCount; _SBIndex++){
		var _SB = global.Level.SaveData.Objs_SwitchBlocks[_SBIndex];

		var SBInst = instance_create_layer(_SB[0], _SB[1], _SB[2], oSwitchBlock);
		SBInst.X1 = _SB[0];
		SBInst.Y1 = _SB[1];
		var i = 3;
		SBInst.X2 = _SB[i++];
		SBInst.Y2 = _SB[i++];
		SBInst.Color = _SB[i++];
		SBInst.Raised = _SB[i++];
		SBInst.ImgIndex = _SB[i++];
		SBInst.Corner_TL = _SB[i++]; SBInst.Corner_TR = _SB[i++]; SBInst.Corner_BL = _SB[i++]; SBInst.Corner_BR = _SB[i++];
		SBInst.Segment_L = _SB[i++]; SBInst.Segment_R = _SB[i++]; SBInst.Segment_T = _SB[i++]; SBInst.Segment_B = _SB[i++];
		SBInst.Segment_L_Y = _SB[i++]; SBInst.Segment_L_H = _SB[i++];
		SBInst.Segment_R_Y = _SB[i++]; SBInst.Segment_R_H = _SB[i++];
		SBInst.Segment_T_X = _SB[i++]; SBInst.Segment_T_W = _SB[i++];
		SBInst.Segment_B_X = _SB[i++]; SBInst.Segment_B_W = _SB[i++];
			
		var Segment_L_WallInstX = _SB[i++];
		var Segment_L_WallInstY = _SB[i++];
		if(Segment_L_WallInstX != -1 && Segment_L_WallInstY != -1){
			with(oWall){
				if(x == Segment_L_WallInstX && y == Segment_L_WallInstY){
					SBInst.Segment_L_Wall = id;
					break;
				}
			}
		}
			
		var Segment_R_WallInstX = _SB[i++];
		var Segment_R_WallInstY = _SB[i++];
		if(Segment_R_WallInstX != -1 && Segment_R_WallInstY != -1){
			with(oWall){
				if(x == Segment_R_WallInstX && y == Segment_R_WallInstY){
					SBInst.Segment_R_Wall = id;
					break;
				}
			}
		}
			
		var Segment_T_WallInstX = _SB[i++];
		var Segment_T_WallInstY = _SB[i++];
		if(Segment_T_WallInstX != -1 && Segment_T_WallInstY != -1){
			with(oWall){
				if(x == Segment_T_WallInstX && y == Segment_T_WallInstY){
					SBInst.Segment_T_Wall = id;
					break;
				}
			}
		}
			
		var Segment_B_WallInstX = _SB[i++];
		var Segment_B_WallInstY = _SB[i++];
		if(Segment_B_WallInstX != -1 && Segment_B_WallInstY != -1){
			with(oWall){
				if(x == Segment_B_WallInstX && y == Segment_B_WallInstY){
					SBInst.Segment_B_Wall = id;
					break;
				}
			}
		}
			

	}	

	var _ShopCount = array_length(global.Level.SaveData.Objs_Shops);
	for(var _ShopIndex = 0; _ShopIndex < _ShopCount; _ShopIndex++){
		var Shop = global.Level.SaveData.Objs_Shops[_ShopIndex];
		
		var _ShopInst = instance_create_layer(Shop[0], Shop[1], Shop[2], oShop, {RoomIndex : Shop[3], ShopW : Shop[4], ShopH : Shop[5], ShopType : Shop[6]});	
		_ShopInst.ItemsSold = Shop[7];
		_ShopInst.Setup = false;
		
		with(_ShopInst){
			Slots = Shop_GetSlotCount();
		}
		with(oWall){
			if(x == _ShopInst.x + 8 && y == _ShopInst.y + 8){
				ShopInst = _ShopInst.id;
				break;
			}
		}
			
	}	

	var _ShopKeeperCount = array_length(global.Level.SaveData.Objs_ShopKeepers);
	for(var _ShopKeeperIndex = 0; _ShopKeeperIndex < _ShopKeeperCount; _ShopKeeperIndex++){
		var _ShopKeeper = global.Level.SaveData.Objs_ShopKeepers[_ShopKeeperIndex];
		
		var _ShopKeeperInst = instance_create_layer(_ShopKeeper[0], _ShopKeeper[1], _ShopKeeper[2], oShopKeeper, {ShopType : _ShopKeeper[3]});	
		_ShopKeeperInst.sprite_index = _ShopKeeper[4];
		
		with(oShop){
			if(_ShopKeeperInst.x >= x && _ShopKeeperInst.y >= y && _ShopKeeperInst.x <= x + ShopW && _ShopKeeperInst.y <= y + ShopH){
				_ShopKeeperInst.ShopInst = id;
				break;	
			}
			
		}
			
	}
	
	var _ItemCount = array_length(global.Level.SaveData.Objs_Items);
	for(var _ItemIndex = 0; _ItemIndex < _ItemCount; _ItemIndex++){
		var _Item = global.Level.SaveData.Objs_Items[_ItemIndex];
		
		var ItemInst = instance_create_layer(_Item[0], _Item[1], _Item[2], _Item[3]);	
		var i = 4;
		with(ItemInst) Item_SetIndex(_Item[i++]);
		ItemInst.FloorLevel = _Item[i++];
		ItemInst.Name = _Item[i++];
		ItemInst.From = _Item[i++];
		ItemInst.Amount = _Item[i++];
		ItemInst.ShowAmount = _Item[i++];
		ItemInst.Price = _Item[i++];
		ItemInst.ShowPrice = _Item[i++];
		ItemInst.ShopItem = _Item[i++];
		ItemInst.Setup = false;
	}		
	
	//[x, y, layer, Index, RoomIndex]
	var _KinstoneCount = array_length(global.Level.SaveData.Objs_Kinstones);
	for(var _KinstoneIndex = 0; _KinstoneIndex < _KinstoneCount; _KinstoneIndex++){
		var _Kinstone = global.Level.SaveData.Objs_Kinstones[_KinstoneIndex];
		var _Index = _Kinstone[3];
		var _RoomIndex = _Kinstone[4];
		instance_create_layer(_Kinstone[0], _Kinstone[1], _Kinstone[2], oItem_Kinstone_Main, {Index : _Index, RoomIndex : _RoomIndex});	
	}		

	var _KeyBlockCount = array_length(global.Level.SaveData.Objs_KeyBlocks);
	for(var _KeyBlockIndex = 0; _KeyBlockIndex < _KeyBlockCount; _KeyBlockIndex++){
		var _KeyBlock = global.Level.SaveData.Objs_KeyBlocks[_KeyBlockIndex];
		var KeyBlockInst = instance_create_layer(_KeyBlock[0], _KeyBlock[1], _KeyBlock[2], oKeyBlock);
		KeyBlockInst.RoomIndex = _KeyBlock[3];
		KeyBlockInst.Unlocked = _KeyBlock[4];
	}	
	

	var _PushBlockCount = array_length(global.Level.SaveData.Objs_PushBlocks);
	for(var _PushBlockIndex = 0; _PushBlockIndex < _PushBlockCount; _PushBlockIndex++){
		var _PushBlock = global.Level.SaveData.Objs_PushBlocks[_PushBlockIndex];
		var PushBlockInst = instance_create_layer(_PushBlock[0], _PushBlock[1], _PushBlock[2], oPushBlock);
		var i = 3;
		PushBlockInst.Moved = _PushBlock[i++];
		PushBlockInst.Action = _PushBlock[i++];
		var TreasureX = _PushBlock[i++];
		var TreasureY = _PushBlock[i++];
		if(TreasureX != -1 && TreasureY != -1){
			with(oItem_Treasure){
				if(x == TreasureX && y == TreasureY){
					PushBlockInst.TreasureInst = id;
					break;
				}
			}
		}
	}	

	var _FloorSwitchCount = array_length(global.Level.SaveData.Objs_FloorSwitches);
	for(var _FloorSwitchIndex = 0; _FloorSwitchIndex < _FloorSwitchCount; _FloorSwitchIndex++){
		var _FloorSwitch = global.Level.SaveData.Objs_FloorSwitches[_FloorSwitchIndex];
		var FloorSwitchInst = instance_create_layer(_FloorSwitch[0], _FloorSwitch[1], _FloorSwitch[2], oFloorSwitch);
		var i = 3;
		FloorSwitchInst.Action = _FloorSwitch[i++];
		var TreasureX = _FloorSwitch[i++];
		var TreasureY = _FloorSwitch[i++];
		if(TreasureX != -1 && TreasureY != -1){
			with(oItem_Treasure){
				if(x == TreasureX && y == TreasureY){
					FloorSwitchInst.TreasureInst = id;
					break;
				}
			}
		}
	}	


	var _EnemyCount = array_length(global.Level.SaveData.Objs_Enemies);
	for(var _EnemyIndex = 0; _EnemyIndex < _EnemyCount; _EnemyIndex++){
		var _Enemy = global.Level.SaveData.Objs_Enemies[_EnemyIndex];
		

		var i = 4;
		var _FloorLevel = _Enemy[i++];
		var _ItemHolding = _Enemy[i++];
		var _RoomTemplate = _Enemy[i++];
		var _SectionID = _Enemy[i++];
		var _RoomX = _Enemy[i++];
		var _RoomY = _Enemy[i++];
		
		var EnemyInst = instance_create_layer(_Enemy[0], _Enemy[1], _Enemy[2], _Enemy[3], {FloorLevel : _FloorLevel, ItemHolding : _ItemHolding, RoomTemplate : _RoomTemplate, SectionID : _SectionID, RoomX : _RoomX, RoomY : _RoomY});

		var SaveVariableStruct = _Enemy[i++];
		var VariableNames = variable_struct_get_names(SaveVariableStruct);
		
		for(var i = 0; i < array_length(VariableNames); i++){
			var VarName = VariableNames[i];
			variable_instance_set(EnemyInst, VarName, variable_struct_get(SaveVariableStruct, VarName));
		}

	}	

	var _EnemyTrapCount = array_length(global.Level.SaveData.Objs_EnemyTraps);
	for(var _EnemyTrapIndex = 0; _EnemyTrapIndex < _EnemyTrapCount; _EnemyTrapIndex++){
		var _EnemyTrap = global.Level.SaveData.Objs_EnemyTraps[_EnemyTrapIndex];
		instance_create_layer(_EnemyTrap[0], _EnemyTrap[1], "System", oEnemyTrap);
	}
	
	var _GuruBarCount = array_length(global.Level.SaveData.Objs_GuruBars);
	for(var _GuruBarIndex = 0; _GuruBarIndex < _GuruBarCount; _GuruBarIndex++){
		var _GuruBar = global.Level.SaveData.Objs_GuruBars[_GuruBarIndex];

		var i = 4;
		var _FloorLevel = _GuruBar[i++];
		var _ItemHolding = _GuruBar[i++];
		var _RoomTemplate = _GuruBar[i++];
		var _SectionID = _GuruBar[i++];
		var _RoomX = _GuruBar[i++];
		var _RoomY = _GuruBar[i++];
		
		instance_create_layer(_GuruBar[0], _GuruBar[1], _GuruBar[2], oEnemy_Guru_Bar, {FloorLevel : _FloorLevel, ItemHolding : _ItemHolding, RoomTemplate : _RoomTemplate, SectionID : _SectionID, RoomX : _RoomX, RoomY : _RoomY});
	}	

	var _FairyCount = array_length(global.Level.SaveData.Objs_Fairies_Health);
	for(var _FairyIndex = 0; _FairyIndex < _FairyCount; _FairyIndex++){
		var _Fairy = global.Level.SaveData.Objs_Fairies_Health[_FairyIndex];
		instance_create_layer(_Fairy[0], _Fairy[1], _Fairy[2], oFairy_Health, {RoomIndex : _Fairy[3]});
	}
	
	var _PrisonerCount = array_length(global.Level.SaveData.Objs_Prisoners);
	for(var _PrisonerIndex = 0; _PrisonerIndex < _PrisonerCount; _PrisonerIndex++){
		var _Prisoner = global.Level.SaveData.Objs_Prisoners[_PrisonerIndex];
		var _PrisonerInst = instance_create_layer(_Prisoner[0], _Prisoner[1], _Prisoner[2], oPrisoner, {Index : _Prisoner[3]});
		_PrisonerInst.GaveLetter = _Prisoner[4];
		_PrisonerInst.GaveRupees = _Prisoner[5];
	}	
	
}