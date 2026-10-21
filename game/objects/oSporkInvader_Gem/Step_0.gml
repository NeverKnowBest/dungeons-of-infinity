//if(oHero.Hero_State != oHero.State.Death){;
	var inst = instance_nearest(x, y, oSporkInvaders_Ship)
	var d = distance_to_object(inst);
	if(d < MagnetD){
		MagnetV+=0.1;
		if(MagnetV > 3) MagnetV = 3;
		Vector_vx_vy(self, x, y, oSporkInvaders_Ship.x, oSporkInvaders_Ship.y, MagnetV);		
	}	
//}

x+=vx;
y+=vy;


if(OutOfBounds(self)) instance_destroy(self);