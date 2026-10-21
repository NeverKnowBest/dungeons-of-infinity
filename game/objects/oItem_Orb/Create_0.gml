event_inherited();

CanPickup = true;

ShadowOffsetY = -2;

switch(From){
	
	default:
		Item_SetIndex(choose(Orb.Fire, Orb.Fire, Orb.Fire, Orb.Fire, Orb.Ice, Orb.Ice, Orb.Ice, Orb.Ice, Orb.Fairy));
		break;
		
	case ItemFrom.MagicStore:
		Item_SetIndex(choose(Orb.Fire, Orb.Ice));
		break;
		
	case ItemFrom.TreasureStore:
		Item_SetIndex(Orb.Fairy);		
		break;

		
}

if(Index == Orb.Fairy) exit;

switch(From){
	
	default:
		Amount = choose(1,1,1,1,1,2);
		break;
		
	case ItemFrom.Treasure:
	case ItemFrom.Shop:
	case ItemFrom.KinstoneGreen:
	case ItemFrom.MagicStore:
		Amount = choose(3,3,3,4,4,5);
		break;
		
}

