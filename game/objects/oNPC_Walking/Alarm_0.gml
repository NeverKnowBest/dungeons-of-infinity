//Pause delay

if(Prob(0.5)){
	Dir = RandomDir();
	NPC_UpdateDir();
	alarm[0] = irandom_range(45, 75);
}else NPC_UpdateState(NPCState.Walking);