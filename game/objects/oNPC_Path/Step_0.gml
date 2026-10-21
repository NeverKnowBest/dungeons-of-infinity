if(DB_Init){
	
	if(Dialogue != ""){
		global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);
		global.DB_Inst.Script = DB_Script;
		NPC_UpdateState(NPCState.Idle);
		image_index = 0;
		Dir = DirFaceLink();
		NPC_UpdateDir();
		DB_Started = true;
	}
	DB_Init = false;	

}

if(DB_Started){

	if(!instance_exists(global.DB_Inst)){
		
		DB_Started = false;
		NPC_UpdateState(NPCState.Idle);
		alarm[0] = irandom_range(45, 75);
	}
	
	exit;
}


switch(State){
	
	case NPCState.Walking:
	
		x += vx;
		y += vy;
		var DestX = PathX[Path[PathIndex_To]];
		var DestY = PathY[Path[PathIndex_To]];
		if( (vx > 0 && x >= DestX) || (vx < 0 && x <= DestX) || (vy > 0 && y >= DestY) || (vy < 0 && y <= DestY)){
	
			x = DestX;
			y = DestY;
			
			NPC_SetNextPathIndex();
			NPC_UpdateState(NPCState.Idle);			
			
			alarm[0] = irandom_range(45, 75);
	
		
		}
		
		break;
		
}



