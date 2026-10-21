function Collision_CheckFloorLevel(_Inst){
	return 	FloorLevel == _Inst.FloorLevel || _Inst.FloorLevel == UPPERLOWER;
}
function ObjCollision(_x, _y, obj){
	
	var ObjInst = instance_place(_x, _y, obj);
	
	return ObjInst != noone && Collision_CheckFloorLevel(ObjInst) ? ObjInst : noone
	
}

function ObjCollision_List(_CollidedObjList, _x, _y, _Obj){
	
	//Detects all objects in collision and stores them in CollidedObjList
	ds_list_clear(_CollidedObjList);
	
	var ObjList = ds_list_create();
	
	var ObjInsts = instance_place_list(_x, _y, _Obj, ObjList, false);	

	for(var i = 0; i < ObjInsts; i++){
		var ObjInst = ObjList[|i];				
		if(Collision_CheckFloorLevel(ObjInst)){
			ds_list_add(_CollidedObjList, ObjInst);
		}
	}

	ds_list_destroy(ObjList);
	
}

function ObjCollision_Circle_List(_CollidedObjList, _x, _y, _Radius, _Obj){
	
	//Detects all objects in collision and stores them in CollidedObjList
	ds_list_clear(_CollidedObjList);
	
	var ObjList = ds_list_create();
	
	var ObjInsts = collision_circle_list(_x, _y, _Radius, _Obj, false, true, ObjList, false);	

	for(var i = 0; i < ObjInsts; i++){
		var ObjInst = ObjList[|i];				
		if(Collision_CheckFloorLevel(ObjInst)){
			ds_list_add(_CollidedObjList, ObjInst);
		}
	}

	ds_list_destroy(ObjList);
	
}

function ObjCollision_Position(_x, _y, obj, _FloorLevel){
	
	var ObjInst = instance_position(_x, _y, obj);
	
	return ObjInst != noone && (Collision_CheckFloorLevel(ObjInst)) ? ObjInst : noone;
	
}


function WallCollision(CollidedWallList, VX, VY, WallObj){
	
	//Detects all walls in collision and stores them in CollidedWallList
	//This should be used seperately for vx and vy
	
	Success = true;
	
	var WallList = ds_list_create();
	ds_list_clear(WallList);
	
	if(object_index == oLink) //temp, convert Link to use y_base
		var Walls = instance_place_list(x + VX, y + VY, WallObj, WallList, false);
	else
		var Walls = instance_place_list(x + VX, y_base + VY, WallObj, WallList, false);

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
			var Condition = (WallInst.BlockLink || (WallInst.BlockLinkCarry && ItemHolding != noone && !WallInst.IsHiddenTreasure)) && (FloorLevel == WallInst.FloorLevel || WallInst.FloorLevel == UPPERLOWER);
			
			//temp, convert Link to use y_base and delete this block, see block below which all other objects use
			if(Condition){
				if(VX != 0){
					var Inc = sign(VX) * 0.25;
					while(!place_meeting(x + Inc, y, WallInst) && frac(x) != 0){ //if new collision problem start occuring, remove this new frac part
						x += Inc;
					}
				}
				if(VY != 0){
					var Inc = sign(VY) * 0.25;
					while(!place_meeting(x, y + Inc, WallInst) && frac(y) != 0){ //if new collision problem start occuring, remove this new frac part
						y += Inc;
					}
				}
				ds_list_add(CollidedWallList, WallInst);
			} 
		}else{
			
			var Condition = (object_get_parent(object_index) == oEnemy && WallInst.BlockEnemies) || (object_get_parent(object_index) == oProjectile && WallInst.BlockProjectiles || object_get_parent(object_index) == oItem && WallInst.BlockItems || object_index == oBoss_Moldorm);

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


function CheckProjectileCollision(){
	
	var inst = ObjCollision(x, y, oCrystalSwitch);
	if(inst != noone){
		inst.Hit = true;
		return inst;
	}

	var inst = ObjCollision(x, y, oPot);
	if(inst != noone){		
		inst.Destroyed = true;
		instance_destroy(inst.WallObj);
		if(inst.ContentsObj != noone) ItemSpawn(inst.ContentsObj, inst.x, inst.y, ItemFrom.Pot, ItemSpawnType.DropShort, oLink.FloorLevel);	
		return inst;
	}
	
	var inst = ObjCollision(x, y, oBoomerang);
	if(inst != noone){
		inst.Hit = true;
		return inst;
	}	
	
	if(object_index == oFireRodBeam || object_index == oSwordBeam){
		var inst = ObjCollision(x, y, oTorch);
		if(inst != noone) inst.Lighting = true;
	}
	
	var inst = ObjCollision(x, y, oEnemy);;
	if(inst != noone){
		
		if(inst.State == EnemyState.OnFire) return noone;
		
		if(Enemy_LinkWeaponHit(GetLinkWeaponIndex(object_index), inst, x, y, point_direction(x, y, x + vx, y + vy)))
			return inst;
	}
	
	return noone;
}

function ObjTileCollision(Obj, TMID){
	
	var O_BBL = Obj.bbox_left;
	var O_BBR = Obj.bbox_right;
	var O_BBT = Obj.bbox_top;
	var O_BBB = Obj.bbox_bottom;
	
	return tilemap_get_at_pixel(TMID, O_BBL, O_BBT) != 0 || tilemap_get_at_pixel(TMID, O_BBR, O_BBT) != 0 || tilemap_get_at_pixel(TMID, O_BBL, O_BBB) != 0 || tilemap_get_at_pixel(TMID, O_BBR, O_BBB) != 0 
		
}