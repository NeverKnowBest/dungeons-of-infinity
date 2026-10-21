enum SwitchType{
	None,
	Block,
	FloorSwitch,
	FloorSwitchMonument,
	Torches, 
	ArrowTarget, //these should be used for secret Rooms and bonus treasures only since you might not have arrows
}

enum SwitchAction{
	None,
	OpenDoors,
	RevealHiddenObj,
}

enum Switch_HiddenObjType{
	None,
	Treasure,
	Crystal,
	Warp,
	Door
}

enum SpawnSwitch_ReturnCode{
	Success = 1,
	SpawnHiddenObjFail,
	AddSwitchFail
}


function Switch_Activate(_Action, _Inst){
	
	switch(_Action){
		
		case SwitchAction.OpenDoors:
			with(oDoor){
				if(RoomIndex == global.CurrentRoomIndex && Status == DoorStatus.Closed && !Entrance){
					Open = true;
				}
			}
			return true
			break;
			
		case SwitchAction.RevealHiddenObj:
			
			if(_Inst == noone) break; //for safe measure. If this function is called to reveal a treasure, the inst should always be given
			
			_Inst.visible = true;
			audio_play_sound(Sound_ChestAppear, 1, false);
			
			switch(global.Level.Rooms[_Inst.RoomIndex].Switch.HiddenObjType){
				case Switch_HiddenObjType.Treasure:
					
					_Inst.WallInst.BlockLink = true;
					_Inst.WallInst.BlockProjectiles = true;
					_Inst.WallInst.BlockEnemies = true;
					_Inst.IsSwitchTreasure = false;
					Treasure_SetSpriteIndex(_Inst);
					
					return true
					
				case Switch_HiddenObjType.Crystal:

					_Inst.WallInst.BlockLink = true;
					_Inst.WallInst.BlockProjectiles = true;
					_Inst.WallInst.BlockEnemies = true;
					_Inst.IsSwitchCrystal = false;
					_Inst.sprite_index = sCrystalSwitch; //crystal might be a block in disguise, so switch sprite index on reveal
					Crystal_CreateLight(_Inst);
					_Inst.alarm[1] = 1;
					ds_list_add(global.LargeMapItems, _Inst); 
					return true
				
				case Switch_HiddenObjType.Warp:
					_Inst.IsSwitchWarp = false;
					for(var i = 0; i < 3; i++){
						Lighting_UpdateLight_Visible(RoomIndex, _Inst.LightIndex[i], true);
					}
					ds_list_add(global.LargeMapItems, _Inst); 
					return true
				
				case Switch_HiddenObjType.Door:
					
					return true
				
			}

			break;

		
	}

	return false;
	
}