enum PokerState{
	Idle,
	Deal1,
	Hold,
	Deal2,
	Win
}

enum PokerSuit{
	Heart,
	Club,
	Diamond,
	Spade	
}

enum PokerHand{
	Nothing,
	Pair,
	TwoPair,
	Three,
	Straight,
	Flush,
	FullHouse,
	Four,
	StraightFlush,
	Royal	
}


function Poker_InitDeck(){
	
	ds_list_clear(Deck);
	for(var i = 0; i < 52; i++){
		ds_list_add(Deck, i);	
	}
	ds_list_shuffle(Deck);
	

	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(14), PokerSuit.Spade));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(12), PokerSuit.Spade));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(11), PokerSuit.Spade));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(13), PokerSuit.Spade));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(10), PokerSuit.Spade));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(8), PokerSuit.Club));
	//Poker_MoveCardToFront(Poker_CardIndex(Poker_RealValueToIndex(5), PokerSuit.Spade));


	
}

function Poker_PickCard(_HandIndex){
	Hand[_HandIndex] = Deck[| 0];
	ds_list_delete(Deck, 0);
}

function Poker_ResetHeldCards(){
	for(var i = 0; i < 5; i++){
		HeldCards[i] = false;
	}
	
}

function Poker_HandValue(){
	
	CardValuesList = ds_list_create();
	CardSuitsList = ds_list_create();
	//first go throught each card in the hand and convert the value to real value(0-12), and also the suit(0-3, Heart, club, diamond, spade)
	for(var i = 0; i < 5; i++){
		ds_list_add(CardValuesList, Hand[i] mod 13);
		ds_list_add(CardSuitsList, Hand[i] div 13);
	}
	
	ds_list_sort(CardValuesList, true);
	ds_list_sort(CardSuitsList, true);

	//transfer list to array so we can destroy the list before returning a value
	for(var i = 0; i < 5; i++){
		CardValues[i] = CardValuesList[|i];
		CardSuits[i] = CardSuitsList[|i];
	}
	ds_list_destroy(CardValuesList);
	ds_list_destroy(CardSuitsList);
	
	
	//straights
	if(	(CardValues[0] + 1 == CardValues[1] && CardValues[1] + 1 == CardValues[2] && CardValues[2] + 1 == CardValues[3] && CardValues[3] + 1 == CardValues[4]) ||
		(CardValues[0] == 0 && CardValues[1] == 1 && CardValues[2] == 2 && CardValues[3] == 3 && CardValues[4] == 12) ){ //special case for 2,3,4,5,A since A is either a 1 or 13
		
		//straight flush
		if(CardSuits[0] == CardSuits[1] && CardSuits[1] == CardSuits[2] && CardSuits[2] == CardSuits[3] && CardSuits[3] == CardSuits[4]){
			
			//royal flush
			if(CardValues[0] == 8 && CardValues[1] == 9 && CardValues[2] == 10 && CardValues[3] == 11 && CardValues[4] == 12){
					return PokerHand.Royal;			
			}
			
			return PokerHand.StraightFlush;
		}
	
		
		return PokerHand.Straight;
	}
	
	//Four of a kind
	if(	(CardValues[0] == CardValues[1] && CardValues[1] == CardValues[2] && CardValues[2] == CardValues[3]) ||
		(CardValues[1] == CardValues[2] && CardValues[2] == CardValues[3] && CardValues[3] == CardValues[4])){
		
		return PokerHand.Four;
	}
	
	
	//Full house
	if(	(CardValues[0] == CardValues[1] && CardValues[1] == CardValues[2] && CardValues[3] == CardValues[4] && CardValues[3] != CardValues[0] && CardValues[4] != CardValues[0]) ||
		(CardValues[0] == CardValues[1] && CardValues[2] == CardValues[3] && CardValues[3] == CardValues[4] && CardValues[0] != CardValues[2] && CardValues[1] != CardValues[2])){
		return PokerHand.FullHouse;
	}
	
	//flush
	if(CardSuits[0] == CardSuits[1] && CardSuits[1] == CardSuits[2] && CardSuits[2] == CardSuits[3] && CardSuits[3] == CardSuits[4]){
		return PokerHand.Flush;
	}
	
	//three of a kind
	if(	(CardValues[0] == CardValues[1] && CardValues[1] == CardValues[2] && CardValues[3] != CardValues[0] && CardValues[3] != CardValues[4]) ||
		(CardValues[1] == CardValues[2] && CardValues[2] == CardValues[3] && CardValues[0] != CardValues[1] && CardValues[0] != CardValues[4]) ||
		(CardValues[2] == CardValues[3] && CardValues[3] == CardValues[4] && CardValues[0] != CardValues[2] && CardValues[0] != CardValues[1]) ){
		return PokerHand.Three;
	}

	//2 Pairs
	if(	(CardValues[0] == CardValues[1] && CardValues[2] == CardValues[3] && CardValues[4] != CardValues[0] && CardValues[4] != CardValues[2]) || 
		(CardValues[0] == CardValues[1] && CardValues[3] == CardValues[4] && CardValues[2] != CardValues[0] && CardValues[2] != CardValues[3]) ||
		(CardValues[1] == CardValues[2] && CardValues[3] == CardValues[4] && CardValues[0] != CardValues[1] && CardValues[0] != CardValues[3])){
		return PokerHand.TwoPair;
	}
	
	//1 Pairs
	if(	(CardValues[0] == CardValues[1] && CardValues[0] >= 9) ||
		(CardValues[1] == CardValues[2] && CardValues[1] >= 9) ||
		(CardValues[2] == CardValues[3] && CardValues[2] >= 9) ||
		(CardValues[3] == CardValues[4] && CardValues[3] >= 9)){
		return PokerHand.Pair;
	}
	
}

function Poker_HandString(_HandIndex){
	
	switch(_HandIndex){
		case PokerHand.Pair: return "Jacks or Better";
		case PokerHand.TwoPair: return "2 Pairs";
		case PokerHand.Three: return "3 of a Kind";
		case PokerHand.Straight: return "Straight";
		case PokerHand.Flush: return "Flush";
		case PokerHand.FullHouse: return "Full House";
		case PokerHand.Four: return "Four of a Kind";
		case PokerHand.StraightFlush: return "Straight Flush";
		case PokerHand.Royal: return "Royal Flush";
	
	}
	return "";
}

function Poker_GetWinAmount(){
	return WinMul[CurrentHand] * (Bet + 1);
}

function Poker_CardIndex(_Number, _Suit){
	return 	(_Suit * 13) + _Number;
}

function Poker_MoveCardToFront(_CardIndex){
	//for testing purposes
	var DeckIndex = ds_list_find_index(Deck, _CardIndex);
	ds_list_delete(Deck, DeckIndex);
	ds_list_insert(Deck, 0, _CardIndex);
}

function Poker_RealValueToIndex(_RealValue){
	return _RealValue - 2;	
}