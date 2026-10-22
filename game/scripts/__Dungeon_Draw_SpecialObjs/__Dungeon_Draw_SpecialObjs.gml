// Feather disable GM2064
enum SpecialDungeonObj{
	None,
	Key,
	Crystal,
	DoorSwitch,
	Warp,
	SpecialRoom,
	Boss,
	House,
	Jail,
	JailKey,
	EnemyTrap
}

enum SpecialObj{
	Pot,
	Treasure,
	Crystal,
	Torch,
	HeartGuy,
	DeadGuy,	
	Warp,
	WarpDest,
	Star
}
#macro SpecialObjTypes 9

enum SpecialObjTemplate{
	Pot,
	Treasure,
	Crystal,
	PotTreasure,
	Torches
}

#macro SpawnMethodCount_Key 7
enum SpawnMethod_Key{
	Pot,
	Treasure,
	Treasure_Switch,
	Enemy,
	DeadGuy,
	Monument,
	Altar
}

#macro SpawnMethodCount_Treasure 4
enum SpawnMethod_Treasure{
	Normal,
	Switch,
	Monument,
	Altar	
}

#macro SpawnMethodCount_Obj 2
enum SpawnMethod_Obj{
	Normal,
	Switch
}

enum ObjInUnusedZone{
	NoUnusedZone,
	Outside,
	Inside
}

enum UsedSpaceType{
	Obj,
	Enemy,
	IgnoreEnemy
}

global.SpikeTileID[0] = GetTileID(20, 0);
global.SpikeTileID[1] = GetTileID(20, 1);

global.TemplateObjsThatCanRotate = ds_list_create();
ds_list_add(global.TemplateObjsThatCanRotate, "PotTreasures", "Kinstones", "Altars", "Jails");

	
//array which hold the obj template name the special obj should use
global.SpecialObjTemplateType = array_create(SpecialObjTypes);
global.SpecialObjTemplateType[SpecialObj.Pot][0] = "Pots";
global.SpecialObjTemplateType[SpecialObj.Treasure][0] = "Treasures";
global.SpecialObjTemplateType[SpecialObj.Treasure][1] = "PotTreasures";
global.SpecialObjTemplateType[SpecialObj.Crystal][0] = "Crystals";
global.SpecialObjTemplateType[SpecialObj.Torch][0] = "Torches";
global.SpecialObjTemplateType[SpecialObj.HeartGuy][0] = "Treasures";
global.SpecialObjTemplateType[SpecialObj.HeartGuy][1] = "PotTreasures";
global.SpecialObjTemplateType[SpecialObj.DeadGuy][0] = "PotTreasures";
global.SpecialObjTemplateType[SpecialObj.Warp][0] = "Crystals";
global.SpecialObjTemplateType[SpecialObj.WarpDest][0] = "Crystals";
global.SpecialObjTemplateType[SpecialObj.Star][0] = "Crystals";
	
function Dungeon_Draw_SpecialObjs(_RoomIndex){
	
	if(global.Level.Index == DungeonLevel.Aghanim2) return true;
	
	//This sets up the altars, monuments, pots, treasures, crystals, etc, based on if the Room needs keys, treasures, crystals, etc
	
	global.UsedObjs = ds_list_create(); //contains obj types and their index so they don't get used twice
	
	global.AltarData = {};


	global.SpawnedPots = false;
	global.SpawnedTreasure = false;
	global.SpawnedCrystal = false;
	global.SpawnedMonument = false;
	global.SpawnedMonumentSpecialObj = false;
	global.SpawnedKinstone = false;
	global.SpawnedAltar = false;
	global.SpawnedShop = false;
	global.SpawnedGemPond = false;
	global.SpawnedJail = false;
	global.SpawnedTorches = false;
	global.SpawnedRollingSpikes = false;
	global.SpawnedMovingSpikeBlocks = false;
	global.SpawnedGuruBar = false;
	global.SpawnedEnemies = false;
	
	global.Switch_Add = false;
	global.Switch_Spawned = false;

	global.SpawnedStarInst = noone;
	global.SpawnedEnemyCountForStar = 0;
	
	global.PotGroupAmount = 2; //when spawning pots, use this random value to cap the groups to a certain value. This way all groups that have 2+ pots will look symetrical
	global.PotSpawnedGroup = false; //only allow 1 large group
	
	global.EnemyHasSpecialItem = false;

	
	SpawnSwitchBlocks(_RoomIndex);

	
	//if you're in the entrance or adjacent boss Room, don't draw any special objects.
	if( global.Level.IsBossLevel && _RoomIndex == global.Level.RoomIndex_BossAdjacent ) return true;	
	
	if(global.Level.Index == DungeonLevel.CastleJails){
		if(Prob(Chance_SpawnJail)) global.SpawnedJail = SpawnJail(_RoomIndex, Room.UnusedZone);
	}
	
	if(_RoomIndex != global.Level.RoomIndex_Entrance && Room.Section_ID == 0 && Room.SpecialObject == SpecialDungeonObj.None && Room.UnusedZone == -1 && !Room.WarpDest){	
		global.SpawnedRollingSpikes = SpawnRollingSpikes(_RoomIndex);
	}
	
	if(StartingRoom){
		global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone);
	}	
	
	var _ObjType;
	switch(Room.SpecialObject){
		
		case SpecialDungeonObj.Key:
		case SpecialDungeonObj.JailKey:

			var SpawnMethodList_Key = ds_list_create();
			
			ds_list_add(SpawnMethodList_Key, SpawnMethod_Key.Pot, SpawnMethod_Key.Treasure, SpawnMethod_Key.Monument, SpawnMethod_Key.Altar);
			
			if(global.Level.Index > DungeonLevel.Castle){ //only add switches and enemy keys past castle level
				
				if(Room.Section_ID == 0 && !(Room.SizeIndex == RoomSize._1x1 && Room.LowerDoors)){ //no enemy keys in cramped room, since there may be an issue with generating enough enemies
					//only use a switch or enemy to reveal treasure if section id = 0
					//ds_list_add(SpawnMethodList_Key, SpawnMethod_Key.Treasure_Switch); //bugged, creates soft locks sometimes
					
					if(DEBUG){
						if(!global.TestGame) ds_list_add(SpawnMethodList_Key, SpawnMethod_Key.Enemy);
					}else{
						ds_list_add(SpawnMethodList_Key, SpawnMethod_Key.Enemy);
					}
				
				}			
				
			}
				
			ds_list_shuffle(SpawnMethodList_Key);
			
			var _KeySpawned = false;
			while(!_KeySpawned && ds_list_size(SpawnMethodList_Key) > 0){
			
				var KeySpawnMethod = SpawnMethodList_Key[| 0];
			
				switch(KeySpawnMethod){
					case SpawnMethod_Key.Pot:
						global.SpawnedPots = SpawnPots(_RoomIndex, Room.SpecialObject_InSection, ItemClass.Key);
						_KeySpawned = global.SpawnedPots;
						break;
				
					case SpawnMethod_Key.Treasure:	
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, Room.SpecialObject_InSection, Room.UnusedZone, ItemClass.Key);
						_KeySpawned = global.SpawnedTreasure;
						break;
				
					case SpawnMethod_Key.Treasure_Switch:
						global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.RevealHiddenObj, Switch_HiddenObjType.Treasure, Room.SpecialObject_InSection, ItemClass.Key);
						_KeySpawned = (global.Switch_Spawned == SpawnSwitch_ReturnCode.Success);
						break;
				
					case SpawnMethod_Key.Enemy:	
						global.SpawnedEnemies = SpawnEnemies(_RoomIndex, ItemClass.Key);
						_KeySpawned = (global.SpawnedEnemies && global.EnemyHasSpecialItem);

						break;
				
					case SpawnMethod_Key.Monument:
						global.SpawnedMonument = SpawnMonuments(_RoomIndex, Room.SpecialObject_InSection, Room.UnusedZone, ItemClass.Key);
						_KeySpawned = global.SpawnedMonument && global.SpawnedMonumentSpecialObj;
						break;
				
					case SpawnMethod_Key.Altar:	
						global.SpawnedAltar = SpawnAltar(_RoomIndex, Room.SpecialObject_InSection, Room.UnusedZone, ItemClass.Key);
						_KeySpawned = global.SpawnedAltar;
						break;
				
				}
			
				ds_list_delete(SpawnMethodList_Key, 0);
			
			}
		
			ds_list_destroy(SpawnMethodList_Key);
			
			if(!_KeySpawned){
				if(DEBUG) Error_Spawn(_RoomIndex, "key", false);	
				return false;
			}
			
			break;
			
			
		case SpecialDungeonObj.Crystal:
		case SpecialDungeonObj.Warp:

			var SpawnMethodList_Obj = ds_list_create();
			
			ds_list_add(SpawnMethodList_Obj, SpawnMethod_Obj.Normal, SpawnMethod_Obj.Normal, SpawnMethod_Treasure.Monument);
			
			
			//bugged, creates soft locks sometimes
			//if(Room.Section_ID == 0 && Prob(0.15)){ 
			//	repeat(5){
			//		ds_list_add(SpawnMethodList_Obj, SpawnMethod_Obj.Switch);
			//	}
			//}
		
			
			//Add monument for spawn method
			
			ds_list_shuffle(SpawnMethodList_Obj);
			
			var _ObjSpawned = false;
			while(!_ObjSpawned && ds_list_size(SpawnMethodList_Obj) > 0){
			
				var _ObjSpawnMethod = SpawnMethodList_Obj[| 0];
			
				switch(_ObjSpawnMethod){
					
					case SpawnMethod_Obj.Normal:
						
						switch(Room.SpecialObject){
							case SpecialDungeonObj.Crystal:
								global.SpawnedCrystal = SpawnObj(_RoomIndex, SpecialObj.Crystal, Room.SpecialObject_InSection, -1, -1);
								_ObjSpawned = global.SpawnedCrystal;								
								break;
								
							case SpecialDungeonObj.Warp:
								global.SpawnedWarp = SpawnWarp(_RoomIndex);
								_ObjSpawned = global.SpawnedWarp;	
								break;
						}

						break;
				
					case SpawnMethod_Obj.Switch:
						
						switch(Room.SpecialObject){
							case SpecialDungeonObj.Crystal:
								_ObjType = Switch_HiddenObjType.Crystal;
								break;
							
							case SpecialDungeonObj.Warp:
								_ObjType = Switch_HiddenObjType.Warp;
								break;
							
						}
						
						global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.RevealHiddenObj, _ObjType, Room.SpecialObject_InSection, -1);
						_ObjSpawned = global.Switch_Spawned;						
						break;
					
					case SpawnMethod_Treasure.Monument:
						
						var _ItemClass = (Room.SpecialObject == SpecialDungeonObj.Crystal ? ItemClass.Crystal : ItemClass.WishStone); //using these item classes for crystal and warp
						global.SpawnedMonument = SpawnMonuments(_RoomIndex, Room.SpecialObject_InSection, Room.UnusedZone, _ItemClass);
						_ObjSpawned = global.SpawnedMonument && global.SpawnedMonumentSpecialObj;						
						break;
				}
			
				ds_list_delete(SpawnMethodList_Obj, 0);
			
			}
		
			ds_list_destroy(SpawnMethodList_Obj);
			
			if(!_ObjSpawned){
				if(DEBUG) Error_Spawn(_RoomIndex, "Crystal or Warp", false);	
				return false;
			}

			break;
			
		
		case SpecialDungeonObj.DoorSwitch:
			global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.OpenDoors);
			if(global.Switch_Spawned == SpawnSwitch_ReturnCode.AddSwitchFail){
				if(DEBUG) Error_Spawn(_RoomIndex, "door switch", false);
				return false;
			}
			break;
		

			
		case SpecialDungeonObj.None: //only spawn these if there's no special items

			//Shop
			if(	global.Level.Index > DungeonLevel.Castle && 
				!(global.Level.Index == DungeonLevel.Aghanim1 && _RoomIndex == global.Level.RoomIndex_BossAdjacent) &&
				Room.SizeIndex == RoomSize._1x1 && 
				Room.Secret == -1 && 
				global.Level.ShopCount < global.Level.MaxShops && 
				!global.SpawnedJail && 
				!ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors) && 
				!Room.WarpDest && 
				!global.SpawnedRollingSpikes && 
				!global.SpawnedMovingSpikeBlocks){
				
					var InSection = (Room.Section_ID != 0 ? FlipCoin_Bool() : false);
				
					global.SpawnedShop = SpawnShop(_RoomIndex, InSection, Room.UnusedZone); 
					if(!global.SpawnedShop) global.SpawnedShop = SpawnShop(_RoomIndex, !InSection, Room.UnusedZone); //try the other section if not spawned						
				
			}	

			
			break;
		
		
	}


	
	if(Room.WarpDest && !Room.WarpDest_Created){
		var SpawnedWarpDest = SpawnWarpDest(_RoomIndex);
		if(!SpawnedWarpDest){
			if(DEBUG) Error_Spawn(_RoomIndex, "warp dest", false);
			return false;
		}
	}
	
	
	
	global.SpawnedKinstone = SpawnKinstone(_RoomIndex, Room.UnusedZone);
	
	
	//bonus treasures
	global.SpawnedMonumentSpecialObj = false;
	
	if(global.Level.Index == DungeonLevel.Castle && global.Level.BonusTreasureCount == 0) Room.BonusTreasure = true; //always have at least 1 treasure in castle level
	
	if( (!global.SpawnedTreasure || ((Room.SpecialObject == SpecialDungeonObj.Key || Room.SpecialObject == SpecialDungeonObj.JailKey) && Room.Section_ID != 0)) && !StartingRoom && Room.BonusTreasure && global.Level.BonusTreasureCount < global.Level.MaxBonusTreasures && !global.SpawnedShop && !ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)){
		
		global.SpawnedTreasure = false;
		
		//pick a random section to spawn treasure, otherwise, pick oposite section from special item's section
		var InSection = false;
		if(Room.Section_ID != 0) InSection = (Room.SpecialObject == SpecialDungeonObj.None ? FlipCoin_Bool() : !Room.SpecialObject_InSection );
		
		var SpawnMethodCount_TreasureList = ds_list_create();
		
		ds_list_add(SpawnMethodCount_TreasureList, SpawnMethod_Treasure.Normal, SpawnMethod_Treasure.Normal);		
		
		if(Room.Section_ID == 0){ //only add a switch if room section id = 0
			
			ds_list_add(SpawnMethodCount_TreasureList, SpawnMethod_Treasure.Switch);
			
			//if(global.Level.Index == DungeonLevel.WaterTemple || global.SpawnedBlocks){
			if(global.SpawnedBlocks){
				repeat(15){
					ds_list_add(SpawnMethodCount_TreasureList, SpawnMethod_Treasure.Switch);	
				}
			}
			
		}
		
		if(!(Room.SpecialObject == SpecialDungeonObj.EnemyTrap && Room.SizeIndex == RoomSize._1x1 && Room.LowerDoors)){
			ds_list_add(SpawnMethodCount_TreasureList, SpawnMethod_Treasure.Altar, SpawnMethod_Treasure.Altar, SpawnMethod_Treasure.Monument, SpawnMethod_Treasure.Monument);
		}
		
		ds_list_shuffle(SpawnMethodCount_TreasureList);
		
		while(!global.SpawnedTreasure && ds_list_size(SpawnMethodCount_TreasureList) > 0){
			
			var TreasureSpawnMethod = SpawnMethodCount_TreasureList[| 0];
			
			switch(TreasureSpawnMethod){
				
				case SpawnMethod_Treasure.Normal:
					if(Prob(Chance_HeartGuy) && global.Level.Index >= DungeonLevel.Catacombs){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.HeartGuy, InSection, Room.UnusedZone, -1);
					}

					if(!global.SpawnedTreasure && Prob(Chance_DeadGuy) && global.Level.Index >= DungeonLevel.Catacombs && global.Level.Index != DungeonLevel.Village){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.DeadGuy, InSection, Room.UnusedZone, -1);
					}
					if(!global.SpawnedTreasure){
						global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, InSection, Room.UnusedZone, RandomItem);
					}
					break;
				
				case SpawnMethod_Treasure.Switch:
					if(global.Switch_Spawned != SpawnSwitch_ReturnCode.Success){
						global.Switch_Spawned = SpawnSwitch(_RoomIndex, SwitchAction.RevealHiddenObj, Switch_HiddenObjType.Treasure, false, RandomItem);
						global.SpawnedTreasure = (global.Switch_Spawned == SpawnSwitch_ReturnCode.Success);
					}
					break;
				
				case SpawnMethod_Treasure.Monument:
					if(!global.SpawnedMonument){
						global.SpawnedMonument = SpawnMonuments(_RoomIndex, InSection, Room.UnusedZone, RandomItem);
						global.SpawnedTreasure = global.SpawnedMonument && global.SpawnedMonumentSpecialObj;
					}
					break;
				
				case SpawnMethod_Treasure.Altar:
					if(!global.SpawnedAltar){
						global.SpawnedAltar = SpawnAltar(_RoomIndex, InSection, Room.UnusedZone, RandomItem);
						global.SpawnedTreasure = global.SpawnedAltar;
					}
					break;
				
			}
			
			ds_list_delete(SpawnMethodCount_TreasureList, 0);
			
		}
		
		if(global.SpawnedTreasure) global.Level.BonusTreasureCount++;
		
		ds_list_destroy(SpawnMethodCount_TreasureList);
			
	}

	
	if(!global.SpawnedMonument && !ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)){
		if(Prob(Chance_Decor_Monuments) || Room.GridW == 2 || Room.GridH == 2){
			global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone);
		}
	}		

	global.SpawnedGuruBar = SpawnGuruBars(_RoomIndex);	
	
	if(!global.SpawnedTorches && !ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)){
		if(Prob(Chance_SpawnTorches)) 
			SpawnTorches(_RoomIndex);
	}
	
	if(!global.SpawnedPots && _RoomIndex != global.Level.RoomIndex_Entrance && !ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)){
		if(Prob(Chance_SpawnPots)) 
			global.SpawnedPots = SpawnPots(_RoomIndex, false, -1);
	}
	
	
	if(Room.SpecialObject == SpecialDungeonObj.EnemyTrap) global.SpawnedEnemies = SpawnEnemies(_RoomIndex);
	
	if(!global.SpawnedEnemies && _RoomIndex != global.Level.RoomIndex_Entrance && !global.SpawnedShop){

		if(global.Level.NoEnemyRoomCount >= global.Level.MaxNoEnemyRooms){
			global.SpawnedEnemies = SpawnEnemies(_RoomIndex);
			
		}else{

			if( (Room.TemplateClass == RoomTemplateClass.Obstacles && Room.Obstacle == RoomObstacle.Blocks) || Room.SizeIndex > RoomSize._1x1){
				if(Prob(0.9)) global.SpawnedEnemies = SpawnEnemies(_RoomIndex); //higher prob if these conditions are met
			}
			
			if(!global.SpawnedEnemies) global.Level.NoEnemyRoomCount++;
			
		}		
		
	}
	
	if(!Room.WarpDest && !global.SpawnedRollingSpikes && !global.SpawnedShop){	
		global.SpawnedMovingSpikeBlocks = SpawnMovingSpikeBlocks(_RoomIndex);
	}
	

	if(global.SpawnedAltar) global.Level.AltarCount++;
	if(global.SpawnedShop) global.Level.ShopCount++;


	//Star
	
	
	//certain conditions demands we destroy these enemies
	var _DestroyRollingSpikes = false;
	var _DestroyGuruBars = false;
	var _DestroyMovingSpikeBlocks = false;
	
	if(global.Level.Stars && Room.StarEnemyCount >= MinEnemiesForStar){
		
		if(Room.Section_ID == 0 && Room.TemplateClass != RoomTemplateClass.Stairs && Room.SizeIndex > RoomSize._1x1 && !global.SpawnedShop && !ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)){ 
			SpawnObj(_RoomIndex, SpecialObj.Star, false, -1, -1);
			global.Level.Stars = false;
			
			_DestroyRollingSpikes = true; //these enemies either are awkward to destroy or don't destroy with star. So just don't put them in star rooms
			_DestroyGuruBars = true;
			
		}
	}


	SpawnSpikes(_RoomIndex);
	
	
	//Destroy any rolling spikes, moving spikes, or guru bars in single rooms with only 1 door when no other enemies have been generated
	if(!global.SpawnedEnemies){
		if(Room.SizeIndex == RoomSize._1x1 && Room.DoorCount == 1){
			_DestroyRollingSpikes = true;
			_DestroyGuruBars = true;
			_DestroyMovingSpikeBlocks = true;
		}
	}
	
	if(_DestroyRollingSpikes){
		with(oEnemy_RollingSpike){
			if(RoomIndex == _RoomIndex){
				UsedSpaceDelInstSpace(_RoomIndex, id);
				instance_destroy(id);
			}
		}
	}
	if(_DestroyGuruBars){
		with(oEnemy_Guru_Bar){
			if(RoomIndex == _RoomIndex){
				UsedSpaceDelInstSpace(_RoomIndex, id);
				instance_destroy(id);
			}
		}
	}
	if(_DestroyMovingSpikeBlocks){
		with(oEnemy_MovingSpikeBlock){
			if(RoomIndex == _RoomIndex){
				UsedSpaceDelInstSpace(_RoomIndex, id);
				instance_destroy(id);
			}
		}
	}

	//check if cannon is the only enemy in room, if so delete it
	var _EnemyCount = 0;
	var _CannonInst = noone;
	with(oEnemy){
		if(RoomIndex == _RoomIndex){
			_EnemyCount++;
			if(object_index == oEnemy_Cannon) _CannonInst = id;
		}
	}
	if(_EnemyCount == 1 && _CannonInst != noone){
		instance_destroy(_CannonInst);
	}
	
	ds_list_destroy(global.UsedObjs);
	
	delete global.AltarData;
	
	return true;

}

function SpawnSwitch(_RoomIndex, _SwitchAction, _HiddenObjType = Switch_HiddenObjType.None, _HiddenObjInSection = false, _TreasureItem = -1){
	
	
	if(Room.Section_ID != 0){
		//don't use switches if room section id != -1, complicates things
		return SpawnSwitch_ReturnCode.AddSwitchFail	
	}
		
	global.Switch_Add = true;
	Room.Switch.Action = _SwitchAction;
	
	if(Room.Switch.Action == SwitchAction.RevealHiddenObj){
		
		Room.Switch.HiddenObjType = _HiddenObjType;
		
		switch(Room.Switch.HiddenObjType){
		
		
			case Switch_HiddenObjType.Treasure:
				
				Room.Switch.TreasureItemClass = _TreasureItem;
				
				global.SpawnedTreasure = SpawnObj(_RoomIndex, SpecialObj.Treasure, _HiddenObjInSection, Room.UnusedZone, Room.Switch.TreasureItemClass);

				if(!global.SpawnedTreasure){
					global.Switch_Add = false;
					return SpawnSwitch_ReturnCode.SpawnHiddenObjFail;
				}
		
				break;
		
			case Switch_HiddenObjType.Crystal:
			
				global.SpawnedCrystal = SpawnObj(_RoomIndex, SpecialObj.Crystal, _HiddenObjInSection, Room.UnusedZone, -1);

				if(!global.SpawnedCrystal){
					global.Switch_Add = false;
					return SpawnSwitch_ReturnCode.SpawnHiddenObjFail;
				}
			
				break;
		
			case Switch_HiddenObjType.Warp:
			
				global.SpawnedWarp = SpawnWarp(_RoomIndex);

				if(!global.SpawnedWarp){
					global.Switch_Add = false;
					return SpawnSwitch_ReturnCode.SpawnHiddenObjFail;
				}
			
				break;
		
		}		
		
	}
	



	//Add all the possible switch types in a list, shuffle list, then pick one by one until switch was added	
	var SwitchTypeList = ds_list_create();
	
	ds_list_add(SwitchTypeList, SwitchType.Torches, 
								SwitchType.FloorSwitch, SwitchType.FloorSwitch, SwitchType.FloorSwitch);
								//SwitchType.FloorSwitchMonument, SwitchType.FloorSwitchMonument, SwitchType.FloorSwitchMonument);


	//if blocks were spawned
	//if(global.SpawnedBlocks){
	//	//prevent import items from needed the block to push
	//	if(Room.Switch.HiddenObjType == Switch_HiddenObjType.Treasure && _TreasureItem == RandomItem){
	//		repeat(9){
	//			ds_list_add(SwitchTypeList, SwitchType.Block); 
	//		}
	//	}
	//}
	

		
	//	if( (Room.Switch.Action == SwitchAction.RevealHiddenObj && Room.Switch.HiddenObjType == Switch_HiddenObjType.Treasure && _TreasureItem == RandomItem)){
	//		repeat(50){
	//			ds_list_add(SwitchTypeList, SwitchType.ArrowTarget);
	//		}
	//	}
	
	//}
	
	if( (Room.Switch.Action == SwitchAction.RevealHiddenObj && Room.Switch.HiddenObjType == Switch_HiddenObjType.Treasure && _TreasureItem == RandomItem)){

		if(global.SpawnedBlocks){
			repeat(50){
				ds_list_add(SwitchTypeList, SwitchType.Block); 
			}			
		}
	
		//Only Ruins 2 level has monuments with eyes on it that can spawn arrow targets. Only use this method if it's a bonus treasure
		//if(global.Level.Index == DungeonLevel.WaterTemple){	
		//	repeat(50){
		//		ds_list_add(SwitchTypeList, SwitchType.ArrowTarget);
		//	}			
		//}
		
	}
	
	ds_list_shuffle(SwitchTypeList);
	
	for(var SwitchTypeIndex = 0; SwitchTypeIndex < ds_list_size(SwitchTypeList); SwitchTypeIndex++){
				
		Room.Switch.Type = SwitchTypeList[| SwitchTypeIndex];
				
		switch(Room.Switch.Type){
					
			case SwitchType.FloorSwitch:

				global.SpawnedPots = SpawnPots(_RoomIndex, _HiddenObjInSection, -2); //using -2 for item class since in SpawnPots, if there's no item class, it'll randomly choose a section. So -2 says to not choose a section, but use the room's section id

				if(global.SpawnedPots && Room.Switch.Inst != noone){
					if(Room.Switch.Action == SwitchAction.RevealHiddenObj) Room.Switch.Inst.HiddenObjInst = Room.Switch.HiddenObjInst;
					global.Switch_Add = false;
				}

				
				break;
			
			
			//Not used monument floor switches for now:
			//glitch where if floor switch was i monument pots, and if switch didn't spawn, 
			//it would pop out the wrong used space entry causing the monument not to have any used space, and pots could generate over them
			
			//case SwitchType.FloorSwitchMonument:

			//	if(!global.SpawnedMonument){
					
			//		global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone, -1, true);
				
			//		if(global.SpawnedMonument && Room.Switch.Inst != noone){
			//			if(Room.Switch.Action == SwitchAction.RevealHiddenObj) Room.Switch.Inst.HiddenObjInst = Room.Switch.HiddenObjInst;
			//		}
					
			//	}
				
			//	break;

			case SwitchType.Torches:
				
				if(!global.SpawnedTorches){
					global.SpawnedTorches = SpawnTorches(_RoomIndex);
					if(global.SpawnedTorches) global.Switch_Add = false;
				}
				
				break;
					
			case SwitchType.Block:

				//Room.Switch.Inst is already set when drawing blocks in draw walls script
				if(Room.Switch.Action == SwitchAction.RevealHiddenObj){
					Room.Switch.Inst.HiddenObjInst = Room.Switch.HiddenObjInst;
				}
				Room.Switch.Inst.Moved = false;
				Room.Switch.Inst.Action = Room.Switch.Action;
				Room.Switch.Inst.image_index = 1;
					
				global.Switch_Add = false;
				
				break;
				
			//case SwitchType.ArrowTarget:
				
			//	if(!global.SpawnedMonument){
					
			//		global.SpawnedMonument = SpawnMonuments(_RoomIndex, false, Room.UnusedZone, -1);
				
			//		if(global.SpawnedMonument && Room.Switch.Inst != noone){
			//			if(Room.Switch.Action == SwitchAction.RevealHiddenObj) Room.Switch.Inst.HiddenObjInst = Room.Switch.HiddenObjInst;
			//			global.Switch_Add = false;
			//		}
					
			//	}
				
			//	break;
						
		}

		//if the switchtype was generated, then global.Switch_Add would have been switched to false in their respective spawn functions, so break
		if(!global.Switch_Add) break;

		ds_list_finddelete_all(SwitchTypeList, Room.Switch.Type);
		SwitchTypeIndex = 0;
		
	}

	//if switch didn't spawn, and if HiddenObj is treasure, then destroy it
	if(global.Switch_Add){
		
		if(Room.Switch.Action == SwitchAction.RevealHiddenObj){
			
			var _DestroyObj = true;
			var _DeleteUsedSpace = true;
			
			switch(Room.Switch.HiddenObjType){	
				default:
					_DestroyObj = false;
					_DeleteUsedSpace = false;					
					break;
				case Switch_HiddenObjType.Treasure:
					global.SpawnedTreasure = false;
					break;
				case Switch_HiddenObjType.Crystal:
					global.SpawnedCrystal = false;
					break;
				case Switch_HiddenObjType.Warp:
					global.SpawnedWarp = false;
					break;
					
			}
			
			if(_DestroyObj) instance_destroy(Room.Switch.HiddenObjInst);
			if(_DeleteUsedSpace) //also destroy used space entry the obj added
				array_pop(Room.UsedSpace);
			
		}
		
		instance_destroy(Room.Switch.Inst);		
				
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
	
	if(Room.Warp_DestRoomIndex == -1) return false;

	var SpawnedWarp = SpawnObj(_RoomIndex, SpecialObj.Warp, Room.SpecialObject_InSection, -1, -1);
		
	return SpawnedWarp;
	
}

function SpawnWarpDest(_RoomIndex){

	var SpawnedWarpDest = SpawnObj(_RoomIndex, SpecialObj.WarpDest, false, -1, -1);
	
	Room.WarpDest_Created = SpawnedWarpDest;
	
	return SpawnedWarpDest;
	
}

function SpawnSpikes(_RoomIndex){

	var ObstacleSpikes = false;
	
	if(Room.TemplateClass == RoomTemplateClass.Obstacles){
		if(!ObstacleClassCheck(_RoomIndex, RoomObstacleClass.Spikes)) return false
		ObstacleSpikes = true;
	}else{
		
		if(!variable_struct_exists(Room.Template, "Spikes")) return false
	
		//skip these levels
		switch(global.Level.Index){
			case DungeonLevel.Castle:	
			case DungeonLevel.CastleBasement:	
			case DungeonLevel.CastleJails:	
			case DungeonLevel.Sewers:	
			case DungeonLevel.WaterTemple:
				return false
		
		}
		
		if(!Prob(Chance_SpawnSpikes)) return false
		
		if(Room.Section_ID != 0 || Room.Secret != -1 || TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss) || global.SpawnedWater || global.SpawnedMovingFloors) return false
		
		if(Room.SpecialObject == SpecialDungeonObj.Key || Room.SpecialObject == SpecialDungeonObj.DoorSwitch) return false;
		
		if(Room.Switch.Action == SwitchAction.RevealHiddenObj) return false;
		
	}
	
	var SpikesInTemplate = array_length(Room.Template.Spikes);	
	var TMID;
	if(SpikesInTemplate == 0) return false


	for(var SpikeIndex = 0; SpikeIndex < SpikesInTemplate; SpikeIndex++){
		
		var Spike = Room.Template.Spikes[SpikeIndex];
		var SpikeX = Room.x + Spike.x;
		var SpikeY = Room.y + Spike.y;
		var SpikeX2 = SpikeX + Spike.width - 1;
		var SpikeY2 = SpikeY + Spike.height - 1;
		var SpikeTileW = Spike.width / 8;
		var SpikeTileH = Spike.height / 8;
		TMID = GetFloorLevelTMID("Tiles_Floor", SpikeX, SpikeY);
		var SpikeIsInSection = InSectionArea(_RoomIndex, SpikeX, SpikeY, Room.Section_ID, true);
		
		if(!ObstacleSpikes){
			
			if(!Prob(Chance_SpikeSection)) continue;
			
			//check if on top of path carpets
			if(global.SpawnedCarpets){
				TMID = GetFloorLevelTMID("Tiles_Floor", SpikeX, SpikeY);
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
		
		}
		
		if(UsedSpaceConflict(_RoomIndex, SpikeX, SpikeY, SpikeX2, SpikeY2, UsedSpaceType.IgnoreEnemy, SpikeIsInSection)) continue;					
		
		ClearTileBlock(GetFloorLevelTMID("Tiles_Water", SpikeX, SpikeY), SpikeX, SpikeY, SpikeTileW, SpikeTileH, 0); //clear any decor that could be covering spikes
		
		for(var _TileY = 0; _TileY < SpikeTileH; _TileY++){
			for(var _TileX = 0; _TileX < SpikeTileW; _TileX++){
				
				var _PosX = SpikeX + (_TileX * 8);
				var _PosY = SpikeY + (_TileY * 8);
				
				var _ID = global.SpikeTileID[((_PosX / 8) mod 2) xor ((_PosY / 8) mod 2)];
				
				tilemap_set_at_pixel(TMID, _ID, _PosX, _PosY);
			}
		}
		
		//AddUsedSpace(_RoomIndex, SpikeX, SpikeY, SpikeX2, SpikeY2, UsedSpaceType.Spikes, SpikeIsInSection);

	}
	
	return true
	
}

function SpawnMonuments(_RoomIndex, InSection, UnusedZone, _ItemClass = -1, ForcePots = false){

	
	if(Room.SpecialObject == SpecialDungeonObj.EnemyTrap && Room.SizeIndex == RoomSize._1x1 && Room.LowerDoors) return false //allow more space for trap enemies 
	
	var MonumentsArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Monuments"];
	var Monuments = array_length(MonumentsArray);
	
	if(Monuments == 0) return false;
	
	var MonumentsList = ds_list_create_sequence_shuffled(0, Monuments - 1);
	

	var ArrowTargetNeeded = (global.Switch_Add && Room.Switch.Type == SwitchType.ArrowTarget);
	var SpawnArrowTarget = false;
	var ArrowTargetSpawned = false;
	
	var MainObjAdded = false;
	var BonusPots = ( (StartingRoom ? false : Prob(Chance_Decor_Monuments_BonusPots)) || ForcePots ); //no pots in first entrance Room	

		
	var TotalMonuments = StartingRoom ? min(Monuments, 4) : irandom_range(min(Room.GridW * Room.GridH, Monuments), Monuments);
	var MonumentsSpawned = 0;
	
	//keep track of centre positions of spawned monuments so we can check to make sure were not spawning them too close to others
	var SpawnedMonumentPositionsX = array_create(0);
	var SpawnedMonumentPositionsY = array_create(0);
			
	var ObjAllowed, Pot1X, Pot2X;
	for(var MonumentIndex = 0; MonumentIndex < Monuments; MonumentIndex++){

		var Monument = MonumentsArray[MonumentsList[| MonumentIndex]];
			
		var MonumentX = Room.x + Monument.x;
		var MonumentY = Room.y + Monument.y;
		var MonumentX2 = MonumentX + 31;
		var MonumentY2 = MonumentY + 31;

		var FloorLevel = GetFloorLevelID(MonumentX, MonumentY);
		var FloorLevelStr = GetFloorLevelString(FloorLevel);

		var TMID_Floor = GetFloorLevelTMID("Tiles_Floor", MonumentX, MonumentY);
		var _UpperStairs = (Room.TemplateClass == RoomTemplateClass.Stairs && FloorLevel == UPPER);
		var TMID_Walls = (_UpperStairs ? global.TMID_StairMonuments : GetFloorLevelTMID("Tiles_Walls", MonumentX, MonumentY));
		var TMID_Decor = (_UpperStairs ? global.TMID_StairMonumentsDecor : GetFloorLevelTMID("Tiles_Decor", MonumentX, MonumentY));

			
		var MonumentOk = true;
			
			
		//Check conditions
					

		//check if on top of path carpets
		if(global.SpawnedCarpetStyle == CarpetStyle.Path){
			if(CornersOnCarpet(TMID_Floor, MonumentX, MonumentY, MonumentX2, MonumentY2) > 1){
				MonumentOk = false; continue;
			}
		}

		//Check for doors
		//Top
		if(collision_rectangle(MonumentX, MonumentY - 24, MonumentX2, MonumentY, oDoor, false, true) != noone){
			MonumentOk = false; continue;
		}
		//Bottom
		if(collision_rectangle(MonumentX, MonumentY2 + 1, MonumentX2, MonumentY2 + 24, oDoor, false, true) != noone){
			MonumentOk = false; continue;
		}
		//Left
		if(collision_rectangle(MonumentX - 24, MonumentY, MonumentX, MonumentY2, oDoor, false, true) != noone){
			MonumentOk = false; continue;
		}
		//Right
		if(collision_rectangle(MonumentX2 + 1, MonumentY, MonumentX2 + 24, MonumentY2, oDoor, false, true) != noone){
			MonumentOk = false; continue;
		}
			
		var MonumentInSection = InSectionArea(_RoomIndex, MonumentX, MonumentY, Room.Section_ID, true);


		//check if monument is arrow target. If so, make sure there's no walls underneath, or treasures underneath if a treasure switch
		SpawnArrowTarget = false;
		if(ArrowTargetNeeded){
			if( collision_rectangle(MonumentX, MonumentY2 + 1, MonumentX2, MonumentY2 + 64, oWall, false, true) == noone &&
				collision_rectangle(MonumentX, MonumentY2 + 1, MonumentX2, Room.y + Room.height - 24, Room.Switch.HiddenObjInst, false, true) == noone){
					SpawnArrowTarget = true;
			}
		}

			
		//Check if object are allowed under monument.
		//If there's a wall below, or there's a door to the left or right of the obj area, then obj not allowed
		
		if(SpawnArrowTarget){
			
			ObjAllowed = false;
			
		}else{
			
			//Bottom
			ObjAllowed = true;
			if(collision_rectangle(MonumentX, MonumentY2 + 1, MonumentX2, MonumentY2 + 32, oWall, false, true)){
				ObjAllowed = false;
			}
			//Door Left of obj area
			if(collision_rectangle(MonumentX - 24, MonumentY2 + 1, MonumentX - 1, MonumentY2 + 24, oDoor, false, true)){
				ObjAllowed = false;
			}
			//Door Right of obj area
			if(collision_rectangle(MonumentX2 + 1, MonumentY2 + 1, MonumentX2 + 24, MonumentY2 + 24, oDoor, false, true)){
				ObjAllowed = false;
			}


		}


		for(var i = 0; i < MonumentsSpawned; i++){
			if(point_distance(MonumentX + 16, MonumentY + 16, SpawnedMonumentPositionsX[i] + 16, SpawnedMonumentPositionsY[i] + 16) < 128){
				MonumentOk = false;
				break;
			}			
			
		}
		
		if(!MonumentOk) continue;

					
		var _UsedSpaceX1 = MonumentX;
		var _UsedSpaceY1 = MonumentY;
		var _UsedSpaceX2 = MonumentX2;
		var _UsedSpaceY2 = MonumentY2;
		
		if(ObjAllowed && (BonusPots || (_ItemClass != -1 && !MainObjAdded))){
			_UsedSpaceX1 -= 16;
			_UsedSpaceY1 -= 16;
			_UsedSpaceX2 += 16;
			_UsedSpaceY2 += 32;
		}else if(SpawnArrowTarget) _UsedSpaceY2 += 64;
		
		if(UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, MonumentInSection)){
			MonumentOk = false;
			continue;					
		}
		
		if(MonumentOk){
			
			var Style = SpawnArrowTarget ? 1 : Decor_Monuments_AllowedStyle(MonumentX, MonumentY);
			
			//if an object has to be placed, make sure the style is not the grave
			if(global.Level.Index == DungeonLevel.Catacombs && Style == 2 && !global.Level.CatacombGrave){
				if(_ItemClass != -1 && _ItemClass != ItemClass.Key && !MainObjAdded){ //keys are fine since pots will be chosen if grave and key is needed
					Style = 3;
				}
			}
			
			var TileX = 116 + (Style * 4);
			
			//half the time draw the monument mirrored, some of them aren't symetrical so it gives variety
			var _Mirrored = FlipCoin_Bool();
			
			DrawTileBlock(TMID_Walls, MonumentX, MonumentY, TileX, LevelTilesY, 4, 4, _Mirrored);

			
			//Extra items on top
			var _ItemStyle = 0;
			if(global.Level.Index == DungeonLevel.Catacombs && Style == 1 && Prob(0.3)){
				instance_create_layer(MonumentX + 16, MonumentY + 13, "ObjsFloor_" + FloorLevelStr, oTombSkeleton);		
			}else{
				_ItemStyle = Decor_MonumentItems(TMID_Decor, MonumentX, MonumentY, Style, _Mirrored);
			}	
			
			var _Grave = (global.Level.Index == DungeonLevel.Catacombs && Style == 2 && _ItemStyle == 1);
			
			var WallInst1 = WallObj_Create("Objs_" + FloorLevelStr, MonumentX, MonumentY, 4, 3);
			WallInst1.BlockProjectiles = true; 
			var WallInst2 = WallObj_Create("Objs_" + FloorLevelStr, MonumentX, MonumentY + 24, 4, 1);
			WallInst2.BlockProjectiles = false; 			
			
			array_push(SpawnedMonumentPositionsX, MonumentX);
			array_push(SpawnedMonumentPositionsY, MonumentY);
			
			if(SpawnArrowTarget){

				Room.Switch.Inst = instance_create_layer(MonumentX + 11, MonumentY + 10, "ObjsHigher_" + FloorLevelStr, oArrowSwitch);
				Room.Switch.Action = SwitchAction.RevealHiddenObj;
				Room.Switch.Inst.Action = Room.Switch.Action;
				Room.Switch.Inst.HiddenObjInst = Room.Switch.HiddenObjInst;
				ArrowTargetSpawned = true;
				ArrowTargetNeeded = false;
				SpawnArrowTarget = false;
				
			}else if(ObjAllowed){
				
				if(_ItemClass != -1 && !MainObjAdded){
				
					if(InSection == MonumentInSection){
					
						var ItemsY = MonumentY2 + 1;
						var ItemsX = MonumentX;

						global.SpawnedMonumentSpecialObj = true;
						MainObjAdded = true;
						
						//if key, then sometimes spawn only pots
						if(_ItemClass == ItemClass.Key && (FlipCoin_Bool() || _Grave)){ //if it's catacomb grave, make sure it's pots so you can read the heading
							var OtherItem = Probs_RandomItemClass(ItemFrom.Pot);
							var PotItem1 = choose(_ItemClass, OtherItem);
							var PotItem2 = (PotItem1 == _ItemClass ? OtherItem : _ItemClass);
							var PotInst = Pot_Create(_RoomIndex, ItemsX, ItemsY, PotItem1, InSection);
								PotInst = Pot_Create(_RoomIndex, ItemsX + 16, ItemsY, PotItem2, InSection);
						}else if(_ItemClass == ItemClass.Crystal){ //using crystal item for crystal switch
							Crystal_Create(_RoomIndex, ItemsX + 8, ItemsY);
						}else if(_ItemClass == ItemClass.WishStone){ //using wishstone for warp
							Warp_Create(_RoomIndex, ItemsX + 8, ItemsY, FloorLevel);
						}else if(_ItemClass == ItemClass.Star){
							global.SpawnedStarInst = instance_create_layer(MonumentX + 16, MonumentY + 48, "Objs_" + FloorLevelStr, oItem_Star, {From : ItemFrom.Anywhere});
						}else{
							if(_ItemClass != ItemClass.Key && !global.Switch_Add && global.Level.Index >= DungeonLevel.Catacombs && !_Grave && global.Level.Index != DungeonLevel.Village && global.Level.Index != DungeonLevel.Mines && Prob(Chance_Decor_Monuments_DeadguyTreasure)){
								instance_create_layer(ItemsX + 16, ItemsY + 16, "ObjsDoors_" + FloorLevelStr, oDeadGuy);									
							}else{
								var Items = (global.Switch_Add && Room.Switch.Action == SwitchAction.RevealHiddenObj ? 1 : choose(1,2));
								SpawnTreasureRow(_RoomIndex, ItemsX + (Items == 1 ? 8 : 0), ItemsY, InSection, _ItemClass, Items);	
							}
							
						}



					}
				
				}else if(BonusPots){				
					
					if(Prob(0.5)){ //switch up pot location since if switch, first one created will have the switch
						Pot1X = MonumentX;
						Pot2X = MonumentX + 16;
					}else{
						Pot1X = MonumentX + 16;
						Pot2X = MonumentX;						
					}
						
					var PotsY = MonumentY2 + 1;
					
					Pot_Create(_RoomIndex, Pot1X, PotsY, Probs_RandomItemClass_Pot(false), InSection);
					Pot_Create(_RoomIndex, Pot2X, PotsY, Probs_RandomItemClass_Pot(false), InSection);
			
				}
				
			}
			
			AddUsedSpace(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, MonumentInSection);
			
			MonumentsSpawned++;
			if(MonumentsSpawned >= TotalMonuments) break;
			
		}
	}

	ds_list_destroy(MonumentsList);

	
	return MonumentsSpawned > 0

}

function SpawnTorches(_RoomIndex){
	
	if(global.ChallengeOptions[ChallengeOption.Darkness] == ChallengeOption_Darkness.NoLights) return false
	
	var TorchArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Torches"];
	
	var TorchesInTemplate = array_length(TorchArray);	
	if(TorchesInTemplate == 0) return false;
	
	var Success = false;
	
	var MinTorches = global.Switch_Add ? min(TorchesInTemplate, 3) : 1;
	var Torches = irandom_range(MinTorches, 4);
	
	for(var TorchIndex = 0; TorchIndex < Torches; TorchIndex++){

		var SpawnedTorch = SpawnObj(_RoomIndex, SpecialObj.Torch, false, -1, -1);			

		if(!Success && SpawnedTorch) Success = true;		
	}
	
	if(Success){
		global.TorchGroupIndex++;
	}
	
	return Success;
	
}

function SpawnAltar(_RoomIndex, InSection, UnusedZone, TreasureContents){
	
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
	var _x, _y;
	for(_y = 0; _y < AltarTileH; _y++){
		for(_x = 0; _x < AltarTileW; _x++){
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
	var SideXR;
	for(_y = 0; _y < AltarTileH - 2; _y++){

			SideXR = AltarX + AltarW - 8;
			var SideY = AltarY + 8 + (_y * 8);
			
			DrawTileBlock(WallTMID, AltarX, SideY, 110, LevelTilesY + 2, 1, 1);
			DrawTileBlock(WallTMID, SideXR, SideY, 112, LevelTilesY + 2, 1, 1);
						
	}
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, AltarX, AltarY, 1, AltarTileH);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, SideXR, AltarY, 1, AltarTileH);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Stairs
	var StairsW = AltarTileW - 6;
	var StairsX = AltarX + (4 * (AltarTileW - StairsW));
	var StairsY = AltarY + AltarH - 16;
	for(_y = 0; _y < 2; _y++){
		for(_x = 0; _x < StairsW; _x++){
			var SX = StairsX + (_x * 8);
			var SY = StairsY + (_y * 8);
			DrawTileBlock(FloorTMID, SX, SY, 111, LevelTilesY, 1, 1);
		}
	}
	
	//Place an EnemyWall on stairs to prevent enemies from going through them
	//**Replace with WallObj_Create
	var inst = WallObj_Create("Objs_" + FloorLevelStr, StairsX, StairsY, StairsW, 2);
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
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 8, StairsY, 1, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY, 1, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Bottom Sides
	var SideLen = (AltarTileW - StairsW - 4) / 2;
		
	for(_x = 0; _x < SideLen; _x++){
		DrawTileBlock(WallTMID, AltarX + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
		DrawTileBlock(WallTMID, StairsX + (StairsW * 8) + 8 + (_x * 8), StairsY + 8, 111, LevelTilesY + 3, 1, 1); 
	}
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX - 16, StairsY + 8, 2, 1);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, StairsX + (StairsW * 8), StairsY + 8, 2, 1);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	
	//Draw Emblem
	//if(AltarTileH > 9){
	//	var EmblemTileW = 4;
	//	var EmblemTileH = 2;
	//	DrawTileBlock(global.TMID_Floors_Decor_Upper, AltarX + ((AltarTileW - EmblemTileW) * 4) , StairsY - 24, 0, 1, EmblemTileW, EmblemTileH);	
	//}
			
			
	var Items = min(1 + floor((AltarTileW - 8) / 2), 5);
	var ItemsW = Items * 16;
	var ItemsX = AltarX + ((AltarW - ItemsW) / 2);
	var ItemsY = AltarY + 8 + (AltarTileH > 8 ? (AltarTileH > 10 ? 16 : 8) : 0);
	
	SpawnTreasureRow(_RoomIndex, ItemsX, ItemsY, InSection, TreasureContents, Items);
	
	if(UnusedZone != -1) Room.UnusedZone = -1;
	
	return true;
	
}

function SpawnShop(_RoomIndex, InSection, UnusedZone){

	if(!PlatformVerify(_RoomIndex, InSection, UnusedZone, 20)) return false;
	
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
	DrawTileBlock(FloorTMID, _ShopX, _ShopY, 15, 0, 1, 1);
	//TR Corner
	DrawTileBlock(FloorTMID, FarEdgeX, _ShopY, 17, 0, 1, 1);
	//BL Corner
	DrawTileBlock(FloorTMID, _ShopX, FarEdgeY, 15, 2, 1, 1);
	//BR Corner
	DrawTileBlock(FloorTMID, FarEdgeX, FarEdgeY, 17, 2, 1, 1);
	
	//Top & Bottom Edges
	for(var _x = 1; _x < _ShopTileW - 1; _x++){
		var FloorX = _ShopX + (_x * 8);
		DrawTileBlock(FloorTMID, FloorX, _ShopY, 16, 0, 1, 1);							
		DrawTileBlock(FloorTMID, FloorX, FarEdgeY, 16, 2, 1, 1);							
	}
	
	//Top & Bottom Edges
	for(var _y = 1; _y < _ShopTileH - 1; _y++){
		var FloorY = _ShopY + (_y * 8);
		DrawTileBlock(FloorTMID, _ShopX, FloorY, 15, 1, 1, 1);							
		DrawTileBlock(FloorTMID, FarEdgeX, FloorY, 17, 1, 1, 1);							
	}	
	
	//Main floor
	for(var _y = 1; _y < _ShopTileH - 1; _y++){
		for(var _x = 1; _x < _ShopTileW - 1; _x++){
			var FloorX = _ShopX + (_x * 8);
			var FloorY = _ShopY + (_y * 8);
			DrawTileBlock(FloorTMID, FloorX, FloorY, 16, 1, 1, 1);							
		}
	}
	
	var ShopInst = instance_create_layer(_ShopX, _ShopY, "ObjsFloor_" + _FloorLevelStr, oShop, {RoomIndex : _RoomIndex, ShopW : _ShopW, ShopH : _ShopH, ShopType : ShopTypes.Various});
	
	//add shop to large map items so we can draw the icon if Link has a compass
	ds_list_add(global.LargeMapItems, ShopInst); 
						
	//Create wall obj
	var WallInst = WallObj_Create("Objs_" + _FloorLevelStr, _ShopX + 8, _ShopY + 8, _ShopTileW - 2, _ShopTileH - 2,,,oShopWall);
	WallInst.ShopInst = ShopInst;
	WallInst.BlockProjectiles = false;
					
	if(UnusedZone != -1) Room.UnusedZone = -1;
	
	return true;
	
}

function SpawnSwitchBlocks(_RoomIndex){

	if(Room.Section_ID == 0) exit;
	
	if(Room.Section_WallType != SectionWallType.SwitchBlock) exit;	

	var SectionWallsArray = Room.Template[$ "Sections"][Room.Section_ID][$ "SectionWalls"];
	
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
	
	var inst = instance_create_layer(X1, Y1, "ObjsDoors_Upper", oSwitchBlock);
	
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
	
	if(inst.Color == global.Level.SwitchBlock_ActiveColor){
		inst.ImgIndex = 0;
		inst.Raised = false;
		SwitchBlock_SetWalls(inst);		
	}	
		
}

function SpawnEnemies(_RoomIndex, _SpecialItem = -1){
	
	if(DEBUG){
		if(global.TestGame) return false		
	}
	
	var EnemyAreaArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Enemies"];
	
	var EnemyAreasInTemplate = array_length(EnemyAreaArray);
	
	if(EnemyAreasInTemplate == 0) return false;
	
	var RoomArea = (Room.GridW * Room.GridH); //larger Rooms should have more enemies, so multiply amount by a factor of RoomArea
	
	var PackPoints_Min = floor((4 + (global.Level.Index / 4)) * RoomArea); //Pack points are used up when an enemy is generated. Larger enemies use up more pack points that smaller ones.
	var PackPoints_Max = floor((8 + global.Level.Index) * RoomArea); 
	
	//give smaller rooms less points
	var _RoomSizeFactor = 1;
	switch(Room.TemplateClass){
		case RoomTemplateClass.Main_Lower:
			_RoomSizeFactor = 0.7;
			break;
			
		case RoomTemplateClass.Stairs:
			_RoomSizeFactor = 0.5;
			break;

	}
	
	var MoreEnemyFactor = global.ChallengeOptions[ChallengeOption.Enemies] + 1; 
	
	PackPoints_Min = (PackPoints_Min * _RoomSizeFactor * MoreEnemyFactor);
	PackPoints_Max = (PackPoints_Max * _RoomSizeFactor * MoreEnemyFactor);
	
	var TotalPackPoints = ceil(min(irandom_range(PackPoints_Min, PackPoints_Max), 30 * MoreEnemyFactor));
	
	var EnemyTrap = false;
	var EnemyTrapOk = false;
	if(Room.SpecialObject == SpecialDungeonObj.EnemyTrap){
		
		var EnemyTrap_DoorsOk = true;

		for(var _DoorIndex = 0; _DoorIndex < array_length(Room.Doors); _DoorIndex++){
			var _Door = Room.Doors[_DoorIndex];
			if(_Door.Status != DoorStatus.Open){
				EnemyTrap_DoorsOk = false;
				break;
			}
		}
		
		EnemyTrap = EnemyTrap_DoorsOk;
		
	}

	
	//list of all possible enemies
	var EnemyList = ds_list_create();
	
	var EnemyTypes;
	for(var Pass = 0; Pass < 2; Pass++){
		
		EnemyTypes = 0;
		
		for(var _ObjIndex = 0; _ObjIndex < array_length(global.EnemyData); _ObjIndex++){
		
			//don't add wall-type enemies to list
			if(Enemy_IsWall(_ObjIndex) || Enemy_IsObstacle(_ObjIndex)) continue;
			
			if(global.Level.Index == DungeonLevel.LanmolasLair){
				//if room doesn't have sand, or room has a crystal which they can get stuck in, don't use enemies that emerge from sand
				if(Enemy_IsUnderground(_ObjIndex)){
					if(!Room.Sand || Room.SpecialObject == SpecialDungeonObj.Crystal){
						continue;
					}
				}
			}
			
			
			
			if(Room.TemplateClass == RoomTemplateClass.Stairs || Room.Section_ID >= 25){	
				
				//don't spawn ennemies that are lit up/or can shoot projectiles when there's stairs or walkway, their lights appear on upper level if on lower level, too difficult to change the lighting system to accomodate.
				
				if(_ObjIndex == oEnemy_Bubble || _ObjIndex == oEnemy_Goriya || _ObjIndex == oEnemy_Kodongo || _ObjIndex == oEnemy_Wizzrobe || _ObjIndex == oEnemy_Bari) continue;
				
				if(_ObjIndex == oEnemy_Soldier_Mace) continue; //his mace shows above walkways when below it.
				
				//Don't spawn jumping or flying enemies if template has no jumping property since they switch floor levels when jumping causing them to go through upper level platforms, or appear under door beams.
				//Also Link can hit them when he's under a platform
				if(Enemy_CanJump(_ObjIndex)){
					if(GetPropertyValue(Room.Template.properties, "NoJumpingEnemies") != -1) continue;					
				}
				
				if(Enemy_CanFly(_ObjIndex)){
					if(GetPropertyValue(Room.Template.properties, "NoFlyingEnemies") != -1) continue;					
				}
				   
			}

			if(Room.TemplateClass == RoomTemplateClass.Stairs){
				//they follow you around so they can easilly get to the stairs before you
				if(_ObjIndex == oEnemy_Helmasaur || _ObjIndex == oEnemy_HardhatBeetle || _ObjIndex == oEnemy_Ropa || _ObjIndex == oEnemy_Hoarder) continue;
				if(_ObjIndex == oEnemy_Leever) continue; //Leevers can go from top floor to bottom, watch glitchy and didn't look good
			}
				
			if(EnemyTrap && !Enemy_GoodForTrap(_ObjIndex)) continue;

			var _Data = global.EnemyData[_ObjIndex];
			if(!is_struct(_Data)) continue;
		
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
	

	var EnemyTrapInst = EnemyTrap ? instance_create_layer(Room.x + 16, Room.y + 16, "System", oEnemyTrap, {RoomIndex : _RoomIndex, X2 : Room.x + Room.width - 17, Y2 : Room.y + Room.height - 17}) : noone;
	
	
	var EnemyTypesSelected = irandom_range(Room.SizeIndex == RoomSize._1x1 ? 1 : 2, min(EnemyTypes, 3));	
		
	
	
	ds_list_shuffle(EnemyList);

	//if enemy needs a key, then move all enemies that can hold special item to front of list so they are sure to get picked
	if(_SpecialItem == ItemClass.Key){
		for(var _ObjIndex = 0; _ObjIndex < array_length(global.EnemyData); _ObjIndex++){
			var _Data = global.EnemyData[_ObjIndex];
			if(!is_struct(_Data)) continue;
			if(_Data.SpecialItem != 0){
				var _KeyEnemyIndex = ds_list_find_index(EnemyList, _ObjIndex);
				if(_KeyEnemyIndex != -1){
					ds_list_delete(EnemyList, _KeyEnemyIndex);
					ds_list_insert(EnemyList, 0, _ObjIndex);
				}				
			}
		}
	}

	var EnemyChoiceList = ds_list_create();
	for(var i = 0; i < EnemyTypesSelected; i++){
		ds_list_add(EnemyChoiceList, EnemyList[| i])
	}
	ds_list_destroy(EnemyList);
	
	
	var WallTypeEnemy = -1;
	
	//switch(Room.TemplateClass){
	//	case RoomTemplateClass.Main_Lower:
	//Pick the type of wall enemy the room may have
	var WallEnemiesList = ds_list_create();
	if(!global.SpawnedRollingSpikes && Prob(Chance_SpawnWallEnemies)){
		if( !((Room.TemplateClass == RoomTemplateClass.Main_Lower && Room.SizeIndex == RoomSize._1x1) || Room.TemplateClass == RoomTemplateClass.Stairs) ){
			repeat(global.EnemyData[oEnemy_Beamos].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Beamos)};
			repeat(global.EnemyData[oEnemy_Cannon].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Cannon)};
		}
		repeat(global.EnemyData[oEnemy_Medusa].Levels[global.Level.Index]){ds_list_add(WallEnemiesList, oEnemy_Medusa)};
	}
	
	if(ds_list_size(WallEnemiesList) > 0){
		ds_list_shuffle(WallEnemiesList);
		WallTypeEnemy =  WallEnemiesList[| 0];
	}
	ds_list_destroy(WallEnemiesList);


	var Spawned = false;
	
	if(EnemyTrap) TotalPackPoints = ceil(TotalPackPoints * 1.2);
	
	var EnemyIndex, WallCollisionInst, DistToWall, DistToDoor, _ItemHolding;
	while(TotalPackPoints > 0 && ds_list_size(EnemyChoiceList) > 0){

		var PackPoints = 0;
		if(WallTypeEnemy != -1){
			EnemyIndex = WallTypeEnemy;
			
		}else{
			ds_list_shuffle(EnemyChoiceList);
			EnemyIndex = EnemyChoiceList[| 0];
			PackPoints = global.EnemyData[EnemyIndex].PackPoints;
			
			switch(EnemyIndex){
				case oEnemy_Rat:
					if(global.Level.Index == DungeonLevel.Sewers) PackPoints = 1; //make sewers infested with rats, normally it's 2
					break;
				
				case oEnemy_Buzz:
					if(global.Level.Index == DungeonLevel.Sewers) PackPoints = 2; //spawn less in earlier levels, normally it's 1
					break;
				
				case oEnemy_Bari:
					if(global.Level.Index == DungeonLevel.Aghanim1) PackPoints = 1.75; //spawn more for Aghanim level, normally it's 3
					break;
				
			}
			
			
			if(PackPoints > TotalPackPoints){
				ds_list_finddelete_all(EnemyChoiceList, EnemyIndex);
				continue;
			}
		}
		
		var SpawnedTry = false;
		for(var Tries = 0; Tries < 75; Tries++){ //Try random positions until enemy is at a safe distance	
		
			var EnemyArea = EnemyAreaArray[irandom(EnemyAreasInTemplate - 1)];
			var EnemyAreaX = Room.x + EnemyArea.x;
			var EnemyAreaY = Room.y + EnemyArea.y;
			var _FloorLevel = GetFloorLevelID(EnemyAreaX, EnemyAreaY);
			var _FloorLevelStr = GetFloorLevelString(_FloorLevel);

			var EnemyX = EnemyAreaX + irandom(EnemyArea.width);
			var EnemyY = EnemyAreaY + irandom(EnemyArea.height);
			
			var MinDistFromWall = 8;
			
			var CheckForObjs = true;
			
			var _UsedSpaceType = UsedSpaceType.Enemy;
			var _UsedSpaceBuffer = 0;
			
			switch(EnemyIndex){

				case oEnemy_Beamos:
				case oEnemy_Medusa:
				case oEnemy_Cannon:
					EnemyX = floor(EnemyX / 8) * 8; //Allign wall-type enemies to grid
					EnemyY = floor(EnemyY / 8) * 8;
					MinDistFromWall = 24;
					_UsedSpaceType = UsedSpaceType.Obj;
					_UsedSpaceBuffer = 16;
					break;
									
				case oEnemy_Keese:
				case oEnemy_Zirro:
					_FloorLevel = UPPERLOWER;					
					break;
					
				case oEnemy_Poe:
					EnemyX = Room.x + (128 * Room.GridW);
					EnemyY = Room.y + 64;
					_FloorLevel = UPPERLOWER;
					CheckForObjs = false;
					break;

				case oEnemy_Eyegore:
				case oEnemy_Hinox:
				case oEnemy_Wizzrobe:
					_UsedSpaceBuffer = 8;
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
			

			var _EnemySprite = object_get_sprite(EnemyIndex);
			var _SpriteOffsetX = sprite_get_xoffset(_EnemySprite);
			var _SpriteOffsetY = sprite_get_yoffset(_EnemySprite);

			var _UsedSpaceX1 = EnemyX + sprite_get_bbox_left(_EnemySprite) - _SpriteOffsetX - _UsedSpaceBuffer;
			var _UsedSpaceY1 = EnemyY + sprite_get_bbox_top(_EnemySprite) - _SpriteOffsetY - _UsedSpaceBuffer;
			var _UsedSpaceX2 = EnemyX + sprite_get_bbox_right(_EnemySprite) - _SpriteOffsetX + _UsedSpaceBuffer;
			var _UsedSpaceY2 = EnemyY + sprite_get_bbox_bottom(_EnemySprite) - _SpriteOffsetY + _UsedSpaceBuffer;
			
			var EnemyIsInSection = InSectionArea(_RoomIndex, EnemyX, EnemyY, Room.Section_ID, true);
			
			if(CheckForObjs){
				if(UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, _UsedSpaceType, EnemyIsInSection)) continue;
			}

			_ItemHolding = -1;
			var CanHoldSpecialItem = global.EnemyData[EnemyIndex].SpecialItem == 0 ? false : true;
			var CanHoldBonusItem = global.EnemyData[EnemyIndex].Item == 0 ? false : true;
		
			if(_SpecialItem != -1 && CanHoldSpecialItem && !global.EnemyHasSpecialItem){
				_ItemHolding = _SpecialItem;
			}
			
			if(_ItemHolding == -1 && CanHoldBonusItem){
				if(Prob(Chance_EnemyBonusItem)){
					_ItemHolding = Probs_RandomItemClass_Pot(true, false);
					if(_ItemHolding == ItemClass.Fairy) _ItemHolding = Probs_RandomItemClass_Pot(true, true);
				}
			}
			
			var EnemyInst = instance_create_layer(EnemyX, EnemyY, "Objs_" + _FloorLevelStr, EnemyIndex, {FloorLevel : _FloorLevel, 
																										ItemHolding : _ItemHolding, 
																										SectionID: Room.Section_ID,
																										RoomIndex: _RoomIndex});
																							 
			if(CheckForObjs){
				
				with(EnemyInst){
					WallCollisionInst = ObjCollision(x, y, oWall, FloorLevel);
					DistToWall = distance_to_object(oWall); 
					DistToDoor = distance_to_object(oDoor);
				}

				if(WallCollisionInst == noone && DistToWall >= MinDistFromWall && DistToDoor >= 32){ 
					AddUsedSpace(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, _UsedSpaceType, EnemyIsInSection);
					Spawned = true;
					SpawnedTry = true;
					break;
				}else{
					instance_destroy(EnemyInst);
				}
				
			}else{
				
				Spawned = true;
				SpawnedTry = true;
				break;
				
			}


			
			
		}
		
		if(Spawned &&_ItemHolding == _SpecialItem) global.EnemyHasSpecialItem = true;
		
		if(SpawnedTry){
			
			TotalPackPoints -= PackPoints;
			
			if(Enemy_GoodForSpecialAttack(EnemyIndex)){
				Room.StarEnemyCount++;

			}

			if(EnemyTrap && Enemy_GoodForTrap(EnemyIndex)){
				EnemyTrapOk = true;
			}
				
			if(EnemyIndex == oEnemy_Soldier_Mace){
				//only allow 1 mace soldier per room
				ds_list_finddelete_all(EnemyChoiceList, oEnemy_Soldier_Mace);
			}
			
		}else{
			ds_list_finddelete_all(EnemyChoiceList, EnemyIndex);
		}
		
		WallTypeEnemy = -1;
		
	}

	ds_list_destroy(EnemyChoiceList);	
	

	if(Spawned && EnemyTrapInst != noone && EnemyTrap && EnemyTrapOk){
		for(var _DoorIndex = 0; _DoorIndex < array_length(Room.Doors); _DoorIndex++){
			var _Door = Room.Doors[_DoorIndex];
			_Door.Status = DoorStatus.Closed;
		}
		with(oDoor){
			if(RoomIndex == _RoomIndex)
				Status = DoorStatus.Closed;
		}	
	}else{
		if(EnemyTrapInst != noone) instance_destroy(EnemyTrapInst);
	}
	
	return Spawned;
	
}

function SpawnRollingSpikes(_RoomIndex){
	
	if(_RoomIndex == global.Level.RoomIndex_Entrance) return false;
	
	if(Room.Section_ID != 0) return false;
	
	if(global.EnemyData[oEnemy_RollingSpike][$ "Levels"][global.Level.Index] == 0) return false;
	
	if(global.Level.MaxRollingSpikes == 0) return false;	
	
	if(!Prob(Chance_SpawnRollingSpikes)) return false;
	
	var RollingSpikeArray = Room.Template[$ "Sections"][Room.Section_ID][$ "RollingSpikes"];

	var RollingSpikesInTemplate = array_length(RollingSpikeArray);
	
	if(RollingSpikesInTemplate == 0) return false;

	var RollingSpikeList = ds_list_create_sequence_shuffled(0, RollingSpikesInTemplate - 1);
	
	var _SpawnRollingSpike = false;
	
	var PathWallList = ds_list_create();
	
	var tries, _PathAreaX1, _PathAreaY1, _PathAreaX2, _PathAreaY2, RollingSpikeX, RollingSpikeY, RollingSpike, RollingSpikeIsInSection;
	for(var RollingSpikeIndex = 0; RollingSpikeIndex < RollingSpikesInTemplate; RollingSpikeIndex++){
		
		RollingSpike = RollingSpikeArray[RollingSpikeList[| RollingSpikeIndex]];

		RollingSpikeX = Room.x + RollingSpike.x;
		RollingSpikeY = Room.y + RollingSpike.y;
		
		RollingSpikeIsInSection = InSectionArea(_RoomIndex, RollingSpikeX, RollingSpikeY, Room.Section_ID, true);
		
		//determine path area
		switch(RollingSpike.gid){
			case TemplateObjGID.RollingSpikesH:	
				
				//determine full path and add that space to UsedSpaceArea
				_PathAreaX1 = RollingSpikeX;
				_PathAreaY1 = RollingSpikeY;
				_PathAreaX2 = _PathAreaX1 + 15;
				_PathAreaY2 = _PathAreaY1 + RollingSpike.height - 1;		
				
				tries = 60;
				while(--tries > 0){
					if(collision_rectangle_list(_PathAreaX1 - 8, _PathAreaY1, _PathAreaX1, _PathAreaY2, oWall, false, true, PathWallList, false) > 0) break;
					_PathAreaX1 -= 8;
				}
				tries = 60;
				while(--tries > 0){
					if(collision_rectangle_list(_PathAreaX2, _PathAreaY1, _PathAreaX2 + 8, _PathAreaY2, oWall, false, true, PathWallList, false) > 0) break;
					_PathAreaX2 += 8;
				}

				
				break;
			case TemplateObjGID.RollingSpikesV:	

				//determine full path and add that space to UsedSpaceArea
				_PathAreaX1 = RollingSpikeX;
				_PathAreaY1 = RollingSpikeY;
				_PathAreaX2 = _PathAreaX1 + RollingSpike.width - 1;
				_PathAreaY2 = _PathAreaY1 + 15;	
				
				tries = 60;
				while(--tries > 0){
					if(collision_rectangle_list(_PathAreaX1, _PathAreaY1 - 8, _PathAreaX2, _PathAreaY1, oWall, false, true, PathWallList, false) > 0) break;
					_PathAreaY1 -= 8;
				}
				tries = 60;
				while(--tries > 0){
					if(collision_rectangle_list(_PathAreaX1, _PathAreaY2, _PathAreaX2, _PathAreaY2 + 8, oWall, false, true, PathWallList, false) > 0) break;
					_PathAreaY2 += 8;
				}

				break;
			
		}
		
		if(UsedSpaceConflict(_RoomIndex, _PathAreaX1, _PathAreaY1, _PathAreaX2, _PathAreaY2, UsedSpaceType.Enemy, RollingSpikeIsInSection)){
			continue;
		}else{
			_SpawnRollingSpike = true;
			break;
		}
		
		
		
	}
	
	ds_list_destroy(PathWallList);
	ds_list_destroy(RollingSpikeList);
			
	if(!_SpawnRollingSpike) return false


	var _FloorLevel = GetFloorLevelID(RollingSpikeX, RollingSpikeY);
	var FloorLevelStr = GetFloorLevelString(_FloorLevel);
	var RollingSpikeInst = instance_create_layer(RollingSpikeX, RollingSpikeY, "Objs_" + FloorLevelStr, oEnemy_RollingSpike, {FloorLevel : _FloorLevel, 
																																ItemHolding : noone, 
																																SectionID: Room.Section_ID,
																																RoomIndex: _RoomIndex});
		


	switch(RollingSpike.gid){
		case TemplateObjGID.RollingSpikesH:	
			RollingSpikeInst.sprite_index = sEnemy_RollingSpikes_H;
			RollingSpikeInst.vx = RollingSpikeInst.Speed;
			RollingSpikeInst.InitialVX = RollingSpikeInst.vx;
			RollingSpikeInst.H = RollingSpike.height;
			RollingSpikeInst.Dir = HORIZONTAL;

			break;
		case TemplateObjGID.RollingSpikesV:	
			RollingSpikeInst.sprite_index = sEnemy_RollingSpikes_V;
			RollingSpikeInst.vy = RollingSpikeInst.Speed;
			RollingSpikeInst.InitialVY = RollingSpikeInst.vy;
			RollingSpikeInst.W = RollingSpike.width;
			RollingSpikeInst.Dir = VERTICAL;

			break;
			
	}		
		
	with(RollingSpikeInst){
		RollingSpikes_SetMaskSprite();
	}
		

	AddUsedSpace(_RoomIndex, _PathAreaX1, _PathAreaY1, _PathAreaX2, _PathAreaY2, UsedSpaceType.Enemy, RollingSpikeIsInSection, RollingSpikeInst);

	global.Level.MaxRollingSpikes--;
	
	return true;
	
}

function SpawnGuruBars(_RoomIndex){
	
	if(_RoomIndex == global.Level.RoomIndex_Entrance) return false;
	
	if(global.Level.MaxGuruBars == 0) return false;
	
	if(global.EnemyData[oEnemy_Guru_Bar][$ "Levels"][global.Level.Index] == 0) return false;
	
	if(Room.Section_ID != 0) return false;	
	
	if(global.SpawnedShop || global.SpawnedKinstone || ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors)) return false;
	
	if(global.SpawnedRollingSpikes || global.SpawnedMovingSpikeBlocks) return false
	
	if(Room.SpecialObject == SpecialDungeonObj.EnemyTrap && Room.SizeIndex == RoomSize._1x1 && Room.LowerDoors) return false //no space to avoid guru bar in trapped room
	
	if(!Prob(Chance_SpawnGuruBars)) return false;	
	
	var GuruBarArray = Room.Template[$ "Sections"][Room.Section_ID][$ "GuruBars"];

	var GuruBarsInTemplate = array_length(GuruBarArray);
	
	if(GuruBarsInTemplate == 0) return false;
	
	var _GuruBarList = ds_list_create_sequence_shuffled(0, GuruBarsInTemplate - 1);
	for(var GuruBarIndex = 0; GuruBarIndex < GuruBarsInTemplate; GuruBarIndex++){
		
		var GuruBar = GuruBarArray[_GuruBarList[| GuruBarIndex]];
		
		var _Angle = GuruBar.height == 16 ? 0 : 90;
		var GuruBarX = Room.x + GuruBar.x + (_Angle == 0 ? 56 : 0);
		var GuruBarY = Room.y + GuruBar.y + (_Angle == 90 ? 56 : 0);
		
		var GuruBarIsInSection = InSectionArea(_RoomIndex, GuruBarX, GuruBarY, Room.Section_ID, true);
		
		_Angle = (_Angle + irandom(360)) mod 360;
		
		var _FloorLevel = GetFloorLevelID(GuruBarX, GuruBarY);
		var FloorLevelStr = GetFloorLevelString(_FloorLevel);
		
		var GuruBarInst = instance_create_layer(GuruBarX, GuruBarY, "Objs_" + FloorLevelStr, oEnemy_Guru_Bar,  {FloorLevel : _FloorLevel, 
																												ItemHolding : noone, 
																												SectionID: Room.Section_ID,
																												RoomIndex: _RoomIndex,
																												Angle: _Angle,
																												GurusDestroyed: false});
		
		var _UsedSpaceX1 = GuruBarX - 16;
		var _UsedSpaceY1 = GuruBarY - 16;
		var _UsedSpaceX2 = GuruBarX + 31;
		var _UsedSpaceY2 = GuruBarY + 31;
		
		if(!UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, GuruBarIsInSection)){
			AddUsedSpace(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, GuruBarIsInSection, GuruBarInst);
			break;
		}else instance_destroy(GuruBarInst);
				
	}
	
	ds_list_destroy(_GuruBarList);
	
	global.Level.MaxGuruBars--;
	
	return true;
			
}

function SpawnMovingSpikeBlocks(_RoomIndex){

	if(global.EnemyData[oEnemy_MovingSpikeBlock][$ "Levels"][global.Level.Index] == 0) return false;
	
	if(_RoomIndex == global.Level.RoomIndex_Entrance) return false;
	
	if(!Prob(Chance_SpawnMovingSpikeBlocks)) return false;
	
	var SpikeArray = Room.Template[$ "Sections"][Room.Section_ID][$ "MovingSpikeBlocks"];

	var SpikesInTemplate = array_length(SpikeArray);
	
	if(SpikesInTemplate == 0) return false;
	
	var _Spikes = irandom_range(1, SpikesInTemplate);
	var _SpikeList = ds_list_create_sequence_shuffled(0, SpikesInTemplate - 1);
	
	for(var _SpikeIndex = 0; _SpikeIndex < _Spikes; _SpikeIndex++){
		
		var Spike = SpikeArray[_SpikeList[| _SpikeIndex]];
			
		var SpikeX = Room.x + Spike.x;
		var SpikeY = Room.y + Spike.y;
		var SpikeX2 = SpikeX + Spike.width - 1;
		var SpikeY2 = SpikeY + Spike.height - 1;
		
		var SpikeBlockInSection = InSectionArea(_RoomIndex, SpikeX, SpikeY, Room.Section_ID, true);
		
		if(UsedSpaceConflict(_RoomIndex, SpikeX, SpikeY, SpikeX2, SpikeY2, UsedSpaceType.Enemy, SpikeBlockInSection)) continue;
		
		var _FloorLevel = GetFloorLevelID(SpikeX, SpikeY);
		var FloorLevelStr = GetFloorLevelString(_FloorLevel);
	
		var SpikeInst = instance_create_layer(SpikeX + 8, SpikeY + 8, "Objs_" + FloorLevelStr, oEnemy_MovingSpikeBlock, {FloorLevel : _FloorLevel, 
																														ItemHolding : noone, 
																														SectionID: Room.Section_ID,
																														RoomIndex: _RoomIndex,
																														W : Spike.width,
																														H : Spike.height});


		AddUsedSpace(_RoomIndex, SpikeX, SpikeY, SpikeX2, SpikeY2, UsedSpaceType.Enemy, SpikeBlockInSection, SpikeInst);
	
	}
	
	ds_list_destroy(_SpikeList);
	
	return true
	
}

function SpawnPots(_RoomIndex, InSection, _ItemClass){

	var PotsArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Pots"];
	
	var PotsInTemplate = array_length(PotsArray);	
	if(PotsInTemplate == 0) return false;
	
	//determine largest pot obj group width/height.
	global.PotGroupAmount = irandom_range(2, 4);
	global.PotSpawnedGroup = false;
	
	var Success = false;
	
	var Pots_Min = (Room.SizeIndex == RoomSize._1x1 ? 1 : 2);
	var Pots_Max = (Room.SizeIndex == RoomSize._1x1 ? 3 : 4);
	
	var SpawnedPot;
	for(var ListIndex = 0; ListIndex < irandom_range(Pots_Min, Pots_Max); ListIndex++){
		
		
		switch(_ItemClass){
			
			case ItemClass.Key:
				SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, InSection, -1, _ItemClass);
				if(SpawnedPot){
					_ItemClass = -1;
				}
				break;
				
			case -1: //any item
				var _InSection = FlipCoin_Bool();
				SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, _InSection, -1, RandomItem);	
				if(!SpawnedPot){ //if pot wasn't spawned, try other section
					SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, !_InSection, -1, RandomItem);
				}
				break;
				
			case -2: //floor switch, so make sure pot is spawned in section without an item
				SpawnedPot = SpawnObj(_RoomIndex, SpecialObj.Pot, InSection, -1, -1);	
				break;
		}

		
		if(!Success && SpawnedPot) Success = true;		
	}
	
	return Success;
	
}

function SpawnObj(_RoomIndex, SpecialObjType, InSection, UnusedZone, ObjContents, IgnoreUsedSpaces = false){	
	
	if(Room.Section_ID == 0) InSection = false;
	
	var Success = false;
	
	var _TemplateTypes = array_length(global.SpecialObjTemplateType[SpecialObjType]); 
	var _TemplateTypeOrder = ds_list_create_sequence(0, _TemplateTypes - 1);
	
	if(SpecialObjType != SpecialObj.Warp && SpecialObjType != SpecialObj.WarpDest){
		//warps should always try the warp template objs first before trying the crystal template objs. Everything else can try in a random order
		ds_list_shuffle(_TemplateTypeOrder);
	}
	
	var HiddenInstPointX, HiddenInstPointY, SpawnItem, ObjX, _PosX, _PosY, TreasureItems, FloorLevelStr, _TorchLit, ObjInst;
	for(var _TemplateTypeIndex = 0; _TemplateTypeIndex < _TemplateTypes; _TemplateTypeIndex++){
		
		var _TemplateType = global.SpecialObjTemplateType[SpecialObjType][_TemplateTypeOrder[| _TemplateTypeIndex]];
		
		var _TemplateObjArray = Room.Template[$ "Sections"][Room.Section_ID][$ _TemplateType];
		
		var _TemplateObjCanRotate = (ds_list_find_index(global.TemplateObjsThatCanRotate, _TemplateType) != -1);
		
		var ObjCount = array_length(_TemplateObjArray);
				
		var ObjOrder = ds_list_create_sequence_shuffled(0, ObjCount - 1);
		
		for(var ObjIndex = 0; ObjIndex < ObjCount; ObjIndex++){			
			
			var Obj = _TemplateObjArray[ObjOrder[| ObjIndex]];
			
			if(_TemplateObjCanRotate && Obj[$ "rotation"] != 0) continue;
			
			var _ObjInSection = false;
			if(Room.Section_ID != 0){
				_ObjInSection = InSectionArea(_RoomIndex, Obj.x, Obj.y, Room.Section_ID, false);
				if(InSection && !_ObjInSection) continue;
				if(!InSection && _ObjInSection) continue;
			}
			

			if(InUnusedZone(_RoomIndex, UnusedZone, Obj) == ObjInUnusedZone.Outside) continue;
		
			var ObjUsed = CheckUsedObj(Obj);
			if(ObjUsed) continue;

			
			var ObjX1 = Room.x + Obj.x;
			var ObjY1 = Room.y + Obj.y;
			var ObjW = Obj.width;
			var ObjH = Obj.height;
			var ObjTilesW = ObjW / 8;
			var ObjTilesH = ObjH / 8;
			var ObjProperties = Obj[$ "properties"];
			
			//if(SpecialObjType == SpecialObj.Warp || SpecialObjType == SpecialObj.WarpDest){
			//	var _CornersOnCarpet = CornersOnCarpet(GetFloorLevelTMID("Tiles_Floor", ObjX1, ObjY1), ObjX1, ObjY1, ObjX1 + 15, ObjY1 + 15);
			//	if(_CornersOnCarpet > 0 && _CornersOnCarpet < 4){
			//		continue;
			//	}
			//}
						
			//Perform obj transformation (SBShifts, rotations, etc)
			var xywhList = ds_list_create();
			ds_list_add(xywhList, ObjX1, ObjY1, ObjW, ObjH);
			TransformObj(_RoomIndex, Obj, xywhList);
			ObjX1 = xywhList[| 0]; 
			ObjY1 = xywhList[| 1];
			ObjW = xywhList[| 2]; 
			ObjH = xywhList[| 3];
			ds_list_destroy(xywhList);
			
			ObjX = ObjX1;
			var ObjY = ObjY1;		
			var ObjX2 = ObjX1 + ObjW - 1;
			var ObjY2 = ObjY1 + ObjH - 1;
			
			//if dest warp is touching a wall above, link will get stuck
			if(SpecialObjType == SpecialObj.WarpDest){
				if(collision_rectangle(ObjX1, ObjY1 - 8, ObjX2, ObjY1 - 1, oWall, false, true)) continue;
			}
			
			var _DoorDist = 16;//(SpecialObjType == SpecialObj.Warp || SpecialObjType == SpecialObj.WarpDest) ? 48 : 16; //keep warps away from doors
			
			var CheckDoorsLeft = collision_rectangle(ObjX1 - _DoorDist, ObjY1, ObjX1, ObjY2, oDoor, false, true);
			var CheckDoorsRight = collision_rectangle(ObjX2, ObjY1, ObjX2 + _DoorDist, ObjY2, oDoor, false, true);
			var CheckDoorsUp = collision_rectangle(ObjX1, ObjY1 - _DoorDist, ObjX2, ObjY1, oDoor, false, true);
			var CheckDoorsDown = collision_rectangle(ObjX1, ObjY2, ObjX2, ObjY2 + _DoorDist, oDoor, false, true);
					
			if(CheckDoorsLeft || CheckDoorsRight || CheckDoorsUp || CheckDoorsDown) continue;						
			
			SpawnItem = false;
			
			var _UsedSpaceX1 = ObjX1;
			var _UsedSpaceY1 = ObjY1;
			var _UsedSpaceX2 = ObjX2;
			var _UsedSpaceY2 = ObjY2;
			
			var _LooseKey = false;
			
			switch(SpecialObjType){
				case SpecialObj.Pot:
					
					//make sure hidden switch inst close to pot, otherwise it might reveal under Link and cause Link to glitch out with collision
					if(global.Switch_Add && Room.Switch.Action == SwitchAction.RevealHiddenObj){
						
						//set the centre point for distance check, different obj indexes have different mask coordinates
						switch(Room.Switch.HiddenObjInst.object_index){
							default:
								HiddenInstPointX = Room.Switch.HiddenObjInst.x;
								HiddenInstPointY = Room.Switch.HiddenObjInst.y - 8;
								break;
							case oWarp:
								HiddenInstPointX = Room.Switch.HiddenObjInst.x + 8;
								HiddenInstPointY = Room.Switch.HiddenObjInst.y + 8;
								break;								
						}
						if(point_distance(ObjX + (ObjW / 2), ObjY + (ObjH / 2), HiddenInstPointX, HiddenInstPointY) < 48){
							break;
						}						
					}
					
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection); 
							
					break;
				
				case SpecialObj.Treasure:
					
					_UsedSpaceY2 += 16;
					
					TreasureItems = 1;
					if(_TemplateType == "PotTreasures"){
						
						//If there's a switch being added, this is the treasure being created.
						//So limit the PotTreasure obj to only 1 treasure, no extra treasures or pots should be created, otherwise button might appear under one of those extra pots.
						if(!global.Switch_Add || Room.Switch.Action != SwitchAction.RevealHiddenObj)
							TreasureItems = irandom_range(1, ObjTilesW / 2);

						while(TreasureItems > 0){
							var ItemsW = TreasureItems * 16;
							ObjX = ObjX1 + ((ObjW - ItemsW) / 2);
							_UsedSpaceX1 = ObjX - 16;
							_UsedSpaceX2 = ObjX + ItemsW + 15;
							
							
							SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);
							if(SpawnItem)
								break;
							else
								TreasureItems--;
						}
						
					}else{

						if(ObjContents == ItemClass.Key && Prob(Chance_LooseKey) && !global.Switch_Add && Room.Section_ID == 0 && Room.TemplateClass != RoomTemplateClass.Stairs){
							_LooseKey = true;
							_UsedSpaceX1 = ObjX1 - 16;
							_UsedSpaceY1 = ObjY1 - 16;
							_UsedSpaceX2 = ObjX2 + 16;
							_UsedSpaceY2 = ObjY2 + 16;
							SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);
						}else{
							_UsedSpaceX1 -= 16;
							_UsedSpaceX2 += 16;
							SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection) && !collision_rectangle(_UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, oWall, false, true);
						}						
						
					}
					break;
				
				case SpecialObj.Torch:
					
					_TorchLit = false;
					
					//make sure torches aren't too close to other torches
					var _TorchOk = true;
					with(oTorch){
						if(RoomIndex == _RoomIndex){
							if(point_distance(x + 8, y + 8, ObjX1 + 8, ObjY2 + 8) < 88){
								_TorchOk = false;
								break;
							}
						}
					}
					if(_TorchOk){

						//if no switch is needed, and lighting in Room is true, then some torches are lit
						
						if(!global.Switch_Add){
							_TorchLit = Room.Lighting == 1.0 ? Prob(Chance_Torches_Lit) : true;
						}
						
						if(!_TorchLit){
							_UsedSpaceX1 = ObjX1 - 16;
							_UsedSpaceY1 = ObjY1 - 16;
							_UsedSpaceX2 = ObjX2 + 16;
							_UsedSpaceY2 = ObjY2 + 16;
						}
						
						SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);						
					}
					break;
					
				case SpecialObj.Crystal:
				case SpecialObj.Warp:		
					_UsedSpaceX1 = ObjX1 - 16;
					_UsedSpaceY1 = ObjY1 - 16;
					_UsedSpaceX2 = ObjX2 + 16;
					_UsedSpaceY2 = ObjY2 + 16;
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);
					break;

				case SpecialObj.Star:				
					_UsedSpaceX1 = ObjX1 - 16;
					_UsedSpaceY1 = ObjY1 - 16;
					_UsedSpaceX2 = ObjX2 + 16;
					_UsedSpaceY2 = ObjY2 + 16;
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.IgnoreEnemy, _ObjInSection);
					break;

				case SpecialObj.WarpDest:
					_UsedSpaceX1 = ObjX1 - 24;
					_UsedSpaceY1 = ObjY1 - 24;
					_UsedSpaceX2 = ObjX2 + 24;
					_UsedSpaceY2 = ObjY2 + 24;
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);					
					break;
					
				case SpecialObj.DeadGuy:
					//if Deadguy is leaning against a hole or SB, then don't spawn. The PotTreasures in the templates should have these properties set
					if(GetPropertyValue(ObjProperties, "NoDeadGuy") != -1 || Room.Section_ID > 0){
						break;
					}
					
					if(collision_rectangle(ObjX1, ObjY2, ObjX2, ObjY2 + 32, oWall, false, true)) break;
					
					//HeartGuy would be sitting in the middle of the PotTreasure Combo
					ObjX = ObjX1 + (ObjW / 2) - 8; //ObjW is the width of the PotTreasure
					ObjW = 26;
						
					_UsedSpaceX1 = ObjX;
					_UsedSpaceY1 = ObjY;
					_UsedSpaceX2 = ObjX + ObjW - 1;
					_UsedSpaceY2 = ObjY2 + 16;
					
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);
					
					break;
					
				case SpecialObj.HeartGuy:
				
					if(collision_rectangle(ObjX1, ObjY2, ObjX2, ObjY2 + 32, oWall, false, true)) break;

					//HeartGuy would be sitting in the middle of the PotTreasure Combo
					ObjX = ObjX1 + (ObjW / 2) - 8; //ObjW is the width of the PotTreasure
					ObjW = 16; //Set it to the new ObjW of 16, width of HeartGuy
						
					_UsedSpaceX1 = ObjX;
					_UsedSpaceY1 = ObjY;
					_UsedSpaceX2 = ObjX + ObjW - 1;
					_UsedSpaceY2 = ObjY2 + 16;
					
					SpawnItem = !UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, _ObjInSection);
					break;

			}

			
			if(SpawnItem){
				
				var FloorLevel = GetFloorLevelID(ObjX, ObjY)
				FloorLevelStr = GetFloorLevelString(FloorLevel);
				
				var _UsedSpaceType = UsedSpaceType.Obj;
				
				ds_list_add(global.UsedObjs, Obj);
				
				switch(SpecialObjType){
					
					case SpecialObj.Pot:

						ObjTilesW = min(ObjTilesW / 2, global.PotGroupAmount);
						ObjTilesH = min(ObjTilesH / 2, global.PotGroupAmount);
					
						//starting corner determines which pot is the starting pot which expands away from as more pots are added
						var _SpawnDir = GetPropertyValue(ObjProperties, "SpawnDir");
						
						if(_SpawnDir == -1 || _SpawnDir == ""){
							
							_SpawnDir = "R";
							ObjTilesW = 1;
							ObjTilesH = 1;
							
						}else if(_SpawnDir == "Any"){

							if(ObjTilesW > ObjTilesH){
								_SpawnDir = choose("R", "L");
							}else if(ObjTilesH > ObjTilesW){
								_SpawnDir = choose("U", "D");
							}else{
									
							}
							
						}else if(_SpawnDir == "Full"){
							
							if(global.PotSpawnedGroup){
								continue;
							}else{
								ObjTilesW = ObjW / 16;
								ObjTilesH = ObjH / 16;								
							}
							
						}

						if(global.PotSpawnedGroup || (Prob(Chance_PotIsSingle) && _SpawnDir != "Full")){
							ObjTilesW = 1;
							ObjTilesH = 1;
						}
						
						if(!global.PotSpawnedGroup && (ObjTilesW > 1 || ObjTilesH > 1) && !Prob(Chance_PotAllowAnotherGroup)){
							global.PotSpawnedGroup = true;							
						}	
						
						var _ObjContents = ObjContents;
						
						var _FillWithSimpleItems = Prob(Chance_PotFillWithSimpleItems);
						var _FillItem = Probs_RandomItemClass_Pot(true, true);
						
						for(var _PotY = 0; _PotY < ObjTilesH; _PotY++){
							for(var _PotX = 0; _PotX < ObjTilesW; _PotX++){

								if(ObjContents == RandomItem) _ObjContents = _FillWithSimpleItems ? _FillItem : Probs_RandomItemClass_Pot(false, false);
								
								switch(_SpawnDir){
									case "R":
									case "D":
									case "Full":
										_PosX = ObjX + (_PotX * 16);
										_PosY = ObjY + (_PotY * 16);
										break;
										
									case "L":
									case "U":
										_PosX = ObjX + ObjW - 16 - (_PotX * 16);
										_PosY = ObjY + ObjH - 16 - (_PotY * 16);
										break;
								}
								
								ObjInst = Pot_Create(_RoomIndex, _PosX, _PosY, _ObjContents, InSection);	
								
								ObjContents = RandomItem;								
								
							}
						}		

						switch(_SpawnDir){
							case "R":
							case "D":
							case "Full":
								_UsedSpaceX1 = ObjX;
								_UsedSpaceY1 = ObjY;
								_UsedSpaceX2 = ObjX + (ObjTilesW * 16) - 1;
								_UsedSpaceY2 = ObjY + (ObjTilesH * 16) - 1;
								break;
										
							case "L":
							case "U":
								_UsedSpaceX1 = ObjX + ObjW - (ObjTilesW * 16);
								_UsedSpaceY1 = ObjY + ObjH - (ObjTilesH * 16);
								_UsedSpaceX2 = _UsedSpaceX1 + (ObjTilesW * 16) - 1;
								_UsedSpaceY2 = _UsedSpaceY1 + (ObjTilesH * 16) - 1;
								break;
						}
					
						break;
							
							
					case SpecialObj.Treasure:
						if(TreasureItems > 1){
							SpawnTreasureRow(_RoomIndex, ObjX, ObjY, InSection, ObjContents, TreasureItems);
						}else{
							if(_LooseKey){
								FloorLevelStr = GetFloorLevelString(ObjX, ObjY);
								instance_create_layer(ObjX + 8, ObjY + 16, "Objs_" + FloorLevelStr, oItem_Key);
							}else{
								ObjInst = Treasure_Create(_RoomIndex, ObjX, ObjY, ObjContents, true, ,InSection);
							}
						}
						break;
								
					case SpecialObj.Crystal:
						ObjInst = Crystal_Create(_RoomIndex, ObjX, ObjY);
						break;
					
					case SpecialObj.HeartGuy:
						instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oHeartGuy, {Type : choose(1, 2)});	
						break;
						
					case SpecialObj.DeadGuy:				
						if(Prob(Chance_DeadGuyIsHungryGuy) && !global.Challenges[Challenges.NoFood]){
							instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "ObjsDoors_" + FloorLevelStr, oHungryGuy);	
						}else{
							instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "ObjsDoors_" + FloorLevelStr, oDeadGuy);
						}
						break;
					
					case SpecialObj.Torch:
												
						var inst = instance_create_layer(ObjX, ObjY, "ObjsDoors_" + FloorLevelStr, oTorch, {RoomIndex : _RoomIndex, Lit: _TorchLit});
						inst.GroupIndex = global.TorchGroupIndex;
						
						if(global.Switch_Add){
							inst.Action = Room.Switch.Action;
							inst.HiddenObjInst = Room.Switch.HiddenObjInst;
							inst.IsSwitch = true;
						}
						break;
					
					case SpecialObj.Warp:

						ObjInst = Warp_Create(_RoomIndex, ObjX, ObjY, FloorLevel);
						break;
						
					case SpecialObj.WarpDest:
						DrawTileBlock(GetFloorLevelTMID("Tiles_Water", ObjX, ObjY), ObjX, ObjY, 9, 0, 2, 2);
						Room.WarpDest_X = ObjX + 8;
						Room.WarpDest_Y = ObjY + 8;
						break;
					
					case SpecialObj.Star:
						global.SpawnedStarInst = instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oItem_Star, {From : ItemFrom.Anywhere});
						break;
				}
				
				AddUsedSpace(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, _UsedSpaceType, _ObjInSection);
				
				Success = true;
				break;
			}
						

			if(Success) break;
		}
		ds_list_destroy(ObjOrder);
		if(Success) break;
	}
	
	if(Success && UnusedZone != -1) Room.UnusedZone = -1;
	
	
	ds_list_destroy(_TemplateTypeOrder);
	
	return Success;
	
}

function SpawnTreasureRow(_RoomIndex, X, Y, InSection, MainItemClass, Items){
	
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

	
	var Pattern = Patterns[| irandom(ds_list_size(Patterns) - 1)];
	
	//var FloorLevelStr = GetFloorLevelString(X, Y);
	PotContents1 = Probs_RandomItemClass_Pot(true);
	PotContents2 = Probs_RandomItemClass_Pot(true);
	
	var TreasureInst;
	for(var StrIndex = 0; StrIndex < Items; StrIndex++){
		var ItemCode = string_copy(Pattern, StrIndex + 1, 1);
		var ItemX = X + (StrIndex * 16);
				
		//If there's no main obj, replace the T with t or P
		if(ItemCode == "*" && MainItemClass = -1) ItemCode = choose("p","P","t");
		
		switch(ItemCode){
				
			case "*": //Main treasure
				TreasureInst = Treasure_Create(_RoomIndex, ItemX, Y, MainItemClass, true, , InSection);
				break;

			case "t": //bonus treasure
				TreasureInst = Treasure_Create(_RoomIndex, ItemX, Y, RandomItem, true, , InSection);
				break;
				
			case "p": //pot 1
				Pot_Create(_RoomIndex, ItemX, Y, PotContents1, InSection);
				break;

			case "P": //pot 2
				Pot_Create(_RoomIndex, ItemX, Y, PotContents2, InSection);
				break;
				
		}
		
	}
	
	AddUsedSpace(_RoomIndex, X - 16, Y, X + (Items * 16) + 15, Y + 31, UsedSpaceType.Obj, InSection);
	
	ds_list_destroy(Patterns);
	
	return true;
	
}

function SpawnKinstone(_RoomIndex, UnusedZone){
	
	if(global.Level.Index == DungeonLevel.Castle) return false;
	
	if(ObstacleClassCheck(_RoomIndex, RoomObstacleClass.MovingFloors) || global.SpawnedRollingSpikes || global.SpawnedMovingSpikeBlocks) return false;
	
	if(Room.SpecialObject == SpecialDungeonObj.EnemyTrap && Room.SizeIndex == RoomSize._1x1 && Room.LowerDoors) return false //allow more space for trap enemies 
	
	if(!Prob(Chance_SpawnKinstoneMonument)) return false;
	
	var KinstoneArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Kinstones"];
	var Kinstones = array_length(KinstoneArray);
	
	if(Kinstones == 0) return false;

	
	//make a list of all monument indexes (0-n), then shuffle that list so we can pick them at random
	var KinstoneIndexList = ds_list_create();
	for(var KinstoneIndex = 0; KinstoneIndex < Kinstones; KinstoneIndex++){
		ds_list_add(KinstoneIndexList, KinstoneIndex);
	}
	ds_list_shuffle(KinstoneIndexList);

	var _RodCharger = !global.Level.RodCharger ? Prob(Chance_SpawnRodCharger) : false;
	
	var KinstoneOK, KinstoneX, KinstoneY, Kinstone, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, KinstoneInSection;
	for(var KinstoneIndex = 0; KinstoneIndex < ds_list_size(KinstoneIndexList); KinstoneIndex++){
		
		KinstoneOK = true;
		
		Kinstone = KinstoneArray[KinstoneIndexList[| KinstoneIndex]];
		
		KinstoneX = Room.x + Kinstone.x;
		KinstoneY = Room.y + Kinstone.y;
		var KinstoneX2 = KinstoneX + 31;
		var KinstoneY2 = KinstoneY + 31;
		
		KinstoneInSection = InSectionArea(_RoomIndex, KinstoneX, KinstoneY, Room.Section_ID, true);
		
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(_RoomIndex, Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);

		if(InUnusedZone(_RoomIndex, UnusedZone, Kinstone) == ObjInUnusedZone.Outside){
			KinstoneOK = false;
			continue;
		}

		
		//check if on top of path carpets
		if(global.SpawnedCarpetStyle == CarpetStyle.Path){
			var TMID = GetFloorLevelTMID("Tiles_Floor", KinstoneX, KinstoneY);
			if(CornersOnCarpet(TMID, KinstoneX, KinstoneY, KinstoneX2, KinstoneY2) > 1){
				KinstoneOK = false;
				continue;
			}
		}
		
		//Check for walls above and below the kinstone. There should be enough space at the bottom to put the treasure and for Link above it
		if(collision_rectangle(KinstoneX - 16, KinstoneY - 16, KinstoneX + 47, KinstoneY + 63, oWall, false, true)){
			KinstoneOK = false;
			continue;
		}

		//Check for doors
		//Top
		if(collision_rectangle(KinstoneX, KinstoneY - 32, KinstoneX2, KinstoneY, oDoor, false, true)){
			KinstoneOK = false; 
			continue;
		}
		//Bottom
		if(collision_rectangle(KinstoneX, KinstoneY2 + 1, KinstoneX2, KinstoneY2 + 32, oDoor, false, true)){
			KinstoneOK = false; 
			continue;
		}
		//Left
		if(collision_rectangle(KinstoneX - 32, KinstoneY, KinstoneX, KinstoneY2, oDoor, false, true)){
			KinstoneOK = false; 
			continue;
		}
		//Right
		if(collision_rectangle(KinstoneX2 + 1, KinstoneY, KinstoneX2 + 32, KinstoneY2, oDoor, false, true)){
			KinstoneOK = false;
			continue;
		}
			
		_UsedSpaceX1 = KinstoneX - 16;
		_UsedSpaceY1 = KinstoneY - 16;
		_UsedSpaceX2 = KinstoneX2 + 16;
		_UsedSpaceY2 = KinstoneY2 + (_RodCharger ? 16 : 32); //extra space for the treasures below, no need ofr that space if it's a rod charger
		
		if(UsedSpaceConflict(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, KinstoneInSection)){
			KinstoneOK = false;
			continue;
		}

		if(KinstoneOK) break;
		
	}
		

	var inst;
	if(KinstoneOK){
					
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(_RoomIndex, Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);
		
		var FloorLevel = GetFloorLevelID(KinstoneX, KinstoneY);
		var FloorLevelStr = GetFloorLevelString(FloorLevel);
		var TMID_Walls = layer_tilemap_get_id(layer_get_id("Tiles_Walls_" + FloorLevelStr));
		var TMID_Water = layer_tilemap_get_id(layer_get_id("Tiles_Water_" + FloorLevelStr));
		
		DrawTileBlock(TMID_Walls, KinstoneX, KinstoneY, 32 + (_RodCharger ? 4 : 0), 0, 4, 4);							
		
		//clear any water tiles on the platform area
		ClearTileBlock(TMID_Water, KinstoneX + 8, KinstoneY, 2, 1);
		
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX, KinstoneY, 1, 4);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY + 8, 2, 3);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 24, KinstoneY, 1, 4);
		var WallInst = WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY, 2, 1);
		WallInst.BlockLink = false;
		
		if(_RodCharger){
			inst = instance_create_layer(KinstoneX + 16, KinstoneY + 14, "ObjsHigher_" + FloorLevelStr, oRodCharger, {RoomIndex : _RoomIndex});
			SignCreate(KinstoneX + 16, KinstoneY + 32, global.RodChargerSignText, true);
			global.Level.RodCharger = true;
		}else{
			inst = instance_create_layer(KinstoneX + 16, KinstoneY + 14, "ObjsHigher_" + FloorLevelStr, oItem_Kinstone_Main, {Index : Kinstone_PickIndex(), RoomIndex : _RoomIndex});
			SignCreate(KinstoneX + 16, KinstoneY + 32, global.KinstoneSignText, true);
		}

		AddUsedSpace(_RoomIndex, _UsedSpaceX1, _UsedSpaceY1, _UsedSpaceX2, _UsedSpaceY2, UsedSpaceType.Obj, KinstoneInSection);

		//add kinstone to large map items so we can draw the icon if Link has a compass
		ds_list_add(global.LargeMapItems, inst); 
		
		
		if(UnusedZone != -1) Room.UnusedZone = -1;
		
	}
	
	ds_list_destroy(KinstoneIndexList);
	
	return KinstoneOK;
	
}
	
function SpawnJail(_RoomIndex, UnusedZoneIndex){

	var JailArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Jails"];
	var Jails = array_length(JailArray);
	
	if(Jails == 0) return false;
	
	//make a list of all jail indexes (0-n), then shuffle that list so we can pick them at random
	
	//************************************************************
	//to-do: InZone not being checked
	//************************************************************
	var JailIndexList = ds_list_create_sequence_shuffled(0, Jails - 1);
	
	var JailOK = false;
	var DoorCount;
	for(var JailIndex = 0; JailIndex < Jails; JailIndex++){
		
		//if(Prob(0.65)) continue;
		
		var Jail = JailArray[JailIndexList[| JailIndex]];
		
		if(Jail[$ "rotation"] != 0) continue;
		
		var JailX = Room.x + Jail.x;
		var JailY = Room.y + Jail.y;
		var JailX2 = JailX + Jail.width - 1;
		var JailY2 = JailY + Jail.height - 1;
		var JailTileW = Jail.width / 8;
		var JailTileH = Jail.height / 8;
		
		
		var Properties = Jail[$ "properties"];
		var PrisonerAllowed = GetPropertyValue(Properties, "NoPrisoner") == -1;
		
		
		//tile widths for each side of entrance including half of entrance width
		var TilesW_LeftSide = floor(JailTileW / 2);
		var RightSideX = JailX + (TilesW_LeftSide * 8);
	
		//Check for doors on the side
		if(collision_rectangle(JailX, JailY, JailX2, JailY2, oDoor, false, true)) continue; 

		JailOK = true;
		
		
		//check if there's a door above. If so, and if it's locked, make door unlocked and add lock to jail. 
		//If there's no doors, make jail a full jail with prisoner
		
		var FoundLockedDoor = false;

		var DoorList = ds_list_create();
		var DoorCheckWide = GetPropertyValue(Properties, "DoorCheckWide") != -1;
			
		if(DoorCheckWide){
			//if this property is set, check the width of the room instead the width of the jail
			var _x1 = Room.x + 16;
			var _y1 = Room.y + 16;
			var _x2 = _x1 + Room.width - 17;
			DoorCount = collision_rectangle_list(_x1, _y1, _x2, JailY, oDoor, false, true, DoorList, false);
		}else{
			DoorCount = collision_rectangle_list(JailX, Room.y + 16, JailX2, JailY, oDoor, false, true, DoorList, false);
		}
		
		if(DoorCount == 1 && Room.Section_ID == 0){ //only allow locked jails with key block that have only 1 door above. Otherwise it might block the path to other doors
			var DoorInst = DoorList[| 0];
			if(DoorInst.Status == DoorStatus.Locked){
				//found a door above the jail that is locked, make it unlocked
				DoorInst.Status = DoorStatus.Open;
				//if the locked door exists in the map items list, then delete it
				var i = ds_list_find_index(global.LargeMapItems, DoorInst);
				if(i != -1) ds_list_delete(global.LargeMapItems, i);
		
				FoundLockedDoor = true;
			}
			
		}

		
		var _JailType = (DoorCount == 0 && PrisonerAllowed ? JailType.Prisoner : (FoundLockedDoor ? JailType.Locked : JailType.Open));
		
		Dungeon_Draw_Jail(_RoomIndex, JailX, JailY, JailTileW, JailTileH, _JailType);
		
		ds_list_destroy(DoorList);
				
		//fix: *********************************************
		//Zone isn't being checked. Should be if in same zone as UnusedZoneIndex, then Room.UnusedZone = -1;
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

function PlatformVerify(_RoomIndex, InSection, UnusedZone, MaxTileW = 14){
	
	//Altars are now part of the Platform family. Platforms can be altars, floor shops, etc.
	//Code below still says Altar for everything, but think of the following as Platforms
	//Check all altars in template and set dimensions into global.AltarData if valid

	var AltarsArray = Room.Template[$ "Sections"][Room.Section_ID][$ "Altars"];
	
	var AltarsInTemplate = array_length(AltarsArray);

	if(AltarsInTemplate == 0) return false;

	var AltarsList = ds_list_create_sequence_shuffled(0, AltarsInTemplate - 1);
			
	var AltarValid = false;
	
	var Collisions, AltarX2, AltarX1, Option_StickLeft, Option_StickRight, AltarY2, AltarY1, AltarInSection;
	for(var AltarListIndex = 0; AltarListIndex < AltarsInTemplate; AltarListIndex++){
		
		var AltarIndex = AltarsList[| AltarListIndex];
		var Altar = AltarsArray[AltarIndex]

		if(Altar[$ "rotation"] != 0) continue;
		
		AltarValid = false;
		
		AltarX1 = Room.x + Altar.x;
		AltarY1 = Room.y + Altar.y;
		var AltarW = Altar.width;
		var AltarH = Altar.height;
		
		
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, AltarX1, AltarY1, AltarW, AltarH);
		TransformObj(_RoomIndex, Altar, xywhList);
		AltarX1 = xywhList[| 0]; AltarY1 = xywhList[| 1];
		AltarW = xywhList[| 2]; AltarH = xywhList[| 3];
		ds_list_destroy(xywhList);
			
			
		AltarX2 = AltarX1 + AltarW - 1;
		AltarY2 = AltarY1 + AltarH - 1;
		
		AltarInSection = InSectionArea(_RoomIndex, AltarX1, AltarY1, Room.Section_ID, true);
		if( (!InSection && AltarInSection) || (InSection && !AltarInSection) ) continue;


		if(InUnusedZone(_RoomIndex, UnusedZone, Altar) == ObjInUnusedZone.Outside) continue;


		Option_StickLeft = true;
		Option_StickRight = true;
		
		var DoorCollisionList = ds_list_create();
		Collisions = collision_rectangle_list(AltarX1 - 24, AltarY1, AltarX2 + 24, AltarY2, oDoor, false, true, DoorCollisionList, false);
		
		//Check Left and Right side doors first, shift the altar if collisions
		for(var DoorIndex = 0; DoorIndex < Collisions; DoorIndex++){
				
			var DoorInst = DoorCollisionList[| DoorIndex];
			
			//We need to check the section of the doors, because if door is in opposite section from altar, no need to worry about collision
			var DoorInSection = InSectionArea(_RoomIndex, DoorInst.x, DoorInst.y, Room.Section_ID, true);
			if(DoorInSection != AltarInSection) continue;
				
			switch(DoorInst.Location){
						
				case "Left":
					AltarX1 = DoorInst.x + 48;
					Option_StickLeft = false;
					break;
					
				case "Right":
					AltarX2 = DoorInst.x - 23;
					Option_StickRight = false;
					break;
					
					
			}
				
		}			

		//Check doors above now
		var CheckDoorCollisions = true;
		while(CheckDoorCollisions){
			
			ds_list_clear(DoorCollisionList);
			Collisions = collision_rectangle_list(AltarX1, AltarY1 - 24, AltarX2, AltarY2, oDoor, false, true, DoorCollisionList, false);
			CheckDoorCollisions = false;
			
			for(var DoorIndex = 0; DoorIndex < Collisions; DoorIndex++){
			
				var DoorInst = DoorCollisionList[| DoorIndex];

				//We need to check the section of the doors, because if door is in opposite section from altar, no need to worry about collision
				var DoorInSection = InSectionArea(_RoomIndex, DoorInst.x, DoorInst.y, Room.Section_ID, true);
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
		
		if(UsedSpaceConflict(_RoomIndex, AltarX1 - 16, AltarY1, AltarX2 + 16, AltarY2 + 16, UsedSpaceType.Obj, AltarInSection)) continue;

		
		AltarValid = true;
		break;
	
	}

	if(!AltarValid) return false;
	
	
	
	//make width a multiple of 16 so treasures are alligned
	var AltarW = floor((AltarX2 - AltarX1 + 1) / 16) * 16; 
	var AltarTileW = AltarW / 8;
	var NewAltarTileW = min(MaxTileW, irandom_range(4, AltarTileW / 2) * 2); //this creates widths that are multiples of 2, starting at 8 tiles wide
	var NewAltarW = NewAltarTileW * 8;
	
	var AltarX;
	if(Option_StickLeft && !Option_StickRight)
		AltarX = AltarX1;	
	else if(Option_StickRight && !Option_StickLeft)
		AltarX = AltarX2 - NewAltarW + 1;
	else
		AltarX = AltarX1 + ((AltarW - NewAltarW) / 2);
	
	AltarW = NewAltarW;	
	var AltarH = AltarY2 - AltarY1 + 1;

	global.AltarData = {x : AltarX, y : AltarY1, w : AltarW, h : AltarH, StickL : Option_StickLeft, StickR : Option_StickRight};
	
	AddUsedSpace(_RoomIndex, AltarX - 16, AltarY1, AltarX + AltarW - 1 + 16, AltarY2 + 16, UsedSpaceType.Obj, AltarInSection);
	
	return true;
	
}

function AddUsedSpace(_RoomIndex, _x1, _y1, _x2, _y2, _SpaceType, _IsInSection, _Inst = noone){
	
	array_push(Room.UsedSpace, {x1 : _x1, y1 : _y1, x2 : _x2, y2 : _y2, SpaceType : _SpaceType, IsInSection : _IsInSection, Inst : _Inst});
	
}

function UsedSpaceConflict(_RoomIndex, _x1, _y1, _x2, _y2, _MySpaceType, _IsInSection){
	
	//returns true if rectangle is colliding with a used space area, taking into account the caller's space type (MySpaceType)
	//Certain obj types are allowed to collide with certain space types (enemies are allowed on spike space types, etc)
	//For objects that may overlap section into the other, set the _InSection in AddUsedSpace to true/false based on if obj is in section or not. Objs that have this set will only check for conflict if obj is in the same section
	
	for(var UsedSpaceIndex = 0; UsedSpaceIndex < array_length(Room.UsedSpace); UsedSpaceIndex++){
		
		var _UsedSpace = Room.UsedSpace[UsedSpaceIndex];
		
		if(_UsedSpace.IsInSection != _IsInSection) continue;
		
		if( rectangle_in_rectangle(_x1, _y1, _x2, _y2, _UsedSpace.x1, _UsedSpace.y1, _UsedSpace.x2, _UsedSpace.y2) != 0 ||
			rectangle_in_rectangle(_UsedSpace.x1, _UsedSpace.y1, _UsedSpace.x2, _UsedSpace.y2, _x1, _y1, _x2, _y2) != 0){
			
			if(_UsedSpace.SpaceType == UsedSpaceType.Obj) return true; //any obj colliding with an obj space returns true
			
			switch(_MySpaceType){
				case UsedSpaceType.Obj:
					//any obj space type colliding with any other type is a conflict
					return true
					
				case UsedSpaceType.Enemy:
					if(_UsedSpace.SpaceType == UsedSpaceType.Enemy) return true;
					break;
				
				case UsedSpaceType.IgnoreEnemy:
					if(_UsedSpace.SpaceType == UsedSpaceType.Enemy) continue;
					break;
					

			}	

		}
		
	}
	
	return false;	
}

function UsedSpaceDelInstSpace(_RoomIndex, _Inst){
	//deletes space that instance _Inst occupied.
	for(var i = 0; i < array_length(Room.UsedSpace); i++){
		if(Room.UsedSpace[i].Inst == _Inst){
			array_delete(Room.UsedSpace, i, 1);
			break;
		}
	}	
	
}

function InSectionArea(_RoomIndex, _x, _y, _SectionID, _RelativeToRoom){
	
	//returns true if point is within a section area
		
	var SectionAreas = array_length(Room.Template[$ "Sections"][_SectionID][$ "SectionArea"]);
	for(var SectionAreaIndex = 0; SectionAreaIndex < SectionAreas; SectionAreaIndex++){

		var SectionObj = Room.Template[$ "Sections"][_SectionID][$ "SectionArea"][SectionAreaIndex];
		
		var SectionX = (_RelativeToRoom ? Room.x : 0) + SectionObj.x;
		var SectionY = (_RelativeToRoom ? Room.y : 0) + SectionObj.y;
		if(point_in_rectangle(_x, _y, SectionX, SectionY, SectionX + SectionObj.width - 1, SectionY + SectionObj.height - 1)) return true;
				
	}
	
	return false;
			
	
}

function InZone(_RoomIndex, Obj){
	
	//returns Zone index if obj is within or overlapping a zone, otherwise returns -1
	
	var Zones = array_length(Room.Template[$ "Sections"][Room.Section_ID][$ "Zones"]);
	
	for(var ZoneIndex = 0; ZoneIndex < Zones; ZoneIndex++){

		var Zone = Room.Template[$ "Sections"][Room.Section_ID][$ "Zones"][ZoneIndex];
		
		if(rectangle_in_rectangle(Obj.x, Obj.y, Obj.x + Obj.width - 1, Obj.y + Obj.height - 1, Zone.x, Zone.y, Zone.x + Zone.width - 1, Zone.y + Zone.height - 1) > 0) return ZoneIndex;
				
	}
	
	return -1;
	
}

function InUnusedZone(_RoomIndex, _UnusedZone, _Obj){
	
	if(_UnusedZone == -1) return ObjInUnusedZone.NoUnusedZone
	
	var _ZoneIndex = InZone(_RoomIndex, _Obj);
	
	if(_ZoneIndex == _UnusedZone) return ObjInUnusedZone.Inside
	
	return ObjInUnusedZone.Outside
		
}

function TransformObj(_RoomIndex, Obj, xywhList){
	
	//to-do: change using list to using array
	
	
	//Apply SBShift/SBResize codes and rotations if they apply using the x/y/w/h in the passed list.
	//Some objects need to be shifted or resized if in the Room template they are against a rail, but that rail becomes a Switchbox.
	//You can't pass a variable by reference, which is why we store all 4 values in a list and pass that to this function
	
	var _x = xywhList[| 0];
	var _y = xywhList[| 1];
	var _w = xywhList[| 2];
	var _h = xywhList[| 3];
					
	if(Room[$ "Section_WallType"] == SectionWallType.SwitchBlock){
		
		var Properties = Obj[$ "properties"];			
		var RoomTransform = Room.Template[$ "RoomTransformation"];
		
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


