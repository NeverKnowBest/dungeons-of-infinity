event_inherited(); 

if(KnockBackDone){
	
	Enemy_UpdateState(EnemyState.Shooting);
	
	//this is the delay that extends the mace when activated, so if he's pushed in a corner an repeadly hit, this counter will go down very slowly since its paused during knockback.
	//So reduce the alarm manually if he's spinning and alarm is current counting down
	if(WeaponInst.Spin){
		alarm[2] -= 20; 
		if(alarm[2] <= 1){
			if(!WeaponInst.SpinExtend && !WeaponInst.SpinContract) WeaponInst.SpinExtend = true;
			alarm[2] = -1;
		}
	}
	//if(!WeaponInst.Spin) alarm[3] = IdleDelay;

}

PauseCheck

switch(State){
	
	case EnemyState.Standing:
		if(!oLink.Cape && distance_to_object(oLink) <= LinkNotVisibleDist){
			Enemy_UpdateState(EnemyState.Walking);
			Soldier_UpdateDir(DirFaceLink());
		}		
		break;
		
	case EnemyState.Shooting:
		if(!oLink.Cape) Soldier_UpdateDir(DirFaceLink());
		break;

	case EnemyState.Walking:
		
		if(oLink.Cape){
			Enemy_UpdateState(EnemyState.Standing);
			break;
		}
		
		if(SpinAllowed && distance_to_object(oLink) <= SpinStartDist){
			Enemy_UpdateState(EnemyState.Shooting);
			break;
		}
		
		if(!Strafe){
			
			if(Dir == UP || Dir == DOWN){
				if(WallCollide_Y){
					if(x <= oLink.x){
						StrafeDir = RIGHT;
						vx = WalkSpeed;
					}else{
						StrafeDir = LEFT;
						vx = -WalkSpeed;						
					}
					Strafe = true;
				}
				
			}else if(Dir == LEFT || Dir == RIGHT){
				if(WallCollide_X){
					if(y <= oLink.y){
						StrafeDir = DOWN;
						vy = WalkSpeed;
					}else{
						StrafeDir = UP;
						vy = -WalkSpeed;						
					}
					Strafe = true;

				}
				
			}

			if(Strafe){
				alarm[1] = StrafeTime;
				//Cancel dir alarm
				alarm[0] = -1;	
			}

		}
		
		if(Strafe){

			switch(StrafeDir){
				case LEFT:
					//if strafing left or right, and Link is now to the right or left, cancel strafing and update running dir
					if(!WallCollide_Y){
						Soldier_Advanced_UpdateRunningDir(false);
						Strafe = false;
					}else{
						if(WallCollide_X){
							StrafeDir = RIGHT;
							vx = WalkSpeed;
						}
						vy = Dir == DOWN ? WalkSpeed : -WalkSpeed;
					}
					break;
					
				case RIGHT:
					//if strafing left or right, and Link is now to the right or left, cancel strafing and update running dir
					if(!WallCollide_Y){
						Soldier_Advanced_UpdateRunningDir(false);
						Strafe = false;
					}else{
						if(WallCollide_X){
							StrafeDir = LEFT;
							vx = -WalkSpeed;
						}
						vy = Dir == DOWN ? WalkSpeed : -WalkSpeed;
					}
					break;	

				case UP:
					if(!WallCollide_X){
						Soldier_Advanced_UpdateRunningDir(false);
						Strafe = false;
					}else{
						if(WallCollide_Y){
							StrafeDir = DOWN;
							vy = WalkSpeed;
						}
						vx = Dir == RIGHT ? WalkSpeed : -WalkSpeed;
					}
					break;

				case DOWN:
					//if strafing left or right, and Link is now to the right or left, cancel strafing and update running dir
					if(!WallCollide_X){
						Soldier_Advanced_UpdateRunningDir(false);
						Strafe = false;
					}else{
						if(WallCollide_Y){
							StrafeDir = UP;
							vy = -WalkSpeed;
						}
						vx = Dir == RIGHT ? WalkSpeed : -WalkSpeed;
					}
					break;	
					
			}
		}
		break;
		

}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 20;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 22;
		break;	
}