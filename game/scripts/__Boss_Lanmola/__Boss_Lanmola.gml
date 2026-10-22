// Feather disable GM2064
function Lanmola_Spawn(ID){
	
	var X = global.CurrentRoom.x + 64 + irandom(global.CurrentRoom.width - 128);
	var Y = global.CurrentRoom.y + 64 + irandom(global.CurrentRoom.height - 128);
	var inst = instance_create_layer(X, Y, "Objs_Upper", oBoss_Lanmola_Dirt1);
	inst.ID = ID;
	
}

function Lanmola_SpawnDelay(){
	return irandom_range(30, 60);	
}

function Lanmola_Update(){
	
	switch(Path){
		case LanmolaPath1:	
			vz = path_get_y(Path, Time) / 45;
			Time+=0.0075;	
			break;
		case LanmolaPath2:
			vz = path_get_y(Path, Time) / 85;
			Time+=0.0065;	
			break;
		case LanmolaPath3:
			vz = path_get_y(Path, Time) / 40;
			Time+=0.015;	
			break;	
	}

	z += vz;

	if(vz < 0 && z <= 8){
		
		//Use this code to figure out distance maximums if variables are changed. See oBoss_Lanmola's create event notes
		//if(point_distance(StartX, StartY, x, y) >= 107){
		//	var a = 0;	
		//}
		instance_destroy(id);	

		if(object_index == oBoss_Lanmola){
			oBoss_Lanmola_C.DirtSplashInst[ID] = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_DirtSplash);
		}
		
		if(object_index == oBoss_Lanmola_Tail){
			instance_destroy(oBoss_Lanmola_C.DirtSplashInst[ID]);
			oBoss_Lanmola_C.alarm[ID] = Lanmola_SpawnDelay();
		}
	}
	
}

function Lanmola_SectionDestroy(_ID){
	
	var ListSize = ds_list_size(SectionInstList[_ID]);
	var LastIndex = ListSize - 1;
	var SectionInst = ds_list_find_value(SectionInstList[_ID], LastIndex);
	
	instance_create_layer(SectionInst.x, SectionInst.y, "ObjsHighest", oExplosion_Large, {FloorLevel : FloorLevel});	
	if(LastIndex > 0){
		ds_list_delete(SectionInstList[_ID], LastIndex);
		alarm[7 + _ID] = SectionDestroyDelay;	
	}else{
		Curse_CheckTask(CurseTasks.Kill);
		global.StatsToAdd[Stat.Monsters]++;		
	}
	instance_destroy(SectionInst);
	
}