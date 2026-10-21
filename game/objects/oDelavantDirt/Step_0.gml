switch(State){
	case EnemyState.Wake:	
		sprite_index = sDelavantDirt_Reveal;
		image_speed = 1;
		break;
		
	case EnemyState.Shooting:
		sprite_index = sDelavantDirt;
		image_speed = 1;
		break;
		
	case EnemyState.Sleep:
		sprite_index = sDelavantDirt_Reveal;
		image_speed = -1;
		break;

	case EnemyState.Frozen:
	case EnemyState.OnFire:
	case EnemyState.Stone:
		image_speed = 0;
		break;
		
}
