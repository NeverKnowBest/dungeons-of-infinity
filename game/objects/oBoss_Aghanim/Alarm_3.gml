// Feather disable GM2064
if(FinalExplosions > 0){
	
	instance_create_layer(x + irandom_range(-12, 12), y - 11 + irandom_range(-12, 12), "ObjsHighest", oExplosion_Large, {FloorLevel : FloorLevel});
	
	FinalExplosions--;
	if(FinalExplosions == 0){
		with(oLink){
			Facing = DOWN;
			UpdateSprites();
		}
		//instance_destroy(id);
		instance_create_layer(x, y, "System", oAghanim_End);
		Lighting_UpdateLight_Visible(RoomIndex, LightIndex_Body, true);
		Lighting_UpdateLight_Radius(RoomIndex, LightIndex_Body, 0.65);
		Lighting_UpdateLight_Pos(RoomIndex, LightIndex_Body, x, y - 7);
		exit;

	}else{
		
		if(FinalExplosions <= 2){
			BossDestroyed = true;
		}		
	}
	
	alarm[3] = 8;
	
}