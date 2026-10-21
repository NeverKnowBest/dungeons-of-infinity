event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);	
}

PauseCheck

if(WallCollide_X){
	DirX *= -1;
	LookDir *= -1;
}
if(WallCollide_Y) DirY *= -1;
		
switch(State){
	
	case EnemyState.Idle:
		
		var InEnemyArea = false;
		for(var i = 0; i < EnemyAreasInTemplate; i++){
			if(point_in_rectangle(oLink.x, oLink.y, SpawnAreas[# 0, i], SpawnAreas[# 1, i], SpawnAreas[# 2, i], SpawnAreas[# 3, i])){
				InEnemyArea = true;
				break;
			}
		}
		if(!oLink.InDoor && InEnemyArea && !oLink.Cape && point_distance(x, y_base, oLink.x, oLink.y) <= 24 && FloorLevel == oLink.FloorLevel) 
			Enemy_UpdateState(EnemyState.Wake);	
		break;
	
	case EnemyState.Wake:
		if(image_index >= image_number - 0.1){
			Enemy_UpdateState(EnemyState.Jumping);	
		}
		break;
	
	case EnemyState.Jumping:
		if(JumpLanded) Enemy_UpdateState(EnemyState.Walking);	
		break;
		

}