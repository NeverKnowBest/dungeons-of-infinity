enum NPCState{
	Idle,
	Walking
}

function NPC_UpdateState(_NewState){
	
	State = _NewState;
	
	switch(State){
		
		case NPCState.Idle:
			image_speed = 0;
			vx = 0;
			vy = 0;
			alarm[0] = -1;
			break;
			
		case NPCState.Walking:
			image_speed = 1;
			image_index = image_index xor 1;
			vx = sign(PathX[Path[PathIndex_To]] - PathX[Path[PathIndex_From]]) * PathSpeed;
			vy = sign(PathY[Path[PathIndex_To]] - PathY[Path[PathIndex_From]]) * PathSpeed;	
			NPC_UpdateDir();
	}
}


function NPC_SetNextPathIndex(){
	PathIndex_From = PathIndex_To;
	PathIndex_To = (PathIndex_To + 1) mod PathNodes;
}

function NPC_UpdateDir(){

	if(vx > 0) 
		Dir = RIGHT;
	else if(vx < 0)
		Dir = LEFT;
	else if(vy > 0)
		Dir = DOWN;
	else if(vy < 0)
		Dir = UP;

	switch(Dir){
		case UP:
			if(SprUp > -1) sprite_index = SprUp;
			break;
		case DOWN:
			if(SprDown > -1) sprite_index = SprDown;
			break;	
		case LEFT:
			if(SprLeft > -1) sprite_index = SprLeft;
			break;
		case RIGHT:
			if(SprRight > -1) sprite_index = SprRight;
			break;	
	}

}

function NPC_SetResponse(_ResponseIndex){
	
	ResponseIndex = _ResponseIndex;
	DB_Init = true;
	DB_Delay = true;
	alarm[0] = DB_Delay_Len;	
	
}