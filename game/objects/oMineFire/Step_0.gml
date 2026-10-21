if(Setup){
	LightIndex = Lighting_CreateLight(RoomIndex, x + (sprite_width / 2), y + (sprite_height / 2), 1.0, [0.7, 0.3, 0.3]);
	Setup = false;
}

Lighting_UpdateLight_Radius(RoomIndex, LightIndex, 2.0 + (image_index / 8) - (image_index >= 2 ? (image_index - 2) / 4 : 0))
