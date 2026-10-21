/// @description Hit timer 1
Hit[1] = false;

if(Destroyed[1] && !DestroyInit[1]){
	alarm[8] = SectionDestroyDelay;
	DestroyInit[1] = true;
}