event_inherited();

var _DropItem = false;

if(Destroyed){
	
	if(SwallowedItem_Class != -1){
		var DroppedItem = ItemSpawn(SwallowedItem_Class, x, y, ItemFrom.Enemy, ItemSpawnType.DropShort, FloorLevel, false);
	
		with(DroppedItem){
			Setup = false;
			Get_ShowDialogue = false;
			Amount = other.SwallowedItem_Amount;
			if(Class == ItemClass.Rupee) ShowAmount = (Amount > 5);
			Item_SetIndex(other.SwallowedItem_Index);			
		}
	}
	
	_DropItem = true;
	
}

if(State == EnemyState.KnockBack || State == EnemyState.Frozen || State == EnemyState.OnFire || State == EnemyState.Stone) _DropItem = true;

if(_DropItem){
	with(TongueInst){
		if(ItemGrabbed && instance_exists(ItemInst)){
			var DroppedItem = ItemSpawn(ItemInst.Class, ItemInst.x, ItemInst.y, ItemInst.From, ItemSpawnType.DropShort, other.FloorLevel, false);
			DroppedItem.Setup = false;
			DroppedItem.Get_ShowDialogue = false;
			DroppedItem.layer = other.layer;
			DroppedItem.Amount = ItemInst.Amount;
			with(DroppedItem){
				if(Class == ItemClass.Rupee) ShowAmount = (Amount > 5);
				Item_SetIndex(other.ItemInst.Index);	
			}
			instance_destroy(ItemInst);	
	
		}
		instance_destroy(self);
	}
}

if(Destroyed) exit;

if(KnockBackDone || StunDone){
	if(instance_exists(TongueInst)){
		sprite_index = sEnemy_Pikit_Shooting;
		State = EnemyState.Shooting;
		Shoot = true;
		if(TongueInst.ItemGrabbed) TongueInst.ItemRelease = true;
	}else Enemy_UpdateState(EnemyState.Shooting);
}


PauseCheck


switch(State){
	
	case EnemyState.Standing:
	
		if(CanShoot && distance_to_object(oLink) <= 32 && FloorLevel == oLink.FloorLevel){
			
			if(oLink.Cape || oLink.State == LinkState.Falling) break;
			
			Enemy_UpdateState(EnemyState.Shooting);
		}
		break;
	
	case EnemyState.Jumping:
		
		if(JumpLanded){
			Enemy_UpdateState(EnemyState.Standing);	
		}
		break;
	
	case EnemyState.Shooting:
		if(!Shoot && image_index >= 1.5){
			ObjSetImageSpeed(0);
			image_index = 1;
			TongueInst = instance_create_layer(x, y - 5, "Objs_" + GetFloorLevelString(x, y), oEnemy_Pikit_Tongue);
			TongueInst.depth = depth - 5;
			TongueInst.Angle = (floor((point_direction(TongueInst.x, TongueInst.y, oLink.x, oLink.y - 6) + 22.5) / 45) * 45) mod 360;
			TongueInst.ParentInst = id;
			TongueInst.FloorLevel = FloorLevel;
			switch(TongueInst.Angle){
				case 0:	TongueInst.OffsetX = 4; break;
				case 45:TongueInst.OffsetX = 4; TongueInst.OffsetY = -4; break;
				case 90:TongueInst.OffsetY = -4; break;
				case 135:TongueInst.OffsetX = -4; TongueInst.OffsetY = -4; break;
				case 180:TongueInst.OffsetX = -4; break;
				case 225:TongueInst.OffsetX = -4; TongueInst.OffsetY = 4; break;
				case 270:TongueInst.OffsetY = 4; break;
				case 315:TongueInst.OffsetX = 4; TongueInst.OffsetY = 4; break;
				
			}
			Shoot = true;
		}else if(Shoot && !instance_exists(TongueInst)){
			ObjSetImageSpeed(1);
			if(image_index >= 2.75){
				Enemy_UpdateState(EnemyState.Standing);
				Shoot = false;
				CanShoot = false;
				alarm[1] = CanShootPause;
			}
		}
		break;
		
}

