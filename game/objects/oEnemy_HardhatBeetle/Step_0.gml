event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}


if(Hit_Started){
	
	if(Hit_LinkWeaponClass == LinkWeaponClass.Sword){
		if(!SwordLevel(Swords.Master) && !StopWatch && State != EnemyState.Frozen){
			var D = point_direction(x, y, oLink.x, oLink.y);
			with(oLink){ 
				if(State != LinkState.Star) LinkBounceBack(D, 2.5, 8);
			}
		}
	}
		
	
}

PauseCheck



switch(State){

	case EnemyState.Walking:
		
		var _Speed = (oLink.Cape || oLink.InDoor_Full ? 0 : Speed);
		var LinkDir = point_direction(x, y, oLink.x, oLink.y);
		vx = lengthdir_x(_Speed, LinkDir);
		vy = lengthdir_y(_Speed, LinkDir);
		
		break;
	
}