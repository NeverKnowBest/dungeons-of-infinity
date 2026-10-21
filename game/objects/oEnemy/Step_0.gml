
if(CheckForWater){
	InWater = OnWaterTile(FloorLevel == UPPER ? global.TMID_Water_Upper : global.TMID_Water_Lower, x, y_base);
}

if(global.Paused) exit;

JumpLanded = false;
if(GravityStatus && Gravity != 0){
	
	vz += Gravity;
	if(vz < -10) vz = -10;
	z += vz	
	
	if(z <= 0){
		z = 0;
		vz = 0;
		GravityStatus = false;
		JumpLanded = true;
	}
}

if(State == EnemyState.Stone){
	vx = 0;
	vy = 0;
	ObjSetImageSpeed(0);
}

OldPosX = x;
OldPosY = y_base;
var CollisionSuccess = true;
var _ContainInRoomBounce = (ContainInRoomBounce && State != EnemyState.KnockBack);

if(!IgnoreWalls) CollisionSuccess = WallCollision(CollidedWallList, vx, 0, oWall);	
WallCollide_X = (ds_list_size(CollidedWallList) > 0);
if(WallCollide_X){
	if(State != EnemyState.KnockBack && WallCollide_Bounce)
		vx *= -WallCollide_Bounce_NewVFactor;
	else{
		vx = 0;
	}
}

//for enemies that fly around randomly, we have to check if they go out of bounds. If so, bounce them back in
if(oCamera.RoomTransition == NONE && ContainInRoom){
	if(x + vx <= global.CurrentRoomX + 16 || x + vx >= global.CurrentRoomX + global.CurrentRoomW - 16){
		
		vx = vx * (_ContainInRoomBounce ? -WallCollide_Bounce_NewVFactor : 0);
			
		WallCollide_X = true;
	}
}


x += vx;


if(!IgnoreWalls) CollisionSuccess = WallCollision(CollidedWallList, 0, vy, oWall);
WallCollide_Y = (ds_list_size(CollidedWallList) > 0);
if(WallCollide_Y){
	if(State != EnemyState.KnockBack && WallCollide_Bounce)
		vy *= -WallCollide_Bounce_NewVFactor;
	else{
		vy = 0;
	}
}

//for enemies that fly around randomly, we have to check if they go out of bounds. If so, bounce them back in
if(oCamera.RoomTransition == NONE && ContainInRoom){
	if(y_base + vy <= global.CurrentRoomY + 16 || y_base + vy >= global.CurrentRoomY + global.CurrentRoomH - 16){
		vy = vy * (_ContainInRoomBounce ? -WallCollide_Bounce_NewVFactor : 0);
		WallCollide_Y = true;
	}
}

ObjSetY(y_base + vy);

if(!CollisionSuccess){
	//got stuck in the wall, very rare case. Set obj to old position and kill it
	x = OldPosX;	
	ObjSetY(OldPosY);
	var inst = instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHighest", oEnemy_Destroy);
	Destroyed = true;
	instance_destroy(id);
	exit;
}

if(instance_exists(OnFireInst)){
	OnFireInst.x = x;
	OnFireInst.y = y - 2;
}
		

if(Hit_AllowedTimer > 0){
	Hit_AllowedTimer--;
	if(Hit_AllowedTimer <= 0){
		Hit_Allowed = true;
		Hit_AllowedTimer = 0;
	}
}

Hit_Started = false;
KnockBackDone = false; //these turn true when these states are done to signal the children in their step function so they can change to whatever state they need to 
PushbackDone = false;
StunDone = false; 
ShockDone = false;
PreDestroyed = false;

Enemy_CheckHit();

switch(State){
	
	case EnemyState.Shock:
		ShockCounter--;		
		if(ShockCounter == 0) ShockDone = true;

		break;
		
	case EnemyState.Stunned:
		
		StunCounter--;
	
		if(StunCounter <= 60) StunnedShake = true;

		if(StunnedShake){
			x += StunnedShakeDir;
			if(x >= StunnedShakeIniX + 1 || x <= StunnedShakeIniX - 1) StunnedShakeDir *= -1;	
		}
	
		if(StunCounter == 0){
			StunnedStart = false;
			StunnedShake = false;
			UnStunWhenHit = false;
			StunDone = true;
		}
		
		break;
	
	case EnemyState.KnockBack:		
		
		KnockBackTime--;
	
		KnockBackColorFrame = (KnockBackColorFrame + 1) mod global.KnockBackColorFrames;
	
		//Play kill sound a few frames in
		if(KnockBackTime == KnockBackTimeLen - 5 && Energy <= EnemyEnergyConsideredDead && !KnockBackIgnoreDestroy){
			audio_play_sound_stopall(DestroySound);
		}
	
		if(KnockBackTime == 10){
		
			var Stop = true;
		
			if(KnockBackIgnoreZRule && z > 0){
				if(Energy <= EnemyEnergyConsideredDead){
					Gravity = 0;
					KnockBackTime = 0;
				}else Stop = false;
			}
		
			if(Stop){
				vx = 0;
				vy = 0;
			}
		
		}
	
		if(KnockBackTime == 0){
		
			if(Energy <= EnemyEnergyConsideredDead){
				
				if(!KnockBackIgnoreDestroy){
					var inst = instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHighest", DestroyObj, {SpawnItem : ItemHolding, Size : Size, y_base : y_base});
					inst.FloorLevel = FloorLevel;
				}
				PreDestroyed = true;
				Hit_Allowed = false;
			}else{
				Hit_Allowed = true;	
				Pushback = false;
				if(StopWatch){
					Enemy_UpdateState(EnemyState.Frozen);
					break;
				}else if(Stoned){
					Enemy_UpdateState(EnemyState.Stone);
					break;					
				}else if(Hit_Stun){
					Enemy_UpdateState(EnemyState.Stunned);
					break;
				}
				
				KnockBackDone = true;
			}
		
		}
	
		//flash colors a bit longer during the DestroyObj phase
		if(KnockBackTime <= -8){
			if(!DestroyIgnore) Enemy_Destroy();
		}
		
		break;

	case EnemyState.PushBack:		
		
		PushbackTime--;
	
		if(PushbackTime <= 0){
			vx = 0;
			vy = 0;
			Hit_Allowed = true;	
			Pushback = false;
			PushbackDone = true;
		}
		
		break;
	
	case EnemyState.Frozen:
		switch(object_index){
			case oEnemy_Guru:
				GuruBarInst.DestroyGurus = true;
				break;
				
			default:
				FrozenSparkleCounter--;
				if(FrozenSparkleCounter <= 0){
					var _SparkleInst = instance_create_layer(irandom_range(bbox_left, bbox_right), irandom_range(bbox_top, bbox_bottom), EffectLayer(FloorLevel), oSparkle);
					_SparkleInst.depth = depth - 5;
					FrozenSparkleCounter = FrozenSparkleTime;			
				}
		}

		break;
		
	case EnemyState.OnFire:

		switch(object_index){
			case oEnemy_Guru:
				if(Type == 1) GuruBarInst.DestroyGurus = true;
				break;
				
			default:
				OnFireCounter--;
				if(OnFireCounter <= 0){
					if(ItemHolding != -1) Enemy_DestroySpawnItem(ItemHolding, Size);
					Enemy_Destroy();
				}
		}

		break;
}
