LinkInFront = (oLink.x >= x - 7 && oLink.x <= x + 7 && oLink.y - 6 >= y - 1 && oLink.y - 6 <= y + 1 && oLink.Facing == UP);

if(!GameAllowed && !LinkInFront) GameAllowed = true; //To make sure Link steps away from machine first after exiting before showing screen again when coming back

switch(State){
	
	case ArcadeState.UnUsed:
		if(LinkInFront && GameAllowed){
			global.ArcadeVP_Show = true;
			State = ArcadeState.Reset;
		}
		break;
		
	case ArcadeState.AttractScreen:		
	case ArcadeState.GameOver:		
		
		if(!LinkInFront){
			State = ArcadeState.Unload;
			break;
		}		
	

}

switch(State){

	case ArcadeState.Reset:
		//oLink.actionVideoGame = false;
		break;
	
	case ArcadeState.GameStartInit:
		break;
		
	case ArcadeState.Unload:

		break;
}