
event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = x + 56;
PathY[1] = y;
PathX[2] = x + 56;
PathY[2] = y - 48;
PathX[3] = x + 56;
PathY[3] = y + 48;
PathX[4] = x - 56;
PathY[4] = y;
PathX[5] = x - 56;
PathY[5] = y - 48;

Path = [0,1,2,1,3,1,4,5,4];
PathNodes = array_length(Path);


NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = irandom_range(1, 60);