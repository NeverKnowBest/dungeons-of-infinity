event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Shooting);
}

if(instance_exists(DirtInst)){
	DirtInst.State = State;
}

PauseCheck



switch(State){
	
	case EnemyState.Idle:
		if(AllowSpawn && distance_to_object(oLink) <= 48){
			DirtInst = instance_create_layer(x, y, layer, oDelavantDirt);
			DirtInst.depth = depth + 5;
			alarm[0] = 80;
			AllowSpawn = false;
		}		
		break;
	
	case EnemyState.Wake:
		if(image_index >= image_number - 0.1){
			Enemy_UpdateState(EnemyState.Shooting);
		}		
		break;

		
	case EnemyState.Shooting:

		break;
	
	case EnemyState.Sleep:
		if(image_index <= 0.1){
			image_index = 0;
			Visible = false;
		}
		if(DirtInst.image_index <= 0.1){
			instance_destroy(DirtInst);
			Enemy_UpdateState(EnemyState.Idle);
		}
			
		break;
	
	case EnemyState.Frozen:
	case EnemyState.OnFire:
	case EnemyState.Stone:
		DirtInst.image_speed = 0;
		break;
}

