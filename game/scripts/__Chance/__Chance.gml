
//#macro Chance_SpawnPots 1
//#macro Chance_PotHasItem 1
//#macro Chance_PotIsSingle 0
//#macro Chance_PotAllowAnotherGroup 1
//#macro Chance_PotFillWithSimpleItems 0

#macro Chance_SpawnPots 0.25
#macro Chance_PotHasItem 0.22
#macro Chance_PotIsSingle 0.88
#macro Chance_PotAllowAnotherGroup 0.16
#macro Chance_PotFillWithSimpleItems 0.24

#macro Chance_SpawnWallEnemies 0.24
#macro Chance_EnemyBonusItem (0.22 - (global.ChallengeOptions[ChallengeOption.Enemies] * 0.02))
#macro Chance_EnemyItemExplosion 0.33

#macro Chance_SpawnRollingSpikes 0.3
#macro Chance_SpawnGuruBars 0.45
#macro Chance_SpawnMovingSpikeBlocks 0.35

#macro Chance_SpawnJail 0.8

#macro Chance_SpawnTorches 0.45
#macro Chance_Torches_Lit 0.45

#macro Chance_LooseKey 0.45

#macro Chance_BonusTreasure 0.72
#macro Chance_HeartGuy 0.04 //(if bonus treasure, prob of that treasure being a HeartGuy)
#macro Chance_DeadGuy 0.12	//(if bonus treasure, prob of that treasure being a DeadGuy)
#macro Chance_DeadGuyIsHungryGuy 0.5
#macro Chance_DeadGuyBonusItem 0.75 

#macro Chance_CurseLevelIncrease (global.Level.Index * 0.005)
#macro Chance_Curse ( (0.04 + Chance_CurseLevelIncrease) * ChallengeMax_Curses)
#macro Chance_Curse_DeadGuy (Chance_Curse + 0.15)

#macro Chance_SpecialRoomFairyOrGemPond 0.60
#macro Chance_FairyRoom 0.5   //if room is fairyorGem, prob that it's Fairy. Gem pond will be used if fairy isn't selected
#macro Chance_LargeFairy 0.7

#macro Chance_SecretDoor 0.65 //If special room isn't fairy or gempond, chance that it will use a secret door
#macro Chance_SecretDoorCrack 0.50 //If secret door, chance that it will be a visible crack
#macro Chance_TreasureRoomNonSecretDoor 0.5
#macro Chance_LargeTreasureRoomNonSecretDoor 0.45

#macro Chance_Decor_Carpets 0.8
#macro Chance_Decor_CarpetsFull 0.4 //if carpets are drawn, chance that it will be a full carpet instead of the path carpets

#macro Chance_Decor_Monuments 0.85
#macro Chance_Decor_Monuments_BonusPots 0.33
#macro Chance_Decor_Monuments_DeadguyTreasure 0.15

#macro Chance_Decor_CurtainOverDoor 0.2
#macro Chance_Decor_CurtainOverDoorSecret 0.75
#macro Chance_Decor_ReplaceMuralWithLight 0.4
#macro Chance_Decor_Lights_Lit 0.75

#macro Chance_SpawnKinstoneMonument 0.125
#macro Chance_SpawnRodCharger 0.4 //if kinstone spawned, chance it will instead be a rod charger
#macro Chance_SpawnRodChargerSpecial 0.25 //if spawning a special room with kinstones, chance that one of them will be a rod charger

#macro Chance_SpawnShopSword 0.04 //extra prob that sword will be spawned in shop
#macro Chance_SpawnTreasureSword (min(0.05 + ((global.Level.Index - 1) * 0.05), 0.28)) //extra prob that sword will be spawned from treasure if you have index 0 sword

#macro Chance_SpawnShopBowSwordless 0.12
#macro Chance_SpawnTreasureBowSwordless 0.04

#macro Chance_CurseExtraChance_TreasureHeartPiece 0.15 //extra prob if you're cursed and shops can't sell to you
#macro Chance_CurseExtraChance_Heart 0.12 //extra prob if you're cursed and you need to collect hearts, add extra chance

#macro Chance_LevelHasStar 0.8

#macro Chance_WaterInRoom (global.Level.Index == DungeonLevel.Aghanim1 ? 0.55 : 0.75)

#macro Chance_TMNT 0.18

#macro Chance_SpawnSpikes (0.5 + (global.Level.Index / 30))
#macro Chance_SpikeSection (0.4 + (global.Level.Index / 30))

#macro Chance_ObstacleTemplate (0.15 + (global.Level.Index / 38))
#macro Chance_SectionTemplate 0.2 //if Sections are <= 20, chance template will be one of the section templates. If section > 20, it will always be a section template

#macro Chance_ChickenEgg 0.1
#macro Chance_ChickenGoldenEgg 0.1 //if chicken has an egg, chance it will be a golden egg

function Lighting_GetRoomStatus(_RoomIndex){

	//if(DEBUG) return true
	
	if(!global.GlobalLighting) return false
	
	if(global.SaveLevel) return true
	
	if(global.ChallengeOptions[ChallengeOption.Darkness] >= ChallengeOption_Darkness.AllDark) return true
	
	if(global.Level.Index == DungeonLevel.Village) return global.VillageLightingMap[Room.GridY][Room.GridX]
	
	if(global.Level.Index == DungeonLevel.Mines) return Room.TemplateSubClass != RoomTemplateClass_Mines.House

	if(	TemplateCheck(_RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.Fairy) || 
		TemplateCheck(_RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.GemPond) || 
		TemplateCheck(_RoomIndex, RoomTemplateClass.Special, RoomTemplateClass_Special.Shop)){ 
			return false;
	}
		   
	if(TemplateCheck(_RoomIndex, RoomTemplateClass.Other, RoomTemplateClass_Other.Boss, "Moldorm")) return true;
	
	if(Room.TemplateClass == RoomTemplateClass.Other) return false	
	
	
	var P = 0.25 + (global.ChallengeOptions[ChallengeOption.Darkness] * 0.3);
	
	switch(global.Level.Index){
		
		case DungeonLevel.Start:
		case DungeonLevel.Aghanim2:
			return false		
		
		case DungeonLevel.Castle:
			P = global.ChallengeOptions[ChallengeOption.Darkness] * 0.45;
			break;
			
		case DungeonLevel.CastleBasement:
		case DungeonLevel.CastleJails:
			P += 0.1;
			break;
			
		case DungeonLevel.Sewers:
		case DungeonLevel.WaterTemple:
		case DungeonLevel.Aghanim1:
			P += 0.15;
			break;			
		
		case DungeonLevel.Ruins:		
			P += 0.2;
			break;
		
		case DungeonLevel.Catacombs:
		case DungeonLevel.MoldormsLair:
			return true;

	}
	
	return Prob(P);
	
}

function Prob(_Percentage){
	//Percentage 0.0 - 1.0
	return random(1) < _Percentage;
}

function FlipCoin_Bin(){
	return choose(0, 1);
}

function FlipCoin_Bool(){
	return choose(false, true);
}
