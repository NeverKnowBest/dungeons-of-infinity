event_inherited();

if(Hit_Started){
	instance_destroy(WallInst);
	exit;
}

//in SpawnEnemies(), it checks for walls to place enemies, so the wall can't be created in the create event since it will detect that wall and never find a good spot
//Any enemies that need walls should do it this way
if(WallInit){
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, x - 8, y - 8, 2, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	WallInst.IsEnemy = true;
	WallInit = false;
}



if(ShootReady && oLink.State == LinkState.Sword && !StopWatch && State != EnemyState.Stone && State != EnemyState.Frozen){
	
	var Dir = DirFaceLink();
	
	var ShotX = x;
	var ShotY = y;
	
	switch(Dir){
		case UP:  ShotY -= 8; break;
		case DOWN: ShotY += 8; break;
		case LEFT: ShotX -= 8; break;
		case RIGHT: ShotX += 8;	break;		
	}

	var inst = instance_create_layer(ShotX, ShotY, "ObjsHigher_" + FloorLevelStr, oRedBall);
	var Angle = DirAngle(Dir);
	inst.vx = lengthdir_x(2, Angle);
	inst.vy = lengthdir_y(2, Angle);
	if(oCamera.InView(ShotX, ShotY)) audio_play_sound_stopall(Sound_Medusa);

	ShootReady = false;
}

if(!ShootReady && oLink.State != LinkState.Sword) ShootReady = true;