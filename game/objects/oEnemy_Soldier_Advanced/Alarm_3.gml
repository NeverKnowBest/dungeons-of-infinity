/// @description Standing turn head


switch(Dir){
	case UP:
	case DOWN:
		if(HeadDir == Dir){
			if(StandingTurnHeadDir == 1)
				Soldier_UpdateHead(RIGHT);
			else
				Soldier_UpdateHead(LEFT);
			StandingTurnHeadDir *= -1;
		}else Soldier_UpdateHead(Dir);

		break;

	
	case LEFT:	
	case RIGHT:
		if(HeadDir == Dir){
			if(StandingTurnHeadDir == 1)
				Soldier_UpdateHead(DOWN);
			else
				Soldier_UpdateHead(UP);
			StandingTurnHeadDir *= -1;
		}else Soldier_UpdateHead(Dir);		
		break;
	
}

StandingHeadChecks--;

if(StandingHeadChecks <= 0){
	Enemy_UpdateState(EnemyState.Walking);	
}else alarm[3] = StandinHeadTurnDelay;