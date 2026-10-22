if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;

	DB_Init = false;
	State = KinstoneState.DBStarted;

}

var ContentsFrom, TreasureInst;
switch(State){
	case KinstoneState.Idle:
		Kinstone_Update();
		break;
	
	case KinstoneState.DBStarted:
		Kinstone_Update();
		if(!instance_exists(global.DB_Inst)){
			if(global.DB_ExitCode == 1){
				FuseInit = true;
				with(oLink) UpdateState(LinkState.Idle);
				global.Paused = true;
			}else{				
				State = KinstoneState.Idle;
			}
		}		
		break;
	
	case KinstoneState.Fuse:
		
		BaseX += vx;
		SpriteY += vy;
		if(BaseX >= WaypointX) BaseX = WaypointX;
		if(SpriteY <= WaypointY) SpriteY = WaypointY;
		
		BaseX_Other += vx_Other;
		SpriteY_Other += vy_Other;
		if(BaseX_Other <= WaypointX_Other) BaseX_Other = WaypointX_Other;
		if(SpriteY_Other <= WaypointY_Other) SpriteY_Other = WaypointY_Other;
		
		Lighting_UpdateLight_Radius(RoomIndex, LightIndex, 1.0 + ((BaseY - SpriteY) / 30.0));		
		
		if(BaseX = WaypointX && SpriteY = WaypointY && BaseX_Other = WaypointX_Other && SpriteY_Other = WaypointY_Other){
			State = KinstoneState.FuseMerge;
			vx = 0;
			vx_Other = 0;
			alarm[0] = 80;
		}
		
		
		break;

	case KinstoneState.FuseMerge:
		if(Merge && !MergeConnected){
			
			vx += -0.025;
			if(vx <= -0.5) vx = -0.5;
			vx_Other += 0.025;
			if(vx_Other >= 0.5) vx_Other = 0.5;
			
			BaseX += vx;
			BaseX_Other += vx_Other;
			
			if(!ConnectSound && BaseX <= x + 6){
				audio_play_sound(Sound_KinstoneConnect, 1, false);
				ConnectSound = true;
			}
			if(BaseX <= x + 3 && BaseX_Other >= x - 3){
				MergeConnected = true;
				alarm[1] = 80;		
				alarm[2] = 1;
			}
		}
		break;
	
	case KinstoneState.TreasureDrop:
		
		SpriteY += 0.4;
		SpriteY_Other += 0.4;
		
		LightY += 0.3;
		if(LightY >= LightY_Treasure) LightY = LightY_Treasure;
		Lighting_UpdateLight_Pos(RoomIndex, LightIndex, BaseX - 3, LightY);
		
		Lighting_UpdateLight_Radius(RoomIndex, LightIndex, 0.6 + ((BaseY - SpriteY) / 50.0));		
		
		if(SpriteY >= BaseY){
			PoofInst = instance_create_layer(BaseX - 3, SpriteY - 6, "ObjsHigher_Upper", oPoof)
			State = KinstoneState.TreasurePoof;
		}
		break;
	
	case KinstoneState.TreasurePoof:
		if(!instance_exists(PoofInst)){
			audio_play_sound(Sound_ChestAppear, 1, false);
			State = KinstoneState.FuseDone;
		}
		break;

	case KinstoneState.FuseDone:
		
		switch(Index){
			case KinstoneColor.Green:
				ContentsFrom = ItemFrom.KinstoneGreen;
				break;
			case KinstoneColor.Blue:
				ContentsFrom = ItemFrom.KinstoneBlue;
				break;
			case KinstoneColor.Red:
				ContentsFrom = ItemFrom.KinstoneRed;
				break;
			case KinstoneColor.Gold:
				ContentsFrom = ItemFrom.KinstoneGold;
				break;
				
		}
		TreasureInst = Treasure_Create(RoomIndex, x - 16, y + 18, RandomItem, true,,,ContentsFrom, ContentsFrom);
		TreasureInst = Treasure_Create(RoomIndex, x, y + 18, RandomItem, true,,,ContentsFrom, ContentsFrom);
		
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [TreasureLightColor, TreasureLightColor, TreasureLightColor]);
		
		var _Slot = Inventory_FindItem(ItemClass.Kinstone, Index);
		Inventory_Add(ItemClass.Kinstone, Index, -1, _Slot);
		

		//if the kinstone exists in the map items list, then delete it
		var i = ds_list_find_index(global.LargeMapItems, id);
		if(i != -1) ds_list_delete(global.LargeMapItems, i);

		//oLink.Kinstones[Index]--;
		global.Paused = false;
		
		State = KinstoneState.TreasureLight;
		
		with(oLink) UpdateState(LinkState.Standing);

		alarm[3] = 90
		
		break;
	
	case KinstoneState.TreasureLight:
		
		if(TreasureLightDim){
			TreasureLightColor -= 0.1;
			Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [TreasureLightColor, TreasureLightColor, TreasureLightColor]);
			if(TreasureLightColor <= 0){
				instance_destroy(id);
				exit;
			}
		}
		
		break;
		
}

var Dir;
if(FuseInit){
	
	
	WaypointX_Other = BaseX_Other - 8;
	WaypointY_Other = BaseY_Other - 12;
	Dir = point_direction(BaseX_Other, SpriteY_Other, WaypointX_Other, WaypointY_Other);
	var Dist_Other = point_distance(BaseX_Other, SpriteY_Other, WaypointX_Other, WaypointY_Other);
	vx_Other = lengthdir_x(0.25, Dir);
	vy_Other = lengthdir_y(0.25, Dir);
	
	WaypointX = BaseX + 8;
	WaypointY = BaseY - 12;
	Dir = point_direction(BaseX, SpriteY, WaypointX, WaypointY);
	var Dist = point_distance(BaseX, SpriteY, WaypointX, WaypointY)
	
	var VFactor = Dist / Dist_Other;
	vx = lengthdir_x(0.25 * VFactor, Dir);
	vy = lengthdir_y(0.25 * VFactor, Dir);
	
	State = KinstoneState.Fuse;
	
	audio_play_sound(Sound_KinstoneFuse2, 1, false);
	
	FuseInit = false;
}




