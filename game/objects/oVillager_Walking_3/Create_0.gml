
event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = x - 160;
PathY[1] = y;
PathX[2] = x;
PathY[2] = y + 160;
PathX[3] = x - 160;
PathY[3] = y + 160;

Path = [0,1,3,1,0,2];
PathNodes = array_length(Path);


NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = 60;