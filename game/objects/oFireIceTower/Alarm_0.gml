for(var PatternY = 0; PatternY < PatternH; PatternY++){
	for(var PatternX = 0; PatternX < PatternW; PatternX++){
		var PatternCode = Pattern[PatternIndex][PatternY][PatternX];
		if(PatternCode == 1){
			var PosX = PatternStartX + (PatternX * 16);
			var PosY = PatternStartY + (PatternY * 16);
			instance_create_layer(PosX, PosY, "ObjsHighest", TowerObj);
		}
	}
}
	
PatternIndex++;
alarm[0] = PatternDelay;
if(PatternIndex >= Patterns){
	instance_destroy(id);
}