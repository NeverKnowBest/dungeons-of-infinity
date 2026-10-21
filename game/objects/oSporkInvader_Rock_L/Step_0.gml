event_inherited();

if(Destroyed){
	
	//Spawn smaller rocks
	switch choose(2,2,2,3,3){
		case 2:
			var inst = instance_create_depth(x-8,y, -400, oRock_S);	
			inst.vx = random_range(-0.25, -1);
			inst.vy = random_range(0.2, 1);
			inst = instance_create_depth(x+8,y, -400, oRock_S);	
			inst.vx = random_range(0.25, 1);
			inst.vy = random_range(0.2, 1);			
			break;
			
		case 3:
			var inst = instance_create_depth(x-8,y, -400, oRock_S);	
			inst.vx = random_range(-0.25, -1);
			inst.vy = random_range(0.2, 1);
			inst = instance_create_depth(x,y, -400, oRock_S);	
			inst.vx = random_range(-0.2, 0.2);
			inst.vy = random_range(0.2, 1);					
			inst = instance_create_depth(x+8,y, -400, oRock_S);	
			inst.vx = random_range(0.25, 1);
			inst.vy = random_range(0.2, 1);			
			break;
	

	}
	
	
	//Create gems
	//if(irandom_range(0, 50) == 0){ //gem lottery
	//	repeat(irandom_range(20, 40)){
	//		inst = instance_create_depth(x + random_range(-15,15), y + random_range(-15,15), -400, choose(oGemS, oGemS, oGemS, oGemS, oGemS, oGemM, oGemM, oGemL, oGemL))
	//		inst.vx = random_range(0,0.2);
	//		inst.vy = random_range(0, 0.25);		
	//	}
	//}else{
	//	repeat(choose(0,0,0,irandom_range(1, 5))){
	//		inst = instance_create_depth(x + random_range(-12,12), y + random_range(-12,12), -400, oGemL)
	//		inst.vx = random_range(0,0.2);
	//		inst.vy = random_range(0, 0.25);		
	//	}
	//	repeat(choose(0,0,0,irandom_range(1, 8))){
	//		inst = instance_create_depth(x + random_range(-12,12), y + random_range(-12,12), -400, oGemM)
	//		inst.vx = random_range(0,0.2);
	//		inst.vy = random_range(0, 0.25);				
	//	}
	//	repeat(choose(0,0,0,irandom_range(1, 12))){
	//		inst = instance_create_depth(x + random_range(-12,12), y + random_range(-12,12), -400, oGemS)
	//		inst.vx = random_range(0,0.2);
	//		inst.vy = random_range(0, 0.25);	

	//	}
	//}			
}
