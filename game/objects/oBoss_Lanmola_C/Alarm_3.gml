/// @description Hit timer 0
Hit[0] = false;

if(Destroyed[0] && !DestroyInit[0]){
	alarm[7] = SectionDestroyDelay;
	DestroyInit[0] = true;
}