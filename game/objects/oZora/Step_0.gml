if(Done) exit;

if(Emerged && !Talking){
	
	if(image_index >= 1){
		image_index = 1;
		image_speed = 0;
	}

	Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);

}


	
if(Talking && !instance_exists(global.DB_Inst)){
	Done = true;
	image_index = 1;
	alarm[4] = 30;
}