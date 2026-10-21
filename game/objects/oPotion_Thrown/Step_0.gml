

if(!ThrownInit){
	x = oLink.x;
	y = oLink.y - 1;
	z = 18;
	vz = 1.5;
	//mask_index = sBomb;
	switch(oLink.Facing){
		case UP: vy = -Speed; break;
		case DOWN: vy = Speed; break;
		case LEFT: vx = -Speed; break;
		case RIGHT: vx = Speed; break;
	}
		
	ThrownInit = true;
}



x += vx;
y += vy;

vz += g;
z += vz;



if(z <= 0){
	
	switch(PotionType){
		case PotionThrown.Treasure:	
			ItemExplosion(x, y);
			break;
		
	}
	
	instance_create_layer(x, y - 8, "ObjsHigher_Upper", oPoof);
	
	instance_destroy(self);			

}

//event_inherited();
//if(WallCollided){
//	vx *= -0.2;
//	vy *= -0.2;
//	WallCollided = false;
//}
