Dialogue[0] = "Ganon is my cousin.";
Dialogue[1] = "My uncle built Hyrule using only\\a hammer.";
Dialogue[2] = "Zelda is my girlfriend.";
Dialogue[3] = "People say I lie all the time. Don't\\believe them, they are the liars.";


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