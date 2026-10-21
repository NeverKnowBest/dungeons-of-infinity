
#macro Chance_SpawnPots 0.35
#macro Chance_PotHasItem 0.35
#macro Chance_SpawnEnemies 0.8
#macro Chance_SpawnWallEnemies 0.2
#macro Chance_SpawnEnemyTrap 0.2
#macro Chance_EnemyBonusItem 0.4
#macro Chance_SpawnRollingSpikes 0.15
#macro Chance_SpawnGuruBars 0.15
#macro Chance_SpawnTorches 0.45
#macro Chance_Torches_Lit 0.4

#macro Chance_Shop 0.17

#macro Chance_BonusTreasure 0.16
#macro Chance_HeartGuy 0.06 //(if bonus treasure, prob of that treasure being a HeartGuy)
#macro Chance_DeadGuy 0.09	//(if bonus treasure, prob of that treasure being a DeadGuy)
#macro Chance_DeadGuyKey 0.2 //if spawning keys. It's this prob, but only if it gets picked as a spawn method, so it's be a lower prob than this
#macro Chance_DeadGuyBonusItem 0.6 

#macro Chance_Curse 0.035 
#macro Chance_CurseDeadGuy 0.15 


#macro Chance_SecretDoor 0.6 //chance that a special Room will use a secret door
#macro Chance_SpecialRoomIsFairy 0.5
#macro Chance_SpecialRoomIsShop 0.5

#macro Chance_Decor_Carpets 0.8
#macro Chance_Decor_CarpetsFull 0.4 //if carpets are drawn, chance that it will be a full carpet instead of the path carpets

#macro Chance_SpawnKinstoneMonument 0.05
#macro Chance_Decor_Monuments 0.8
#macro Chance_Decor_Monuments_BonusPots 0.35
#macro Chance_Decor_Monuments_DeadguyTreasure 0.15
#macro Chance_Decor_CurtainOverDoor 0.09
#macro Chance_Decor_ReplaceMuralWithLight 0.4

#macro Chance_SpawnBlocks 0.2

#macro Chance_Decor_Lights_Lit 0.75

#macro Chance_WaterInRoom (global.Level.Index == DungeonLevel.Aghanim3 ? 0.5 : 0.7)
#macro Chance_WaterSection 0.7

#macro Chance_SpawnSpikes (global.Level.Index == DungeonLevel.Aghanim3 ? 1 : 0.5 + (global.Level.Index / 50))
#macro Chance_SpikeSection (0.5 + (global.Level.Index / 40))

function RoomLighting(_RoomIndex){
	
	
	if(RoomID(_RoomIndex, RoomType.Boss) || RoomID(_RoomIndex, RoomType.Special, "Fairy") || RoomID(_RoomIndex, RoomType.Special, "Shop"))
		return 0.0;
	
	switch(global.Level.Index){
		
		case DungeonLevel.Start:
		case DungeonLevel.Castle:
			return 0.0		
			
		case DungeonLevel.Village:
			return global.VillageLightingMap[Room.GridY][Room.GridX];

		
		
		case DungeonLevel.Ruins2:
		case DungeonLevel.Ruins3:
		case DungeonLevel.Aghanim3:
			var P = 0.5;
			break;
			
		case DungeonLevel.Sewers:
		case DungeonLevel.Ruins1:
		case DungeonLevel.MoldormsLair:		
			var P = 0.6;
			break;
			
		case DungeonLevel.Catacombs:
			var P = 0.8;
			break;
			
		default: var P = 0.4;
			break;
	}
	
	return Prob(P) ? 1.0 : 0.0;
	
}

function Prob(Percentage){
	//Percentage 0.0 - 1.0
	return random(1) < Percentage;
}

function FlipCoin_Bin(){
	return choose(0, 1);
}

function FlipCoin_Bool(){
	return choose(false, true);
}
