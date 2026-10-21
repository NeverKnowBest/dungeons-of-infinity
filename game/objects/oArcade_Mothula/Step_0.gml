event_inherited();

if(GameReady && (State == ArcadeState.AttractScreen || State == ArcadeState.GameOver)) Arcade_Slot_KeyCheck_Start();	



switch(State){

	case ArcadeState.UnUsed:

		break;

	case ArcadeState.Reset:
		
		global.Arcade_ActiveInst = self;
		
		Arcade_SetCam(CamW, CamH);

		GameSurface = surface_create(RoomW, RoomH);
		
		State = ArcadeState.AttractScreen;

		break;
		
	case ArcadeState.GameStartInit:
		
		audio_stop_sound(WinSound);
		
		global.Inventory.ItemData[ItemClass.Rupee].Amount -= (Bet + 1);

		WinAmount = 0;
		
		var _WinProb = irandom(10000);
		if(_WinProb <= 15){								//15
			ReelSpinResult = MothulaSlotSymbol.Jackpot;
			
		}else if(_WinProb > 15 && _WinProb <= 100){		//85
			ReelSpinResult = MothulaSlotSymbol.Seven;
			
		}else if(_WinProb > 100 && _WinProb <= 275){	//175
			ReelSpinResult = MothulaSlotSymbol.Bell;
			
		}else if(_WinProb > 275 && _WinProb <= 625){	//350
			ReelSpinResult = MothulaSlotSymbol.Orange;
			
		}else if(_WinProb > 625 && _WinProb <= 1125){	//500
			ReelSpinResult = MothulaSlotSymbol.Plum;
			
		}else if(_WinProb > 1125 && _WinProb <= 2725){	//1600
			ReelSpinResult = MothulaSlotSymbol.Cherry;
			
		}else{
			ReelSpinResult = MothulaSlotSymbol.None;
		}
		
		//ReelSpinResult = MothulaSlotSymbol.Jackpot;
		
		if(ReelSpinResult == MothulaSlotSymbol.None){
			
			ReelSpinResultSymbols[0] = choose(0,0,0,0,1,2,3,4,5,5,6,6);
			ReelSpinResultSymbols[1] = choose(0,0,0,0,1,2,3,4,5,5,6,6);
			ReelSpinResultSymbols[2] = choose(0,0,0,0,1,2,3,4,5,5,6,6);
			
			if(ReelSpinResultSymbols[0] != 0 && ReelSpinResultSymbols[0] == ReelSpinResultSymbols[1] && ReelSpinResultSymbols[1] == ReelSpinResultSymbols[2] && ReelSpinResultSymbols[2] == ReelSpinResultSymbols[0]){
				ReelSpinResultSymbols[choose(0,1,2,2)] = 0;
			}
			
		}else{
			ReelSpinResultSymbols[0] = ReelSpinResult;
			ReelSpinResultSymbols[1] = ReelSpinResult;
			ReelSpinResultSymbols[2] = ReelSpinResult;
		}
		
		for(var i = 0; i < 3; i++){
			ReelSpin[i] = true;		
			ReelSpinResultSeek[i] = false;
			ReelSpinIndexSeek[i] = -1;
			ReelSpinSpeed[i] = random_range(ReelSpinMaxSpeed - 0.75, ReelSpinMaxSpeed + 0.75);
		}
		

		alarm[1] = ReelSpinStopDelay + irandom(4);
		
		GameState = SlotState.Spin;
		
		audio_play_sound(Sound_SlotSpin, 1, true);
		
		break;
		
	case ArcadeState.GameStarted:
		
		switch(GameState){
			case SlotState.Idle:

				break;
				
			case SlotState.Spin:

				for(var i = 0; i < 3; i++){
	
					if(!ReelSpin[i]) continue;
	
					ReelPos[i] -= ReelSpinSpeed[i];
					if(ReelPos[i] < 0) ReelPos[i] += global.MothulaSlot_ReelH;
					
					var _ReelIndex = floor(ReelPos[i] / 16);
					
					if(ReelSpinResultSeek[i]){						
						
						if(global.MothulaSlot_ReelSymbols[_ReelIndex] == ReelSpinResultSymbols[i]){
							
							ReelSpinResultSeek[i] = false;
							ReelSpinIndexSeek[i] = _ReelIndex;
							
						}
						
					}

					if(ReelSpinIndexSeek[i] >= 0){
						
						var _LinePos = ReelSpinIndexSeek[i] * 16;
						
						if(ReelPos[i] <= _LinePos || ReelPos[i] - ReelSpinSpeed[i] < 0){
							
							audio_play_sound(StopSounds[i], 1, false);
							
							ReelPos[i] = _LinePos;
							ReelSpin[i] = false;
							ReelSpinIndexSeek[i] = -1;
							
							if(i <= 1){
								alarm[i + 2] = ReelSpinStopDelay + irandom(4);
							}
							
						}
					}
					
				}			
				
				if(!ReelSpin[0] && !ReelSpin[1] && !ReelSpin[2]){
					
					GameState = SlotState.Win;
					State = ArcadeState.GameOver;
					
					audio_stop_sound(Sound_SlotSpin);
					
					WinSound = WinSounds[ReelSpinResult];
					if(ReelSpinResult != MothulaSlotSymbol.None) audio_play_sound(WinSound, 1, false);
						
					WinAmount = WinMul[ReelSpinResult] * (Bet + 1);
					global.Inventory.ItemData[ItemClass.Rupee].Amount += WinAmount;

					GameReady = false;
					alarm[4] = GameReadyDelay;	
					
				}

			
				break;

				
		}

		break;
		
	case ArcadeState.GameOver:
	
		break;	
	
	case ArcadeState.Unload:
		audio_stop_sound(WinSound);
		break;
		
}




