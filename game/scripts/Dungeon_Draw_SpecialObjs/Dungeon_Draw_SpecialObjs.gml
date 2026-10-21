enum SpecialDungeonObj{
	None,
	Key,
	SpecialRoom,
	Crystal,
	DoorSwitch,
	Warp,
	Boss,
	House
}

enum SpecialObj{
	Pot,
	Treasure,
	Crystal,
	HeartGuy,
	DeadGuy,
	Torch,
	Warp,
	WarpDest
}

enum SpecialObjCombo{
	Pot,
	Treasure,
	Crystal,
	PotTreasure,
	TreasureCrystal,
	PotCrystal,
	PotTreasureCrystal
}

#macro KeySpawnMethods 7
enum SpawnMethod_Key{
	Pot,
	Treasure,
	Treasure_Switch,
	Enemy,
	DeadGuy,
	Monument,
	Altar
}

#macro TreasureSpawnMethods 4
enum SpawnMethod_Treasure{
	Normal,
	Switch,
	Monument,
	Altar	
}


global.SpikeTileID = GetTileID(30, 2);

function Dungeon_Draw_SpecialObjs(_RoomIndex){
	
	
	//This sets up the altars, monuments, pots, treasures, crystals, etc, based on if the Room needs keys, treasures, crystals, etc
	
	global.UsedObjs = ds_list_create(); //contains obj types and their index so they don't get used twice
	global.UsedSpaces = ds_list_create(); //contains occupied space from created objs, used for collision detection
	
	global.AltarData = {};
		
		
	//Store the objs for main/section  

	global.RoomTemplateObjLists_SpecialObjCombos_Main = array_create(0);
	global.RoomTemplateObjLists_SpecialObjCombos_Section = array_create(0);

	for(var SpecialObjComboTypeIndex = 0; SpecialObjComboTypeIndex < global.SpecialObjComboTypes; SpecialObjComboTypeIndex++){
		
		var SpecialObjComboType = global.SpecialObjComboTypeList[| SpecialObjComboTypeIndex];
		
		array_insert(global.RoomTemplateObjLists_SpecialObjCombos_Main, SpecialObjComboTypeIndex, ds_list_create());
		array_insert(global.RoomTemplateObjLists_SpecialObjCombos_Section, SpecialObjComboTypeIndex, ds_list_create());
			
		//go through each obj for current type and place in either Main or Section lists for that type
			
		var RoomTemplateObjArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ SpecialObjComboType];
		for(var SpecialObjComboType_ObjIndex = 0; SpecialObjComboType_ObjIndex < array_length(RoomTemplateObjArray); SpecialObjComboType_ObjIndex++){

			//Check if obj is inside SectionArea. If so add obj to RoomTemplateObjArray_SpecialObjCombos_Section. If not, RoomTemplateObjArray_SpecialObjCombos_Main.
			var Obj = RoomTemplateObjArray[SpecialObjComboType_ObjIndex];
			var ObjIsInSection = InSectionArea(_RoomIndex, Obj.x, Obj.y, Room.TemplateIndex, Room.Section_ID, false);
			var ObjList = (ObjIsInSection ? global.RoomTemplateObjLists_SpecialObjCombos_Section[SpecialObjComboTypeIndex] : global.RoomTemplateObjLists_SpecialObjCombos_Main[SpecialObjComboTypeIndex]);
			ds_list_add(ObjList, Obj);

		}

		
	}

	//Now to access all SpecialObjCombo Obj indexes from main or section, use this:
	//RoomTemplateObjIndexes_SpecialObjCombos_Main[SpecialObjComboID.Treasure][3]: obj from 3rd Treasure(1) in array
	//RoomTemplateObjIndexes_SpecialObjCombos_Section[SpecialObjComboID.TreasureCrystal][2]: obj from 2nd TreasureCrystal(4) in array
	//To count crystals, use array_length(RoomTemplateObjIndexes_SpecialObjCombos_Main[SpecialObjComboID.Crystal])


		
	
	//if(global.UsingChallengeArea){


		
	//	//Moving Floors
	//	var MovingFloorArray = global.ChallengeArea[$ "MovingFloors"];
	//	var MovingFloors = array_length(MovingFloorArray);
	//	for(var MovingFloorIndex = 0; MovingFloorIndex < MovingFloors; MovingFloorIndex++){
			
	//		var TilesW = MovingFloorArray[MovingFloorIndex].width / 16;
	//		var TilesH = MovingFloorArray[MovingFloorIndex].height / 16;
			
	//		for(var TileY = 0; TileY < TilesH; TileY++){
	//			for(var TileX = 0; TileX < TilesW; TileX++){
					
	//				var MovingFloorX = global.SpawnAreaX + MovingFloorArray[MovingFloorIndex].x + (TileX * 16);
	//				var MovingFloorY = global.SpawnAreaY + MovingFloorArray[MovingFloorIndex].y + (TileY * 16);	

	//				var MovingFloorInst = instance_create_layer(MovingFloorX, MovingFloorY, "Objs_" + GetFloorLevelString(MovingFloorX, MovingFloorY), oMovingFloor);
	//				switch(MovingFloorArray[MovingFloorIndex][$ "gid"]){
	//					case TemplateObjGID.MovingFloorLeft:
	//						MovingFloorInst.sprite_index = sMovingFloorLeft;
	//						MovingFloorInst.DirX = -1;
	//						break;
	//					case TemplateObjGID.MovingFloorRight:
	//						MovingFloorInst.sprite_index = sMovingFloorRight;
	//						MovingFloorInst.DirX = 1;
	//						break;
	//					case TemplateObjGID.MovingFloorUp:
	//						MovingFloorInst.sprite_index = sMovingFloorUp;
	//						MovingFloorInst.DirY = -1;
	//						break;
	//					case TemplateObjGID.MovingFloorDown:
	//						MovingFloorInst.sprite_index = sMovingFloorDown;
	//						MovingFloorInst.DirY = 1;
	//						break;
	//				}
			
	//			}
	//		}
		
	//	}
		
	//}



	global.SpawnedPots = false;
	global.SpawnedTreasure = false;
	global.SpawnedCrystal = false;
	global.SpawnedMonument = false;
	global.SpawnedKinstone = false;
	global.SpawnedAltar = false;
	global.SpawnedShop = false;
	global.SpawnedJail = false;
	global.SpawnedTorches = false;
	global.SpawnedRollingSpikes = false;
	global.SpawnedGuruBar = false;
	global.SpawnedEnemies = false;
	
	global.SpawnedBlocks = false;
	global.SpawnedBlocks_PatternIndex = 0;
	global.SpawnedBlocks_PatternSize = 0;
	global.SpawnedBlocks_GroupX = 0;
	global.SpawnedBlocks_GroupY = 0;
	global.SpawnedBlocks_TMID = 0;
	
	global.Switch_Spawned = false;
	global.Switch_Add = false;
	global.Switch_Action = SwitchAction.None;
	global.Switch_Inst = noone; 
	global.Switch_TreasureInst = noone; 
	global.Switch_TreasureItem = noone; 
	
	global.SpawnedWarp = false;
	global.SpawnedWarpDest = false;
	
	global.EnemyHasSpecialItem = false;
	
	SpawnSwitchBlocks(_RoomIndex);


	//if you're in the entrance or adjacent boss Room, don't draw any special objects.
	if( global.Level.IsBossLevel && _RoomIndex == global.Level.RoomIndex_BossAdjacent ) return true;	
	
	if(StartingRoom){
		global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone);
		return true;
	}
	
	if(global.Level.Index == DungeonLevel.CastleJails) global.SpawnedJail = SpawnJail(_RoomIndex, Room.UnusedZone);

	if(!global.SpawnedJail && Room.Section_ID == 0 && Prob(Chance_SpawnBlocks)) global.SpawnedBlocks = SpawnBlocks(_RoomIndex); 
	

	switch(Room.SpecialObject){
		
		case SpecialDungeonObj.Key:
		
			//shuffled list holding all the key spawn methods
			var KeySpawnMethodsList = ds_list_create_sequence(0, KeySpawnMethods - 1);
			ds_list_shuffle(KeySpawnMethodsList);
			
			var KeySpawned = false;
			while(!KeySpawned && ds_list_size(KeySpawnMethodsList) > 0){
			
				var KeySpawnMethod = KeySpawnMethodsList[| 0];
			
				switch(KeySpawnMethod){
					case SpawnMethod_Key.Pot:
						global.SpawnedPots = SpawnPots(_RoomIndex, Room.SpecialObject_InSection, oItem_Key);
						KeySpawned = global.SpawnedPots;
						break;
				
					case SpawnMethod_Key.Treasure:	
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, Room.SpecialObject_InSection, Room.UnusedZone, oItem_Key);
						KeySpawned = global.SpawnedTreasure;
						break;
				
					case SpawnMethod_Key.Treasure_Switch:
						if(Room.Section_ID == 0){
							global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.RevealTreasure, oItem_Key);
							KeySpawned = (global.Switch_Spawned == SpawnSwitch_ReturnCode.Success);
						}
						break;
				
					case SpawnMethod_Key.Enemy:	
						if(Room.Section_ID == 0){
							global.SpawnedEnemies = SpawnEnemies(_RoomIndex, oItem_Key);
							KeySpawned = (global.SpawnedEnemies && global.EnemyHasSpecialItem);
						}
						break;
				
					case SpawnMethod_Key.DeadGuy:	
						if(global.Level.Index >= DungeonLevel.Catacombs && global.Level.Index != DungeonLevel.Village ){
							if(Prob(Chance_DeadGuyKey)){
								global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.DeadGuy, Room.SpecialObject_InSection, Room.UnusedZone, oItem_Key);
								KeySpawned = global.SpawnedTreasure;
							}
						}
						break;
				
					case SpawnMethod_Key.Monument:
						global.SpawnedMonument = SpawnMonuments(_RoomIndex, Room.SpecialObject_InSection, Room.UnusedZone, oItem_Key);
						KeySpawned = global.SpawnedMonument;
						break;
				
					case SpawnMethod_Key.Altar:	
						global.SpawnedAltar = SpawnAltar(_RoomIndex, Room.SpecialObject_InSection, Room.UnusedZone, oItem_Key);
						KeySpawned = global.SpawnedAltar;
						break;
				
				}
			
				ds_list_delete(KeySpawnMethodsList, 0);
			
			}
		
			ds_list_destroy(KeySpawnMethodsList);
			
			if(!KeySpawned){
				//Error_Spawn(_RoomIndex, "key", false);	
				return false;
			}
			
			break;
			
			
		case SpecialDungeonObj.Crystal:
			global.SpawnedCrystal = SpawnObj(_RoomIndex, SpecialObj.Crystal, Room.SpecialObject_InSection, Room.UnusedZone, noone);
			if(!global.SpawnedCrystal){
				//Error_Spawn(_RoomIndex, "crystal", false);
				return false;
			}
			break;
		
		
		case SpecialDungeonObj.DoorSwitch:
			global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.OpenDoors);
			if(global.Switch_Spawned == SpawnSwitch_ReturnCode.AddSwitchFail){
				//Error_Spawn(_RoomIndex, "door switch", false);
				return false;
			}
			break;
		
		case SpecialDungeonObj.Warp:
			global.SpawnedWarp = SpawnWarp(_RoomIndex);
			if(!global.SpawnedWarp){
				//Error_Spawn(_RoomIndex, "warp", false);	
				return false;
			}
			break;
			
		case SpecialDungeonObj.None: //only spawn these if there's no special items

			//Shop
			if(global.Level.Index > DungeonLevel.Castle && Room.Secret == -1 && global.Level.ShopCount < global.Level.MaxShops && !global.SpawnedJail){
				if(Prob(global.Level.Index == DungeonLevel.CastleJails? Chance_Shop * 3 : Chance_Shop)){ //more chances in jail level since it's hard to find space since jails are always being drawn first
					var InSection = (Room.Section_ID != 0 ? FlipCoin_Bool() : false);
				
					global.SpawnedShop = SpawnShop(_RoomIndex, InSection, Room.UnusedZone); 
					if(!global.SpawnedShop) global.SpawnedShop = SpawnShop(_RoomIndex, !InSection, Room.UnusedZone); //try the other section if not spawned			
			
				}
			}	

			
			break;
		
		
	}
	
	global.SpawnedWarpDest = SpawnInnactiveWarps(_RoomIndex);
	if(!global.SpawnedWarpDest){
		//Error_Spawn(_RoomIndex, "warp dest", false);
		return false;
	}
	
	if(Prob(Chance_SpawnKinstoneMonument)){
		global.SpawnedKinstone = SpawnKinstone(_RoomIndex, Room.UnusedZone);
	}


	//bonus treasures
	if(!global.SpawnedTreasure && Prob(Chance_BonusTreasure)){

		//pick a random section to spawn treasure, otherwise, pick oposite section from special item's section
		var InSection = false;
		if(Room.Section_ID != 0) InSection = (Room.SpecialObject == SpecialDungeonObj.None ? FlipCoin_Bool() : !Room.SpecialObject_InSection )
	
		var TreasureSpawnMethodsList = ds_list_create_sequence(0, TreasureSpawnMethods - 1);
		ds_list_shuffle(TreasureSpawnMethodsList);
		
		var TreasureSpawned = false;
		while(!TreasureSpawned && ds_list_size(TreasureSpawnMethodsList) > 0){
			
			var TreasureSpawnMethod = TreasureSpawnMethodsList[| 0];
			
			switch(TreasureSpawnMethod){
				
				case SpawnMethod_Treasure.Normal:
					if(Prob(Chance_HeartGuy)){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.HeartGuy, InSection, Room.UnusedZone, noone);
						TreasureSpawned = global.SpawnedTreasure;
					}

					if(!TreasureSpawned && Prob(Chance_DeadGuy) && global.Level.Index >= DungeonLevel.Catacombs && global.Level.Index != DungeonLevel.Village){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.DeadGuy, InSection, Room.UnusedZone, noone);
						TreasureSpawned = global.SpawnedTreasure;
					}
					if(!TreasureSpawned){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, InSection, Room.UnusedZone, RandomItem);
						TreasureSpawned = global.SpawnedTreasure;
					}
					break;
				
				case SpawnMethod_Treasure.Switch:
					if(global.Switch_Spawned != SpawnSwitch_ReturnCode.Success && Room.Section_ID == 0){
						global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.RevealTreasure, RandomItem);
						TreasureSpawned = (global.Switch_Spawned == SpawnSwitch_ReturnCode.Success);
					}
					break;
				
				case SpawnMethod_Treasure.Monument:
					if(!global.SpawnedMonument){
						global.SpawnedMonument = SpawnMonuments(_RoomIndex, InSection, Room.UnusedZone, RandomItem);
						TreasureSpawned = global.SpawnedMonument;
					}
					break;
				
				case SpawnMethod_Treasure.Altar:
					if(!global.SpawnedAltar){
						global.SpawnedAltar = SpawnAltar(_RoomIndex, InSection, Room.UnusedZone, RandomItem);
						TreasureSpawned = global.SpawnedAltar;
					}
					break;
				
			}
			
			ds_list_delete(TreasureSpawnMethodsList, 0);
			
		}
		
		ds_list_destroy(TreasureSpawnMethodsList);
			
	}

	
	if(!global.SpawnedMonument){
		if(Prob(Chance_Decor_Monuments) || Room.GridW == 2 || Room.GridH == 2){
			global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone);
		}
	}	
	

	if(_RoomIndex != global.Level.RoomIndex_Entrance){
		if(FlipCoin_Bool()){ //half the time check Guru first then spikes, otherwise check the opposite.
			global.SpawnedGuruBar = SpawnGuruBars(_RoomIndex);
			if(!global.SpawnedGuruBar) global.SpawnedRollingSpikes = SpawnRollingSpikes(_RoomIndex);
		}else{
			global.SpawnedRollingSpikes = SpawnRollingSpikes(_RoomIndex);
			if(!global.SpawnedRollingSpikes) global.SpawnedGuruBar = SpawnGuruBars(_RoomIndex);			
		}
	}

	if(Prob(Chance_SpawnSpikes)) SpawnSpikes(_RoomIndex);
	
	if(!global.SpawnedTorches){
		if(Prob(Chance_SpawnTorches)) 
			SpawnTorches(_RoomIndex);
	}
	
	if(!global.SpawnedPots && _RoomIndex != global.Level.RoomIndex_Entrance){
		if(Prob(Chance_SpawnPots)) 
			global.SpawnedPots = SpawnPots(_RoomIndex, false, noone);
	}

	if(!global.SpawnedEnemies && _RoomIndex != global.Level.RoomIndex_Entrance && !global.SpawnedShop){
		if(Prob(Chance_SpawnEnemies) || (!global.SpawnedTreasure && !global.SpawnedAltar && !global.SpawnedKinstone && !global.SpawnedCrystal)) {
			SpawnEnemies(_RoomIndex);
		}
	}
		
	
	
	if(global.SpawnedAltar) global.Level.AltarCount++;
	if(global.SpawnedShop) global.Level.ShopCount++;
	
	for(var SpecialObjComboTypeIndex = 0; SpecialObjComboTypeIndex < global.SpecialObjComboTypes; SpecialObjComboTypeIndex++){
		ds_list_destroy(global.RoomTemplateObjLists_SpecialObjCombos_Main[SpecialObjComboTypeIndex]);
		ds_list_destroy(global.RoomTemplateObjLists_SpecialObjCombos_Section[SpecialObjComboTypeIndex]);		
	}
	global.RoomTemplateObjLists_SpecialObjCombos_Main = 0;
	global.RoomTemplateObjLists_SpecialObjCombos_Section = 0;
	
	ds_list_destroy(global.UsedObjs);
	ds_list_destroy(global.UsedSpaces);

	return true;

}

function SpawnSwitch(_RoomIndex, _SwitchAction, _TreasureItem = noone){

	global.Switch_Add = true;
	global.Switch_Action = _SwitchAction;
	
	global.Switch_TreasureItem = _TreasureItem;
	
	if(global.Switch_Action == SwitchAction.RevealTreasure){
		
		//first spawn the treasure chest the key will be in.
		global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, Room.SpecialObject_InSection, Room.UnusedZone, global.Switch_TreasureItem);
			
		if(!global.SpawnedTreasure && global.SpawnedBlocks){
				
			//if we can't spawn the treasure normally, and if blocks were spawned, then use one of the treasure spots
			global.SpawnedTreasure = BlockPattern_DrawItem(_RoomIndex, BlockObj.Treasure, global.Switch_TreasureItem);
				
		}

		if(!global.SpawnedTreasure){
			global.Switch_Add = false;
			return SpawnSwitch_ReturnCode.SpawnTreasureFail;
		}
		
	}

	//Add all the possible switch types in a list, shuffle list, then pick one by one until switch was added	
	var SwitchTypeList = ds_list_create();
	
	ds_list_add(SwitchTypeList, SwitchType.FloorSwitch, SwitchType.Torches);

	//if blocks were spawned
	if(global.SpawnedBlocks) ds_list_add(SwitchTypeList, SwitchType.Block, SwitchType.Block, SwitchType.Block, SwitchType.Block); 
	
	//Only Ruins 3 level has monuments with eyes on it that can spawn arrow targets. Only use this method if it's a bonus treasure
	if(global.Level.Index == DungeonLevel.Ruins3 && Room.Section_ID == 0){
		
		if( (global.Switch_Action == SwitchAction.RevealTreasure && _TreasureItem == RandomItem)){
			ds_list_add(SwitchTypeList, SwitchType.ArrowTarget, SwitchType.ArrowTarget, SwitchType.ArrowTarget, SwitchType.ArrowTarget, SwitchType.ArrowTarget);
		}
		
		
	}
	
	ds_list_shuffle(SwitchTypeList);
			
	var SwitchTypes = ds_list_size(SwitchTypeList);
			
	for(var SwitchTypeIndex = 0; SwitchTypeIndex < SwitchTypes; SwitchTypeIndex++){
				
		global.SwitchType = SwitchTypeList[| SwitchTypeIndex];
				
		switch(global.SwitchType){
					
			case SwitchType.FloorSwitch:

				global.SpawnedPots = SpawnPots(_RoomIndex, Room.SpecialObject_InSection, noone);

				if(global.SpawnedPots){
					if(global.Switch_Action == SwitchAction.RevealTreasure)	global.Switch_Inst.TreasureInst = global.Switch_TreasureInst;
					global.Switch_Add = false;
					
				}
						
				break;


			case SwitchType.Torches:

				if(Room.Section_ID == 0){ //only use torches as switches if section ID is 0
					global.SpawnedTorches = SpawnTorches(_RoomIndex);
					if(global.SpawnedTorches) global.Switch_Add = false;
					
				}
						
				break;
					
			case SwitchType.Block:
				
				if(global.SpawnedBlocks){
					var SpawnedSwitchBlock = BlockPattern_DrawItem(_RoomIndex, BlockObj.Switch);
					if(SpawnedSwitchBlock){
						if(global.Switch_Action == SwitchAction.RevealTreasure) global.Switch_Inst.TreasureInst = global.Switch_TreasureInst;
						global.Switch_Add = false;
					}
				}
				
				break;
				
			case SwitchType.ArrowTarget:
				
				global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone, noone);
				if(global.SpawnedMonument){
					if(global.Switch_Action == SwitchAction.RevealTreasure)	global.Switch_Inst.TreasureInst = global.Switch_TreasureInst;
					global.Switch_Add = false;					
				}				
				break;
						
		}
				
		//if the switchtype was generated, then global.Switch_Add would have been switched to false in their respective spawn functions, so break
		if(!global.Switch_Add) break;
				
	}

	//if switch didn't spawn, then destroy the treasure
	if(global.Switch_Add && global.Switch_Action == SwitchAction.RevealTreasure){
				
		instance_destroy(global.Switch_TreasureInst);
		instance_destroy(global.Switch_Inst);
				
		//also destroy used space entry the treasure added
		ds_list_delete(global.UsedSpaces, ds_list_size(global.UsedSpaces) - 1);

		global.SpawnedTreasure = false;
				
	}	

	
	ds_list_destroy(SwitchTypeList);
	
	if(!global.Switch_Add)
		return SpawnSwitch_ReturnCode.Success
	else{
		global.Switch_Add = false;
		return SpawnSwitch_ReturnCode.AddSwitchFail
	}

}

function SpawnWarp(_RoomIndex){
	
	SpawnedWarp = false;
	
	for(var i = 0; i < global.Level.RoomCount; i++){
		if(i != _RoomIndex && DungeonRoom.Warps[i]){
			var SpawnedWarp = SpawnObj(_RoomIndex, SpecialObj.Warp, Room.SpecialObject_InSection, Room.UnusedZone, i);
		}		
	}
	
	return SpawnedWarp;
	
}

function SpawnInnactiveWarps(_RoomIndex){
	
	if(Room.WarpDestX != -1 || Room.WarpDestY != -1) exit; //exit if innactive warp was already put down for this room
	
	SpawnedWarpDest = true;
	
	for(var _RoomFromIndex = 0; _RoomFromIndex < global.Level.RoomCount; _RoomFromIndex++){
		
		var _DungeonRoom = global.Level.DungeonTemplate.Rooms[_RoomFromIndex];

		if(_DungeonRoom.Warps[_RoomIndex]){
			var SpawnedWarpDest = SpawnObj(_RoomIndex, SpecialObj.WarpDest, false, Room.UnusedZone, noone);
			break;
		}

	}

	return SpawnedWarpDest;
	
}


function SpawnSpikes(_RoomIndex){
	
	//skip these levels
	switch(global.Level.Index){
		case DungeonLevel.Castle:	
		case DungeonLevel.CastleBasement:	
		case DungeonLevel.CastleJails:	
		case DungeonLevel.Sewers:	
		case DungeonLevel.Ruins2:	
		case DungeonLevel.Aghanim1:	
			exit;
		
	}
	
	if(Room.Section_ID != 0 || Room.Water || Room.Secret != -1 || Room.Type == RoomType.Boss) return false;
	
	var SpikesArray = TemplateRoom.Spikes;
	
	var SpikesInTemplate = array_length(SpikesArray);	
	if(SpikesInTemplate == 0) return false;
	
	var UsedSpaceData = []; 
	//instead of adding used space after each spike obj, we keep all the data here until all of them are drawn, then we add them all after.
	//this is to prevent spikes from being flagged as unsafe distance.
	
	for(var SpikeIndex = 0; SpikeIndex < SpikesInTemplate; SpikeIndex++){
		
		var Spike = SpikesArray[SpikeIndex];
		var SpikeX = Room.x + Spike.x;
		var SpikeY = Room.y + Spike.y;
		var SpikeX2 = SpikeX + Spike.width - 1;
		var SpikeY2 = SpikeY + Spike.height - 1;
		var SpikeTileW = Spike.width / 8;
		var SpikeTileH = Spike.height / 8;

		//check if on top of path carpets
		if(global.SpawnedCarpets){
			var TMID = GetFloorLevelTMID("Tiles_Floor", SpikeX, SpikeY);
			if(CornersOnCarpet(TMID, SpikeX, SpikeY, SpikeX2, SpikeY2) > 0) continue;
		}

			
		//Check for doors
		//Top
		if(collision_rectangle(SpikeX, SpikeY - 24, SpikeX2, SpikeY, oDoor, false, true) != noone) continue;
		//Bottom
		if(collision_rectangle(SpikeX, SpikeY2 + 1, SpikeX2, SpikeY2 + 24, oDoor, false, true) != noone) continue;
		//Left
		if(collision_rectangle(SpikeX - 24, SpikeY, SpikeX, SpikeY2, oDoor, false, true) != noone) continue;
		//Right
		if(collision_rectangle(SpikeX2 + 1, SpikeY, SpikeX2 + 24, SpikeY2, oDoor, false, true) != noone) continue;
			
		if(!SafeDistanceBox(SpikeX, SpikeY, SpikeX2, SpikeY2, false, 24, false)) continue;
		
		if(!Prob(Chance_SpikeSection)) continue;
			
		array_push(UsedSpaceData, {_SpikeX: SpikeX, _SpikeY: SpikeY, _SpikeW: Spike.width, _SpikeH: Spike.height})
		
		var TMID = GetFloorLevelTMID("Tiles_Floor", SpikeX, SpikeY);
		
		ClearTileBlock(TMID, SpikeX, SpikeY, SpikeTileW, SpikeTileH, global.SpikeTileID);

	}
	
	while(array_length(UsedSpaceData) > 0){
		var _Data = array_pop(UsedSpaceData);
		AddUsedSpace(_Data._SpikeX, _Data._SpikeY, _Data._SpikeW, _Data._SpikeH, false, true);
	}
	
	return true;
	
}

function SpawnMonuments(_RoomIndex, InSection, UnusedZone, Obj = noone, ForcePots = false){
	
	//To future self: If monuments aren't spawning when an altar is in the Room, remember that monuments check a large distance using SafeDistance().
	//So even though it looks like monuments can fit, it's best if you just leave it as is because through testing it was shown that sometimes there's not enough Room left
	
	var MonumentsArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Monuments"];
	var Monuments = array_length(MonumentsArray);
	
	if(Monuments == 0) return false;

	
	//Find MonumentGroups object (The point object on monuments layer that holds the groups string)
	
	var MonumentGroupsObj = -1;
	var MonumentGroupsObjIndex = -1;
	for(var MonumentIndex = 0; MonumentIndex < Monuments; MonumentIndex++){
		if(MonumentsArray[MonumentIndex][$ "name"] == "MonumentGroups"){
			MonumentGroupsObj = MonumentsArray[MonumentIndex];
			MonumentGroupsObjIndex = MonumentIndex;
			break;
		}
	}
	
	if(MonumentGroupsObj == -1) return false; //no group obj found, return false, each section needs one of these if there's monuments

	
	//MGO = Monument Group Object
	var MGOProperties = MonumentGroupsObj[$ "properties"];

	//Split the monument groups string into an array
	var GroupsStr = GetPropertyValue(MGOProperties, "Groups");
	if(GroupsStr != -1)	var GroupsArray = SplitStrToArray(GroupsStr, "\n");
	
	var Groups = array_length(GroupsArray);
	
	//make a list of group indexes, then shuffle the list. One by one, pick the next group from the list and try it out. If there's collisions, go to the next group.

	var GroupIndexesList = ds_list_create();
	ds_list_clear(GroupIndexesList);
	repeat(Groups) ds_list_add(GroupIndexesList, ds_list_size(GroupIndexesList)); //list now has 1,2,3... up to Patterns
	ds_list_shuffle(GroupIndexesList);
	
	//create list with 26 slots for each of the letters of the alphabet. This list will store the monument array index, where if the Group ID is C, then store it at position 2 (third pos)
	//Then we can find out which monument obj it is when scanning each letter in the GroupsStr
	//Note: if ID is upper case, then it's a central monument
	var MonumentIndexList = ds_list_create();
	repeat(26) ds_list_add(MonumentIndexList, -1);
	for(var MonumentIndex = 0; MonumentIndex < Monuments; MonumentIndex++){
		if(MonumentIndex != MonumentGroupsObjIndex){
			var Monument = MonumentsArray[MonumentIndex];
			var Properties = Monument[$ "properties"];
			var GroupID = string_upper(GetPropertyValue(Properties, "ID"));
			var LetterIndex = ord(GroupID) - 65; //A = 0, B = 1, etc
			MonumentIndexList[| LetterIndex] = MonumentIndex;
		}
	}

	var ArrowTargetNeeded = (global.Switch_Add && global.SwitchType == SwitchType.ArrowTarget);
	
	var GroupOk = false;
	for(var GroupIndexesListIndex = 0; GroupIndexesListIndex < Groups; GroupIndexesListIndex++){
			
		var GroupIndex = GroupIndexesList[| GroupIndexesListIndex];
		var GroupStr = GroupsArray[GroupIndex];
		var MonumentsInGroup = string_length(GroupStr);

		//Special case only for Room template 663 main section and when altar is centered
		var SpecialAltarCase = false;
		if((global.SpawnedAltar || global.SpawnedShop) && TemplateRoom[$ "id"] == 663 && Room.Section_ID == 0){
			var AltarStickL = global.AltarData[$ "StickL"];
			var AltarStickR = global.AltarData[$ "StickR"];
			if( (AltarStickL && AltarStickR) || (!AltarStickL && !AltarStickR) ) SpecialAltarCase = true;
		}
		//if Altar is centered in template 0, ignore patterns that only have an odd number of monuments
		if(SpecialAltarCase){
			if( (string_length(GroupStr) mod 2) != 0) continue;
		}
		
		
		GroupOk = true;

		var ObjectsAllowed_Main = false;
		var ObjectsAllowed_Section = false;
		
		var _InZone = false;
		
		var ArrowTargetOk = false;
		var ArrowTargetMonumentID = -1;
		
		for(var MonumentIndex = 0; MonumentIndex < MonumentsInGroup; MonumentIndex++){
			
			var GroupID = string_char_at(GroupStr, MonumentIndex + 1);
			var LetterIndex = ord(string_upper(GroupID)) - 65; //A = 0, B = 1, etc
			
			var ArrayIndex = MonumentIndexList[| LetterIndex];
			if(ArrayIndex == -1){
				Error("Monument Letter Error: Letter Index " + string(LetterIndex) + "(A=0,B=1..), Room Index " + string(global.RoomIndex) + ", template id " + string(global.Templates_Room[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Templates_Room[global.RoomTemplate][$ "RoomTransformation"]), true );
				return false;
			}
			var Monument = MonumentsArray[ArrayIndex];
			
			if(UnusedZone != -1 && !_InZone){
				var ZoneIndex = InZone(_RoomIndex, Monument, Room.TemplateIndex, Room.Section_ID, false);
				if( ZoneIndex == UnusedZone) _InZone = true;
			}
			
			var Properties = Monument[$ "properties"];
	
			var MonumentTLCornerX = Room.x + Monument.x;
			var MonumentTLCornerY = Room.y + Monument.y;
			var MonumentTLCornerX2 = MonumentTLCornerX + 31;
			var MonumentTLCornerY2 = MonumentTLCornerY + 31;
			
			//Apply transformations if any
			var xywhList = ds_list_create();
			ds_list_add(xywhList, MonumentTLCornerX, MonumentTLCornerY, 32, 32);
			TransformObj(_RoomIndex, Monument, xywhList);
			MonumentTLCornerX = xywhList[| 0]; MonumentTLCornerY = xywhList[| 1];
			ds_list_destroy(xywhList);
			
			var TMID_Floor = GetFloorLevelTMID("Tiles_Floor", MonumentTLCornerX, MonumentTLCornerY);
			
			//Check conditions that make a pattern not ok. If any are true, go to next pattern.

			//check if on top of path carpets
			if(global.SpawnedCarpetStyle == CarpetStyle.Path){
				if(CornersOnCarpet(TMID_Floor, MonumentTLCornerX, MonumentTLCornerY, MonumentTLCornerX2, MonumentTLCornerY2) > 1){
					GroupOk = false; break;
				}
			}
			
			//Check for doors
			//Top
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY - 24, MonumentTLCornerX2, MonumentTLCornerY, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Bottom
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY2 + 1, MonumentTLCornerX2, MonumentTLCornerY2 + 24, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Left
			if(collision_rectangle(MonumentTLCornerX - 24, MonumentTLCornerY, MonumentTLCornerX, MonumentTLCornerY2, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Right
			if(collision_rectangle(MonumentTLCornerX2 + 1, MonumentTLCornerY, MonumentTLCornerX2 + 24, MonumentTLCornerY2, oDoor, false, true)){
				GroupOk = false; break;
			}
			
			var MonumentInSection = InSectionArea(_RoomIndex, MonumentTLCornerX, MonumentTLCornerY, Room.TemplateIndex, Room.Section_ID, true);
			
			//Check for used objects
			
			//Special case only for Room template index 0: if altar is centered, and the monument is at the same level as the altar, and the monuments are at A or E, allow
			if(SpecialAltarCase && ( (abs(MonumentTLCornerY - global.AltarData[$ "y"]) <= 8) && global.AltarData[$ "w"] <= 96 && (string_upper(GroupID) == "A" || string_upper(GroupID) == "E" ))){
				//skip safe distance check
			}else if(!SafeDistanceBox(MonumentTLCornerX, MonumentTLCornerY, MonumentTLCornerX2, MonumentTLCornerY2, MonumentInSection, 64, false)){
				GroupOk = false;
				break;					
			}

			//check if monument is arrow target. If so, make sure there's no walls underneath, or treasures underneath if a treasure switch
			if(ArrowTargetNeeded && !ArrowTargetOk){
				if( collision_rectangle(MonumentTLCornerX, MonumentTLCornerY2 + 1, MonumentTLCornerX2, MonumentTLCornerY2 + 80, oWall, false, true) == noone){
					
					ArrowTargetOk = true;
					
					if(global.Switch_Action == SwitchAction.RevealTreasure){
						//if the switch reveals a treasure, make sure the treasure it's revealing isn't where Link might be standing
						if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY2 + 1, MonumentTLCornerX2, Room.y + Room.height - 24, oItem_Treasure, false, true) != noone){
							ArrowTargetOk = false;
						}
					}
				}
			}
			if(ArrowTargetMonumentID == -1 && ArrowTargetOk) ArrowTargetMonumentID = LetterIndex;
			
			//Check if object are allowed under monument.
			//If there's a wall below, or there's a door to the left or right of the obj area, then obj not allowed
			
			//Bottom
			var ObjAllowed = true;
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY2 + 1, MonumentTLCornerX2, MonumentTLCornerY2 + 32, oWall, false, true)){
				ObjAllowed = false;
			}
			//Door Left of obj area
			if(collision_rectangle(MonumentTLCornerX - 24, MonumentTLCornerY2 + 1, MonumentTLCornerX - 1, MonumentTLCornerY2 + 24, oDoor, false, true)){
				ObjAllowed = false;
			}
			//Door Right of obj area
			if(collision_rectangle(MonumentTLCornerX2 + 1, MonumentTLCornerY2 + 1, MonumentTLCornerX2 + 24, MonumentTLCornerY2 + 24, oDoor, false, true)){
				ObjAllowed = false;
			}

			
			//We also have to check if other monuments that are part of this group would be in the way of objects
			//======================================
				for(var OtherMonumentIndex = 0; OtherMonumentIndex < MonumentsInGroup; OtherMonumentIndex++){
			
					var OtherGroupID = string_char_at(GroupStr, OtherMonumentIndex + 1);
					var OtherLetterIndex = ord(string_upper(OtherGroupID)) - 65; //A = 0, B = 1, etc
			
					var OtherArrayIndex = MonumentIndexList[| OtherLetterIndex];
					if(OtherArrayIndex == -1){
						Error("Monument Letter Error: Letter Index " + string(OtherLetterIndex) + "(A=0,B=1..), Room Index " + string(global.RoomIndex) + ", template id " + string(global.Templates_Room[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Templates_Room[global.RoomTemplate][$ "RoomTransformation"]), true );
						return false;
					}
					var OtherMonument = MonumentsArray[OtherArrayIndex];

					var OtherMonumentTLCornerX = Room.x + OtherMonument.x;
					var OtherMonumentTLCornerY = Room.y + OtherMonument.y;
			
					//Apply transformations if any
					var OtherxywhList = ds_list_create();
					ds_list_add(OtherxywhList, OtherMonumentTLCornerX, OtherMonumentTLCornerY, 32, 32);
					TransformObj(_RoomIndex, OtherMonument, OtherxywhList);
					OtherMonumentTLCornerX = OtherxywhList[| 0]; OtherMonumentTLCornerY = OtherxywhList[| 1];
					ds_list_destroy(OtherxywhList);
					
					if(rectangle_in_rectangle(MonumentTLCornerX, MonumentTLCornerY2 + 1, MonumentTLCornerX2, MonumentTLCornerY2 + 32, OtherMonumentTLCornerX, OtherMonumentTLCornerY, OtherMonumentTLCornerX + 31, OtherMonumentTLCornerY + 31)){
						ObjAllowed = false;
						break;
					}
				}
			//==========================================


			if(ObjAllowed){					
				//we found at least 1 monument that can have objs, so this pattern is a good candidate
				if(MonumentInSection)
					ObjectsAllowed_Section = true;
				else
					ObjectsAllowed_Main = true;						
			}
			
			Monument[$ "ObjAllowed"] = ObjAllowed;
			
		}
		
		if(ArrowTargetNeeded && !ArrowTargetOk) GroupOk = false;
		
		
		if(GroupOk){

			//Pattern might be ok to not block doors and such, but if an obj is needed or switch needs to be added in pots and objs are not allowed, 
			//or an object is needed in a specific section but no monuments exist in that section, then we can't use this pattern
			if(Obj != noone || (global.Switch_Add && global.SwitchType == SwitchType.FloorSwitch)){
				if( (!InSection && !ObjectsAllowed_Main) || (InSection && !ObjectsAllowed_Section) ){
					GroupOk = false;
					continue;
				}
			}
			
			//If we need a monument to be in a zone, but none were inside one from the group, pick a new group
			if( UnusedZone != -1 ){
				if(!_InZone){
					GroupOk = false;
					continue;
				}
			}
			
			break;
		}
		
	}

	
	//draw the group that was selected
	
	if(GroupOk){
		
		var GroupIndex = GroupIndexesList[| GroupIndexesListIndex];
		var GroupStr = GroupsArray[GroupIndex];
		GroupStr = String_Shuffle(GroupStr); //shuffle group str since we try and place the main obj at the first monument we can, this will make the ist one different every time
		var MonumentsInGroup = string_length(GroupStr);	
		var MainObjAdded = false;
		var MainObjMonumentIndex = -1;
		var BonusPotsMonumentY = -1;
		
		var BonusPots = (StartingRoom ? false : Prob(Chance_Decor_Monuments_BonusPots) || ForcePots ); //no pots in first entrance Room
				
		var Style1 = choose(0, 1, 2);
		var Style2 = choose(0, 1, 2);

		var ArrowTargetSpawned = false;
		
		for(var MonumentIndex = 0; MonumentIndex < MonumentsInGroup; MonumentIndex++){	

			var GroupID = string_char_at(GroupStr, MonumentIndex + 1);
			
			var LetterIndex = ord(string_upper(GroupID)) - 65; //A = 0, B = 1, etc
			
			var MainMonument = ord(GroupID) <= 90;
			
			var Monument = MonumentsArray[MonumentIndexList[| LetterIndex]];
			
			//var Properties = Monument[$ "properties"];			
			
			var MonumentTLCornerX = Room.x + Monument.x;
			var MonumentTLCornerY = Room.y + Monument.y;	
			
			var FloorLevelStr = GetFloorLevelString(MonumentTLCornerX, MonumentTLCornerY);
			
			//Apply transformations if any
			var xywhList = ds_list_create();
			ds_list_add(xywhList, MonumentTLCornerX, MonumentTLCornerY, 32, 32);
			TransformObj(_RoomIndex, Monument, xywhList);
			MonumentTLCornerX = xywhList[| 0]; MonumentTLCornerY = xywhList[| 1];
			ds_list_destroy(xywhList);
			
			//If there's 3 monuments in the group, make the main monument one style, and the other 2 another.
			//If there's more then 3, just make them all the same.
			//Otherwise just pick random styles when 1 or 2 in the group
			if(MonumentsInGroup == 3){
				var Style = (MainMonument ? Style1 : Style2);
			}else if(MonumentsInGroup > 3){
				var Style = Style1;
			}else{
				var Style = choose(0, 1, 2);
			}
			
			//if castle or Aghanim 1 level, make sure the chair isn't picked if monument is below a certain y coordinate
			//This is so we don't have a chair at the bottom looking like you can't sit in it
			if(global.Level.Index == DungeonLevel.Castle || global.Level.Index == DungeonLevel.Aghanim1){
				if(Style == 0 && (Monument.y > 128 || collision_rectangle(MonumentTLCornerX, MonumentTLCornerY + 32, MonumentTLCornerX + 31, MonumentTLCornerY + 63, oWall, false, true)))
					Style = choose(1, 2);
			}

			if(ArrowTargetMonumentID == LetterIndex && ArrowTargetNeeded && !ArrowTargetSpawned){
				//this will only be the case on level Ruins 3, so pick the monuments with the eyes
				var Style = choose(0, 1);
			}
			if(ArrowTargetSpawned || (ArrowTargetNeeded && ArrowTargetMonumentID != LetterIndex)) var Style = 2; //so that when there's an arrow target, it's the only monument in the room with the eye, the rest would be the rock
			
			
			var TileX = 116 + (Style * 4);
			
			//half the time draw the monument mirrored, some of them aren't symetrical so it gives variety
			DrawTileBlock(GetFloorLevelTMID("Tiles_Walls", MonumentTLCornerX, MonumentTLCornerY), MonumentTLCornerX, MonumentTLCornerY, TileX, LevelTilesY, 4, 4, FlipCoin_Bool());
			
			var WallInst1 = WallObj_Create("Objs_" + FloorLevelStr, MonumentTLCornerX, MonumentTLCornerY, 4, 3);
			WallInst1.BlockProjectiles = true; 
			var WallInst2 = WallObj_Create("Objs_" + FloorLevelStr, MonumentTLCornerX, MonumentTLCornerY + 24, 4, 1);
			WallInst2.BlockProjectiles = false; 
			
			if(ArrowTargetMonumentID == LetterIndex && ArrowTargetNeeded){
				global.Switch_Inst = instance_create_layer(MonumentTLCornerX + 11, MonumentTLCornerY + 10, "ObjsHigher_" + FloorLevelStr, oArrowSwitch);
				global.Switch_Inst.Action = global.Switch_Action;
				ArrowTargetSpawned = true;
				ArrowTargetNeeded = false;
				ArrowTargetMonumentID = -1;
				AddUsedSpace(MonumentTLCornerX + 8, MonumentTLCornerY2 + 1, 15, 79, MonumentInSection, false); //add used space if front of monument so nothing gets generated there like spikes
			}
			
			var MonumentInSection = InSectionArea(_RoomIndex, MonumentTLCornerX, MonumentTLCornerY, Room.TemplateIndex, Room.Section_ID, true);
			
			AddUsedSpace(MonumentTLCornerX, MonumentTLCornerY, 32, 32, MonumentInSection, false);
			
			
			//Add Main Object first
			
			if(Obj != noone && !MainObjAdded && !ArrowTargetNeeded && !ArrowTargetSpawned){
				
				if(Monument[$ "ObjAllowed"] && MainMonument && ( (InSection && MonumentInSection) || (!InSection && !MonumentInSection))){ //if GroupID letter is uppercase, then it's a suitable monument for the main obj. Z is ascii 90)
					
					var ItemsY = MonumentTLCornerY + 32;
					var ItemsX = MonumentTLCornerX;
					
					//if key, then sometimes spawn only pots
					if(Obj == oItem_Key && FlipCoin_Bool()){
						var OtherItem = PickRandomItem(ItemFrom.Pot);
						var PotItem1 = choose(Obj, OtherItem);
						var PotItem2 = (PotItem1 == Obj ? OtherItem : Obj);
						var PotInst = Pot_Create(ItemsX, ItemsY, PotItem1, InSection);
							PotInst = Pot_Create(ItemsX + 16, ItemsY, PotItem2, InSection);
						AddUsedSpace(MonumentTLCornerX, MonumentTLCornerY + 32, 32, 16, MonumentInSection, false);
					}else{
						if(!global.Switch_Add && global.Level.Index >= DungeonLevel.Catacombs && global.Level.Index != DungeonLevel.Village && Prob(Chance_Decor_Monuments_DeadguyTreasure)){
							if(Obj == RandomItem) Obj = (Prob(Chance_DeadGuyBonusItem) ? PickRandomItem(ItemFrom.Treasure) : noone);
							instance_create_layer(ItemsX + 16, ItemsY + 16, "Objs_" + FloorLevelStr, oDeadGuy, {ItemHolding : Obj});	
						}else{
							var Items = (global.Switch_Add && global.Switch_Action == SwitchAction.RevealTreasure ? 1 : choose(1,2));
							SpawnTreasureRow(ItemsX + (Items == 1 ? 8 : 0), ItemsY, InSection, true, Obj, Items);	
						}
					}
					
					MainObjMonumentIndex = MonumentIndex;
					MainObjAdded = true;
					continue;
				}
				
			}
			
			
			if(BonusPots && Monument[$ "ObjAllowed"] && !ArrowTargetNeeded && !ArrowTargetSpawned){
				//add pots only if monument is not the main obj monument
				if(MonumentIndex != MainObjMonumentIndex){

					//Keep track of the monument's y position. If another is found later at the same Y value, add pots to that one too
					if(BonusPotsMonumentY == -1) BonusPotsMonumentY = MonumentTLCornerY;
					
					if(MonumentTLCornerY == BonusPotsMonumentY){
						var PotsY = MonumentTLCornerY + 32;										
						Pot_Create(MonumentTLCornerX, PotsY, PickPotItem(false), InSection);
						Pot_Create(MonumentTLCornerX + 16, PotsY, PickPotItem(false), InSection);
						AddUsedSpace(MonumentTLCornerX, PotsY, 32, 16, InSection, false);						
					}
					

				}
			}
				
		}
		
		if(UnusedZone != -1) Room.UnusedZone = -1;
		
	}
	
	ds_list_destroy(MonumentIndexList);
	
	return GroupOk;
	
}


function SpawnBlocks(_RoomIndex){
	
	if(global.SpawnedCarpets) return false;
	
	
	var BlockGroupArray = TemplateRoom[$ "Blocks"];
	var BlockGroups = array_length(BlockGroupArray);
	
	if(BlockGroups == 0) return false;
	
	var BlockGroupIndex = irandom(BlockGroups - 1);
	
	var BlockGroup = BlockGroupArray[BlockGroupIndex];
	
	global.SpawnedBlocks_GroupX = Room.x + BlockGroup.x;
	global.SpawnedBlocks_GroupY = Room.y + BlockGroup.y;
	
	var BlockGroupW = BlockGroup.width / 16;
	var BlockGroupH = BlockGroup.height / 16;
	
	global.SpawnedBlocks_PatternSize = global.BlockPatternSizeID[BlockGroupW][BlockGroupH];
	var Patterns = array_length(global.BlockPatterns[global.SpawnedBlocks_PatternSize]);

	global.SpawnedBlocks_PatternIndex = irandom(Patterns - 1);
	
	var Pattern = global.BlockPatterns[global.SpawnedBlocks_PatternSize, global.SpawnedBlocks_PatternIndex];

	global.SpawnedBlocks_TMID = GetFloorLevelID(global.SpawnedBlocks_GroupX, global.SpawnedBlocks_GroupY) == UPPER ? global.TMID_Walls_Upper : global.TMID_Walls_Lower;

	
	for(var BlockY = 0; BlockY < BlockGroupH; BlockY++){
		for(var BlockX = 0; BlockX < BlockGroupW; BlockX++){

			var BlockPosX = global.SpawnedBlocks_GroupX + (BlockX * 16);
			var BlockPosY = global.SpawnedBlocks_GroupY + (BlockY * 16);

			var PatternSymbol = string_char_at(Pattern[BlockY], BlockX + 1);
			
			switch(PatternSymbol){
				default:
					Block_Draw(BlockPosX, BlockPosY);
					break;
				
				case ".":
				case "t":
					break;
					
			}

		}
	}

	return true;
	
}


function SpawnPots(_RoomIndex, InSection, Obj){
	
	var PotsArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Pots"];
	
	var PotsInTemplate = array_length(PotsArray);	
	if(PotsInTemplate == 0) return false;
	
	var ObjPotSpawned = false;
	var Success = false;

	for(var ListIndex = 0; ListIndex < irandom_range(1, PotsInTemplate); ListIndex++){
		var _InSection = (InSection ? true : (Room.Section_ID == 0 ? false : FlipCoin_Bool()));
		if(Obj != noone && !ObjPotSpawned){
			var SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, _InSection, -1, Obj);
			if(SpawnedPot) ObjPotSpawned = true;
		}else{
			var _Item = PickPotItem(false, false);
			var SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, _InSection, -1, _Item);			
		}
		if(!Success && SpawnedPot) Success = true;		
	}
	
	return Success;
	
}


function SpawnTorches(_RoomIndex){
	
	var PotsArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Pots"];
	
	var PotsInTemplate = array_length(PotsArray);	
	if(PotsInTemplate == 0) return false;
	
	var Success = false;
	
	var MinPots = global.Switch_Add ? min(PotsInTemplate, 3) : 1;
	var Pots = irandom_range(MinPots, 4);
	
	for(var ListIndex = 0; ListIndex < Pots; ListIndex++){

		var SpawnedTorch = SpawnObj(_RoomIndex, SpecialObj.Torch, false, -1, noone);			

		if(!Success && SpawnedTorch) Success = true;		
	}
	
	if(Success){
		global.TorchGroupIndex++;
	}
	
	return Success;
	
}


function SpawnAltar(_RoomIndex, InSection, UnusedZone, TreasureContents){
	
	//if(global.Level.Index == DungeonLevel.Sewers) return false;

	if(!PlatformVerify(_RoomIndex, InSection, UnusedZone)) return false;
		
	var AltarX = global.AltarData.x;
	var AltarY = global.AltarData.y;
	var AltarW = global.AltarData.w;
	var AltarH = global.AltarData.h;
	//===Draw Altar===
	
	var FloorTMID = GetFloorLevelTMID("Tiles_Floor", AltarX, AltarY); 
	var WallTMID = GetFloorLevelTMID("Tiles_Walls", AltarX, AltarY);
	var FloorLevelStr = GetFloorLevelString(AltarX, AltarY);

	var AltarTileW = AltarW / 8;
	var AltarTileH = AltarH / 8;

	//first clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
	ClearTileBlock(global.TMID_Water_Upper, AltarX, AltarY, AltarTileW, AltarTileH);
	ClearTileBlock(global.TMID_Water_Lower, AltarX, AltarY, AltarTileW, AltarTileH);
	
	//Draw floor
	for(var _y = 0; _y < AltarTileH; _y++){
		for(var _x = 0; _x < AltarTileW; _x++){
			var FloorX = AltarX + (_x * 8);
			var FloorY = AltarY + (_y * 8);
			DrawTileBlock(FloorTMID, FloorX, FloorY, 111, LevelTilesY + 2, 1, 1);							
		}
	}
					
	//Draw Corners
	DrawTileBlock(WallTMID, AltarX, AltarY, 110, LevelTilesY + 1, 1, 1); //TL
	DrawTileBlock(WallTMID, AltarX + AltarW - 8, AltarY, 112, LevelTilesY + 1, 1, 1); //TR
	DrawTileBlock(WallTMID, AltarX, AltarY + AltarH - 8, 110, LevelTilesY + 3, 1, 1); //BL
	DrawTileBlock(WallTMID, AltarX + AltarW - 8, AltarY + AltarH - 8, 112, LevelTilesY + 3, 1, 1); //BR
					
	//Draw Top
	for(_x = 0; _x < AltarTileW - 2; _x++){
		var SideX = AltarX + 8 + (_x * 8);
		DrawTileBlock(WallTMID, SideX, AltarY, 111, LevelTilesY + 1, 1, 1);							
	}
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, AltarX, AltarY, AltarTileW, 1);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw L/R sides
	for(_y = 0; _y < AltarTileH - 2; _y++){

			var SideXR = AltarX + AltarW - 8;
			var SideY = AltarY + 8 + (_y * 8);
			
			DrawTileBlock(WallTMID, AltarX, SideY, 110, LevelTilesY + 2, 1, 1);
			DrawTileBlock(WallTMID, SideXR, SideY, 112, LevelTilesY + 2, 1, 1);
						
	}
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, AltarX, AltarY, 1, AltarTileH);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, SideXR, AltarY, 1, AltarTileH);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Stairs
	var StairsW = AltarTileW - 6;
	var StairsX = AltarX + (4 * (AltarTileW - StairsW));
	var StairsY = AltarY + AltarH - 16;
	for(var _y = 0; _y < 2; _y++){
		for(var _x = 0; _x < StairsW; _x++){
			var SX = StairsX + (_x * 8);
			var SY = StairsY + (_y * 8);
			DrawTileBlock(FloorTMID, SX, SY, 111, LevelTilesY, 1, 1);
		}
	}
	
	//Place an EnemyWall on stairs to prevent enemies from going through them
	//**Replace with WallObj_Create
	var inst = instance_create_layer(StairsX, StairsY, "Objs_" + FloorLevelStr, oWall);
	inst.image_xscale = StairsW;
	inst.image_yscale = 2;
	inst.FloorLevel = GetFloorLevelID(FloorLevelStr);
	inst.BlockLink = false;
	inst.BlockLinkCarry = false;
	inst.BlockProjectiles = false;
	inst.BlockItems = false;
	
	
	//Draw Stair Edges
	DrawTileBlock(WallTMID, StairsX - 8, StairsY, 112, LevelTilesY, 1, 1); //TL
	DrawTileBlock(WallTMID, StairsX + (StairsW * 8), StairsY, 110, LevelTilesY, 1, 1); //TR
	DrawTileBlock(WallTMID, StairsX - 8, StairsY + 8, 112, LevelTilesY + 3, 1, 1); //BL
	DrawTileBlock(WallTMID, StairsX + (StairsW * 8), StairsY + 8, 110, LevelTilesY + 3, 1, 1); //TR
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 8, StairsY, 1, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY, 1, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Bottom Sides
	var SideLen = (AltarTileW - StairsW - 4) / 2;
		
	for(var _x = 0; _x < SideLen; _x++){
		DrawTileBlock(WallTMID, AltarX + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
		DrawTileBlock(WallTMID, StairsX + (StairsW * 8) + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
	}
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 16, StairsY + 8, 2, 1);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	var WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY + 8, 2, 1);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Emblem
	//if(AltarTileH > 9){
	//	var EmblemTileW = 4;
	//	var EmblemTileH = 2;
	//	DrawTileBlock(global.TMID_Floors_Decor_Upper, AltarX + ((AltarTileW - EmblemTileW) * 4) , StairsY - 24, 0, 1, EmblemTileW, EmblemTileH);	
	//}
			
			
	var MinItems = (AltarTileW < 12 ? 1 : 3);
	var MaxItems = MinItems + 2;
			
	var Items = clamp(choose(1,3,5), MinItems, MaxItems);
	var ItemsW = Items * 16;
	var ItemsX = AltarX + ((AltarW - ItemsW) / 2);
	var ItemsY = AltarY + 8 + (AltarTileH > 8 ? (AltarTileH > 10 ? 16 : 8) : 0);
	
	SpawnTreasureRow(ItemsX, ItemsY, InSection, true, TreasureContents, Items);
	
	if(UnusedZone != -1) Room.UnusedZone = -1;
	
	return true;
	
}


function SpawnShop(_RoomIndex, InSection, UnusedZone){
	
	if(!PlatformVerify(_RoomIndex, InSection, UnusedZone)) return false;
	
	var _ShopX = global.AltarData.x;
	var _ShopY = global.AltarData.y;
	var _ShopW = global.AltarData.w;
	var _ShopH = 64;
	var _ShopTileW = _ShopW / 8;
	var _ShopTileH = _ShopH / 8;
		
	var FloorTMID = GetFloorLevelTMID("Tiles_Floor", _ShopX, _ShopY); 
	var _FloorLevelStr = GetFloorLevelString(_ShopX, _ShopY);

	//first clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
	ClearTileBlock(global.TMID_Water_Upper, _ShopX, _ShopY, _ShopTileW, _ShopTileH);
	ClearTileBlock(global.TMID_Water_Lower, _ShopX, _ShopY, _ShopTileW, _ShopTileH);
	
	//Draw floor
	var FarEdgeX = _ShopX + ((_ShopTileW - 1) * 8);
	var FarEdgeY = _ShopY + ((_ShopTileH - 1) * 8);
	//TL Corner
	DrawTileBlock(FloorTMID, _ShopX, _ShopY, 27, 0, 1, 1);
	//TR Corner
	DrawTileBlock(FloorTMID, FarEdgeX, _ShopY, 29, 0, 1, 1);
	//BL Corner
	DrawTileBlock(FloorTMID, _ShopX, FarEdgeY, 27, 2, 1, 1);
	//BR Corner
	DrawTileBlock(FloorTMID, FarEdgeX, FarEdgeY, 29, 2, 1, 1);
	
	//Top & Bottom Edges
	for(var _x = 1; _x < _ShopTileW - 1; _x++){
		var FloorX = _ShopX + (_x * 8);
		DrawTileBlock(FloorTMID, FloorX, _ShopY, 28, 0, 1, 1);							
		DrawTileBlock(FloorTMID, FloorX, FarEdgeY, 28, 2, 1, 1);							
	}
	
	//Top & Bottom Edges
	for(var _y = 1; _y < _ShopTileH - 1; _y++){
		var FloorY = _ShopY + (_y * 8);
		DrawTileBlock(FloorTMID, _ShopX, FloorY, 27, 1, 1, 1);							
		DrawTileBlock(FloorTMID, FarEdgeX, FloorY, 29, 1, 1, 1);							
	}	
	
	//Main floor
	for(var _y = 1; _y < _ShopTileH - 1; _y++){
		for(var _x = 1; _x < _ShopTileW - 1; _x++){
			var FloorX = _ShopX + (_x * 8);
			var FloorY = _ShopY + (_y * 8);
			DrawTileBlock(FloorTMID, FloorX, FloorY, 28, 1, 1, 1);							
		}
	}
	
	var ShopInst = instance_create_layer(_ShopX, _ShopY, "ObjsFloor_" + _FloorLevelStr, oShop, {RoomIndex : _RoomIndex, ShopW : _ShopW, ShopH : _ShopH, ShopType : ShopTypes.Various});
	
	//add shop to large map items so we can draw the icon if Link has a compass
	ds_list_add(global.LargeMapItems, ShopInst); 
						
	//Create wall obj
	var WallInst = WallObj_Create("Objs_" + _FloorLevelStr, _ShopX + 8, _ShopY + 8, _ShopTileW - 2, _ShopTileH - 2);
	WallInst.ShopInst = ShopInst;
	WallInst.BlockProjectiles = false;
					
	if(UnusedZone != -1) Room.UnusedZone = -1;
	
	return true;
	
}


function SpawnSwitchBlocks(_RoomIndex){
		
		
	if(Room.Section_WallType != SectionWallType.SwitchBlock) exit;
	
	if(Room.Section_ID == 0 || Room.Section_ID > 24) exit;

	var SectionWallsArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "SectionWalls"];
	
	var Walls = array_length(SectionWallsArray);
	if(Walls == 0) exit
	

	//Set the boundaries of the entire SB in X1/Y1/X2/Y2. 
	
	var X1 = 100000;
	var Y1 = 100000;
	var X2 = -100000;
	var Y2 = -100000;
	
	var SBSegmentsList = ds_list_create(); //keep track of all the SB segments so we can figure out the corners after
	
	for(var SectionWallIndex = 0; SectionWallIndex < Walls; SectionWallIndex++){
		
		var SB = SectionWallsArray[SectionWallIndex];
		
		var SwitchBoxShiftString = GetPropertyValue(SB[$ "properties"], "SB");
		if(SwitchBoxShiftString == -1) continue; //wall can't be used as a switchbox, go to the next one
				
		ds_list_add(SBSegmentsList, SB);
		
		var SB_X1 = Room.x + SB.x;
		var SB_Y1 = Room.y + SB.y;	
		var SB_X2 = SB_X1 + SB.width - 1;
		var SB_Y2 = SB_Y1 + SB.height - 1;
		
		//Shift the Switch blocks based on the shift codes found
		if(string_pos("L", SwitchBoxShiftString) != 0){	SB_X1 -= 8; };
		if(string_pos("R", SwitchBoxShiftString) != 0){ SB_X2 += 8; };
		if(string_pos("U", SwitchBoxShiftString) != 0){	SB_Y1 -= 8; };
		if(string_pos("D", SwitchBoxShiftString) != 0){ SB_Y2 += 8; };

		if(SB_X1 < X1) X1 = SB_X1;
		if(SB_Y1 < Y1) Y1 = SB_Y1;
		if(SB_X2 > X2) X2 = SB_X2;
		if(SB_Y2 > Y2) Y2 = SB_Y2;
		
	}

	//Keep track if we need corner blocks
	var TLCorner = false;
	var TRCorner = false;
	var BLCorner = false;
	var BRCorner = false;
	
	//check each combination of 2 segments for corner overlaps, thene set those corners to true
	var Segments = ds_list_size(SBSegmentsList);
	for(var i = 0; i < Segments - 1; i++){
		var SB1 = SBSegmentsList[| i];
		var Segment1_X1 = SB1.x;
		var Segment1_Y1 = SB1.y;
		var Segment1_X2 = SB1.x + SB1.width - 1;
		var Segment1_Y2 = SB1.y + SB1.height - 1;
		for(var j = i + 1; j < Segments; j++){
			
			var SB2 = SBSegmentsList[| j];
			var Segment2_X1 = SB2.x;
			var Segment2_Y1 = SB2.y;
			var Segment2_X2 = SB2.x + SB2.width - 1;
			var Segment2_Y2 = SB2.y + SB2.height - 1;		

			if(Segment1_X1 == Segment2_X1 && Segment1_Y1 == Segment2_Y1) TLCorner = true;
			if(Segment1_X2 == Segment2_X2 && Segment1_Y1 == Segment2_Y1) TRCorner = true;
			if(Segment1_X1 == Segment2_X1 && Segment1_Y2 == Segment2_Y2) BLCorner = true;
			if(Segment1_X2 == Segment2_X2 && Segment1_Y2 == Segment2_Y2) BRCorner = true;
		
		}
	}
	
	ds_list_destroy(SBSegmentsList);
	
	var inst = instance_create_layer(X1, Y1, "Objs_Upper", oSwitchBlock);
	
	inst.X1 = X1;
	inst.Y1 = Y1;
	inst.X2 = X2;
	inst.Y2 = Y2;
	inst.Corner_TL = TLCorner;
	inst.Corner_TR = TRCorner;
	inst.Corner_BL = BLCorner;
	inst.Corner_BR = BRCorner;
	
	if(Segments == 1){
		if(X2 - X1 == 15) inst.Segment_L = true;
		if(Y2 - Y1 == 15) inst.Segment_T = true;		
	}else{
		//we can determine the segment edges based on the corners present
		inst.Segment_L = TLCorner || BLCorner;
		inst.Segment_R = TRCorner || BRCorner;
		inst.Segment_T = TLCorner || TRCorner;
		inst.Segment_B = BLCorner || BRCorner;
	}
	
	if(inst.Segment_L){
		inst.Segment_L_Y = Y1 + (inst.Corner_TL ? 16 : 0);
		var _Y2 = Y2 - (inst.Corner_BL ? 16 : 0);
		inst.Segment_L_H = _Y2 - inst.Segment_L_Y + 1;
		inst.Segment_L_Wall = WallObj_Create("Objs_Upper", X1, Y1, 2, (Y2 - Y1 + 1) / 8);
		inst.Segment_L_Wall.SwitchBlockInst = inst;
		inst.Segment_L_Wall.IsSwitchBlock = true;
		inst.Segment_L_Wall.BlockProjectiles = false;
		inst.Segment_L_Wall.BlockItems = false;
	}
	if(inst.Segment_R){
		inst.Segment_R_Y = Y1 + (inst.Corner_TR ? 16 : 0);
		var _Y2 = Y2 - (inst.Corner_BR ? 16 : 0);
		inst.Segment_R_H = _Y2 - inst.Segment_R_Y + 1;
		inst.Segment_R_Wall = WallObj_Create("Objs_Upper", X2 - 15, Y1, 2, (Y2 - Y1 + 1) / 8);
		inst.Segment_R_Wall.SwitchBlockInst = inst;
		inst.Segment_R_Wall.IsSwitchBlock = true;
		inst.Segment_R_Wall.BlockProjectiles = false;
		inst.Segment_R_Wall.BlockItems = false;
	}
	if(inst.Segment_T){
		inst.Segment_T_X = X1 + (inst.Corner_TL ? 16 : 0);
		var _X2 = X2 - (inst.Corner_TR ? 16 : 0);
		inst.Segment_T_W = _X2 - inst.Segment_T_X + 1;
		inst.Segment_T_Wall = WallObj_Create("Objs_Upper", X1, Y1, (X2 - X1 + 1) / 8, 2);
		inst.Segment_T_Wall.SwitchBlockInst = inst;
		inst.Segment_T_Wall.IsSwitchBlock = true;
		inst.Segment_T_Wall.BlockProjectiles = false;
		inst.Segment_T_Wall.BlockItems = false;
	}
	if(inst.Segment_B){
		inst.Segment_B_X = inst.X1 + (inst.Corner_BL ? 16 : 0);
		var _X2 = inst.X2 - (inst.Corner_BR ? 16 : 0);
		inst.Segment_B_W = _X2 - inst.Segment_B_X + 1;
		inst.Segment_B_Wall = WallObj_Create("Objs_Upper", X1, Y2 - 15, (X2 - X1 + 1) / 8, 2);
		inst.Segment_B_Wall.SwitchBlockInst = inst;
		inst.Segment_B_Wall.IsSwitchBlock = true;
		inst.Segment_B_Wall.BlockProjectiles = false;
		inst.Segment_B_Wall.BlockItems = false;
	}
	
	inst.Color = DungeonRoom.Section_Color;
	global.Level.SwitchBlock_Colors = max(inst.Color + 1, global.Level.SwitchBlock_Colors);

	
	if(inst.Color == global.Level.SwitchBlock_ActiveColor){
		inst.ImgIndex = 0;
		inst.Raised = false;
		SwitchBlock_SetWalls(inst);		
	}	
		
}

function SpawnEnemies(_RoomIndex, _SpecialItem = noone){
	
	if(global.NoEnemies) exit; //temp
	
	var EnemyAreaArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Enemies"];
	
	var EnemyAreasInTemplate = array_length(EnemyAreaArray);
	
	if(EnemyAreasInTemplate == 0) return false;
	
	var RoomArea = min(Room.GridW * Room.GridH, 3); //larger Rooms should have more enemies, so multiply amount by a factor of RoomArea, cap it at 3x
	
	var PackPoints_Min = (5 + floor(global.Level.Index / 4)) * RoomArea; //Pack points are used up when an enemy is generated. Larger enemies use up more pack points that smaller ones.
	var PackPoints_Max = (10 + global.Level.Index) * RoomArea; 

	var TotalPackPoints = irandom_range(PackPoints_Min, PackPoints_Max);
	
	var EnemyTrap = false;
	if(	Room.Section_ID == 0 && 
		Room.GridW == 1 &&
		Room.GridH == 1 &&
		_RoomIndex != global.Level.RoomIndex_Entrance && 
		_RoomIndex != global.Level.RoomIndex_BossAdjacent && 
		_RoomIndex != global.Level.RoomIndex_Boss){
		
		var EnemyTrap_DoorsOk = true;

		for(var _DoorIndex = 0; _DoorIndex < array_length(Room.Doors); _DoorIndex++){
			var _Door = Room.Doors[_DoorIndex];
			if(_Door.Status != DoorStatus.Open){
				EnemyTrap_DoorsOk = false;
				break;
			}
		}
		if(EnemyTrap_DoorsOk){
			EnemyTrap = Prob(Chance_SpawnEnemyTrap);
		}
	}
	
	
	
	//list of all possible enemies
	var EnemyList = ds_list_create();
	
	for(var Pass = 0; Pass < 2; Pass++){
		
		var EnemyTypes = 0;
		
		for(var _ObjIndex = 0; _ObjIndex < array_length(global.EnemyData); _ObjIndex++){
		
			//don't add wall-type enemies to list
			if(_ObjIndex == oEnemy_Beamos || _ObjIndex == oEnemy_Cannon || _ObjIndex == oEnemy_Medusa || _ObjIndex == oEnemy_RollingSpike || _ObjIndex == oEnemy_Guru_Bar) continue;
			
			if(global.Level.Index == DungeonLevel.LanmolasLair){
				//if room doesn't have sand, don't use enemies that emerge from sand
				if(!Room.Sand && (_ObjIndex == oEnemy_Delavant || _ObjIndex == oEnemy_Geldman || _ObjIndex == oEnemy_Leever)) continue;
			}
			
			var _Data = global.EnemyData[_ObjIndex];
			if(!is_struct(_Data)) continue;
		
			if(EnemyTrap && _Data.TrapEnemy == 0) continue;
			
			var EnemyMultiple = _Data.Levels[global.Level.Index];
			repeat(EnemyMultiple){ //add this amount to the list, higher values mean more likely it will get picked
				ds_list_add(EnemyList, _ObjIndex);
			}
			if(EnemyMultiple > 0) EnemyTypes++;
		}
		//check to see if list is empty, if it is:
		//	if we want an enemy trap but there's none in the list for this level, then set the trap to false and redo the list count for all enemies
		//	if normal list is empty, return false
		if(ds_list_size(EnemyList) == 0){
			if(EnemyTrap){
				EnemyTrap = false;
				continue;
			}else{
				ds_list_destroy(EnemyList);
				return false;
			}
		}
		break;
	}	
	

	var EnemyTrapInst = EnemyTrap ? instance_create_layer(Room.x + 16, Room.y + 16, "System", oEnemyTrap) : noone;
	
	
	var EnemyTypesSelected = irandom_range(1, min(EnemyTypes, 3));	
	
	
	ds_list_shuffle(EnemyList);
	var EnemyChoiceList = ds_list_create();
	for(var i = 0; i < EnemyTypesSelected; i++){
		ds_list_add(EnemyChoiceList, EnemyList[| i])
	}
	ds_list_destroy(EnemyList);
	
	
	var WallTypeEnemy = -1;
	

	//Pick the type of wall enemy the room may have
	var WallEnemiesList = ds_list_create();
	if(!global.SpawnedRollingSpikes && Prob(Chance_SpawnWallEnemies)){
		repeat(global.EnemyData[oEnemy_Beamos].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Beamos)};
		repeat(global.EnemyData[oEnemy_Cannon].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Cannon)};
		repeat(global.EnemyData[oEnemy_Medusa].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Medusa)};
	}
	
	if(ds_list_size(WallEnemiesList) > 0){
		ds_list_shuffle(WallEnemiesList);
		WallTypeEnemy =  WallEnemiesList[| 0];
	}
	ds_list_destroy(WallEnemiesList);

	
	var Spawned = false;
	
	if(EnemyTrap) TotalPackPoints = ceil(TotalPackPoints * 1.4);
	
	while(TotalPackPoints > 0 && ds_list_size(EnemyChoiceList) > 0){

		var PackPoints = 0;
		if(WallTypeEnemy != -1){
			var EnemyIndex = WallTypeEnemy;
			WallTypeEnemy = -1;
		}else{
			ds_list_shuffle(EnemyChoiceList);
			var EnemyIndex = EnemyChoiceList[| 0];
			PackPoints = global.EnemyData[EnemyIndex].PackPoints;
			if(PackPoints > TotalPackPoints){
				ds_list_finddelete_all(EnemyChoiceList, EnemyIndex);
				continue;
			}
		}
			
		for(var Tries = 0; Tries < 75; Tries++){ //Try random positions until enemy is at a safe distance	
		
			var EnemyArea = EnemyAreaArray[irandom(EnemyAreasInTemplate - 1)];
			var EnemyAreaX = Room.x + EnemyArea.x;
			var EnemyAreaY = Room.y + EnemyArea.y;
			var _FloorLevel = GetFloorLevelID(EnemyAreaX, EnemyAreaY);
			var FloorLevelStr = GetFloorLevelString(_FloorLevel);
			
			var CheckForObjs = true;
			var MinDistFromWall = 8;
			var SafeDistance = 16;


			var EnemyX = EnemyAreaX + irandom(EnemyArea.width);
			var EnemyY = EnemyAreaY + irandom(EnemyArea.height);
					
			switch(EnemyIndex){

				case oEnemy_Beamos:
				case oEnemy_Medusa:
				case oEnemy_Cannon:
					EnemyX = EnemyAreaX + (floor(irandom(EnemyArea.width) / 8) * 8); //Allign wall-type enemies tog grid
					EnemyY = EnemyAreaY + (floor(irandom(EnemyArea.height) / 8) * 8);
					MinDistFromWall = 24;
					SafeDistance = 32;
					break;

				case oEnemy_Keese:
					CheckForObjs = false;
					_FloorLevel = UPPERLOWER;					
					break;
					
				case oEnemy_Poe:
					EnemyX = Room.x + 128;
					EnemyY = Room.y + 64;
					CheckForObjs = false;
					_FloorLevel = UPPERLOWER;
					
					break;

				case oEnemy_Wizzrobe:
					SafeDistance = 48;				
					break;
				
				case oEnemy_Kyameron_Emitter:
				case oEnemy_Hover:	
					if(!OnWaterTile(_FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower, EnemyX, EnemyY)) continue;
					break;
				
				case oEnemy_Geldman:
					MinDistFromWall = 24;
				case oEnemy_Delavant:				
				case oEnemy_Leever:
					if(!OnSandTile(_FloorLevel == UPPER ? global.TMID_Floor_Upper : global.TMID_Floor_Lower, EnemyX, EnemyY)) continue;
					break;

			}			

			if(CheckForObjs){
				if(!SafeDistancePoint(EnemyX, EnemyY, false, SafeDistance, true)) continue;
			}


			var _ItemHolding = noone;
			var CanHoldSpecialItem = global.EnemyData[EnemyIndex].SpecialItem == 0 ? false : true; //Enemy_SafeToHoldSpecialItem(EnemyIndex);
			var CanHoldBonusItem = global.EnemyData[EnemyIndex].Item == 0 ? false : true;
		
			if(_SpecialItem != noone && CanHoldSpecialItem && !global.EnemyHasSpecialItem){
				_ItemHolding = _SpecialItem;
			}
			
			if(_ItemHolding == noone && CanHoldBonusItem){
				if(Prob(Chance_EnemyBonusItem)) _ItemHolding = PickPotItem(true, false);
			}
			
			var EnemyInst = instance_create_layer(EnemyX, EnemyY, "Objs_" + FloorLevelStr, EnemyIndex, {FloorLevel : _FloorLevel, 
																							 ItemHolding : _ItemHolding, 
																							 RoomTemplate: Room.TemplateIndex,
																							 SectionID: Room.Section_ID,
																							 RoomX : Room.x,
																							 RoomY : Room.y});
		

			if(CheckForObjs){
				
				with(EnemyInst){
					var WallCollisionInst = ObjCollision(x, y, oWall);
					var DistToWall = distance_to_object(oWall); 
					var DistToDoor = distance_to_object(oDoor);
				}
				if(!InstInUsedSpaceArea(EnemyInst) && WallCollisionInst == noone && DistToWall >= MinDistFromWall && DistToDoor >= 32){ 
					AddUsedSpace(EnemyX, EnemyY, EnemyInst.sprite_width, EnemyInst.sprite_height, false, true);
					Spawned = true;
					break;
				}else{
					instance_destroy(EnemyInst);
				}
				
			}else{
				Spawned = true;
				break;
			}

			
			
		}
		
		if(Spawned && _ItemHolding == _SpecialItem) global.EnemyHasSpecialItem = true;
		
		TotalPackPoints -= PackPoints;
		
	}

	ds_list_destroy(EnemyChoiceList);	


	if(EnemyTrap && Spawned){
		for(var _DoorIndex = 0; _DoorIndex < array_length(Room.Doors); _DoorIndex++){
			var _Door = Room.Doors[_DoorIndex];
			_Door.Status = DoorStatus.Closed;
		}
		with(oDoor){
			if(RoomIndex == _RoomIndex)
				Status = DoorStatus.Closed;
		}
	}
	
	if(EnemyTrapInst != noone && (!Spawned || !EnemyTrap)){
		instance_destroy(EnemyTrapInst);
	}

	return Spawned;
	
}

function SpawnRollingSpikes(_RoomIndex){
	
	if(global.EnemyData[oEnemy_RollingSpike][$ "Levels"][global.Level.Index] == 0) exit;
	
	if(!Prob(Chance_SpawnRollingSpikes)) return false;	
	
	if(Room.SpecialObject == SpecialDungeonObj.Crystal || global.SpawnedMonument || global.SpawnedShop || global.SpawnedAltar || global.SpawnedKinstone || global.SpawnedBlocks || global.SpawnedTreasure) return false;

	var RollingSpikeArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "RollingSpikes"];

	var RollingSpikesInTemplate = array_length(RollingSpikeArray);
	
	if(RollingSpikesInTemplate == 0) return false;
	
	for(var RollingSpikeIndex = 0; RollingSpikeIndex < RollingSpikesInTemplate; RollingSpikeIndex++){
		
		var RollingSpike = RollingSpikeArray[RollingSpikeIndex];
			
		var RollingSpikeX = Room.x + RollingSpike.x;
		var RollingSpikeY = Room.y + RollingSpike.y;

		var FloorLevelStr = GetFloorLevelString(RollingSpikeX, RollingSpikeY);
		var _FloorLevel = GetFloorLevelID(RollingSpikeX, RollingSpikeY);
		var RollingSpikeInst = instance_create_layer(RollingSpikeX, RollingSpikeY, "Objs_" + FloorLevelStr, oEnemy_RollingSpike, {FloorLevel : _FloorLevel, 
																																 ItemHolding : noone, 
																																 RoomTemplate: Room.TemplateIndex,
																																 SectionID: Room.Section_ID,
																																 RoomX : Room.x,
																																 RoomY : Room.y});
		
		switch(RollingSpike.gid){
			case TemplateObjGID.RollingSpikesH:	
				RollingSpikeInst.sprite_index = sEnemy_RollingSpikes_H;
				RollingSpikeInst.vx = RollingSpikeInst.Speed;
				RollingSpikeInst.H = RollingSpike.height;
				RollingSpikeInst.Dir = HORIZONTAL;
				break;
			case TemplateObjGID.RollingSpikesV:	
				RollingSpikeInst.sprite_index = sEnemy_RollingSpikes_V;
				RollingSpikeInst.vy = RollingSpikeInst.Speed;
				RollingSpikeInst.W = RollingSpike.width;
				RollingSpikeInst.Dir = VERTICAL;
				break;
		}
		
		
		with(RollingSpikeInst){
			
			RollingSpikes_SetMaskSprite();
			
			var WallCollisionInst = ObjCollision(x, y, oWall);
		}
				
		if(!InstInUsedSpaceArea(RollingSpikeInst) && WallCollisionInst == noone){ 
			AddUsedSpace(RollingSpikeX, RollingSpikeY, RollingSpike.width, RollingSpike.height, false, true);
		}else instance_destroy(RollingSpikeInst);
				
	}
	
	return true;
	
}

function SpawnGuruBars(_RoomIndex){
	
	if(global.EnemyData[oEnemy_Guru_Bar][$ "Levels"][global.Level.Index] == 0) exit;
	
	if(global.SpawnedShop || global.SpawnedKinstone) return false;
	
	if(!Prob(Chance_SpawnGuruBars)) return false;	
	
	var GuruBarArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "GuruBars"];

	var GuruBarsInTemplate = array_length(GuruBarArray);
	
	if(GuruBarsInTemplate == 0) return false;

	if(global.SpawnedBlocks){
		var SpawnedGuruBar = BlockPattern_DrawItem(_RoomIndex, BlockObj.Guru);
		if(SpawnedGuruBar) return true;
	}
	
	for(var GuruBarIndex = 0; GuruBarIndex < GuruBarsInTemplate; GuruBarIndex++){
		
		var GuruBar = GuruBarArray[GuruBarIndex];
			
		var GuruBarX = Room.x + GuruBar.x + 56;
		var GuruBarY = Room.y + GuruBar.y;

		var FloorLevelStr = GetFloorLevelString(GuruBarX, GuruBarY);
		var _FloorLevel = GetFloorLevelID(GuruBarX, GuruBarY);
		var GuruBarInst = instance_create_layer(GuruBarX, GuruBarY, "Objs_" + FloorLevelStr, oEnemy_Guru_Bar, {FloorLevel : _FloorLevel, 
																												ItemHolding : noone, 
																												RoomTemplate: Room.TemplateIndex,
																												SectionID: Room.Section_ID,
																												RoomX : Room.x,
																												RoomY : Room.y});		
				
		if(!InstInUsedSpaceArea(GuruBarInst) && ObjCollision(x, y, oWall) == noone && SafeDistancePoint(GuruBarX + 8, GuruBarY + 8, false, 32, false)){ 
			AddUsedSpace(GuruBarX - 16, GuruBarY - 16, 48, 48, false, true);
		}else instance_destroy(GuruBarInst);
				
	}
	
	return true;
			
}


function SpawnObj(_RoomIndex, SpecialObjType, InSection, UnusedZone, ObjContents, IgnoreUsedSpaces = false){	
	
	//SpecialObjType = enum SpecialObj.Pot, SpecialObj.Treasure, etc

	
	if(SpecialObjType == SpecialObj.HeartGuy || SpecialObjType == SpecialObj.DeadGuy)
		//use treasure containers for heart guy locations
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObj.Treasure];
	else if(SpecialObjType == SpecialObj.Torch)
		//use pot containers for torches
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObj.Pot];
	else if(SpecialObjType == SpecialObj.Warp || SpecialObjType == SpecialObj.WarpDest)
		//use crystal containers for warps
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObj.Crystal];
	else
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObjType];
		
	ds_list_shuffle(SpecialObjComboIDList);
	
	var Success = false;

	for(var SpecialObjComboTypeIndex = 0; SpecialObjComboTypeIndex < ds_list_size(SpecialObjComboIDList); SpecialObjComboTypeIndex++){
		
		var SpecialObjComboType = SpecialObjComboIDList[| SpecialObjComboTypeIndex];
		
		//don't use PotTreasures if pot is requested
		if(SpecialObjType == SpecialObj.Pot && SpecialObjComboType == SpecialObjCombo.PotTreasure) continue;
		//don't use anything but a PotTreasures if DeadGuy is requested
		if(SpecialObjType == SpecialObj.DeadGuy && SpecialObjComboType != SpecialObjCombo.PotTreasure) continue;
		//don't use anything but a Pot if torch is requested
		if(SpecialObjType == SpecialObj.Torch && SpecialObjComboType != SpecialObjCombo.Pot) continue;
		
		//Main/Section objs
		var SpecialObjComboObjList = (InSection ? global.RoomTemplateObjLists_SpecialObjCombos_Section[SpecialObjComboType] : global.RoomTemplateObjLists_SpecialObjCombos_Main[SpecialObjComboType]);
		
		var ObjCount = ds_list_size(SpecialObjComboObjList);
		ds_list_shuffle(SpecialObjComboObjList);
		
		for(var ObjListIndex = 0; ObjListIndex < ObjCount; ObjListIndex++){			
			
			var Obj = SpecialObjComboObjList[| ObjListIndex];
			
			var ZoneIndex = InZone(_RoomIndex, Obj, Room.TemplateIndex, Room.Section_ID, false);
			if( (UnusedZone != -1 && ZoneIndex != UnusedZone) ) continue;
			
			var ObjUsed = CheckUsedObj(Obj);
			if(ObjUsed) continue;

			
			var ObjX1 = Room.x + Obj.x;
			var ObjY1 = Room.y + Obj.y;
			var ObjW = Obj.width;
			var ObjH = Obj.height;
			
			if(SpecialObjType == SpecialObj.Warp || SpecialObjType == SpecialObj.WarpDest){
				var _CornersOnCarpet = CornersOnCarpet(GetFloorLevelTMID("Tiles_Floor", ObjX1, ObjY1), ObjX1, ObjY1, ObjX1 + 15, ObjY1 + 15);
				if(_CornersOnCarpet > 0 && _CornersOnCarpet < 4){
					continue;
				}
			}
						
			//Perform obj transformation (SBShifts, rotations, etc)
			var xywhList = ds_list_create();
			ds_list_add(xywhList, ObjX1, ObjY1, ObjW, ObjH);
			TransformObj(_RoomIndex, Obj, xywhList);
			ObjX1 = xywhList[| 0]; ObjY1 = xywhList[| 1];
			ObjW = xywhList[| 2]; ObjH = xywhList[| 3];
			ds_list_destroy(xywhList);
			
			
			var ObjX2 = ObjX1 + ObjW - 1;
			var ObjY2 = ObjY1 + ObjH - 1;

			//if dest warp is touching a wall above, lInk will get stuck
			if(SpecialObjType == SpecialObj.WarpDest){
				if(collision_rectangle(ObjX1, ObjY1 - 8, ObjX2, ObjY1 - 1, oWall, false, true)) continue;
			}
			
			var Dist = 24;
			var SafeDistBox = SafeDistanceBox(ObjX1, ObjY1, ObjX2, ObjY2, InSection, Dist, false);
			if(!SafeDistBox) continue;
			
			var _DoorDist = 16;//(SpecialObjType == SpecialObj.Warp || SpecialObjType == SpecialObj.WarpDest) ? 48 : 16; //keep warps away from doors
			
			var CheckDoorsLeft = collision_rectangle(ObjX1 - _DoorDist, ObjY1, ObjX1, ObjY2, oDoor, false, true);
			var CheckDoorsRight = collision_rectangle(ObjX2, ObjY1, ObjX2 + _DoorDist, ObjY2, oDoor, false, true);
			var CheckDoorsUp = collision_rectangle(ObjX1, ObjY1 - _DoorDist, ObjX2, ObjY1, oDoor, false, true);
			var CheckDoorsDown = collision_rectangle(ObjX1, ObjY2, ObjX2, ObjY2 + _DoorDist, oDoor, false, true);
					
			if(CheckDoorsLeft || CheckDoorsRight || CheckDoorsUp || CheckDoorsDown) continue;						
			
			var ObjTilesW = ObjW / 8;
			var ObjTilesH = ObjH / 8;
			var MaxItems = ObjTilesW / 2;
			
			var SpawnItem = false;
			if(SpecialObjComboType == SpecialObjCombo.PotTreasure && ObjTilesH == 2){
				//Special case with PotTreasures. These are usually always found below doors to be used when doors aren't there, and have a width of 6, 8 or 10, and tile height of 2(3-5 items lined up in a row)
				//If the specialitemtype is one of these, then sometimes spawn a treasure row, otherwise proceed below as usual with the offset lists
				
				switch(SpecialObjType){
					case SpecialObj.Treasure:
						if(MaxItems > 5){
							show_message("PotTreasure ID " + string(Obj.id) + " has more than 5 items width");
							game_end();
				
						}
						
						//If there's a switch being added, this is the treasure being created.
						//So limit the PotTreasure obj to only 1 treasure, no extra treasures or pots should be created, otherwise button might appear under one of those extra pots.
						if(global.Switch_Add && global.Switch_Action == SwitchAction.RevealTreasure) MaxItems = 1; 
						
						var Items = irandom_range(1, MaxItems);
						var ItemsW = Items * 16;
						Success = SpawnTreasureRow(ObjX1 + ((ObjW - ItemsW) / 2), ObjY1, InSection, false, ObjContents, Items);
				
						if(Success) ds_list_add(global.UsedObjs, Obj);
						break;
						
					case SpecialObj.HeartGuy:
					case SpecialObj.DeadGuy:
						//HeartGuy would be sitting in the middle of the PotTreasure Combo
						var ObjX = ObjX1 + (ObjW / 2) - 8; //ObjW is the width of the PotTreasure
						var ObjY = ObjY1;
						ObjW = 16; //Set it to the new ObjW of 16, width of HeartGuy
						if(SafeDistanceBox(ObjX, ObjY, ObjX + 15, ObjY + 15, InSection, 56, false)) SpawnItem = true;
						break;

				}
				
			}else{
			
				//make list of all possible offsets and shuffle them. This is so if it tries to generate too close to another used obj, it can keep trying the other offsets
				var OffsetListX = ds_list_create();
				var OffsetListY = ds_list_create();
				for(var OffsetXIndex = 0; OffsetXIndex <= ObjTilesW - 2; OffsetXIndex++)
					ds_list_add(OffsetListX, OffsetXIndex);		
				for(var OffsetYIndex = 0; OffsetYIndex <= ObjTilesH - 2; OffsetYIndex++)
					ds_list_add(OffsetListY, OffsetYIndex);	
			
				ds_list_shuffle(OffsetListX);
				ds_list_shuffle(OffsetListY);
				
				for(var OffsetYIndex = 0; OffsetYIndex < ds_list_size(OffsetListY); OffsetYIndex++){
					for(var OffsetXIndex = 0; OffsetXIndex < ds_list_size(OffsetListX); OffsetXIndex++){
						var ObjX = ObjX1 + (OffsetListX[| OffsetXIndex] * 8);
						var ObjY = ObjY1 + (OffsetListY[| OffsetYIndex] * 8);
						
						switch(SpecialObjType){
							case SpecialObj.Pot:
							case SpecialObj.Crystal:
								var Dist = 8;
								break;
							case SpecialObj.Warp:
							case SpecialObj.WarpDest:
								var Dist = 16;
								break;
							default:
								var Dist = 56;
								break;
						}
						
						//(assuming all obj will be 16x16, this may change). 
						if(SafeDistanceBox(ObjX, ObjY, ObjX + 15, ObjY + 15, InSection, Dist, false))
							var SpawnItem = true;

					
						if(SpawnItem) break;
					}
					if(SpawnItem) break;
				}
			
				ds_list_destroy(OffsetListX);
				ds_list_destroy(OffsetListY);
			
			}
			
			if(SpawnItem){
				
				var FloorLevel = GetFloorLevelID(ObjX, ObjY)
				var FloorLevelStr = GetFloorLevelString(FloorLevel);
				
				switch(SpecialObjType){
					case SpecialObj.Pot:
						var ObjInst = Pot_Create(ObjX, ObjY, ObjContents, InSection);						
						break;
							
							
					case SpecialObj.Treasure:
						var ObjInst = Treasure_Create(ObjX, ObjY, ObjContents, true, ,InSection);					
						break;
								
					case SpecialObj.Crystal:
						var ObjInst = Crystal_Create(_RoomIndex, ObjX, ObjY);						
						break;
					
					case SpecialObj.HeartGuy:
						instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oHeartGuy, {Type : choose(1, 2)});	
						break;
						
					case SpecialObj.DeadGuy:
						if(ObjContents == noone && Prob(Chance_DeadGuyBonusItem)) ObjContents = PickRandomItem(ItemFrom.Treasure)
						instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oDeadGuy, {ItemHolding : ObjContents});	
						break;
					
					case SpecialObj.Torch:
						
						//if no switch is needed, and lighting in Room is true, then some torches are lit
						var _Lit = false;
						if(!global.Switch_Add){
							_Lit = Room.Lighting == 1.0 ? Prob(Chance_Torches_Lit) : true;
						}
						
						var inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oTorch, {Lit: _Lit});
						inst.FloorLevel = FloorLevel;
						inst.GroupIndex = global.TorchGroupIndex;
						WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 2, 2);
						if(global.Switch_Add){
							inst.Action = global.Switch_Action;
							inst.TreasureInst = global.Switch_TreasureInst;
							inst.Switch = true;
						}
						break;
					
					case SpecialObj.Warp:
						
						//using the ObjContents var to send the RoomIndex the warp is travelling to
						var WarpInst = instance_create_layer(ObjX, ObjY, "ObjsFloor_" + FloorLevelStr, oWarp, {RoomIndex : _RoomIndex, FloorLevel : FloorLevel, DestRoomIndex : ObjContents});
						ds_list_add(global.LargeMapItems, WarpInst); 
						break;
						
					case SpecialObj.WarpDest:
						DrawTileBlock(GetFloorLevelTMID("Tiles_Water", ObjX, ObjY), ObjX, ObjY, 9, 0, 2, 2);
						Room.WarpDestX = ObjX + 8;
						Room.WarpDestY = ObjY + 8;
						break;
				}
						

				ds_list_add(global.UsedObjs, Obj);
				AddUsedSpace(ObjX, ObjY, 16, 16, InSection, false);
				Success = true;
				break;
			}
						

			if(Success) break;
		}
		if(Success) break;
	}
	
	if(Success && UnusedZone != -1) Room.UnusedZone = -1;
	
	return Success;
	
}

function SpawnTreasureRow(X, Y, InSection, IgnoreUsedSpaces, MainObj, Items){
	
	//Spawns a row of treasure/pots Items-wide
	
	//p = pot item 1, P = pot item 2, t = bonus treasure, * = main treasure
	var Patterns = ds_list_create();
	switch(Items){
		case 1:	
			ds_list_add(Patterns,"*");
			break;
		
		case 2:
			ds_list_add(Patterns, "*p", "*p", "p*", "p*", "*t", "t*");
			break;
		case 3:
			ds_list_add(Patterns, "p*p", "p*p", "p*p", "p*P", "p*P", "*pt", "tp*", "t*t");
			break;
		
		case 4:
			ds_list_add(Patterns, "p*tp", "p*tP", "pt*p", "pt*P", "*ppt", "tpp*", "tpP*", "*pPt", "t*tt", "tt*t");
			break;
			
		case 5:
			ds_list_add(Patterns, "pp*pp", "pp*pp", "pp*PP", "pP*Pp", "ptp*p", "P*ptP", "tp*pt", "pt*tp", "tp*pt", "pt*tp", "tt*tt");
			break;
			
		default:
			return false;
	}	
	
	if(!IgnoreUsedSpaces){
		if(!SafeDistanceBox(X, Y, X + (Items * 16) - 1, Y + 15, InSection, 40, false)) return false;
	}
	
	var Pattern = Patterns[| irandom(ds_list_size(Patterns) - 1)];
	
	//var FloorLevelStr = GetFloorLevelString(X, Y);
	PotContents1 = PickPotItem(true);
	PotContents2 = PickPotItem(true);
	
	for(var StrIndex = 0; StrIndex < Items; StrIndex++){
		var ItemCode = string_copy(Pattern, StrIndex + 1, 1);
		var ItemX = X + (StrIndex * 16);
				
		//If there's no main obj, replace the T with t or P
		if(ItemCode == "*" && MainObj = noone) ItemCode = choose("p","P","t");
		
		switch(ItemCode){
				
			case "*": //Main treasure
				var TreasureInst = Treasure_Create(ItemX, Y, MainObj, true, , InSection);
				break;

			case "t": //bonus treasure
				var TreasureInst = Treasure_Create(ItemX, Y, RandomItem, true, , InSection);
				break;
				
			case "p": //pot 1
				Pot_Create(ItemX, Y, PotContents1, InSection);
				break;

			case "P": //pot 2
				Pot_Create(ItemX, Y, PotContents2, InSection);
				break;
				
		}
		
	}
	
	AddUsedSpace(X, Y, Items * 16, 16, InSection, false);
	
	ds_list_destroy(Patterns);
	
	return true;
	
}

function SpawnKinstone(_RoomIndex, UnusedZone){
	

	var KinstoneArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Kinstones"];
	var Kinstones = array_length(KinstoneArray);
	
	if(Kinstones == 0) return false;
	
	//make a list of all monument indexes (0-n), then shuffle that list so we can pick them at random
	var KinstoneIndexList = ds_list_create();
	for(var KinstoneIndex = 0; KinstoneIndex < Kinstones; KinstoneIndex++){
		ds_list_add(KinstoneIndexList, KinstoneIndex);
	}
	ds_list_shuffle(KinstoneIndexList);
	

	var _InZone = false;
	
	
	for(var KinstoneIndex = 0; KinstoneIndex < ds_list_size(KinstoneIndexList); KinstoneIndex++){
		
		var KinstoneOK = true;
		
		var Kinstone = KinstoneArray[KinstoneIndexList[| KinstoneIndex]];
		
		var KinstoneX = Room.x + Kinstone.x;
		var KinstoneY = Room.y + Kinstone.y;
		var KinstoneX2 = KinstoneX + 31;
		var KinstoneY2 = KinstoneY + 31;

		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(_RoomIndex, Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);
		
		if(UnusedZone != -1 && !_InZone){
			var ZoneIndex = InZone(_RoomIndex, Kinstone, Room.TemplateIndex, Room.Section_ID, false);
			if( ZoneIndex != UnusedZone) KinstoneOK = false;
		}

		//check if on top of path carpets
		if(global.SpawnedCarpetStyle == CarpetStyle.Path){
			var TMID = GetFloorLevelTMID("Tiles_Floor", KinstoneX, KinstoneY);
			if(CornersOnCarpet(TMID, KinstoneX, KinstoneY, KinstoneX2, KinstoneY2) > 1){
				KinstoneOK = false;
			}
		}
		
		//Check for walls above and below the kinstone. There should be enough space at the bottom to put the treasure and for Link above it
		if(collision_rectangle(KinstoneX, KinstoneY - 24, KinstoneX + 23, KinstoneY + 32 + 31, oWall, false, true)) KinstoneOK = false;

		//Check for doors
		//Top
		if(collision_rectangle(KinstoneX, KinstoneY - 32, KinstoneX2, KinstoneY, oDoor, false, true)) KinstoneOK = false; 
		//Bottom
		if(collision_rectangle(KinstoneX, KinstoneY2 + 1, KinstoneX2, KinstoneY2 + 32, oDoor, false, true)) KinstoneOK = false; 
		//Left
		if(collision_rectangle(KinstoneX - 32, KinstoneY, KinstoneX, KinstoneY2, oDoor, false, true)) KinstoneOK = false; 
		//Right
		if(collision_rectangle(KinstoneX2 + 1, KinstoneY, KinstoneX2 + 1, KinstoneY2, oDoor, false, true)) KinstoneOK = false;
			
		var KinstoneInSection = InSectionArea(_RoomIndex, KinstoneX, KinstoneY, Room.TemplateIndex, Room.Section_ID, true);

		if(!SafeDistanceBox(KinstoneX, KinstoneY, KinstoneX2, KinstoneY2, KinstoneInSection, 64, false)) KinstoneOK = false;

		if(KinstoneOK) break;
		
	}
		

	if(KinstoneOK){
					
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(_RoomIndex, Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);
		
		var FloorLevelStr = GetFloorLevelString(KinstoneX, KinstoneY);
		
		DrawTileBlock(GetFloorLevelTMID("Tiles_Walls", KinstoneX, KinstoneY), KinstoneX, KinstoneY, 36, 0, 4, 4);							
				
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX, KinstoneY, 1, 4);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY + 8, 2, 3);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 24, KinstoneY, 1, 4);
		var WallInst = WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY, 2, 1);
		WallInst.BlockLink = false;
				
		var KinstoneInSection = InSectionArea(_RoomIndex, KinstoneX, KinstoneY, Room.TemplateIndex, Room.Section_ID, true);
			
		AddUsedSpace(KinstoneX, KinstoneY, 32, 32, KinstoneInSection, false);
		
		var inst = instance_create_layer(KinstoneX + 16, KinstoneY + 14, "ObjsHigher_" + FloorLevelStr, oItem_Kinstone_Main, {Index : Kinstone_PickIndex(), RoomIndex : _RoomIndex});

		//add kinstone to large map items so we can draw the icon if Link has a compass
		ds_list_add(global.LargeMapItems, inst); 
		
		if(UnusedZone != -1) Room.UnusedZone = -1;
		
	}
	
	ds_list_destroy(KinstoneIndexList);
	
	return KinstoneOK;
	
}
	
function SpawnJail(_RoomIndex, UnusedZoneIndex){
	
	var JailArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Jails"];
	var Jails = array_length(JailArray);
	
	if(Jails == 0) return false;
	
	//make a list of all jail indexes (0-n), then shuffle that list so we can pick them at random
	
	var JailIndexList = ds_list_create_sequence_shuffled(0, Jails - 1);
	
	var JailOK = false;
	for(var JailIndex = 0; JailIndex < Jails; JailIndex++){

		var Jail = JailArray[JailIndexList[| JailIndex]];
		
		var JailX = Room.x + Jail.x;
		var JailY = Room.y + Jail.y;
		var JailTileW = Jail.width / 8;
		var JailTileH = Jail.height / 8;
		var InSection = InSectionArea(_RoomIndex, JailX + (Jail.width / 2), JailY + (Jail.height / 2), Room.TemplateIndex, Room.Section_ID, true);

		//Check for doors on the side
		if(collision_rectangle(JailX, JailY, JailX + Jail.width - 1, JailY + Jail.height - 1, oDoor, false, true)) continue; 

		JailOK = true;
		break;
		
	}
		

	if(JailOK){
		
		//tile widths for each side of entrance including half of entrance width
		var TilesW_LeftSide = floor(JailTileW / 2);
		var TilesW_RightSide = JailTileW - TilesW_LeftSide;
		var RightSideX = JailX + (TilesW_LeftSide * 8);

		var FloorLevelStr = GetFloorLevelString(JailX + 32, JailY + 32);
		var JailBaseWallLayer = GetFloorLevelTMID("Tiles_Walls", JailX + 32, JailY + 32);
		
		//check if there's a door above. If so, and if it's locked, make door unlocked and add lock to jail. If there's no doors, make jail a full jail with prisoner
		var DoorList = ds_list_create();
		var DoorCount = collision_rectangle_list(JailX, Room.y + 16, JailX + Jail.width - 1, JailY, oDoor, false, true, DoorList, false);
		var FoundLockedDoor = false;
		for(var DoorIndex = 0; DoorIndex < DoorCount; DoorIndex++){
			var DoorInst = DoorList[| DoorIndex];
			if(DoorInst.Status == DoorStatus.Locked){
				//found a door above the jail that is locked, make it unlocked
				DoorInst.Status = DoorStatus.Open;
				//if the locked door exists in the map items list, then delete it
				var i = ds_list_find_index(global.LargeMapItems, DoorInst);
				if(i != -1) ds_list_delete(global.LargeMapItems, i);
		
				FoundLockedDoor = true;
			}
			
		}
		
		DrawTileBlock(global.TMID_Higher, JailX, JailY, 56, 0, 1, 1); //TL
		//top beam
		for(var i = 0; i < JailTileW - 2; i++){
			DrawTileBlock(global.TMID_Higher, JailX + 8 + (i * 8), JailY, 57, 0, 1, 1);
		}
		DrawTileBlock(global.TMID_Higher, JailX + ((JailTileW - 1) * 8), JailY, 61, 0, 1, 1); //TR
		
		if(DoorCount == 0){ //***also add a check to make sure the top of the jail is either 7,8 or 9 tiles away from Room.y so that prisoner has just enough space, not too much, not too little
			
			//top vertical bars
			for(var i = 0; i < JailTileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 8, 57, 1, 1, 1);
			}				

			//top horizontal bars
			DrawTileBlock(global.TMID_Higher, JailX + 8, JailY + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), JailY + 16, 61, 2, 1, 1);
			for(var i = 0; i < JailTileW - 4; i++){ //left side
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 16, 57, 2, 1, 1);
			}

			//bottom bars
			for(var i = 0; i < JailTileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 24, 57, 3, 1, 1);
			}
			DrawTileBlock(global.TMID_Higher, RightSideX - 8, JailY + 16, 58, 2, 1, 1);
			DrawTileBlock(global.TMID_Higher, RightSideX - 8, JailY + 24, 58, 3, 1, 1);
			
			//left base walls
			DrawTileBlock(JailBaseWallLayer, JailX + 24, JailY + 32, 56, 3, 1, 1);
			for(var i = 0; i < JailTileW - 8; i++){ 
				DrawTileBlock(JailBaseWallLayer, JailX + 32 + (i * 8), JailY + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, JailX + Jail.width - 32, JailY + 32, 56, 3, 1, 1);
		
			var WallInst = WallObj_Create("Objs_" + FloorLevelStr, JailX + 24, JailY + 24, JailTileW - 6, 2);
			
			//add extra used space above full jails so we don't add pots and such inside
			AddUsedSpace(JailX, Room.y, Jail.width, JailY - Room.y, InSection, false);
			
			//prisoner
			if(ds_list_size(global.UnusedPrisoners) == 0){
				//if all prisoners were used (unlikely), just use dead prisoner
				var _Index = Prisoner.Dead;
			}else{
				//pick first prisoner index from shuffled list, then delete it from the list so it's not picked twice
				var _Index = global.UnusedPrisoners[| 0];
				ds_list_delete(global.UnusedPrisoners, 0);
			}
			var inst = instance_create_layer(JailX + 40 + (irandom(JailTileW - 10) * 8), JailY + 8, "Objs_" + FloorLevelStr, oPrisoner, {Index : _Index});			
			
		}else{
		
		
			//top vertical bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 8, 57, 1, 1, 1);
			}		
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Higher, JailX + (TilesW_LeftSide * 8) + 8 + (i * 8), JailY + 8, 60, 1, 1, 1);
			}

			//top horizontal bars
			DrawTileBlock(global.TMID_Higher, JailX + 8, JailY + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), JailY + 16, 61, 2, 1, 1);
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //left side
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 16, 57, 2, 1, 1);
			}
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //right side
				DrawTileBlock(global.TMID_Higher, RightSideX + 8 + (i * 8), JailY + 16, 59, 2, 1, 1);
			}
		
			//bottom bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Higher, JailX + 16 + (i * 8), JailY + 24, 57, 3, 1, 1);
			}			
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Higher, RightSideX + 8 + (i * 8), JailY + 24, 59, 3, 1, 1);
			}

			//left base walls
			DrawTileBlock(JailBaseWallLayer, JailX + 24, JailY + 32, 56, 3, 1, 1);
			for(var i = 0; i < TilesW_LeftSide - 6; i++){ 
				DrawTileBlock(JailBaseWallLayer, JailX + 32 + (i * 8), JailY + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, JailX + (TilesW_LeftSide * 8) - 16, JailY + 32, 56, 3, 1, 1);
		
			//right base wall
			DrawTileBlock(JailBaseWallLayer, RightSideX + 8, JailY + 32, 56, 3, 1, 1);
			for(var i = 0; i < TilesW_RightSide - 6; i++){ 
				DrawTileBlock(JailBaseWallLayer, RightSideX + 16 + (i * 8), JailY + 32, 61, 3, 1, 1);
			}
			DrawTileBlock(JailBaseWallLayer, RightSideX + (TilesW_RightSide * 8) - 32, JailY + 32, 56, 3, 1, 1);
		
			var WallInst = WallObj_Create("Objs_" + FloorLevelStr, JailX + 24, JailY + 24, TilesW_LeftSide - 4, 2);
			var WallInst = WallObj_Create("Objs_" + FloorLevelStr, RightSideX + 8, JailY + 24, TilesW_RightSide - 4, 2);

		
			//Lock
			if(FoundLockedDoor){
				var KeyBlockInst = instance_create_layer(RightSideX - 8, JailY + 16, "Objs_" + FloorLevelStr, oKeyBlock);	
				KeyBlockInst.RoomIndex = _RoomIndex;
				//add key block to map items list. Any locked door above was already removed from that list
				ds_list_add(global.LargeMapItems, KeyBlockInst);
			
			}
			ds_list_destroy(DoorList);
		
		}
					
		AddUsedSpace(JailX, JailY, Jail.width, Jail.height, InSection, false);
		//add used space in front of jail entrance.
		AddUsedSpace(RightSideX - 8, JailY + Jail.height, 16, 8, InSection, false);
		
		if(UnusedZoneIndex != -1) Room.UnusedZone = -1;
		
	}
	
	ds_list_destroy(JailIndexList);
	
	return JailOK;
	
}

function CheckUsedObj(_Obj){
	
	//check if _Obj was used already
	for(var ObjIndex = 0; ObjIndex < ds_list_size(global.UsedObjs); ObjIndex++){
		if(global.UsedObjs[| ObjIndex] == _Obj) return true;
	}
	
	return false
	
}

function PlatformVerify(_RoomIndex, InSection, UnusedZone){
	
	//Altars are now part of the Platform family. Platforms can be altars, floor shops, etc.
	//Code below still says Altar for everything, but think of the following as Platforms
	//Check all altars in template and set dimensions into global.AltarData if valid

	var AltarsArray = TemplateRoom[$ "Sections"][Room.Section_ID][$ "Altars"];
	
	var AltarsInTemplate = array_length(AltarsArray);

	if(AltarsInTemplate == 0) return false;

	var AltarsList = ds_list_create();
	repeat(AltarsInTemplate) ds_list_add(AltarsList, ds_list_size(AltarsList)); //list now has 0,1,2... up to AltarsInTemplate - 1
	ds_list_shuffle(AltarsList);
			
	var AltarValid = false;
	
	for(var AltarListIndex = 0; AltarListIndex < AltarsInTemplate; AltarListIndex++){
		

		var AltarIndex = AltarsList[| AltarListIndex];
		var Altar = AltarsArray[AltarIndex]
		
		if(Room.Lighting && GetPropertyValue(Altar[$ "properties"], "LightNotAllowed") != -1) continue;
		
		var AltarValid = false;
		
		var AltarX1 = Room.x + Altar.x;
		var AltarY1 = Room.y + Altar.y;
		var AltarW = Altar.width;
		var AltarH = Altar.height;
		
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, AltarX1, AltarY1, AltarW, AltarH);
		TransformObj(_RoomIndex, Altar, xywhList);
		AltarX1 = xywhList[| 0]; AltarY1 = xywhList[| 1];
		AltarW = xywhList[| 2]; AltarH = xywhList[| 3];
		ds_list_destroy(xywhList);
			
			
		var AltarX2 = AltarX1 + AltarW - 1;
		var AltarY2 = AltarY1 + AltarH - 1;
		
		var AltarInSection = InSectionArea(_RoomIndex, AltarX1, AltarY1, Room.TemplateIndex, Room.Section_ID, true);
		if( (!InSection && AltarInSection) || (InSection && !AltarInSection) ) continue;

		var ZoneIndex = InZone(_RoomIndex, Altar, Room.TemplateIndex, Room.Section_ID, false);
		if( (UnusedZone != -1 && ZoneIndex != UnusedZone) ) continue;
		
		var Option_StickLeft = true;
		var Option_StickRight = true;
		
		var DoorCollisionList = ds_list_create();
		var Collisions = collision_rectangle_list(AltarX1 - 24, AltarY1, AltarX2 + 24, AltarY2, oDoor, false, true, DoorCollisionList, false);
		
		//Check Left and Right side doors first, shift the altar if collisions
		for(var DoorIndex = 0; DoorIndex < Collisions; DoorIndex++){
				
			var DoorInst = DoorCollisionList[| DoorIndex];
			
			//We need to check the section of the doors, because if door is in opposite section from altar, no need to worry about collision
			var DoorInSection = InSectionArea(DoorInst.x, DoorInst.y, Room.TemplateIndex, Room.Section_ID, true);
			if(DoorInSection != AltarInSection) continue;
				
			switch(DoorInst.Location){
						
				case "Left":
					AltarX1 = DoorInst.x + 24 + 24;
					Option_StickLeft = false;
					break;
					
				case "Right":
					AltarX2 = DoorInst.x - 24 - 1;
					Option_StickRight = false;
					break;
					
					
			}
				
		}			

		//Check doors above now
		var CheckDoorCollisions = true;
		while(CheckDoorCollisions){
			
			ds_list_clear(DoorCollisionList);
			var Collisions = collision_rectangle_list(AltarX1, AltarY1 - 24, AltarX2, AltarY2, oDoor, false, true, DoorCollisionList, false);
			CheckDoorCollisions = false;
			
			for(var DoorIndex = 0; DoorIndex < Collisions; DoorIndex++){
			
				var DoorInst = DoorCollisionList[| DoorIndex];

				//We need to check the section of the doors, because if door is in opposite section from altar, no need to worry about collision
				var DoorInSection = InSectionArea(_RoomIndex, DoorInst.x, DoorInst.y, Room.TemplateIndex, Room.Section_ID, true);
				if(DoorInSection != AltarInSection) continue;
			
				switch(DoorInst.Location){
					case "Top":
						var DoorCenterX = DoorInst.x + 16;
						var DistFromX1 = abs(DoorCenterX - AltarX1);
						var DistFromX2 = abs(DoorCenterX - AltarX2);

						if(abs(DistFromX2 - DistFromX1) <= 1){				
							if(FlipCoin_Bool()){
								AltarX1 = DoorInst.x + 32;
								CheckDoorCollisions = true;
								Option_StickLeft = false;
							}else{
								AltarX2 = DoorInst.x - 1;
								CheckDoorCollisions = true;
								Option_StickRight = false;
							}
							//Option_Centered = false;
						}else if(DistFromX1 < DistFromX2){
							AltarX1 = DoorInst.x + 32;
							CheckDoorCollisions = true;
							Option_StickLeft = false;
						}else if(DistFromX2 < DistFromX1){
							AltarX2 = DoorInst.x - 1;
							CheckDoorCollisions = true;
							Option_StickRight = false;
						}

						break;					
					
				}
				
				if(CheckDoorCollisions) break;
				
			}
		}
		
		ds_list_destroy(DoorCollisionList);
			
		
		//after all the transformations, the altar might be less than 8 tiles wide which is too small. If it is go to next altar
		if(AltarX2 - AltarX1 + 1 < 64) continue;

		if(!SafeDistanceBox(AltarX1, AltarY1, AltarX2, AltarY2, AltarInSection, 48, false)) continue;
		
		AltarValid = true;
		break;
	
	}

	if(!AltarValid) return false;
	
	
	
	//make width a multiple of 16 so treasures are alligned
	var AltarW = floor((AltarX2 - AltarX1 + 1) / 16) * 16; 
	var AltarH = AltarY2 - AltarY1 + 1;

	var NewAltarW = irandom_range(4, min((AltarW / 16), 7)) * 2 * 8; //this creates widths that are multiples of 2, starting at 8 tiles wide
	
	
	if(Option_StickLeft && !Option_StickRight)
		var AltarX = AltarX1;	
	else if(Option_StickRight && !Option_StickLeft)
		var AltarX = AltarX2 - NewAltarW + 1;
	else
		var AltarX = AltarX1 + ((AltarW - NewAltarW) / 2);
	
	AltarW = NewAltarW;	
	
	var AltarY = AltarY1;
	AltarH = irandom_range(8, AltarH / 8) * 8;

	global.AltarData = {x : AltarX, y : AltarY, w : AltarW, h : AltarH, StickL : Option_StickLeft, StickR : Option_StickRight};
	
	AddUsedSpace(AltarX, AltarY, AltarW, AltarH + 24, InSection, false);
	
	return true;
	
}

function AddUsedSpace(_x, _y, _w, _h, _InSection, _Enemy){
	
	var UsedSpace = {x : _x, y : _y, w : _w, h : _h, InSection : _InSection, Enemy : _Enemy};

	ds_list_add(global.UsedSpaces, UsedSpace);	
	
}

function InUsedSpaceArea(_x, _y){

	//returns true if point is within a used space area
	
	for(var UsedSpaceIndex = 0; UsedSpaceIndex < ds_list_size(global.UsedSpaces); UsedSpaceIndex++){
		
		var UsedSpaceX = global.UsedSpaces[| UsedSpaceIndex][$ "x"];
		var UsedSpaceY = global.UsedSpaces[| UsedSpaceIndex][$ "y"];
		var UsedSpaceW = global.UsedSpaces[| UsedSpaceIndex][$ "w"];
		var UsedSpaceH = global.UsedSpaces[| UsedSpaceIndex][$ "h"];
		
		if(point_in_rectangle(_x, _y, UsedSpaceX, UsedSpaceY, UsedSpaceX + UsedSpaceW - 1, UsedSpaceY + UsedSpaceH - 1)) return true;
				
	}
	
	return false;
	
}

function InstInUsedSpaceArea(Inst){

	//returns true if instance is within a used space area
	
	for(var UsedSpaceIndex = 0; UsedSpaceIndex < ds_list_size(global.UsedSpaces); UsedSpaceIndex++){
		
		var UsedSpaceX = global.UsedSpaces[| UsedSpaceIndex][$ "x"];
		var UsedSpaceY = global.UsedSpaces[| UsedSpaceIndex][$ "y"];
		var UsedSpaceW = global.UsedSpaces[| UsedSpaceIndex][$ "w"];
		var UsedSpaceH = global.UsedSpaces[| UsedSpaceIndex][$ "h"];
		
		if(collision_rectangle(UsedSpaceX, UsedSpaceY, UsedSpaceX + UsedSpaceW - 1, UsedSpaceY + UsedSpaceH - 1, Inst, false, true)) return true;
				
	}
	
	return false;
	
}

function SafeDistanceBox(_x1, _y1, _x2, _y2, InSection, Distance, CheckForEnemy){
	
	//check 4 corners and center point
	return SafeDistancePoint(_x1, _y1, InSection, Distance, CheckForEnemy) && SafeDistancePoint(_x2, _y1, InSection, Distance, CheckForEnemy) && SafeDistancePoint(_x1, _y2, InSection, Distance, CheckForEnemy) && SafeDistancePoint(_x2, _y2, InSection, Distance, CheckForEnemy) && SafeDistancePoint((_x1 + _x2) / 2, (_y1 + _y2) / 2, InSection, Distance, CheckForEnemy)
	
}

function SafeDistancePoint(_x, _y, InSection, Distance, CheckForEnemy){
	
	
	//checks if (_x, _y) is too close to the used space, or enemy if CheckForEnemy is true
	var Safe = true;
	
	for(var UsedSpaceIndex = 0; UsedSpaceIndex < ds_list_size(global.UsedSpaces); UsedSpaceIndex++){
		
		//if the space is in a different section, no need to check current space since objs can be close to another if in different sections
		var UsedSpaceInSection = global.UsedSpaces[| UsedSpaceIndex][$ "InSection"];
		if(UsedSpaceInSection != InSection) continue;
		
		var IsEnemy = global.UsedSpaces[| UsedSpaceIndex][$ "Enemy"];
		if(CheckForEnemy && !IsEnemy) continue;
		
		var UsedSpaceX = global.UsedSpaces[| UsedSpaceIndex][$ "x"];
		var UsedSpaceY = global.UsedSpaces[| UsedSpaceIndex][$ "y"];
		var UsedSpaceW = global.UsedSpaces[| UsedSpaceIndex][$ "w"];
		var UsedSpaceH = global.UsedSpaces[| UsedSpaceIndex][$ "h"];
		var UsedSpaceX2 = UsedSpaceX + UsedSpaceW - 1;
		var UsedSpaceY2 = UsedSpaceY + UsedSpaceH - 1;
		
		//check if point is inside used space
		if(point_in_rectangle(_x, _y, UsedSpaceX, UsedSpaceY, UsedSpaceX2, UsedSpaceY2)){
			Safe = false;
			break;			
		}
		
		//check distance away from used space at all 4 corners
		if(point_distance(_x, _y, UsedSpaceX, UsedSpaceY) <= Distance || point_distance(_x, _y, UsedSpaceX2, UsedSpaceY) <= Distance || point_distance(_x, _y, UsedSpaceX, UsedSpaceY2) <= Distance || point_distance(_x, _y, UsedSpaceX2, UsedSpaceY2) <= Distance){
			Safe = false;
			break;
		}
	}
	
	return Safe;
	
}

function InSectionArea(_RoomIndex, _x, _y, _TemplateIndex, _SectionID, _RelativeToRoom){
	
	//returns true if point is within a section area
	//_Template: boolean if checking template coordinates or actual dungeon Room
	var SectionAreas = array_length(global.Templates_Room[_TemplateIndex][$ "Sections"][_SectionID][$ "SectionArea"]);
	for(var SectionAreaIndex = 0; SectionAreaIndex < SectionAreas; SectionAreaIndex++){

		var SectionObj = global.Templates_Room[_TemplateIndex][$ "Sections"][_SectionID][$ "SectionArea"][SectionAreaIndex];
		
		var SectionX = (_RelativeToRoom ? Room.x : 0) + SectionObj.x;
		var SectionY = (_RelativeToRoom ? Room.y : 0) + SectionObj.y;
		if(point_in_rectangle(_x, _y, SectionX, SectionY, SectionX + SectionObj.width - 1, SectionY + SectionObj.height - 1)) return true;
				
	}
	
	return false;
			
	
}

function InZone(_RoomIndex, Obj, _TemplateIndex, _SectionID, _RelativeToRoom){
	
	//returns Zone index if obj is within or overlapping a zone, otherwise returns -1
	
	var Zones = array_length(global.Templates_Room[_TemplateIndex][$ "Sections"][_SectionID][$ "Zones"]);
	for(var ZoneIndex = 0; ZoneIndex < Zones; ZoneIndex++){

		var ZoneObj = global.Templates_Room[_TemplateIndex][$ "Sections"][_SectionID][$ "Zones"][ZoneIndex];
		
		var ZoneX = (_RelativeToRoom ? Room.x : 0) + ZoneObj.x;
		var ZoneY = (_RelativeToRoom ? Room.y : 0) + ZoneObj.y;
		if(rectangle_in_rectangle(Obj.x, Obj.y, Obj.x + Obj.width - 1, Obj.y + Obj.height - 1, ZoneX, ZoneY, ZoneX + ZoneObj.width - 1, ZoneY + ZoneObj.height - 1) > 0) return ZoneIndex;
				
	}
	
	return -1;
	
}

function TransformObj(_RoomIndex, Obj, xywhList){
	
	//Apply SBShift/SBResize codes and rotations if they apply using the x/y/w/h in the passed list.
	//Some objects need to be shifted or resized if in the Room template they are against a rail, but that rail becomes a Switchbox.
	//You can't pass a variable by reference, which is why we store all 4 values in a list and pass that to this function
	
	var _x = xywhList[| 0];
	var _y = xywhList[| 1];
	var _w = xywhList[| 2];
	var _h = xywhList[| 3];
					
	if(Room[$ "Section_WallType"] == SectionWallType.SwitchBlock){
		
		var Properties = Obj[$ "properties"];			
		var RoomTransform = TemplateRoom[$ "RoomTransformation"];
		
		var SBShiftCode = GetPropertyValue(Properties, "SBShift");
		if(SBShiftCode != -1){
			var L = RealToBool(string_pos("L", SBShiftCode));
			var R = RealToBool(string_pos("R", SBShiftCode));
			var U = RealToBool(string_pos("U", SBShiftCode));
			var D = RealToBool(string_pos("D", SBShiftCode));
			if(L &&	(RoomTransform == ObjTransformation.FlipH || RoomTransform == ObjTransformation.FlipHV)) {L = false; R = true;}
			else if(R && (RoomTransform == ObjTransformation.FlipH || RoomTransform == ObjTransformation.FlipHV)) {R = false; L = true;}
			if(L) _x -= 8;
			if(R) _x += 8;
			if(U) _y -= 8;
			if(D) _y += 8;				
		}
		
		SBShiftCode = GetPropertyValue(Properties, "SBResize");
		if(SBShiftCode != -1){
			var L = RealToBool(string_pos("L", SBShiftCode));
			var R = RealToBool(string_pos("R", SBShiftCode));
			var U = RealToBool(string_pos("U", SBShiftCode));
			var D = RealToBool(string_pos("D", SBShiftCode));
			if(L &&	(RoomTransform == ObjTransformation.FlipH || RoomTransform == ObjTransformation.FlipHV)) {L = false; R = true;}
			else if(R && (RoomTransform == ObjTransformation.FlipH || RoomTransform == ObjTransformation.FlipHV)) {R = false; L = true;}
			if(L) {_x += 8; _w -= 8;}
			if(R) _w -= 8;
			if(U) {_y += 8; _h -= 8;}
			if(D) _h -= 8;				
		}
	}
	
	xywhList[| 0] = _x;
	xywhList[| 1] = _y;
	xywhList[| 2] = _w;
	xywhList[| 3] = _h;
			
}


