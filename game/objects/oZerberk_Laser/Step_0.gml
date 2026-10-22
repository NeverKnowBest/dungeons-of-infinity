x += vx;
y += vy;

	
if(Destroyed) exit;

if(!Zerberk_InLevel(x, y)){
	Destroyed = true;
	alarm[0] = 1;
	exit;
}


if(Zerberk_WallCollisionX(id) || Zerberk_WallCollisionY(id)){
	instance_destroy(id);
	exit;
}


var inst;
switch(From){
	
	case 0: //Hero
		inst = instance_place(x, y, oZerberk_Robot)
		if(inst != noone){
			global.Arcade_ActiveInst.Score += inst.Points;
			inst.Destroyed = true;
			Destroyed = true;
			alarm[0] = 1;
		}	
		break;
		
	case 1: //robot
		
		if(oZerberk_Hero.Dead) break;
		
		inst = instance_place(x, y, oZerberk_Hero)
		if(inst != noone){
			Zerberk_Hero_Death();
			Destroyed = true;
			alarm[0] = 1;
		}		
		break;
}




