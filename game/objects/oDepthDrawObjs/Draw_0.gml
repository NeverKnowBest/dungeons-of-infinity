if(!Draw) exit;

for(var ObjIndex = 0; ObjIndex < ObjectCount; ObjIndex++){

	with(ObjGrid[# 0, ObjIndex]){
		event_perform(ev_draw, 0);
	}
	
}

