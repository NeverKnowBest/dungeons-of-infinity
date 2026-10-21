LargeBodyCollision = place_meeting(x, y, oBoss_Moldorm) || place_meeting(x, y, oBoss_Moldorm_BodyL);

if(oLink.State != LinkState.FallingOverEdge && oLink.State != LinkState.Falling && oBoss_Moldorm.State == EnemyState.Walking){


	if(Hit_Started && !LargeBodyCollision){

		var _Hit = false;
		
		switch(Hit_LinkWeaponClass){
			case LinkWeaponClass.Sword:
				oBoss_Moldorm.Energy -= global.LinkSwordDamage[ATTACK()][oBoss_Moldorm.EnergyIndex];
				_Hit = true;
				break;
				
			case LinkWeaponClass.Arrow:
				oBoss_Moldorm.Energy -= 1.5;
				_Hit = true;
				break;

			case LinkWeaponClass.Fire:
			case LinkWeaponClass.Ice:
			case LinkWeaponClass.Transform:
			case LinkWeaponClass.Stone:
				oBoss_Moldorm.Energy -= 2;
				_Hit = true;
				break;
				
		}
		
		if(_Hit){
			if(oBoss_Moldorm.Energy <= EnemyEnergyConsideredDead){
				oBoss_Moldorm.Energy = 0;
				oBoss_Moldorm.State = EnemyState.Killed;
				audio_play_sound(Sound_Boss_Destroy, 1, false);	
				audio_stop_sound(Sound_MoldormSkitter);
				with(oCape){
					instance_destroy(id);
				}
				instance_destroy()
				oBoss_Moldorm.alarm[5] = 120;
			}else{
				oBoss_Moldorm.State = EnemyState.Hit;
				audio_play_sound(Sound_Boss_Hit, 1, false);		
				oBoss_Moldorm.alarm[2] = 30;
			}
		
			//Hit_Allowed = false;
			//oBoss_Moldorm.Hit_Allowed = false;
		}
	}
}