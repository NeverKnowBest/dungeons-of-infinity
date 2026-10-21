

function Dungeon_Draw_Special_Items(){
	
	//if we're in the boss room at a boss depth, then don't draw special items
	if(global.RoomIndex == global.BossRoomIndex && global.BossLevel){

		switch(global.DungeonDepth){
			case DungeonLevel.CastleJails:	
				var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Armos_C); 
				inst.RoomX = Room.x;
				inst.RoomY = Room.y;				
				break;
				
			case DungeonLevel.LanmolasLair:
				var inst = instance_create_layer(Room.x + 20, Room.y + 20, "System", oBoss_Lanmola_C);
				inst.RoomX = Room.x;
				inst.RoomY = Room.y;
				break;
				
			case DungeonLevel.MoldormsLair:
				var inst = instance_create_layer(Room.x + 128, Room.y + 80, "Objs_Upper", oBoss_Moldorm);			
				break;
		
		}
		
		exit;
	}
	
	
	//This sets up the altars, monuments, pots, treasures, crystals, etc, based on if the room needs keys, treasures, crystals, etc
	
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
			
		var RoomTemplateObjArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ SpecialObjComboType];
		for(var SpecialObjComboType_ObjIndex = 0; SpecialObjComboType_ObjIndex < array_length(RoomTemplateObjArray); SpecialObjComboType_ObjIndex++){

			//Check if obj is inside SectionArea. If so add obj to RoomTemplateObjArray_SpecialObjCombos_Section. If not, RoomTemplateObjArray_SpecialObjCombos_Main.
			var Obj = RoomTemplateObjArray[SpecialObjComboType_ObjIndex];
			var ObjIsInSection = InSectionArea(Obj.x, Obj.y, global.RoomTemplate, global.SectionID, false);
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
	
	SpawnSpecialObjects();
	
	for(var SpecialObjComboTypeIndex = 0; SpecialObjComboTypeIndex < global.SpecialObjComboTypes; SpecialObjComboTypeIndex++){
		ds_list_destroy(global.RoomTemplateObjLists_SpecialObjCombos_Main[SpecialObjComboTypeIndex]);
		ds_list_destroy(global.RoomTemplateObjLists_SpecialObjCombos_Section[SpecialObjComboTypeIndex]);		
	}
	global.RoomTemplateObjLists_SpecialObjCombos_Main = 0;
	global.RoomTemplateObjLists_SpecialObjCombos_Section = 0;
	
	ds_list_destroy(global.UsedObjs);
	ds_list_destroy(global.UsedSpaces);

	
}


function SpawnSwitch(){
	
	
	switch(global.Switch_Add){
		
		case SwitchAction.None:
			
			break;
			
		case SwitchAction.OpenDoors:
		
			break;
		
		case SwitchAction.RevealTreasure:
			
			//spawn the treasure chest the key will be in.
			global.SpawnedTreasure = SpawnObj(SpecialObj.Treasure, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			
			if(!global.SpawnedTreasure) break;
			
			//Add all the possible switch types in a list, remove any that are invalid, shuffle list, then pick one by one until switch was added
			var SwitchTypeList = ds_list_create();
			ds_list_add(SwitchTypeList, SwitchType.FloorSwitch, SwitchType.Torches, SwitchType.Block);
			ds_list_shuffle(SwitchTypeList);
			
			var SwitchTypes = ds_list_size(SwitchTypeList);
			
			for(var SwitchTypeIndex = 0; SwitchTypeIndex < SwitchTypes; SwitchTypeIndex++){
				
				var _SwitchType = SwitchTypeList[| SwitchTypeIndex];
				
				switch(_SwitchType){
					
					case SwitchType.FloorSwitch:
						
						if(global.SectionID == 0){ //only use torches as switches if section ID is 0
							global.SpawnedTorches = SpawnTorches();
							if(global.SpawnedTorches) global.Switch_Add = SwitchAction.None;
								
						}
						
						break;


					case SwitchType.Torches:

						global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, noone);

						if(global.SpawnedPots){
							global.Switch_Inst.TreasureInst = global.Switch_TreasureInst;
							global.Switch_Add = SwitchAction.None;							
						}
						
						break;
					
					case SwitchType.Block:

						if(!global.SpawnedJail && global.SectionID == 0){
							
							global.SpawnedBlocks = SpawnBlocks(BlockObj.Switch); 
							
						}

						if(global.SpawnedBlocks){
							if(global.Switch_Inst != noone){
								global.Switch_Inst.TreasureInst = global.Switch_TreasureInst;
								global.Switch_Add = SwitchAction.None;
							}
						}
						
						break;
						
				}
				
				if(global.Switch_Add == SwitchAction.None) break;
				
			}

			//if switch didn't spawn, then destroy the treasure
			if(global.Switch_Add != SwitchAction.None){
				
				instance_destroy(global.Switch_TreasureInst);
				instance_destroy(global.Switch_Inst);
				
				//also destroy used space entry the treasure added
				ds_list_delete(global.UsedSpaces, ds_list_size(global.UsedSpaces) - 1);

				global.SpawnedTreasure = false;
				
				
			}			
						
			break;
		
	}
	
	ds_list_destroy(SwitchTypeList);
	
	return global.Switch_Add == SwitchAction.None



}


function SpawnSpecialObjects(){

	global.SpawnedPots = false;
	global.SpawnedTreasure = false;
	global.SpawnedCrystal = false;
	global.SpawnedSwitch = false;
	global.SpawnedMonument = false;
	global.SpawnedKinstone = false;
	global.SpawnedAltar = false;
	global.SpawnedShop = false;
	global.SpawnedJail = false;
	global.SpawnedBlocks = false;
	global.SpawnedTorches = false;
	
	if(global.DungeonDepth == DungeonLevel.CastleJails && !(global.BossLevel && global.RoomIndex == global.BossRoomAdjacentIndex)) 
		global.SpawnedJail = SpawnJail(global.UnusedZoneIndex);

	if(StartingRoom) global.SpawnedMonument = SpawnMonuments(false, global.UnusedZoneIndex);
	
	//if you're in the entrance or adjacent boss room, don't draw any special objects.
	if(StartingRoom || (global.BossLevel && global.RoomIndex == global.BossRoomAdjacentIndex) ) exit;	
	
	switch(global.SpecialObj){
		
		case SpecialDungeonObj.Crystal:
			
			global.SpawnedCrystal = SpawnObj(SpecialObj.Crystal, global.SpecialObj_InSection, global.UnusedZoneIndex, noone);
			if(!global.SpawnedCrystal) Error("Can't spawn crystal for dungeon index " + string(global.DungeonNo) + ", room index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]), false);
			break;
		
		case SpecialDungeonObj.Key:			
			
			if(global.EnemyHasKey) break;
			
			global.SpawnedSwitch = SpawnSwitch();
			

						
					
					


			
			//if(!Spawned && global.UnusedZoneIndex < 1){
			//	if(Prob(0.3)){
			//		global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, oItem_Key);
			//		Spawned = global.SpawnedPots;
			//		if(Spawned) break;
			//	}
			//}

			//if(!Spawned){
			//	if(Prob(0.3)){
			//		global.SpawnedTreasure = SpawnObj(SpecialObj.Treasure, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//		Spawned = global.SpawnedTreasure;
			//		if(Spawned) break;
			//	}
			//}

			//if(!Spawned){
			//	if(Prob(0.3)){
			//		global.SpawnedMonument = SpawnMonuments(global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//		Spawned = global.SpawnedMonument;
			//		if(Spawned) break;
			//	}
			//}

			//if(!Spawned){
			//	if(Prob(Chance_DeadGuy) && global.DungeonDepth > DungeonLevel.CastleJails){
			//		global.SpawnedTreasure = SpawnObj(SpecialObj.DeadGuy, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//		Spawned = global.SpawnedTreasure;
			//		if(Spawned) break;
			//	}
			//}
			
			//if(!Spawned){
			//	global.SpawnedAltar = SpawnAltar(global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//	Spawned = global.SpawnedAltar;
			//	if(Spawned) break;
			//}
			
			////Key might still not be spawned at this point, try again with pots, treasures, and monuments without probs
			//if(global.UnusedZoneIndex < 1){			
			//	if(!Spawned){
			//		global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, oItem_Key);
			//		Spawned = global.SpawnedPots;
			//		if(Spawned) break;
			//	}
			//}

			//if(!Spawned){
			//	global.SpawnedTreasure = SpawnObj(SpecialObj.Treasure, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//	Spawned = global.SpawnedTreasure;
			//	if(Spawned) break;
			//}

			//if(!Spawned){
			//	global.SpawnedMonument = SpawnMonuments(global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//	Spawned = global.SpawnedMonument;
			//	if(Spawned) break;
			//}

			//if(!Spawned){
			//	global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, oItem_Key);
			//	Spawned = global.SpawnedPots;
			//	if(Spawned) break;
			//}

			//if(!Spawned){
			//	if(Prob(Chance_DeadGuy) && global.DungeonDepth > DungeonLevel.CastleJails){
			//		global.SpawnedTreasure = SpawnObj(SpecialObj.DeadGuy, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
			//		Spawned = global.SpawnedTreasure;
			//		if(Spawned) break;
			//	}
			//}
			
			//if(!Spawned){			
			//	Error("Can't spawn key for room index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"]), false );
			//	//Spawned = true;
			//	//game_end();
			//	exit;
			//}
			
			break;
		
	}
	
	//if(global.Switch_Add){
	//	//if(!global.SpawnedMonument && FlipCoin_Bool()) global.SpawnedMonument = SpawnMonuments(global.SpecialObj_InSection, global.UnusedZoneIndex, noone, true)
	//	//if(!global.SpawnedMonument) 
	//	if(Prob(Chance_SwitchTorches) && global.SectionID == 0){ //only use torches as switches if section ID is 0
	//		global.SpawnedTorches = SpawnTorches();
	//	}
		
	//	if(!global.SpawnedTorches){
	//		global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, noone);
		
	//		//if(!global.SpawnedMonument && !global.SpawnedPots){			
	//		if(!global.SpawnedPots){
				
	//			//try again with the torches since they may not have been used because of Prob
	//			if(global.SectionID == 0) global.SpawnedTorches = SpawnTorches();
	//			if(!global.SpawnedTorches){
	//				Error("Can't spawn door switch for room index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"]), false );
	//			}
	//		}
			
	//	}
	//}



	//if( global.SectionID == 0 && ( (global.SpecialObj == SpecialDungeonObj.Key && !global.EnemyHasKey) || global.SpecialObj == SpecialDungeonObj.Crystal)){
	//	//if there was a special obj like key, crystal, and section ID is 0(no sections), don't generate a bonus treasure.
	//	//It's fine if enemy has key though
	//}else{
		
	//	var TreasureInRoom = collision_rectangle(Room.x, Room.y, Room.x + Room.width - 1, Room.y + Room.height - 1, oItem_Treasure, false, true);
		
	//	if(!TreasureInRoom && !global.SpawnedAltar && !global.EnemyHasKey){
			
	//		if(global.SpawnShop){

	//			var InSection = (global.SectionID != 0 ? FlipCoin_Bool() : false);
				
	//			global.SpawnedShop = SpawnShop(InSection, global.UnusedZoneIndex); 
	//			if(!global.SpawnedShop) global.SpawnedShop = SpawnShop(!InSection, global.UnusedZoneIndex); //try the other section if not spawned

	//		}
			
	//	}
		
	//	if(global.SpawnKinstone) global.SpawnedKinstone = SpawnKinstone(false, global.UnusedZoneIndex);

		
	//	if(global.SpawnBonusTreasure){
				
	//		//I'm aware this method looks innefient and messy, but any other method resulted in trouble. Keep this method since it works.
				
	//		//if no special item was generated, pick a random section to spawn treasure, otherwise, pick oposite section from special item's section
	//		var InSection = false;
	//		if(global.SectionID != 0) InSection = (global.SpecialObj == SpecialDungeonObj.None ? FlipCoin_Bool() : !global.SpecialObj_InSection )
				
	//		var Spawned = false;
			

	//		if(Prob(Chance_HeartGuy)){
	//			global.SpawnedTreasure = SpawnObj(SpecialObj.HeartGuy, InSection, global.UnusedZoneIndex, noone);
	//			Spawned = global.SpawnedTreasure;
	//		}

	//		if(!Spawned && Prob(Chance_DeadGuy) && global.DungeonDepth > DungeonLevel.CastleJails){
	//			global.SpawnedTreasure = SpawnObj(SpecialObj.DeadGuy, InSection, global.UnusedZoneIndex, noone);
	//			Spawned = global.SpawnedTreasure;
	//		}

			
	//		if(!Spawned && FlipCoin_Bool()){
	//			global.SpawnedTreasure = SpawnObj(SpecialObj.Treasure, InSection, global.UnusedZoneIndex, RandomItem);
	//			Spawned = global.SpawnedTreasure;
	//		}
				
	//		if(!Spawned && FlipCoin_Bool()){
	//			if(!global.SpawnedMonument) global.SpawnedMonument = SpawnMonuments(InSection, global.UnusedZoneIndex, RandomItem);
	//			Spawned = global.SpawnedMonument;
	//		}
				
	//		if(!Spawned){
	//			global.SpawnedAltar = SpawnAltar(InSection, global.UnusedZoneIndex, RandomItem);
	//			Spawned = global.SpawnedAltar;
	//		}
				
	//		//At this point, the treasure might stil not be spawned, so try again with loose and monument but without prob
	//		if(!Spawned){
	//			global.SpawnedTreasure = SpawnObj(SpecialObj.Treasure, InSection, global.UnusedZoneIndex, RandomItem);
	//			Spawned = global.SpawnedTreasure;
	//		}

	//		if(!Spawned){
	//			if(!global.SpawnedMonument) global.SpawnedMonument = SpawnMonuments(InSection, global.UnusedZoneIndex, RandomItem);
	//			Spawned = global.SpawnedMonument;
	//		}
				
	//		if(Spawned) global.SpawnBonusTreasure = false;	
	//	}
			


	//}



	////add a check to see which section monument or pots were spawned. Allow in opposite section
	//if(!global.SpawnedMonument && !global.SpawnRollingSpikes){
	//	var GridW = Room.GridW;
	//	var GridH = Room.GridH;
	//	if(Prob(Chance_Decor_Monuments) || GridW == 2 || GridH == 2){
	//		global.SpawnedMonument = SpawnMonuments(false, -1, global.SpawnBonusTreasure ? RandomItem : noone);
	//		if(global.SpawnBonusTreasure && global.SpawnedMonument) global.SpawnBonusTreasure = false;
	//	}
	//}	

	
	//if(!global.SpawnedPots){// && global.RoomIndex != global.EntranceRoomIndex){
	//	if(Prob(Chance_SpawnPots)) 
	//		global.SpawnedPots = SpawnPots(global.SpecialObj_InSection, noone);
	//}
	
	
	//if(global.SpawnedAltar) global.AltarCount++;
	//if(global.SpawnedShop) global.ShopCount++;
	
	//if(global.RoomIndex != global.EntranceRoomIndex && !global.SpawnedBlocks){
	//	if(FlipCoin_Bool()){ //half the time check Guru first then spikes, otherwise check the opposite.
	//		if(global.SpawnGuruBars) SpawnGuruBars();
	//		else if(global.SpawnRollingSpikes) SpawnRollingSpikes();
	//	}else{
	//		if(global.SpawnRollingSpikes) SpawnRollingSpikes();
	//		else if(global.SpawnGuruBars) SpawnGuruBars();			
	//	}
	//}

	//if(!global.SpawnedShop){
	//	if( Prob(Chance_SpawnEnemies) || global.EnemyHasKey || (!StartingRoom && !global.SpawnedTreasure && !global.SpawnedAltar && !global.SpawnedKinstone && !global.SpawnedCrystal )) {
	//		var Spawned = SpawnEnemies();
	//		if(global.EnemyHasKey){
	//			//last resort to spawn key if enemies failed to spawn, or enemy has spawned but no key was given to them.
	//			//Sometimes enemies don't get spawned after all tries because the random pickes for the enemies just aren't allowed.
	//			var KeySpawned = false;
	//			if(!global.SpawnedPots){
	//				KeySpawned = SpawnPots(global.SpecialObj_InSection, oItem_Key);	
					
	//			}else{
	//				//bonus pots already created, find a pot in the room and place key in pot, making sure the InSection is the same
	//				with(oPot){
	//					if(x >= Room.x && x < Room.x + Room.width && y >= Room.y && y < Room.y + Room.height){
	//						if(global.SpecialObj_InSection == self.InSection){
	//							self.ContentsObj = oItem_Key;
	//							KeySpawned = true;
	//							break;
	//						}
	//					}
	//				}
	//			}
	//			if(!KeySpawned){
	//				if(!global.SpawnedTreasure){
	//					KeySpawned = SpawnObj(SpecialObj.Treasure, global.SpecialObj_InSection, global.UnusedZoneIndex, oItem_Key);
						
	//				}else{
	//					//bonus treasures already created find a treasure in the room and place key in pot, making sure the InSection is the same
	//					with(oItem_Treasure){
	//						if(x >= Room.x && x < Room.x + Room.width && y >= Room.y && y < Room.y + Room.height){
	//							if(global.SpecialObj_InSection == self.InSection){
	//								self.ContentsObj = oItem_Key;
	//								KeySpawned = true;
	//								break;
	//							}
	//						}
	//					}						

	//				}
	//				//at this point, no key has been generated with all further attempts
	//				if(!KeySpawned){
	//					Error("Can't spawn key for enemy for room index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"]), false );
	//				}
					
	//			}
				
				
				

	//		}
	//	}
	//}
	
	
	//if(!global.SpawnedTorches){
	//	if(Prob(Chance_SpawnTorches)) 
	//		SpawnTorches();
	//}
	
}


function SpawnMonuments(InSection, UnusedZone, Obj = noone, ForcePots = false){
	
	//To future self: If monuments aren't spawning when an altar is in the room, remember that monuments check a large distance using SafeDistance().
	//So even though it looks like monuments can fit, it's best if you just leave it as is because through testing it was shown that sometimes there's not enough room left
	
	var MonumentsArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Monuments"];
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

	
	var GroupOk = false;
	for(var GroupIndexesListIndex = 0; GroupIndexesListIndex < Groups; GroupIndexesListIndex++){
			
		var GroupIndex = GroupIndexesList[| GroupIndexesListIndex];
		var GroupStr = GroupsArray[GroupIndex];
		var MonumentsInGroup = string_length(GroupStr);

		//Special case only for room template 663 main section and when altar is centered
		var SpecialAltarCase = false;
		if((global.SpawnedAltar || global.SpawnedShop) && global.Data_RoomTemplates[global.RoomTemplate][$ "id"] == 663 && global.SectionID == 0){
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
		
		var InZone = false;
				
		for(var MonumentIndex = 0; MonumentIndex < MonumentsInGroup; MonumentIndex++){
			
			var GroupID = string_char_at(GroupStr, MonumentIndex + 1);
			var LetterIndex = ord(string_upper(GroupID)) - 65; //A = 0, B = 1, etc
			
			var ArrayIndex = MonumentIndexList[| LetterIndex];
			if(ArrayIndex == -1){
				Error("Monument Letter Error: Letter Index " + string(LetterIndex) + "(A=0,B=1..), Room Index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"]), true );
				return false;
			}
			var Monument = MonumentsArray[ArrayIndex];
			
			if(UnusedZone != -1 && !InZone){
				var ZoneIndex = InZone(Monument, global.RoomTemplate, global.SectionID, false);
				if( ZoneIndex == UnusedZone) InZone = true;
			}
			
			var Properties = Monument[$ "properties"];
	
			var MonumentTLCornerX = Room.x + Monument.x;
			var MonumentTLCornerY = Room.y + Monument.y;
			
			//Apply transformations if any
			var xywhList = ds_list_create();
			ds_list_add(xywhList, MonumentTLCornerX, MonumentTLCornerY, 32, 32);
			TransformObj(Monument, xywhList);
			MonumentTLCornerX = xywhList[| 0]; MonumentTLCornerY = xywhList[| 1];
			ds_list_destroy(xywhList);
						
			//Check conditions that make a pattern not ok. If any are true, go to next pattern.


			//Check for doors
			//Top
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY - 24, MonumentTLCornerX + 31, MonumentTLCornerY, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Bottom
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY + 32, MonumentTLCornerX + 31, MonumentTLCornerY + 32 + 23, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Left
			if(collision_rectangle(MonumentTLCornerX - 24, MonumentTLCornerY, MonumentTLCornerX, MonumentTLCornerY + 31, oDoor, false, true)){
				GroupOk = false; break;
			}
			//Right
			if(collision_rectangle(MonumentTLCornerX + 32, MonumentTLCornerY, MonumentTLCornerX + 32 + 23, MonumentTLCornerY + 31, oDoor, false, true)){
				GroupOk = false; break;
			}
			
			var MonumentInSection = InSectionArea(MonumentTLCornerX, MonumentTLCornerY, global.RoomTemplate, global.SectionID, true);
			
			//Check for used objects
			
			//Special case only for room template index 0: if altar is centered, and the monument is at the same level as the altar, and the monuments are at A or E, allow
			if(SpecialAltarCase && ( (abs(MonumentTLCornerY - global.AltarData[$ "y"]) <= 8) && global.AltarData[$ "w"] <= 96 && (string_upper(GroupID) == "A" || string_upper(GroupID) == "E" ))){
				//skip safe distance check
			}else if(!SafeDistanceBox(MonumentTLCornerX, MonumentTLCornerY, MonumentTLCornerX + 31, MonumentTLCornerY + 31, MonumentInSection, 64, false)){
				GroupOk = false;
				break;					
			}
			
			
			//Check if object are allowed under monument.
			//If there's a wall below, or there's a door to the left or right of the obj area, then obj not allowed
			
			//Bottom
			var ObjAllowed = true;
			if(collision_rectangle(MonumentTLCornerX, MonumentTLCornerY + 32, MonumentTLCornerX + 31, MonumentTLCornerY + 32 + 31, oWall, false, true)){
				ObjAllowed = false;
			}
			//Door Left of obj area
			if(collision_rectangle(MonumentTLCornerX - 24, MonumentTLCornerY + 32, MonumentTLCornerX - 1, MonumentTLCornerY + 32 + 23, oDoor, false, true)){
				ObjAllowed = false;
			}
			//Door Right of obj area
			if(collision_rectangle(MonumentTLCornerX + 32, MonumentTLCornerY + 32, MonumentTLCornerX + 32 + 23, MonumentTLCornerY + 32 + 23, oDoor, false, true)){
				ObjAllowed = false;
			}

			
			//We also have to check if other monuments that are part of this group would be in the way of objects
			//======================================
				for(var OtherMonumentIndex = 0; OtherMonumentIndex < MonumentsInGroup; OtherMonumentIndex++){
			
					var OtherGroupID = string_char_at(GroupStr, OtherMonumentIndex + 1);
					var OtherLetterIndex = ord(string_upper(OtherGroupID)) - 65; //A = 0, B = 1, etc
			
					var OtherArrayIndex = MonumentIndexList[| OtherLetterIndex];
					if(OtherArrayIndex == -1){
						Error("Monument Letter Error: Letter Index " + string(OtherLetterIndex) + "(A=0,B=1..), Room Index " + string(global.RoomIndex) + ", template id " + string(global.Data_RoomTemplates[global.RoomTemplate][$ "id"]) + ", Room Transform " + GetTransformationStr(global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"]), true );
						return false;
					}
					var OtherMonument = MonumentsArray[OtherArrayIndex];

					var OtherMonumentTLCornerX = Room.x + OtherMonument.x;
					var OtherMonumentTLCornerY = Room.y + OtherMonument.y;
			
					//Apply transformations if any
					var OtherxywhList = ds_list_create();
					ds_list_add(OtherxywhList, OtherMonumentTLCornerX, OtherMonumentTLCornerY, 32, 32);
					TransformObj(OtherMonument, OtherxywhList);
					OtherMonumentTLCornerX = OtherxywhList[| 0]; OtherMonumentTLCornerY = OtherxywhList[| 1];
					ds_list_destroy(OtherxywhList);
					
					if(rectangle_in_rectangle(MonumentTLCornerX, MonumentTLCornerY + 32, MonumentTLCornerX + 31, MonumentTLCornerY + 32 + 31, OtherMonumentTLCornerX, OtherMonumentTLCornerY, OtherMonumentTLCornerX + 31, OtherMonumentTLCornerY + 31)){
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
		
		if(GroupOk){

			//Pattern might be ok to not block doors and such, but if an obj is needed or switch needs to be added in pots and objs are not allowed, 
			//or an object is needed in a specific section but no monuments exist in that section, then we can't use this pattern
			if(Obj != noone || global.Switch_Add != SwitchAction.None){
				if( (!InSection && !ObjectsAllowed_Main) || (InSection && !ObjectsAllowed_Section) ){
					GroupOk = false;
					continue;
				}
			}
			
			//If we need a monument to be in a zone, but none were inside one from the group, pick a new group
			if( UnusedZone != -1 ){
				if(!InZone){
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
		
		var BonusPots = (StartingRoom ? false : Prob(Chance_Decor_Monuments_BonusPots) || ForcePots ); //no pots in first entrance room
	
		var Style1 = choose(0, 1, 2);
		var Style2 = choose(0, 1, 2);
	
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
			TransformObj(Monument, xywhList);
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
			if(global.DungeonDepth == DungeonLevel.Castle || global.DungeonDepth == DungeonLevel.Aghanim1){
				if(Style == 0 && (Monument.y > 128 || collision_rectangle(MonumentTLCornerX, MonumentTLCornerY + 32, MonumentTLCornerX + 31, MonumentTLCornerY + 63, oWall, false, true)))
					Style = choose(1, 2);
			}
			
			var TileX = 116 + (Style * 4);
			
			//half the time draw the monument mirrored, some of them aren't symetrical so it gives variety
			DrawTileBlock(GetFloorLevelTMID("Tiles_Walls", MonumentTLCornerX, MonumentTLCornerY), MonumentTLCornerX, MonumentTLCornerY, TileX, LevelTilesY, 4, 4, FlipCoin_Bool());
				
			var WallInst = WallObj_Create("Objs_" + FloorLevelStr, MonumentTLCornerX, MonumentTLCornerY, 4, 4);
			//WallInst.BlockProjectiles = false; 
			
			var MonumentInSection = InSectionArea(MonumentTLCornerX, MonumentTLCornerY, global.RoomTemplate, global.SectionID, true);
			
			AddUsedSpace(MonumentTLCornerX, MonumentTLCornerY, 32, 32, MonumentInSection, false);
			
			
			//Add Main Object first
			
			if(Obj != noone && !MainObjAdded){
				
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
						var Items = (global.Switch_Add == SwitchAction.RevealTreasure ? 1 : choose(1,2));
						SpawnTreasureRow(ItemsX + (Items == 1 ? 8 : 0), ItemsY, InSection, true, Obj, Items);	
					}
					
					MainObjMonumentIndex = MonumentIndex;
					MainObjAdded = true;
					continue;
				}
				
			}
			
			
			if(BonusPots && Monument[$ "ObjAllowed"]){
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
		
		if(UnusedZone != -1) global.UnusedZoneIndex = -1;
		
	}
	
	ds_list_destroy(MonumentIndexList);
	
	return GroupOk;
	
}


function SpawnBlocks(_Obj){
	
	var BlockGroupArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Blocks"];
	var BlockGroups = array_length(BlockGroupArray);
	
	if(BlockGroups == 0) return false;
	
	var BlockGroupIndex = 0;//irandom(BlockGroups - 1);
	
	var BlockGroup = BlockGroupArray[BlockGroupIndex];
	
	var BlockGroupX = Room.x + BlockGroup.x;
	var BlockGroupY = Room.y + BlockGroup.y;
	
	var BlockGroupW = BlockGroup.width / 16;
	var BlockGroupH = BlockGroup.height / 16;

	var FloorLevel = GetFloorLevelID(BlockGroupX, BlockGroupY);
	var FloorLevelStr = GetFloorLevelString(BlockGroupX, BlockGroupY);
	
	var UsePattern = (BlockGroupW >= 3 && BlockGroupH >= 3);
	
	if(UsePattern){
		var PatternSize = global.BlockPatternSizeID[BlockGroupW][BlockGroupH];
		var Patterns = array_length(global.BlockPatterns[PatternSize]);
		var Pattern = 0;//irandom(Patterns - 1);
		var PatternArray = global.BlockPatterns[PatternSize, Pattern];
	}
	
	
	for(var BlockY = 0; BlockY < BlockGroupH; BlockY++){
		for(var BlockX = 0; BlockX < BlockGroupW; BlockX++){
			
			var PatternSymbol = UsePattern ? string_char_at(PatternArray[BlockY], BlockX + 1) : "0";
			
			var BlockPosX = BlockGroupX + (BlockX * 16);
			var BlockPosY = BlockGroupY + (BlockY * 16);
			
			var _SpawnBlock = false;
			var _SpawnCrystal = false;
			var _SpawnSwitch = false;
			var _SpawnTreasure = false;
			var _SpawnGuru = false;
			
			switch(PatternSymbol){
				
				case "S":
					if(_Obj == BlockObj.Switch)
						_SpawnSwitch = true;
					else
						_SpawnBlock = true;
					break;
					
				//case "C":
				//	if(_Obj == BlockObj.Crystal){
				//		_SpawnCrystal = true;
				//	}else{
				//		_SpawnBlock = true;
				//	}				
				//	break;
					
				//case "c":
				//	if(_Obj == BlockObj.Crystal){
				//		_SpawnCrystal = true;
				//	}else if(_SpawnTreasure){
					
				//	}
				//	break;
					
				//case "g":
				//	if(global.SpecialObj == SpecialDungeonObj.Crystal){
				//		_SpawnCrystal = true;
				//	}else if(_SpawnGuru){
						
				//	}else{
				//		_SpawnBlock = true;	
				//	}

				//	break;
				
				case "0": 
					_SpawnBlock = true;
					break;
					
				//case "G":
				//	if(_SpawnGuru){
						
				//	}else{
				//		_SpawnBlock = true;
				//	}
				//	break;
					
				//case "T":
				//	if(_SpawnTreasure){
						
				//	}else{
				//		_SpawnBlock = true;
				//	}
				//	break;

				
				//case "t":
				//	if(_SpawnTreasure){
						
				//	}
				//	break;
			}
			
			if(_SpawnBlock){
				//var SpikeBlockInst = instance_create_layer(BlockPosX, BlockPosY, "Objs_" + FloorLevelStr, oSpikeBlock);
				DrawTileBlock(FloorLevel == UPPER ? global.TMID_Tiles_Walls_Upper : global.TMID_Tiles_Walls_Lower, BlockPosX, BlockPosY, 1, 0, 2, 2);
				WallObj_Create("Objs_" + FloorLevelStr, BlockPosX, BlockPosY, 2, 2);
				AddUsedSpace(BlockPosX, BlockPosY, 16, 16, false, false);				
			}
			if(_SpawnCrystal){
				Crystal_Create(BlockPosX, BlockPosY);
			}
			if(_SpawnSwitch){
				global.Switch_Inst = instance_create_layer(BlockPosX, BlockPosY, "Objs_" + FloorLevelStr, oPushBlock, {Action : global.Switch_Add});
				AddUsedSpace(BlockPosX, BlockPosY, 16, 16, false, false);	
			}
		}
	}

	return true;
	
}


function SpawnPots(InSection, Obj){
	
	var PotsArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Pots"];
	
	var PotsInTemplate = array_length(PotsArray);	
	if(PotsInTemplate == 0) return false;
	
	var ObjPotSpawned = false;
	var Success = false;

	for(var ListIndex = 0; ListIndex < irandom_range(1, PotsInTemplate); ListIndex++){
	
		if(Obj != noone && !ObjPotSpawned){
			var SpawnedPot = SpawnObj(SpecialObj.Pot, InSection, -1, Obj);
			if(SpawnedPot) ObjPotSpawned = true;
		}else{
			var _Item = PickPotItem(false, false);
			var SpawnedPot = SpawnObj(SpecialObj.Pot, InSection, -1, _Item);			
		}
		if(!Success && SpawnedPot) Success = true;		
	}
	
	return Success;
	
}


function SpawnTorches(){
	
	var PotsArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Pots"];
	
	var PotsInTemplate = array_length(PotsArray);	
	if(PotsInTemplate == 0) return false;
	
	var Success = false;
	
	var MinPots = global.Switch_Add != SwitchAction.None ? min(PotsInTemplate, 3) : 1;
	var Pots = irandom_range(MinPots, 4);
	
	for(var ListIndex = 0; ListIndex < Pots; ListIndex++){

		var SpawnedTorch = SpawnObj(SpecialObj.Torch, false, -1, noone);			

		if(!Success && SpawnedTorch) Success = true;		
	}
	
	return Success;
	
}


function SpawnAltar(InSection, UnusedZone, TreasureContents){
	
	if(global.DungeonDepth == DungeonLevel.Sewers) return false;

	if(!PlatformVerify(InSection, UnusedZone)) return false;
		
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
	ClearTileBlock(global.TMID_Tiles_Water_Upper, AltarX, AltarY, AltarTileW, AltarTileH);
	ClearTileBlock(global.TMID_Tiles_Water_Lower, AltarX, AltarY, AltarTileW, AltarTileH);
	
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
	
	if(UnusedZone != -1) global.UnusedZoneIndex = -1;
	
	return true;
	
}


function SpawnShop(InSection, UnusedZone){
	
	if(!PlatformVerify(InSection, UnusedZone)) return false;
	
	var _ShopX = global.AltarData.x;
	var _ShopY = global.AltarData.y;
	var _ShopW = global.AltarData.w;
	var _ShopH = 64;
	var _ShopTileW = _ShopW / 8;
	var _ShopTileH = _ShopH / 8;
		
	var FloorTMID = GetFloorLevelTMID("Tiles_Floor", _ShopX, _ShopY); 
	var _FloorLevelStr = GetFloorLevelString(_ShopX, _ShopY);

	//first clear any blood or bones that may have been drawn in floor draw function which would be on water layer above
	ClearTileBlock(global.TMID_Tiles_Water_Upper, _ShopX, _ShopY, _ShopTileW, _ShopTileH);
	ClearTileBlock(global.TMID_Tiles_Water_Lower, _ShopX, _ShopY, _ShopTileW, _ShopTileH);
	
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
	
	var ShopInst = instance_create_layer(_ShopX, _ShopY, "ObjsFloor_" + _FloorLevelStr, oShop, {RoomIndex : global.RoomIndex, ShopW : _ShopW, ShopH : _ShopH, TileW : _ShopTileW, TileH : _ShopTileH, Store : false, StoreType : ""});
	
	//add shop to large map items so we can draw the icon if Link has a compass
	ds_list_add(global.LargeMapItems, ShopInst); 
						
	//Create wall obj
	var WallInst = WallObj_Create("Objs_" + _FloorLevelStr, _ShopX + 8, _ShopY + 8, _ShopTileW - 2, _ShopTileH - 2);
	WallInst.ShopInst = ShopInst;
	WallInst.BlockProjectiles = false;
					
	if(UnusedZone != -1) global.UnusedZoneIndex = -1;
	
	return true;
	
}


function SpawnEnemies(){
	
	if(global.NoEnemies) exit;
	
	var EnemyAreaArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Enemies"];
	
	var EnemyAreasInTemplate = array_length(EnemyAreaArray);
	
	if(EnemyAreasInTemplate == 0) return false;
	
	var RoomArea = Room.GridW * Room.GridH; //larger rooms should have more enemies, so multiply amount by a factor of RoomArea
	var MinAmount = 1 + floor(global.DungeonDepth / 5) * RoomArea;
	var MaxAmount = 2 + floor(global.DungeonDepth / 3) * RoomArea;
	var Amount = irandom_range(MinAmount, MaxAmount);
	
	var KyameronPicked = false; //only allow 1 Kyameron per room
	
	var EnemyChoicesList = ds_list_create();
	repeat(irandom_range(1, 3)){
		ds_list_add(EnemyChoicesList, PickEnemy(global.EnemyHasKey));
	}
	
	//Try random positions until enemy is at a safe distance	
	var Spawned = false;
	for(var i = 0; i < Amount; i++){
		for(var Tries = 0; Tries < 50; Tries++){
		
			var EnemyArea = EnemyAreaArray[irandom(EnemyAreasInTemplate - 1)];
			var EnemyAreaX = Room.x + EnemyArea.x;
			var EnemyAreaY = Room.y + EnemyArea.y;

			var _FloorLevel = GetFloorLevelID(EnemyAreaX, EnemyAreaY);
			var EnemyIndex = EnemyChoicesList[| irandom(ds_list_size(EnemyChoicesList) - 1)];
			if(EnemyIndex == undefined) continue;
			
			var CheckForObjs = true;
			var MinDistFromWall = 8;
			var SafeDistance = 24;

			//***add min distance from doors, see notes***


			var EnemyX = EnemyAreaX + irandom(EnemyArea.width);
			var EnemyY = EnemyAreaY + irandom(EnemyArea.height);
					
			switch(EnemyIndex){

				case oEnemy_Beamos:
					//Possible Bug:
					//When beamos' walls are not alligned with the 8x8 grid using the following random floored coordinates,
					//it's easy for the move assist to get stuck. See if there's anything in the code that shows it
					//wouldn't work for walls not alligned with the grid.
					var EnemyX = EnemyAreaX + (floor(irandom(EnemyArea.width) / 8) * 8);
					var EnemyY = EnemyAreaY + (floor(irandom(EnemyArea.height) / 8) * 8);
					var MinDistFromWall = 24;
					break;
				
				case oEnemy_Geldman:
					var MinDistFromWall = 24;
					break;

				case oEnemy_Keese:
					CheckForObjs = false;
					_FloorLevel = UPPERLOWER;					
					break;
					
				case oEnemy_Poe:
					var EnemyX = Room.x + 128;
					var EnemyY = Room.y + 64;
					CheckForObjs = false;
					_FloorLevel = UPPERLOWER;
					
					break;

				case oEnemy_Wizzrobe:
					SafeDistance = 48;				
					break;
				
				case oEnemy_Kyameron_Emitter:
					if(KyameronPicked) continue;
					if(!OnWaterTile(_FloorLevel == UPPER ? global.TMID_Tiles_Water_Upper : global.TMID_Tiles_Water_Lower, EnemyX, EnemyY)) continue;
					KyameronPicked = true;
					break;
				case oEnemy_Hover:					
					if(!OnWaterTile(_FloorLevel == UPPER ? global.TMID_Tiles_Water_Upper : global.TMID_Tiles_Water_Lower, EnemyX, EnemyY)) continue;
					break;
				
				case oEnemy_Zol:
					
					break;
					
			}			

			if(CheckForObjs){
				if(!SafeDistancePoint(EnemyX, EnemyY, false, SafeDistance, true)) continue;
			}

			var _ItemHolding = noone;
			
			if(global.EnemyHasKey) _ItemHolding = oItem_Key
			
			if(_ItemHolding == noone && Enemy_SafeToHoldBonusItem(EnemyIndex)){
				if(Prob(Chance_EnemyBonusItem)) _ItemHolding = PickPotItem(true, false);				
			}
			
			
			var EnemyInst = instance_create_layer(EnemyX, EnemyY, "Objs_Upper", EnemyIndex, {FloorLevel : _FloorLevel, 
																							 ItemHolding : _ItemHolding, 
																							 RoomTemplate: global.RoomTemplate,
																							 RoomX : Room.x,
																							 RoomY : Room.y});
			
			
			if(CheckForObjs){
				with(EnemyInst){
					var WallCollisionInst = ObjCollision(x, y, oWall);
					var DistToWall = distance_to_object(oWall); 
				}
				if(!InstInUsedSpaceArea(EnemyInst) && WallCollisionInst == noone && DistToWall >= MinDistFromWall){ 
					AddUsedSpace(EnemyX, EnemyY, EnemyInst.sprite_width, EnemyInst.sprite_height, false, true);
					Spawned = true;
					break;
				}else instance_destroy(EnemyInst);
			}else{
				Spawned = true;
				break;
			}
			
		}
		
		if(Spawned && global.EnemyHasKey && _ItemHolding == oItem_Key) global.EnemyHasKey = false;
		
	}

	ds_list_destroy(EnemyChoicesList);	
	

	return Spawned;
	
}


function SpawnObj(SpecialObjType, InSection, UnusedZone, ObjContents){	
	
	//SpecialObjType = enum SpecialObj.Pot, SpecialObj.Treasure, etc

	
	if(SpecialObjType == SpecialObj.HeartGuy || SpecialObjType == SpecialObj.DeadGuy)
		//use treasure containers for heart guy locations
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObj.Treasure];
	else if(SpecialObjType == SpecialObj.Torch)
		//use pot containers for torches
		var SpecialObjComboIDList = global.ListOfSpecialObjComboIDLists[| SpecialObj.Pot];
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
			
			var ZoneIndex = InZone(Obj, global.RoomTemplate, global.SectionID, false);
			if( (UnusedZone != -1 && ZoneIndex != UnusedZone) ) continue;
			
			var ObjUsed = CheckUsedObj(Obj);
			if(ObjUsed) continue;

			
			var ObjX1 = Room.x + Obj.x;
			var ObjY1 = Room.y + Obj.y;
			var ObjW = Obj.width;
			var ObjH = Obj.height;
	
	
			//Perform obj transformation (SBShifts, rotations, etc)
			var xywhList = ds_list_create();
			ds_list_add(xywhList, ObjX1, ObjY1, ObjW, ObjH);
			TransformObj(Obj, xywhList);
			ObjX1 = xywhList[| 0]; ObjY1 = xywhList[| 1];
			ObjW = xywhList[| 2]; ObjH = xywhList[| 3];
			ds_list_destroy(xywhList);
			
			
			var ObjX2 = ObjX1 + ObjW - 1;
			var ObjY2 = ObjY1 + ObjH - 1;
			
			var Dist = 24;
			var SafeDistBox = SafeDistanceBox(ObjX1, ObjY1, ObjX2, ObjY2, InSection, Dist, false);
			if(!SafeDistBox) continue;
			
			var CheckDoorsLeft = collision_rectangle(ObjX1 - 16, ObjY1, ObjX1, ObjY2, oDoor, false, true);
			var CheckDoorsRight = collision_rectangle(ObjX2, ObjY1, ObjX2 + 16, ObjY2, oDoor, false, true);
			var CheckDoorsUp = collision_rectangle(ObjX1, ObjY1 - 16, ObjX2, ObjY1, oDoor, false, true);
			var CheckDoorsDown = collision_rectangle(ObjX1, ObjY2, ObjX2, ObjY2 + 16, oDoor, false, true);
					
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
						if(global.Switch_Add == SwitchAction.RevealTreasure) MaxItems = 1; 
						
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
			
						if(SpecialObjType == SpecialObj.Pot || SpecialObjType == SpecialObj.Crystal)
							var Dist = 8;
						else
							var Dist = 56
						
						//(assuming all obj will be 16x16, this may change). 
						if(SafeDistanceBox(ObjX, ObjY, ObjX + 15, ObjY + 15, InSection, Dist, false)){ 
							
							var SpawnItem = true;
						}
					
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
						var ObjInst = Crystal_Create(ObjX, ObjY);						
						break;
					
					case SpecialObj.HeartGuy:
						instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oHeartGuy);	
						break;
						
					case SpecialObj.DeadGuy:
						if(ObjContents == noone && Prob(0.6)) ObjContents = PickRandomItem(ItemFrom.Treasure)
						instance_create_layer(ObjX + (ObjW / 2), ObjY + 16, "Objs_" + FloorLevelStr, oDeadGuy, {LootObjectIndex : ObjContents});	
						break;
					
					case SpecialObj.Torch:
						
						//if no switch is needed, and lighting in room is true, then some torches are lit
						var _Lit = false;
						if(global.Switch_Add == SwitchAction.None && Room.Lighting == 1.0){
							_Lit = Prob(0.25);
						}
						
						var inst = instance_create_layer(ObjX, ObjY, "Objs_" + FloorLevelStr, oTorch, {Lit: _Lit});
						inst.FloorLevel = FloorLevel;
						WallObj_Create("Objs_" + FloorLevelStr, ObjX, ObjY, 2, 2);
						if(global.Switch_Add != SwitchAction.None){
							inst.Action = global.Switch_Add;
							inst.TreasureInst = global.Switch_TreasureInst;
							inst.Switch = true;
						}
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
	
	if(Success && UnusedZone != -1) global.UnusedZoneIndex = -1;
	
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
		if(!SafeDistanceBox(X, Y, X + (Items * 16) - 1, Y + 15, InSection, 64, false)) return false;
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

function SpawnKinstone(InSection, UnusedZone){
	

	var KinstoneArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Kinstones"];
	var Kinstones = array_length(KinstoneArray);
	
	if(Kinstones == 0) return false;
	
	//make a list of all monument indexes (0-n), then shuffle that list so we can pick them at random
	var KinstoneIndexList = ds_list_create();
	for(var KinstoneIndex = 0; KinstoneIndex < Kinstones; KinstoneIndex++){
		ds_list_add(KinstoneIndexList, KinstoneIndex);
	}
	ds_list_shuffle(KinstoneIndexList);
	

	var InZone = false;
	
	
	for(var KinstoneIndex = 0; KinstoneIndex < ds_list_size(KinstoneIndexList); KinstoneIndex++){
		
		var KinstoneOK = true;
		
		var Kinstone = KinstoneArray[KinstoneIndexList[| KinstoneIndex]];
		
		var KinstoneX = Room.x + Kinstone.x;
		var KinstoneY = Room.y + Kinstone.y;

		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);
		
		if(UnusedZone != -1 && !InZone){
			var ZoneIndex = InZone(Kinstone, global.RoomTemplate, global.SectionID, false);
			if( ZoneIndex != UnusedZone) KinstoneOK = false;
		}

		
		//Check for walls above and below the kinstone. There should be enough space at the bottom to put the treasure and for Link above it
		if(collision_rectangle(KinstoneX, KinstoneY - 24, KinstoneX + 23, KinstoneY + 32 + 31, oWall, false, true)) KinstoneOK = false;

		//Check for doors
		//Top
		if(collision_rectangle(KinstoneX, KinstoneY - 32, KinstoneX + 31, KinstoneY, oDoor, false, true)) KinstoneOK = false; 
		//Bottom
		if(collision_rectangle(KinstoneX, KinstoneY + 32, KinstoneX + 31, KinstoneY + 32 + 31, oDoor, false, true)) KinstoneOK = false; 
		//Left
		if(collision_rectangle(KinstoneX - 32, KinstoneY, KinstoneX, KinstoneY + 31, oDoor, false, true)) KinstoneOK = false; 
		//Right
		if(collision_rectangle(KinstoneX + 32, KinstoneY, KinstoneX + 32 + 31, KinstoneY + 31, oDoor, false, true)) KinstoneOK = false;
			
		var KinstoneInSection = InSectionArea(KinstoneX, KinstoneY, global.RoomTemplate, global.SectionID, true);

		if(!SafeDistanceBox(KinstoneX, KinstoneY, KinstoneX + 31, KinstoneY + 31, KinstoneInSection, 64, false)) KinstoneOK = false;

		if(KinstoneOK) break;
		
	}
		

	if(KinstoneOK){
					
		//Apply transformations if any
		var xywhList = ds_list_create();
		ds_list_add(xywhList, KinstoneX, KinstoneY, 32, 32);
		TransformObj(Kinstone, xywhList);
		KinstoneX = xywhList[| 0]; KinstoneY = xywhList[| 1];
		ds_list_destroy(xywhList);
		
		var FloorLevelStr = GetFloorLevelString(KinstoneX, KinstoneY);
		
		DrawTileBlock(GetFloorLevelTMID("Tiles_Walls", KinstoneX, KinstoneY), KinstoneX, KinstoneY, 36, 0, 4, 4);							
				
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX, KinstoneY, 1, 4);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY + 8, 2, 3);
		WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 24, KinstoneY, 1, 4);
		var WallInst = WallObj_Create("Objs_" + FloorLevelStr, KinstoneX + 8, KinstoneY, 2, 1);
		WallInst.BlockLink = false;
				
		var KinstoneInSection = InSectionArea(KinstoneX, KinstoneY, global.RoomTemplate, global.SectionID, true);
			
		AddUsedSpace(KinstoneX, KinstoneY, 32, 32, KinstoneInSection, false);
		
		var inst = instance_create_layer(KinstoneX + 16, KinstoneY + 14, "ObjsHigher_" + FloorLevelStr, oItem_Kinstone_Main);
		inst.RoomIndex = global.RoomIndex;
		//add kinstone to large map items so we can draw the icon if Link has a compass
		ds_list_add(global.LargeMapItems, inst); 
		
		if(UnusedZone != -1) global.UnusedZoneIndex = -1;
		
	}
	
	ds_list_destroy(KinstoneIndexList);
	
	return KinstoneOK;
	
}
	
function SpawnJail(UnusedZoneIndex){
	
	var JailArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Jails"];
	var Jails = array_length(JailArray);
	
	if(Jails == 0) return false;
	
	//make a list of all jail indexes (0-n), then shuffle that list so we can pick them at random
	var JailIndexList = ds_list_create();
	for(var JailIndex = 0; JailIndex < Jails; JailIndex++){
		ds_list_add(JailIndexList, JailIndex);
	}
	ds_list_shuffle(JailIndexList);

	for(var JailIndex = 0; JailIndex < ds_list_size(JailIndexList); JailIndex++){
		
		var JailOK = true;
		
		var Jail = JailArray[JailIndexList[| JailIndex]];
		
		var JailX = Room.x + Jail.x;
		var JailY = Room.y + Jail.y;
		var JailTileW = Jail.width / 8;
		var JailTileH = Jail.height / 8;
		var InSection = InSectionArea(JailX + (Jail.width / 2), JailY + (Jail.height / 2), global.RoomTemplate, global.SectionID, true);
		
		if(UnusedZoneIndex != -1){
			var ZoneIndex = InZone(Jail, global.RoomTemplate, global.SectionID, false);
			if( ZoneIndex != UnusedZoneIndex) JailOK = false;
		}

		//Check for doors
		if(collision_rectangle(JailX, JailY, JailX + Jail.width - 1, JailY + Jail.height - 1, oDoor, false, true)) JailOK = false; 

		if(JailOK) break;
		
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
		
		DrawTileBlock(global.TMID_Tiles_Higher, JailX, JailY, 56, 0, 1, 1); //TL
		//top beam
		for(var i = 0; i < JailTileW - 2; i++){
			DrawTileBlock(global.TMID_Tiles_Higher, JailX + 8 + (i * 8), JailY, 57, 0, 1, 1);
		}
		DrawTileBlock(global.TMID_Tiles_Higher, JailX + ((JailTileW - 1) * 8), JailY, 61, 0, 1, 1); //TR
		
		if(DoorCount == 0){ //***also add a check to make sure the top of the jail is either 7,8 or 9 tiles away from Room.y so that prisoner has just enough space, not too much, not too little
			
			//top vertical bars
			for(var i = 0; i < JailTileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 8, 57, 1, 1, 1);
			}				

			//top horizontal bars
			DrawTileBlock(global.TMID_Tiles_Higher, JailX + 8, JailY + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), JailY + 16, 61, 2, 1, 1);
			for(var i = 0; i < JailTileW - 4; i++){ //left side
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 16, 57, 2, 1, 1);
			}

			//bottom bars
			for(var i = 0; i < JailTileW - 4; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 24, 57, 3, 1, 1);
			}
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX - 8, JailY + 16, 58, 2, 1, 1);
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX - 8, JailY + 24, 58, 3, 1, 1);
			
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
			var inst = instance_create_layer(JailX + 40 + (irandom(JailTileW - 10) * 8), JailY + 8, "Objs_" + FloorLevelStr, oPrisoner);			
			WallInst.PrisonerInst = inst;
			
		}else{
		
		
			//top vertical bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 8, 57, 1, 1, 1);
			}		
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + (TilesW_LeftSide * 8) + 8 + (i * 8), JailY + 8, 60, 1, 1, 1);
			}

			//top horizontal bars
			DrawTileBlock(global.TMID_Tiles_Higher, JailX + 8, JailY + 16, 56, 2, 1, 1);
			DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + ((TilesW_RightSide - 2) * 8), JailY + 16, 61, 2, 1, 1);
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //left side
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 16, 57, 2, 1, 1);
			}
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //right side
				DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + 8 + (i * 8), JailY + 16, 59, 2, 1, 1);
			}
		
			//bottom bars
			for(var i = 0; i < TilesW_LeftSide - 3; i++){ //top left
				DrawTileBlock(global.TMID_Tiles_Higher, JailX + 16 + (i * 8), JailY + 24, 57, 3, 1, 1);
			}			
			for(var i = 0; i < TilesW_RightSide - 3; i++){ //top right
				DrawTileBlock(global.TMID_Tiles_Higher, RightSideX + 8 + (i * 8), JailY + 24, 59, 3, 1, 1);
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
				KeyBlockInst.RoomIndex = global.RoomIndex;
				//add key block to map items list. Any locked door above was already removed from that list
				ds_list_add(global.LargeMapItems, KeyBlockInst);
			
			}
			ds_list_destroy(DoorList);
		
		}
					
		AddUsedSpace(JailX, JailY, Jail.width, Jail.height, InSection, false);
		//add used space in front of jail entrance.
		AddUsedSpace(RightSideX - 8, JailY + Jail.height, 16, 8, InSection, false);
		
		if(UnusedZoneIndex != -1) global.UnusedZoneIndex = -1;
		
	}
	
	ds_list_destroy(JailIndexList);
	
	return JailOK;
	
}

function SpawnRollingSpikes(){

	switch(global.DungeonDepth){
		case DungeonLevel.Castle:	
		case DungeonLevel.CastleBasement:	
		case DungeonLevel.CastleJails:
		case DungeonLevel.Sewers:
		case DungeonLevel.Catacombs:
		case DungeonLevel.Village:
			exit;
	}
	
	var RollingSpikeArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "RollingSpikes"];

	var RollingSpikesInTemplate = array_length(RollingSpikeArray);
	
	if(RollingSpikesInTemplate == 0) return false;
	
	for(var RollingSpikeIndex = 0; RollingSpikeIndex < RollingSpikesInTemplate; RollingSpikeIndex++){
		
		var RollingSpike = RollingSpikeArray[RollingSpikeIndex];
			
		var RollingSpikeX = Room.x + RollingSpike.x;
		var RollingSpikeY = Room.y + RollingSpike.y;

		var FloorLevelStr = GetFloorLevelString(RollingSpikeX, RollingSpikeY);
		var _FloorLevel = GetFloorLevelID(RollingSpikeX, RollingSpikeY);
		var RollingSpikeInst = instance_create_layer(RollingSpikeX, RollingSpikeY, "Objs_" + FloorLevelStr, oEnemy_RollingSpike, {FloorLevel : _FloorLevel});
		
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
			
}

function SpawnGuruBars(){
	
	switch(global.DungeonDepth){
		case DungeonLevel.Castle:	
		case DungeonLevel.CastleBasement:	
		case DungeonLevel.CastleJails:
		case DungeonLevel.Sewers:
		case DungeonLevel.Village:
			exit;
	}
	
	var GuruBarArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "GuruBars"];

	var GuruBarsInTemplate = array_length(GuruBarArray);
	
	if(GuruBarsInTemplate == 0) exit;
	
	for(var GuruBarIndex = 0; GuruBarIndex < GuruBarsInTemplate; GuruBarIndex++){
		
		var GuruBar = GuruBarArray[GuruBarIndex];
			
		var GuruBarX = Room.x + GuruBar.x + 56;
		var GuruBarY = Room.y + GuruBar.y;

		var FloorLevelStr = GetFloorLevelString(GuruBarX, GuruBarY);
		
		var GuruBarInst = instance_create_layer(GuruBarX, GuruBarY, "Objs_" + FloorLevelStr, oEnemy_Guru_Bar);		
				
		if(!InstInUsedSpaceArea(GuruBarInst) && ObjCollision(x, y, oWall) == noone && SafeDistancePoint(GuruBarX + 8, GuruBarY + 8, false, 32, false)){ 
			AddUsedSpace(GuruBarX - 16, GuruBarY - 16, 48, 48, false, true);
		}else instance_destroy(GuruBarInst);
				
	}
			
}

function CheckUsedObj(_Obj){
	
	//check if _Obj was used already
	for(var ObjIndex = 0; ObjIndex < ds_list_size(global.UsedObjs); ObjIndex++){
		if(global.UsedObjs[| ObjIndex] == _Obj) return true;
	}
	
	return false
	
}

function PlatformVerify(InSection, UnusedZone){
	
	//Altars are now part of the Platform family. Platforms can be altars, floor shops, etc.
	//Code below still says Altar for everything, but think of the following as Platforms
	//Check all altars in template and set dimensions into global.AltarData if valid

	var AltarsArray = global.Data_RoomTemplates[global.RoomTemplate][$ "Sections"][global.SectionID][$ "Altars"];
	
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
		TransformObj(Altar, xywhList);
		AltarX1 = xywhList[| 0]; AltarY1 = xywhList[| 1];
		AltarW = xywhList[| 2]; AltarH = xywhList[| 3];
		ds_list_destroy(xywhList);
			
			
		var AltarX2 = AltarX1 + AltarW - 1;
		var AltarY2 = AltarY1 + AltarH - 1;
		
		var AltarInSection = InSectionArea(AltarX1, AltarY1, global.RoomTemplate, global.SectionID, true);
		if( (!InSection && AltarInSection) || (InSection && !AltarInSection) ) continue;

		var ZoneIndex = InZone(Altar, global.RoomTemplate, global.SectionID, false);
		if( (UnusedZone != -1 && ZoneIndex != UnusedZone) ) continue;
		
		var Option_StickLeft = true;
		var Option_StickRight = true;
		
		var DoorCollisionList = ds_list_create();
		var Collisions = collision_rectangle_list(AltarX1 - 24, AltarY1, AltarX2 + 24, AltarY2, oDoor, false, true, DoorCollisionList, false);
		
		//Check Left and Right side doors first, shift the altar if collisions
		for(var DoorIndex = 0; DoorIndex < Collisions; DoorIndex++){
				
			var DoorInst = DoorCollisionList[| DoorIndex];
			
			//We need to check the section of the doors, because if door is in opposite section from altar, no need to worry about collision
			var DoorInSection = InSectionArea(DoorInst.x, DoorInst.y, global.RoomTemplate, global.SectionID, true);
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
				var DoorInSection = InSectionArea(DoorInst.x, DoorInst.y, global.RoomTemplate, global.SectionID, true);
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

	
	variable_struct_set(global.AltarData, "x", AltarX);
	variable_struct_set(global.AltarData, "y", AltarY);
	variable_struct_set(global.AltarData, "w", AltarW);
	variable_struct_set(global.AltarData, "h", AltarH);
	variable_struct_set(global.AltarData, "StickL", Option_StickLeft);
	variable_struct_set(global.AltarData, "StickR", Option_StickRight);
	
	AddUsedSpace(AltarX, AltarY, AltarW, AltarH + 24, InSection, false);
	
	return true;
	
}

function AddUsedSpace(_x, _y, _w, _h, _InSection, _Enemy){
	

	var UsedSpace = {};
	variable_struct_set(UsedSpace, "x", _x);
	variable_struct_set(UsedSpace, "y", _y);
	variable_struct_set(UsedSpace, "w", _w);
	variable_struct_set(UsedSpace, "h", _h);
	variable_struct_set(UsedSpace, "InSection", _InSection);
	variable_struct_set(UsedSpace, "Enemy", _Enemy);
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

function InSectionArea(_x, _y, _TemplateIndex, _SectionID, _RelativeToRoom){
	
	//returns true if point is within a section area
	//_Template: boolean if checking template coordinates or actual dungeon room
	var SectionAreas = array_length(global.Data_RoomTemplates[_TemplateIndex][$ "Sections"][_SectionID][$ "SectionArea"]);
	for(var SectionAreaIndex = 0; SectionAreaIndex < SectionAreas; SectionAreaIndex++){

		var SectionObj = global.Data_RoomTemplates[_TemplateIndex][$ "Sections"][_SectionID][$ "SectionArea"][SectionAreaIndex];
		
		var SectionX = (_RelativeToRoom ? Room.x : 0) + SectionObj.x;
		var SectionY = (_RelativeToRoom ? Room.y : 0) + SectionObj.y;
		if(point_in_rectangle(_x, _y, SectionX, SectionY, SectionX + SectionObj.width - 1, SectionY + SectionObj.height - 1)) return true;
				
	}
	
	return false;
			
	
}

function InZone(Obj, _TemplateIndex, _SectionID, _RelativeToRoom){
	
	//returns Zone index if obj is within or overlapping a zone, otherwise returns -1
	
	var Zones = array_length(global.Data_RoomTemplates[_TemplateIndex][$ "Sections"][_SectionID][$ "Zones"]);
	for(var ZoneIndex = 0; ZoneIndex < Zones; ZoneIndex++){

		var ZoneObj = global.Data_RoomTemplates[_TemplateIndex][$ "Sections"][_SectionID][$ "Zones"][ZoneIndex];
		
		var ZoneX = (_RelativeToRoom ? Room.x : 0) + ZoneObj.x;
		var ZoneY = (_RelativeToRoom ? Room.y : 0) + ZoneObj.y;
		if(rectangle_in_rectangle(Obj.x, Obj.y, Obj.x + Obj.width - 1, Obj.y + Obj.height - 1, ZoneX, ZoneY, ZoneX + ZoneObj.width - 1, ZoneY + ZoneObj.height - 1) > 0) return ZoneIndex;
				
	}
	
	return -1;
	
}

function TransformObj(Obj, xywhList){
	
	//Apply SBShift/SBResize codes and rotations if they apply using the x/y/w/h in the passed list.
	//Some objects need to be shifted or resized if in the room template they are against a rail, but that rail becomes a Switchbox.
	//You can't pass a variable by reference, which is why we store all 4 values in a list and pass that to this function
	
	var _x = xywhList[| 0];
	var _y = xywhList[| 1];
	var _w = xywhList[| 2];
	var _h = xywhList[| 3];
					
	if(Room[$ "Section_WallType"] == SectionWallType.SwitchBlock){
		
		var Properties = Obj[$ "properties"];			
		var RoomTransform = global.Data_RoomTemplates[global.RoomTemplate][$ "RoomTransformation"];
		
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


