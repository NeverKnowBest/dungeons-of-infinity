event_inherited();


if(!OnWaterTile(TMID, x + vx, y)){
	if(Timeout) WallCollide_X = true;
	else vx *= -1;
	
}
if(!OnWaterTile(TMID, x, y + vy)){
	if(Timeout) WallCollide_Y = true;
	else vy *= -1;
}

if(State == EnemyState.KnockBack || (Timeout && (WallCollide_X || WallCollide_Y))){
	instance_destroy(id);
	instance_create_layer(x, y, layer, oEnemy_Kyameron_Exploding);
	if(State == EnemyState.KnockBack){
		with(ParentInst) alarm[0] = IdleTime;
	}
	exit;
}

PauseCheck