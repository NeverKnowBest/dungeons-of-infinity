enum PickupObjState{
	Idle,
	PickUp,
	PickedUp,
	Throw,
	Travelling,
	Destroyed,
	Stopped	
}

function PickupObj_RevealContents(){
	
	if(WallObj != noone) instance_destroy(WallObj);

	if(ContentsObj != -1){
		if(ContentsObj == ItemClass.Stopwatch){
			if(!Enemy_StopWatchItem_Allowed()) ContentsObj = Probs_RandomItemClass_Pot(true, true);
		}
		var _ItemInst = ItemSpawn(ContentsObj, ContentsObjX, ContentsObjY, ItemFrom.Pot, ItemSpawnType.DropShort, FloorLevel);
		_ItemInst.layer = global.LayerID_ObjsHighest;
		_ItemInst.visible = true;
		ContentsObj = -1;
	}
		
}

function PickupObj_InitThrow(){
	
	WallCollided = false;
	Bounces = 2;		
	
	z = 18;
	vz = vz_Init;
	
	mask_index = sprite_index; //it was set to empty mask when Link picked up item, so set it back
	
	State = PickupObjState.Travelling;
	
}

function PickupObj_CheckExplosions(_x, _y, _FloorLevel, _BlastRadius, _CollisionList){
	
	ds_list_clear(_CollisionList);
	ObjCollision_Circle_List(_CollisionList, _x, _y, _BlastRadius, oPickupObj, _FloorLevel);
	var PickupObjs = ds_list_size(_CollisionList);
	if(PickupObjs > 0){
		for(var PickupObjIndex = 0; PickupObjIndex < PickupObjs; PickupObjIndex++){
			
			var PickupObjInst = _CollisionList[| PickupObjIndex];
			
			if(PickupObjInst.DestroyedByProjectile && PickupObjInst.State == PickupObjState.Idle && !PickupObjInst.Hidden){
				PickupObjInst.State = PickupObjState.Destroyed;
			}
			
		}
	}

}

function PickupObj_CheckRoomIndex(){
	
	if(id == oLink.ItemHolding){
		
		var _y = y - 5;
		
		var _RoomIndex = Dungeon_GetRoomIndex(x, _y);
		
		if(RoomIndex != _RoomIndex){
			if(LightIndex != -1){
				Lighting_DestroyLight(RoomIndex, LightIndex);
				LightIndex = Lighting_CreateLight(_RoomIndex, x, _y, LightStrength, [LightR, LightG, LightB]);
			}
			RoomIndex = _RoomIndex;
		}
	}

}


function PickupObj_ResetToItem(_ItemObj){
	
	var _ItemInst = instance_create_layer(x, y_base, "Objs_" + FloorLevelStr, _ItemObj, {From : From});

	with(_ItemInst){
		FloorLevel = other.FloorLevel;
		Item_SetIndex(other.Index);
	}
		
	instance_destroy(id);
	
}