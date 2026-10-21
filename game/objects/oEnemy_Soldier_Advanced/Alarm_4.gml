/// @description Walking change direction


switch(Dir){
	case LEFT: 
	case RIGHT: Soldier_UpdateDir(choose(UP, DOWN)); break;
	case UP: 
	case DOWN: Soldier_UpdateDir(choose(LEFT, RIGHT)); break;		
}
Soldier_UpdateWeaponSprite();
alarm[4] = irandom_range(60, 400);
