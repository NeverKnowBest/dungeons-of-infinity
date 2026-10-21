event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = PathX[0] + 64;
PathY[1] = PathY[0];
PathX[2] = PathX[1];
PathY[2] = PathY[1] + 32;

Path = [0,1,2,1];
PathNodes = array_length(Path);


NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = 60;