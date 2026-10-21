event_inherited();


if(KnockBackDone){ //this only occurs if there's still energy left after knockback
	
	Enemy_UpdateState(oBoss_Armos_C.State);
	
	switch(oBoss_Armos_C.State){
		
		case EnemyState.Jumping:
			Armos_Waypoints_Calculate(id);
			break;
			
		case EnemyState.Shooting:
			vx = 0;
			vy = 0;
			Hit_Allowed = false;
			CanHurtLink = false;
			break;
	}
	
	
}
if(PreDestroyed){ //this only occurs if enemy will be destroyed, KnockBackDone above is not called
					
	oBoss_Armos_C.ArmosStatus[ID] = false;
	oBoss_Armos_C.ArmosLeft--;
	oBoss_Armos_C.LastArmos_X = x;
	oBoss_Armos_C.LastArmos_Y = y_base;
	
	if(oBoss_Armos_C.ArmosLeft == 1){
		with(oBoss_Armos){
			if(oBoss_Armos_C.ArmosStatus[ID]){
				Enemy_SetEnergy(global.EnemyData[object_index].EnergyIndex);
				oBoss_Armos_C.LastArmos_Inst = id;
				image_index = 1;
				break;
			}
		}
	}

	if(oBoss_Armos_C.ArmosLeft <= 0){
		with(oCape){
			instance_destroy(id);
		}	
	}
		
	PreDestroyed = false;
			
}

PauseCheck



			