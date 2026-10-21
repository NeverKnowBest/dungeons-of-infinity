/// @description Curse Health Drain



if(Curse_Check(CurseEffects.HealthDrain)){

	if(LinkHealth > 2){
		HealthAdd(-0.25);
		if(LinkHealth < 2) LinkHealth = 2;
	}
	alarm[3] = global.CurseHealthDrainDelay;
}
	