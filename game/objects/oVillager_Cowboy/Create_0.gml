
event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = x;
PathY[1] = y - 96;
PathX[2] = x - 80;
PathY[2] = y - 96;

Path = [0,1,2,1];
PathNodes = array_length(Path);


NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = irandom_range(1, 60);