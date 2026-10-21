event_inherited();

if(KnockBackDone || StunDone){

	var _FaceLinkDir = DirFaceLink();
	
	switch(Type){
		case 0:
			Enemy_UpdateState(EnemyState.Walking);
			Goriya_UpdateDir(OppositeDir(_FaceLinkDir));
			break;
			
		case 1:
			Enemy_UpdateState(EnemyState.Standing);
			Dir = _FaceLinkDir;
			Enemy_UpdateSprite(State);
			OpenMouth = true;
			alarm[0] = -1; 
			alarm[1] = 10;
			alarm[3] = -1;
			break;
	}
	
	
	
}

PauseCheck

var _LinkActive = (!oLink.Cape && oLink.State != LinkState.Falling);

if(State == EnemyState.Walking){

	VX_Extra = 0;
	VY_Extra = 0;	

	Enemy_UpdateV(Speed);	
	
	if(_LinkActive){
		
		switch(Type){
	
			case 0: //green
				var _DirFromLink = point_direction(oLink.x, oLink.y, x, y);
				VX_Extra = lengthdir_x(0.25, _DirFromLink);
				VY_Extra = lengthdir_y(0.25, _DirFromLink);
				break;

			case 1: //red
				var _DirToLink = point_direction(x, y, oLink.x, oLink.y);
				VX_Extra = lengthdir_x(0.25, _DirToLink);
				VY_Extra = lengthdir_y(0.25, _DirToLink);
		
				break;
		}
	
		vx += VX_Extra;
		vy += VY_Extra;
		
	}
	
	if(WallCollide_X && (Dir == LEFT || Dir == RIGHT)) Goriya_UpdateDir(choose(OppositeDir(Dir), Enemy_WallCollisionNewDir(HORIZONTAL)));
	if(WallCollide_Y && (Dir == UP || Dir == DOWN)) Goriya_UpdateDir(choose(OppositeDir(Dir), Enemy_WallCollisionNewDir(VERTICAL)));
		
}


if(Type == 1 && _LinkActive){
	
	var LinkInSight = Enemy_LinkInSight(Dir, SightOffset, SightDist);
	
	if(!OpenMouth && CanShoot && LinkInSight){	
		Enemy_UpdateState(EnemyState.Standing);
		OpenMouth = true;
		alarm[0] = 30;
		alarm[1] = 20;
		alarm[3] = -1;
	}
			
}
