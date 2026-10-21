if(DB_Started){
	
	if(!instance_exists(global.DB_Inst)){
		
		if(global.DB_ExitCode == 1){

			with(TentFireInst){
				if(!FireLit){
					var _FireInst = instance_create_layer(x + 8, y + 4, "ObjsHigher_" + FloorLevelStr, oFireEffect);
					_FireInst.sprite_index = sFireEffect_Continuous;
					_FireInst.AnimationEndDestroy = false;
					_FireInst.CanPause = false;
					audio_play_sound(Sound_Lamp, 1, false);
					FireLit = true;
				}
			}
			
			alarm[0] = 25;
			with(oLink){
				x = other.x + 16;
				y = other.y + 26;
				layer = global.LayerID_ObjsFloor_Upper;
				UpdateState(LinkState.Idle);
			}
			global.Paused = true;
			
		}		
		DB_Started = false;
	}
	
}