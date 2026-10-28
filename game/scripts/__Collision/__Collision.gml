function Collision_CheckFloorLevel(_FloorLevel, _Inst){
	return _FloorLevel == _Inst.FloorLevel || _Inst.FloorLevel == UPPERLOWER;
}

function ObjCollision(_x, _y, _obj, _FloorLevel){
	
	var ObjInst = instance_place(_x, _y, _obj);
	
	if(ObjInst != noone){
		if(Collision_CheckFloorLevel(_FloorLevel, ObjInst)) return ObjInst
	}
	
	return noone
	
}

function ObjCollision_Position(_x, _y, _obj, _FloorLevel){
	
	var _ObjInst = instance_position(_x, _y, _obj);

	if(_ObjInst != noone){
		if(Collision_CheckFloorLevel(_FloorLevel, _ObjInst)) return _ObjInst
	}
	
	return noone;
	
}

function ObjCollision_List(_CollidedObjList, _x, _y, _Obj, _FloorLevel){
	
	//Detects all objects in collision and stores them in CollidedObjList
	ds_list_clear(_CollidedObjList);
	
	var ObjList = ds_list_create();
	
	var ObjInsts = instance_place_list(_x, _y, _Obj, ObjList, false);	

	for(var i = 0; i < ObjInsts; i++){
		var ObjInst = ObjList[|i];				
		if(Collision_CheckFloorLevel(_FloorLevel, ObjInst)){
			ds_list_add(_CollidedObjList, ObjInst);
		}
	}

	ds_list_destroy(ObjList);
	
}

function ObjCollision_Circle(_x, _y, _Radius, _Obj, _FloorLevel){
	
	var ObjInst = collision_circle(_x, _y, _Radius, _Obj, false, true);	

	return ObjInst != noone && Collision_CheckFloorLevel(_FloorLevel, ObjInst) ? ObjInst : noone
	
}

function ObjCollision_Circle_List(_CollidedObjList, _x, _y, _Radius, _Obj, _FloorLevel){
	
	//Detects all objects in collision and stores them in CollidedObjList
	ds_list_clear(_CollidedObjList);
	
	var ObjList = ds_list_create();
	
	var ObjInsts = collision_circle_list(_x, _y, _Radius, _Obj, false, true, ObjList, false);	

	for(var i = 0; i < ObjInsts; i++){
		var ObjInst = ObjList[|i];				
		if(Collision_CheckFloorLevel(_FloorLevel, ObjInst)){
			ds_list_add(_CollidedObjList, ObjInst);
		}
	}

	ds_list_destroy(ObjList);
	
}

function WallCollision(CollidedWallList, VX, VY, WallObj){
	
	//Detects all walls in collision and stores them in CollidedWallList
	//This should be used seperately for vx and vy
	
	Success = true;
	
	var WallList = ds_list_create();
	ds_list_clear(WallList);
	
	var Walls;
	if(object_index == oLink) //temp, convert Link to use y_base
		Walls = instance_place_list(x + VX, y + VY, WallObj, WallList, false);
	else
		Walls = instance_place_list(x + VX, y_base + VY, WallObj, WallList, false);

	if(object_index == oLink){
		//if there's more than 1 walls, we have to check to see if one of those is moving, If so, remove it from the list so we can perform the collision on the non-moving one only
		if(Walls > 1){
			for(var i = 0; i < Walls; i++){
				var WallInst = WallList[|i];
				if(WallInst.BlockLink && WallInst.Move_Start && !WallInst.Moved){
					ds_list_delete(WallList, i);
					Walls--;
				}			 
			}
		}
	}
	
	ds_list_clear(CollidedWallList);
	
	for(var i = 0; i < Walls; i++){
		var WallInst = WallList[|i];
		
		if(object_index == oLink){
			
			var Condition = (WallInst.BlockLink || (WallInst.BlockLinkCarry && ItemHolding != noone && !WallInst.IsHiddenObj));
			
			if(Condition && (FloorLevel == WallInst.FloorLevel || WallInst.FloorLevel == UPPERLOWER)){
				if(VX != 0){

					if(VX > 0){
						x = (x - bbox_right + WallInst.bbox_left);
					}else{
						x = (x + WallInst.bbox_right - bbox_left);
					}
					
					
				}
				if(VY != 0){

					if(VY > 0){
						y = (y - bbox_bottom + WallInst.bbox_top);
					}else{
						y = (y + WallInst.bbox_bottom - bbox_top);
					}
					
				}
				ds_list_add(CollidedWallList, WallInst);
				
			} 
		}else{
			
			var _ParentObj = object_get_parent(object_index);
			if(_ParentObj == oEnemy_Archetype) _ParentObj = oEnemy;	// archetype enemies are enemies (scripts/__EnemyArch)
			var Condition = (_ParentObj == oEnemy && WallInst.BlockEnemies) || 
							( 
								(_ParentObj == oProjectile && WallInst.BlockProjectiles) ||
								(WallInst.IsHole && object_index == oItem_Key) || //can't let keys fall into holes
								((_ParentObj == oItem || _ParentObj == oPickupObj) && WallInst.BlockItems) || 
								object_index == oBoss_Moldorm
							);

			if(Condition && (FloorLevel == WallInst.FloorLevel || WallInst.FloorLevel == UPPERLOWER)){
				
				var Counter = 0;
				
				if(VX != 0){
					var Inc = sign(VX) * 0.25;
					while(!place_meeting(x + Inc, y_base, WallInst)){
						x += Inc;
						Counter++;
						if(Counter > 100){
							Success = false;
							break;
						}
					}

				}
				if(VY != 0){
					var Inc = sign(VY) * 0.25;
					while(!place_meeting(x, y_base + Inc, WallInst)){
						ObjSetY(y_base + Inc);
						Counter++;
						if(Counter > 100){
							Success = false;
							break;
						}
					}

				}
				ds_list_add(CollidedWallList, WallInst);
			}
		}
			

	}
	
	ds_list_destroy(WallList);
	
	return Success;
	
}

function CheckProjectileCollision(_FloorLevel){
	
	var inst;
	if(!HitCrystalSwitch){
		inst = ObjCollision(x, y_base, oCrystalSwitch, _FloorLevel);
		if(inst != noone){
			if(inst.visible && !inst.HitPause){
				inst.Hit = true;
				HitCrystalSwitch = true;
				return inst;
			}
		}
	}

	inst = ObjCollision(x, y_base, oPickupObj, _FloorLevel);
	if(inst != noone){
		if(inst.Hidden){
			inst.State = PickupObjState.Idle;
		}else if(inst.DestroyedByProjectile && inst.State != PickupObjState.Destroyed && inst.visible){
			inst.State = PickupObjState.Destroyed;
			return inst;
		}
	}

	
	switch(object_index){
		case oSwordBeam: //put objs here that can light torches and open curtains
		case oRodBeam:
		case oCaneBeam:
			inst = ObjCollision(x, y, oTorch, _FloorLevel);
			if(inst != noone) inst.Lighting = true;
		
		case oArrow:
		case oBoomerang: //put objs here that can only open curtain and not light torches
		case oHookshot: 
			var CurtainInst = ObjCollision(x, y, oCurtain, _FloorLevel);
			if(CurtainInst != noone) Curtain_Reveal(CurtainInst);
	}

	
	var _EnemyList = ds_list_create();
	ObjCollision_List(_EnemyList, x, y, oEnemy, _FloorLevel);

	for(var i = 0; i < ds_list_size(_EnemyList); i++){
		
		inst = _EnemyList[| i];
		
		if(inst.State == EnemyState.OnFire || inst.Energy <= EnemyEnergyConsideredDead){
			ds_list_destroy(_EnemyList);
			return noone;
		}
		
		var _WeaponClass = GetLinkWeaponClass(object_index, Index);
		if(_WeaponClass != -1){
			if(Enemy_LinkWeaponHit(_WeaponClass, Index, inst, x, y, point_direction(x, y, x + vx, y + vy))){	
				ds_list_destroy(_EnemyList);
				return inst;				
			}
		}
	}
	ds_list_destroy(_EnemyList);
	
	return noone;
}
