event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = x + 168;
PathY[1] = y;
PathX[2] = x;
PathY[2] = y + 168;

Path = [0,1,0,2];
PathNodes = array_length(Path);


NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = 60;