PauseObj

if(!Spark && image_index >= 3 && image_index < 5){
	instance_create_layer(x + 22 - (Flip ? 44 : 0), y + 14, "ObjsHigher_" + FloorLevelStr, oWallHit, {PlaySound: distance_to_object(oLink) < 220});
	Spark = true;
}

if(!Pause && image_index >= 6){
	ObjSetImageSpeed(0);
	alarm[0] = irandom_range(1, 10);
	Pause = true;
	
}

