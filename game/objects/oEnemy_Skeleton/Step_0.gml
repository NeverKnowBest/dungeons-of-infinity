// Feather disable GM2064
event_inherited(); 

if(KnockBackDone || StunDone){
	switch(Type){
		case 0:
			NextDir = DirFaceLink();
			Enemy_UpdateState(EnemyState.Walking);
			break;
		case 1: 
			Enemy_UpdateState(EnemyState.Shooting);
			break;
	}

}

PauseCheck

if(State != EnemyState.Jumping && oLink.Action[ActionKey.Sword] && FloorLevel == oLink.FloorLevel && !oLink.Cape){

	if(distance_to_object(oSword) <= 9) Enemy_UpdateState(EnemyState.Jumping);
	
}

switch(State){

	case EnemyState.Walking:
		if(WallCollide_X) Skeleton_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Skeleton_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
		break;
	
	case EnemyState.Jumping:
		if(JumpLanded){ 
			switch(Type){
				case 0:
					Enemy_UpdateState(EnemyState.Standing);
					break;
				case 1: 
					Enemy_UpdateState(oLink.Cape ? EnemyState.Standing : EnemyState.Shooting);
					break;
			}
			layer = WalkingLayer;

		}
		break;
		
	case EnemyState.Shooting: 
		if(Shoot){
			ObjSetImageSpeed(0);
			switch(image_index){
				case 0: image_index = 1; break;
				case 1: image_index = 0; break;
				case 2:
					sprite_index = sEnemy_SkeletonBody_Walking_Left;	
					image_index = 1;
					break;
				case 3:
					sprite_index = sEnemy_SkeletonBody_Walking_Right;	
					image_index = 1;
					break;
			}
			instance_create_layer(x, y - 4, "ObjsHigher_" + GetFloorLevelString(x, y), oBone, {FloorLevel: FloorLevel, ColorIndex: Type});
			alarm[1] = 30;
			Shoot = false;
		}
		break;
}
