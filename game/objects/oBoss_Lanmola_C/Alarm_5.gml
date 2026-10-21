/// @description Hit timer 2
Hit[2] = false;

if(Destroyed[2] && !DestroyInit[2]){
	alarm[9] = SectionDestroyDelay;
	DestroyInit[2] = true;
}