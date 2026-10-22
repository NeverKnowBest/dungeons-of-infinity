event_inherited();

EyeX = Beamos_EyeX();
EyeY = Beamos_EyeY();

if(Hit_Started && State == EnemyState.KnockBack){
	instance_destroy(WallInst);
	exit;
}
	
PauseCheck


//in SpawnEnemies(), it checks for walls to place enemies, so the wall can't be created in the create event since it will detect that wall and never find a good spot
//Any enemies that need walls should do it this way
if(WallInit){
	WallInst = WallObj_Create("ObjsHigher_" + FloorLevelStr, x - 8, y - 16, 2, 2);
	WallInst.IsEnemy = true;
	WallInit = false;
}


if(CanShoot && oCamera.InView(EyeX, EyeY) && !oLink.Cape){
	
	//check for wall in between Link
	ClosestWall = SightDistance;
	for(var i = 1; i < SightDistance / 4; i++){
		ClosestWallPosX = EyeX + lengthdir_x(i * 4, EyeA);
		ClosestWallPosY = EyeY + lengthdir_y(i * 4, EyeA);
		var _WallInst = collision_point(ClosestWallPosX, ClosestWallPosY, oWall, false, true);
		if(_WallInst != noone){
			if(_WallInst != WallInst && (_WallInst.BlockProjectiles || _WallInst.IsDoorEntrance)){
				ClosestWall = point_distance(EyeX, EyeY, ClosestWallPosX, ClosestWallPosY);
				break;
			}
		}
	}
	
	var DistToLink = point_distance(EyeX, EyeY, oLink.x, oLink.y - 6);
	AngleToLink = point_direction(EyeX, EyeY, oLink.x, oLink.y - 6);
	
	if(DistToLink <= SightDistance && DistToLink < ClosestWall && abs(angle_difference(EyeA, AngleToLink)) <= 4){
		Flashing = true;
		EyeMove = false;
		CanShoot = false;
		audio_play_sound(Sound_Medusa, 1, false);
		alarm[2] = FlashSpeed;
	}
}

var NewPointX, NewPointY;
if(Shooting){

	repeat(3){
		NewPointX = LaserPointsX[LaserPoints - 1] + lengthdir_x(LaserPointSpacing, AngleToLink);
		NewPointY = LaserPointsY[LaserPoints - 1] + lengthdir_y(LaserPointSpacing, AngleToLink);
		array_push(LaserPointsX, NewPointX);
		array_push(LaserPointsY, NewPointY);
		array_push(LaserLights, Lighting_CreateLight(RoomIndex, NewPointX, NewPointY, 0.09, [0.9,0.2,0.2]));
		
		LaserPoints++;
	}

	for(var i = 0; i < Beamos_Laser_MinPoint(); i++){
		Lighting_UpdateLight_Visible(RoomIndex, LaserLights[i], false);
	}
	
	if(collision_point(NewPointX, NewPointY, oLink, false, true) != noone){
		with(oLink){
			if(!Shield_Hit(other.id, NewPointX, NewPointY)){
				LinkHit(other.AngleToLink, 4, 16, other.Attack);
			}
		}
		Beamos_Laser_Hit(NewPointX, NewPointY);
		exit;
	}	
	var _WallInst = collision_point(NewPointX, NewPointY, oWall, false, true);
	if(_WallInst != noone){
		if(_WallInst != WallInst && (_WallInst.BlockProjectiles || _WallInst.IsDoorEntrance)){
			Beamos_Laser_Hit(NewPointX, NewPointY);
			exit;
		}
	}
		

	
}