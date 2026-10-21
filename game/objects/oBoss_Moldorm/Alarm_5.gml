/// @description Explosion

for(var _BodyIndex = MoldormSection.Tail; _BodyIndex >= MoldormSection.BodyL1; _BodyIndex--){
	if(instance_exists(BodyInst[_BodyIndex])){
		instance_create_layer(BodyInst[_BodyIndex].x, BodyInst[_BodyIndex].y, "ObjsHighest", oExplosion_Large, {FloorLevel : FloorLevel});
		instance_destroy(BodyInst[_BodyIndex]);
		alarm[5] = _BodyIndex == MoldormSection.BodyL1 ? 60 : 20;
		exit;	
	}
}

if(FinalExplosions > 0){
	instance_create_layer(x + irandom_range(-12, 12), y + irandom_range(-12, 12), "ObjsHighest", oExplosion_Large, {FloorLevel : FloorLevel});
	if(FinalExplosions <= 2) ShowHead = false;	
	FinalExplosions--;
	if(FinalExplosions == 0){
		alarm[7] = 20;
		Curse_CheckTask(CurseTasks.Kill);
		global.StatsToAdd[Stat.Monsters]++;	
	}else{
		alarm[5] = 10;
	}
}

