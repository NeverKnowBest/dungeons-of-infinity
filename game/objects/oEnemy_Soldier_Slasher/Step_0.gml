event_inherited(); 

if(KnockBackDone || PushbackDone || StunDone){
	Enemy_UpdateState(EnemyState.Running);
	Soldier_UpdateDir(DirFaceLink());
}

PauseCheck


switch(State){

	case EnemyState.Running:
		

		if(!Strafe){
			
			if(Dir == UP || Dir == DOWN){
				if(WallCollide_Y){
					if(x <= oLink.x){
						StrafeDir = RIGHT;
						vx = RunSpeed;
					}else{
						StrafeDir = LEFT;
						vx = -RunSpeed;						
					}
					Strafe = true;
				}
				
			}else if(Dir == LEFT || Dir == RIGHT){
				if(WallCollide_X){
					if(y <= oLink.y){
						StrafeDir = DOWN;
						vy = RunSpeed;
					}else{
						StrafeDir = UP;
						vy = -RunSpeed;						
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
						Soldier_Advanced_UpdateRunningDir();
						Strafe = false;
					}else{
						if(WallCollide_X){
							StrafeDir = RIGHT;
							vx = RunSpeed;
						}
						vy = Dir == DOWN ? RunSpeed : -RunSpeed;
					}
					break;
					
				case RIGHT:
					//if strafing left or right, and Link is now to the right or left, cancel strafing and update running dir
					if(!WallCollide_Y){
						Soldier_Advanced_UpdateRunningDir();
						Strafe = false;
					}else{
						if(WallCollide_X){
							StrafeDir = LEFT;
							vx = -RunSpeed;
						}
						vy = Dir == DOWN ? RunSpeed : -RunSpeed;
					}
					break;	

				case UP:
					if(!WallCollide_X){
						Soldier_Advanced_UpdateRunningDir();
						Strafe = false;
					}else{
						if(WallCollide_Y){
							StrafeDir = DOWN;
							vy = RunSpeed;
						}
						vx = Dir == RIGHT ? RunSpeed : -RunSpeed;
					}
					break;

				case DOWN:
					//if strafing left or right, and Link is now to the right or left, cancel strafing and update running dir
					if(!WallCollide_X){
						Soldier_Advanced_UpdateRunningDir();
						Strafe = false;
					}else{
						if(WallCollide_Y){
							StrafeDir = UP;
							vy = -RunSpeed;
						}
						vx = Dir == RIGHT ? RunSpeed : -RunSpeed;
					}
					break;	
					
			}
		}
		break;
}

