switch(State){
	
	case 0:
		x += vx;
		ObjSetY(y_base + vy);
		vz += g;
		z += vz;

		if(z <= 0){
			z = 0;
			State = 1;
			sprite_index = sZora_Splash2;
		}
		break;
		
	case 1:
		if(image_index >= image_number - 1) instance_destroy(self);
		break;
	
}