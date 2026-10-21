


var Probability = 0.05;

if(random(1) <= Probability){

	var _x = irandom_range(8, global.Arcade_ActiveInst.CamW - 8);
	var _y = global.Arcade_ActiveInst.CamY - 20;	
	var size = 0;//choose(0,0,0,1,1); //0=small, 1=large
	var dir = -sign(_x - (global.Arcade_ActiveInst.CamW / 2));
	
	switch(size){

		case 0:
			var inst = instance_create_layer(_x, _y, "Arcade_Objs2", oSporkInvader_Rock_S);
			inst.vy = random_range(-0.5, 0);
			inst.vx	= choose(0, 0.1, 0.2, 0.25) * dir;
			break;
		
		case 1:
			var inst = instance_create_depth(_x, _y, -400, oSporkInvader_Rock_L);
			inst.vy = random_range(0.25, 1);
			inst.vx	= random_range(0, 0.5) * dir;
			break;
		
	}
	
}







