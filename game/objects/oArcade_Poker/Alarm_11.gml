/// @description Deal Delay

//find next empty spot in hand to add card to

for(var i = 0; i < 5; i++){
	if(Hand[i] == -1){
		Poker_PickCard(i);
		audio_play_sound(Sound_Poker_CardDeal, 1, false);
		break;
	}
	
}

//see if there's a still an empty spot
for(var i = 0; i < 5; i++){
	if(Hand[i] == -1){
		alarm[11] = DealDelay;
		exit;			
	}
}
	
CurrentHand = Poker_HandValue();
CurrentHandStr = Poker_HandString(CurrentHand);
DealCardIndex = 0;
GameState++;



switch(GameState){
	case PokerState.Hold:
		if(CurrentHand > PokerHand.Nothing) audio_play_sound(Sound_Poker_Blip, 1, false);
		GameReady = false;
		alarm[1] = GameReadyDelay;
		break;
		
	case PokerState.Win:
	
		if(CurrentHand > PokerHand.Nothing){
			if(CurrentHand > 0 && CurrentHand <= 2) WinSound = Sound_Poker_Win1;
			if(CurrentHand > 2 && CurrentHand <= 3) WinSound = Sound_Poker_Win2;
			if(CurrentHand > 3 && CurrentHand <= 4) WinSound = Sound_Poker_Win3;
			if(CurrentHand > 4 && CurrentHand <= 8) WinSound = Sound_Poker_Win4;
			if(CurrentHand > 8) WinSound = Sound_Poker_Win5;
			audio_play_sound(WinSound, 1, false);
			
			WinAmount = Poker_GetWinAmount();
			RupeesAdd(WinAmount, false);
		}
		
		State = ArcadeState.GameOver;
		
		GameReady = false;
		alarm[1] = GameReadyDelay;
		
		break;
}
