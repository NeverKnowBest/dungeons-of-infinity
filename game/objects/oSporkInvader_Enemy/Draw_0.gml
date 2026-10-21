//if(alarm[11] != -1){
    
//	shader_set(shdHit);
//	draw_sprite_ext(sprite_index, image_index, x, y, FlipH, FlipV, image_angle, -1, 1);
//	shader_reset();

//}
//else{
	
//	//if(Rock){
//	//	draw_sprite_ext(sprite_index, image_index, x, y, FlipH, FlipV, image_angle, RockColor, Opacity);
//	//}else{
		
//		draw_sprite_ext(sprite_index, image_index, x, y, FlipH, FlipV, image_angle, -1, Opacity);
//	//}
	
//}

draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), FlipH, FlipV, 0, -1, 1);