
//vx += Delta_vx;
//vy += Delta_vy;

x += vx;
y += vy;


//if (y > room_height + sprite_height) OutOfBounds = true;

//image_angle = (image_angle + RotateV) mod 360;

//if(Damaged != 0){
//	Energy -= Damaged;
	
//	Damaged = 0;
//	if(Energy <= 0){
				
//		if(MultiExplosion){
//			var inst = instance_create_depth(x, y, -500, oExplosionMulti);
//			inst.ExplosionObj = ExplosionObj;
//			inst.Spacing = MultiExplosionSpacing;
//			inst.alarm[1] = MultiExplosionLength;
//			//Multi Explosion object is responsible for destroying object after.
//			inst.Obj = self;
//			visible = false;
//			Harmless = true;
//		}else{
//			var inst = instance_create_depth(x, y, -500, ExplosionObj);
//			inst.vx = vx;
//			inst.vy = vy;
//			Destroyed = true;
//		}
		

//		//DestroyAfterExplosion = true;
		
//		if(CanSpawnBonusItem){
//			if(irandom_range(0, 8) == 1) scr_Powerup_Generate(x, y, choose(-0.5, 0.5), 0.5);
//		}
			
//		scr_AddScore(Points);
		

		
//	}else alarm[11] = 3;
//}

