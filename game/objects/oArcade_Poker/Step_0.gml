event_inherited();

if(GameReady && (State == ArcadeState.AttractScreen || State == ArcadeState.GameOver))
	Arcade_Slot_KeyCheck_Start();	



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
		RupeesAdd(-(Bet + 1), false);
		Poker_InitDeck();

		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(14), PokerSuit.Spade));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(12), PokerSuit.Spade));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(11), PokerSuit.Spade));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(13), PokerSuit.Spade));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(10), PokerSuit.Spade));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(8), PokerSuit.Club));
		//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(5), PokerSuit.Spade));
	
		for(var i = 0; i < 5; i++){
			Hand[i] = -1;
			HeldCards[i] = false;
			HoldPos = 0;
			CurrentHand = PokerHand.Nothing;
			CurrentHandStr = "";
			WinAmount = 0;
		}		
		GameState = PokerState.Deal1;
		alarm[11] = DealDelay;
		
		break;
		
	case ArcadeState.GameStarted:
		
		switch(GameState){
			case PokerState.Idle:

				break;
			case PokerState.Deal1:
				
				break;

			case PokerState.Hold:
				if(input_check_pressed("right")){
					GameReady = true;
					alarm[1] = -1;
					HoldPos = (HoldPos + 1) mod 5;
				}
				if(input_check_pressed("left")){
					GameReady = true;
					alarm[1] = -1;
					HoldPos--;
					if(HoldPos < 0) HoldPos = 4;
				}
				if(input_check_pressed("action")) HeldCards[HoldPos] = !HeldCards[HoldPos];
				if(GameReady && input_check_pressed("sword")){
					for(var i = 0; i < 5; i++){
						Hand[i] = HeldCards[i] ? Hand[i] : -1;
					}
					CurrentHand = PokerHand.Nothing;
					CurrentHandStr = "";
					GameState = PokerState.Deal2;
					alarm[11] = DealDelay;
				}
				break;	

			case PokerState.Deal2:
				
				break;

				
		}

		break;
		
	case ArcadeState.GameOver:
	
		break;	
	
	case ArcadeState.Unload:
		CurrentHand = PokerHand.Nothing;
		CurrentHandStr = "";
		break;
		
}





