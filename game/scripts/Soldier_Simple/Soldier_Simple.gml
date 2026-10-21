
function Soldier_Simple_LookSideDir(_Dir){
	switch(_Dir){
		case LEFT: 
		case RIGHT: return choose(UP, DOWN);
		case UP: 
		case DOWN: return choose(LEFT, RIGHT);
		
	}	
	
}

