// Feather disable GM2064


function Treasure_Create(_RoomIndex, _x, _y, Contents, AddWall, Floor = true, _InSection = false, _From = ItemFrom.Treasure, _ContentsFrom = ItemFrom.Treasure){
	
	var FloorLevelStr = GetFloorLevelString(_x, _y);
	var FloorLevelID = GetFloorLevelID(FloorLevelStr);
	var Layer;
	if(Floor) Layer = "ObjsFloor_" + FloorLevelStr;
	else Layer = "Objs_" + FloorLevelStr;
	var TreasureInst = instance_create_layer(_x + 8, _y + 16, Layer , oItem_Treasure, {From : _From, ContentsFrom : _ContentsFrom});
	
	TreasureInst.ContentsObj = Contents;
	TreasureInst.FloorLevel = FloorLevelID;
	TreasureInst.InSection = _InSection;
	TreasureInst.RoomIndex = _RoomIndex;
	
	Treasure_SetSpriteIndex(TreasureInst);
	
	if(AddWall){
		//most treasures will require walls, the ones at the shops don't since they interfere with the shop's wall collision when trying to buy item
		TreasureInst.WallInst = WallObj_Create(Layer, _x, _y, 2, 2);
		TreasureInst.WallInst.FloorLevel = FloorLevelID;
		TreasureInst.WallInst.BlockProjectiles = false;
		TreasureInst.WallInst.BlockItems = false;
	}

	if(global.Switch_Add){
		Room.Switch.HiddenObjInst = TreasureInst;
		TreasureInst.visible = false;
		TreasureInst.IsSwitchTreasure = true;
		if(AddWall){
			TreasureInst.WallInst.BlockLink = false;
			TreasureInst.WallInst.BlockProjectiles = false;
			TreasureInst.WallInst.BlockEnemies = false;
			TreasureInst.WallInst.IsHiddenObj = true;
		}
	}
	
	return TreasureInst
	
}

function Treasure_Open(Inst){
	
	var _DoCurse;
	switch(global.ChallengeOptions[ChallengeOption.Curses]){
		default: //0 and 1
			_DoCurse = Prob(Chance_Curse) && !FromAnyKinstone(Inst.ContentsFrom) && global.Level.Index != DungeonLevel.Castle && global.Level.Index != DungeonLevel.Village && global.Level.Index != DungeonLevel.Mines;
			break;
		
		case 2: 
			_DoCurse = Prob(Chance_Curse) && !FromAnyKinstone(Inst.ContentsFrom);
			break;
		
		case 3:
			_DoCurse = Prob(Chance_Curse);
			break;			
	}

	
	if(!global.Cursed && Inst.ContentsObj == RandomItem && _DoCurse){
		
		var CursedInst = instance_create_layer(Inst.x, Inst.y - 12, "ObjsHighest", oCursed);
		
		if(FromAnyStore(Inst.From)) CursedInst.depth = Inst.depth - 10; //otherwise when link is holding treasure from shop, curse animation is behind treasure		
		
	}else{
		
		if(Inst.ContentsObj == RandomItem){
			
			
			Inst.ContentsObj = Probs_RandomItemClass(Inst.ContentsFrom);
			
			
			if(global.Swordless){
				
				if(Inst.ContentsObj != ItemClass.Bow){
				
					if(Item_Allowed(ItemClass.Bow)){
					
						//give more chance that a bow is generated if swordless
						if(Prob(Chance_SpawnTreasureBowSwordless)) Inst.ContentsObj = ItemClass.Bow;					
					}
				}
				
			}else{
			
				if(Inst.ContentsObj != ItemClass.Sword){ 
				
					if(global.Inventory.ItemData[ItemClass.Sword].Index == 0 && global.Level.Index > DungeonLevel.Castle && !FromAnyKinstone(Inst.From)){
					
						if(Item_Allowed(ItemClass.Sword)){
					
							//give more chance that a sword is generated the further you go downwith with only a level 0 sword
							if(Prob(Chance_SpawnTreasureSword)) Inst.ContentsObj = ItemClass.Sword;
						
						}
					}

				} 
				
			}

			//extra prob in case you're cursed and shops can't sell to you, it can be tricky to find a heart container
			if(Curse_Check(CurseEffects.ShopsNoSell)){
				if(Inst.ContentsObj != ItemClass.HeartPiece){
					if(global.CurseTaskItem == ItemClass.HeartPiece){
						if(Item_Allowed(ItemClass.HeartPiece)){
							if(Prob(Chance_CurseExtraChance_TreasureHeartPiece)) Inst.ContentsObj = ItemClass.HeartPiece;
						}
					}
				}
			}
			
			if(Curse_Check(CurseEffects.HealthNoValue)){ 
				if(Inst.ContentsObj == ItemClass.HeartPiece){
					if(global.CurseTask == CurseTasks.Treasures && global.CurseTaskCount == 1){
						global.CurseTreasure_HeartPiece = true; //see curse script for explanation
					}
				}
			}
			
			if(Curse_Check(CurseEffects.RupeesNoValue)){ 
				if(Inst.ContentsObj == ItemClass.Rupee){
					if(global.CurseTask == CurseTasks.Treasures && global.CurseTaskCount == 1){
						global.CurseTreasure_Rupees = true; //see curse script for explanation
					}
				}
			}
			
		}
		
		
		
		var _Item = ItemSpawn(Inst.ContentsObj, Inst.x, Inst.y - 6, Inst.ContentsFrom, ItemSpawnType.Float, UPPER);
		if(_Item != noone){
			_Item.depth = 0;	
			audio_play_sound(Sound_ChestOpen, 1, false);
		}else{
			audio_play_sound(Sound_Arrow_Hit, 1, false);
			MsgBox("Nothing inside");
		}		
		
	}
	
	
	Inst.image_index = 1;
		
	global.StatsToAdd[Stat.Treasures]++;
	
}

function TreasureLarge_Open(Inst){

	var _Item = ItemSpawn(Inst.ContentsObj == RandomItem ? Probs_RandomItemClass(ItemFrom.LargeTreasure) : Inst.ContentsObj, Inst.x + 16, Inst.y + 6, ItemFrom.LargeTreasure, ItemSpawnType.Float, UPPER);

	if(_Item != noone){
		audio_play_sound(Sound_ChestOpen, 1, false);
	}else{
		audio_play_sound(Sound_Arrow_Hit, 1, false);
		MsgBox("Nothing inside");
	}	

	Inst.image_index = 1;
	
	global.StatsToAdd[Stat.Treasures]++;
	
}

function Treasure_SetSpriteIndex(Inst){
	
	if(Inst.ContentsObj == ItemClass.Key){
		Inst.sprite_index = (global.Xmas ? sItem_Treasure_XmasKey : sItem_Treasure_Key);
	}else{
		Inst.sprite_index = (global.Xmas ? choose(sItem_Treasure_Xmas1, sItem_Treasure_Xmas2) : sItem_Treasure);
	}
	
}