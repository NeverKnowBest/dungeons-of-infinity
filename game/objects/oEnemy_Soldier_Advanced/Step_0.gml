event_inherited(); 


if(KnockBackDone || PushbackDone || StunDone){
	Enemy_UpdateState(EnemyState.Running);
	Soldier_UpdateDir(DirFaceLink());
}

PauseCheck


switch(State){
	
	case EnemyState.Standing:
		if(Enemy_LinkInSight(HeadDir, SightOffset, SightDist)) Enemy_UpdateState(EnemyState.Alerted);
		break;
		
	case EnemyState.Walking:
		if(WallCollide_X){
			Soldier_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
			Soldier_UpdateWeaponSprite();
		}
		if(WallCollide_Y){
			Soldier_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
			Soldier_UpdateWeaponSprite();
		}
		if(Enemy_LinkInSight(HeadDir, SightOffset, SightDist)) Enemy_UpdateState(EnemyState.Alerted);
		break;
		
	case EnemyState.Running:
		
		if(oLink.Cape){
			Enemy_UpdateState(EnemyState.Standing);
			break;
		}
		

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

			if(Strafe) alarm[1] = StrafeTime;

		}
		
		var _UpdateDir = false;
		
		if(Strafe){			
			
			switch(StrafeDir){
				case LEFT:

					if(WallCollide_Y){
						if(WallCollide_X){
							StrafeDir = RIGHT;
							vx = RunSpeed;
						}
						vy = Dir == DOWN ? RunSpeed : -RunSpeed;
					}else{
						_UpdateDir = true;
					}
					break;
					
				case RIGHT:

					if(WallCollide_Y){
						if(WallCollide_X){
							StrafeDir = LEFT;
							vx = -RunSpeed;
						}
						vy = Dir == DOWN ? RunSpeed : -RunSpeed;
					}else{
						_UpdateDir = true;
					}
					break;	

				case UP:
					if(WallCollide_X){
						if(WallCollide_Y){
							StrafeDir = DOWN;
							vy = RunSpeed;
						}
						vx = Dir == RIGHT ? RunSpeed : -RunSpeed;
					}else{
						_UpdateDir = true;
					}
					break;

				case DOWN:

					if(WallCollide_X){
						if(WallCollide_Y){
							StrafeDir = UP;
							vy = -RunSpeed;
						}
						vx = Dir == RIGHT ? RunSpeed : -RunSpeed;
					}else{
						_UpdateDir = true;
					}
					break;	
					
			}

			
		
			//check if soldier is running away from link, if so update his dir
			switch(Dir){
				case UP:
					if(y < oLink.y) _UpdateDir = true;
					break;
				case DOWN:
					if(y > oLink.y) _UpdateDir = true;
					break;
				case LEFT:
					if(x < oLink.x) _UpdateDir = true;
					break;
				case RIGHT:
					if(x > oLink.x) _UpdateDir = true;
					break;
			
			}
		
			if(_UpdateDir){
				Soldier_Advanced_UpdateRunningDir();
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