if(image_index >= 4){
	
	if(variable_instance_exists(id, "SpawnItem")){
		if(SpawnItem != -1 && SpawnItem != noone){

			Enemy_DestroySpawnItem(SpawnItem, Size);
			
			SpawnItem = noone;
			
		}
		
	}	
}