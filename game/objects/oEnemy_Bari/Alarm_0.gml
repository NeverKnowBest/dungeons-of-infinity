/// @description Shock State
CanShock = !CanShock;

if(CanShock){
	vx = 0;
	vy = 0;	
	Enemy_UpdateSprite(EnemyState.Shock);
}else{
	Enemy_UpdateSprite(EnemyState.Walking);
}


alarm[0] = irandom_range(120, 200);
