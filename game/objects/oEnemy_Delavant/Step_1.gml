switch(State){
	
	case EnemyState.Shooting:
		if(distance_to_object(oLink) <= 16){
			var Angle = point_direction(oLink.x, oLink.y - 6, x, y);
			oLink.x += lengthdir_x(0.2, Angle);
			oLink.y += lengthdir_y(0.2, Angle);
		}
		break;

}