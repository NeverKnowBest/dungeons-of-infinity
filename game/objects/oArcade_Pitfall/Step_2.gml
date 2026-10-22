event_inherited();


var Y;
switch(State){
	
	case ArcadeState.UnUsed:

		break;

	case ArcadeState.Reset:

		break;
		
	case ArcadeState.AttractScreen:
		break;
	
	case ArcadeState.GameStartInit:

		break;
		
	case ArcadeState.GameStarted:
	
		CamX = Harry.x - CamW_3;
		CamXMin = max(CamXMin, CamX);
		if(CamX < CamXMin) CamX = CamXMin;
		if(CamX >= CamXMax){
			CamX = 0;
			CamXMin = 0;
			Harry.x = CamW_3;
			NextEnemySpawnX = CamX + 30 + irandom(CamW_2 + 40);	
			with(oPitfall_Enemy) x -= other.CamXMax;
			with(oPitfall_Treasure) instance_destroy(id);
			if(Prob(0.4)) instance_create_layer(CamXMax - CamW, HarryStartY, "System", choose(oPitfall_Gold, oPitfall_Gold, oPitfall_Ring));
		}

		if(CamX >= NextEnemySpawnX){
	
			var CurrentEnemy = NextEnemy;
			switch(CurrentEnemy){
				case oPitfall_Scorpion:
					Y = HarryStartY;
					break;
				case oPitfall_Bat:
					Y = HarryStartY - 34;
					break;
				case oPitfall_Eagle:
					Y = HarryStartY - 38;
					break;
				case oPitfall_Frog:
					Y = HarryStartY;
					break;
			}
			instance_create_layer(CamX + CamW + 8, Y, "System", CurrentEnemy);
	
			if(CurrentEnemy == oPitfall_Scorpion && choose(1,2,3,4) == 1){
				NextEnemy = oPitfall_Scorpion;
				NextEnemySpawnX = CamX + irandom_range(32, 36);
			}else if(CurrentEnemy == oPitfall_Bat && choose(1,2,3,4) == 1){
				NextEnemy = oPitfall_Bat;
				NextEnemySpawnX = CamX + irandom_range(34, 50);
			}else{
				switch(choose(1,1,1,2,2,2,3,3,4)){
					case 1:
						NextEnemy = oPitfall_Scorpion;
						NextEnemySpawnX = CamX + 32 + irandom(CamW_2 + 20);	
						break;
					case 2:
						NextEnemy = oPitfall_Bat;
						NextEnemySpawnX = CamX + 45 + irandom(CamW_2 + 20);	
						break;
					case 3:
						NextEnemy = oPitfall_Eagle;
						NextEnemySpawnX = CamX + 55 + irandom(CamW_2 + 20);	
						break;
					case 4:
						NextEnemy = oPitfall_Frog;
						NextEnemySpawnX = CamX + 30 + irandom(CamW_2 + 20);	
						break;
				}
			}
	
	
		}
		break;
		
	case ArcadeState.GameOver:
		break;	
	
	case ArcadeState.Unload:
		break;
		
}


