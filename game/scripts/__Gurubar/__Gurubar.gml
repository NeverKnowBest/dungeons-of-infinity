function Gurus_GetType(){
	
	return LevelDef.GuruBarType;
	
}

function Gurus_Update(){

	for(var i = 0; i < GuruCount; i++){
		if(!instance_exists(GuruInst[i])) continue;
		GuruInst[i].State = State;
		GuruInst[i].x = CenterX + lengthdir_x(BlockSeperation + (i * SeperationDist), Angle);
		GuruInst[i].y_base = CenterY + lengthdir_y(BlockSeperation + (i * SeperationDist), Angle);
		GuruInst[i].y = GuruInst[i].y_base;
		Lighting_UpdateLight_Visible(RoomIndex, GuruInst[i].LightIndex, State == EnemyState.Walking);
		Lighting_UpdateLight_Pos(RoomIndex, GuruInst[i].LightIndex, GuruInst[i].x, GuruInst[i].y);
		Lighting_UpdateLight_Radius(RoomIndex, GuruInst[i].LightIndex, choose(0.5, 0.51, 0.52, 0.53, 0.54, 0.55, 0.56, 0.57, 0.58));
	}

}

function Gurus_Destroy(){
	
	for(var i = 0; i < GuruCount; i++){
		if(!instance_exists(GuruInst[i])) continue;
		instance_destroy(GuruInst[i]);
	}

	GuruInst = [];
	GuruCount = 0;
	GurusDestroyed = true;
	
}