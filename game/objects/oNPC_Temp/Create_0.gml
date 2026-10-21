Dialogue[0] = "Test 123";
Dialogue[1] = "Test 456";
Dialogue[2] = "Test 789";

event_inherited();

PathX[0] = x;
PathY[0] = y;
PathX[1] = PathX[0] + 64;
PathY[1] = PathY[0];
PathX[2] = PathX[1];
PathY[2] = PathY[1] + 32;

Path = [0,1,2,1];
PathNodes = array_length(Path);

SprUp = sNPC_Temp_Up;
SprDown = sNPC_Temp_Down;
SprLeft = sNPC_Temp_Left;
SprRight = sNPC_Temp_Right;

NPC_SetNextPathIndex();
NPC_UpdateState(NPCState.Idle);
alarm[0] = 60;