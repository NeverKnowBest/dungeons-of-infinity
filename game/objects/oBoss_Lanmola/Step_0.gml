event_inherited();

if(KnockBackDone || PreDestroyed){
	Enemy_UpdateState(EnemyState.Jumping);
}

if(global.Paused){
	ObjPause();
	exit;
}

if(Hit_Started && Hit_LinkWeaponEffect > 0 && !oBoss_Lanmola_C.Hit[ID] && !oBoss_Lanmola_C.Destroyed[ID]){
	
	oBoss_Lanmola_C.Hit[ID] = true;
	oBoss_Lanmola_C.Energy[ID] = Energy;
	
	if(Energy <= EnemyEnergyConsideredDead){
		oBoss_Lanmola_C.alarm[ID + 3] = 120;
		oBoss_Lanmola_C.Destroyed[ID] = true;
		oBoss_Lanmola_C.BossCount--;
		oBoss_Lanmola_C.HeartSpawn_X = x;
		oBoss_Lanmola_C.HeartSpawn_Y = y_base;
		CanHurtLink = false;
		vx = 0;	vy = 0;	vz = 0;

		if(oBoss_Lanmola_C.BossCount <= 0){
			with(oBoss_Lanmola_Rock){
				instance_destroy(id);
			}
			with(oCape){
				instance_destroy(id);
			}

		}
		
		if(instance_exists(oBoss_Lanmola_C.DirtSplashInst[ID])) instance_destroy(oBoss_Lanmola_C.DirtSplashInst[ID]);
		audio_play_sound_stopall(Sound_Boss_Destroy);
		
	}else{
		oBoss_Lanmola_C.alarm[ID + 3] = 40;
		audio_play_sound_stopall(Sound_Boss_Hit);
	}

}

image_index = (oBoss_Lanmola_C.Hit[ID] ? oBoss_Lanmola_C.FlashFrame : 0);

if(oBoss_Lanmola_C.Destroyed[ID]) exit;

//on rare occasions, if z == 0 and hit, it will trigger the KnockBackTime == 10 stop code(see enemy step) and reset the vx/vy to 0. 
//Not sure how to deal with this without breaking other enemies, so just make sure vx/vy are always = to start vx/vy
vx = StartVX;
vy = StartVY;

	
Lanmola_Update();

var VY = vy - vz;
if(VY == 0) VY = (0.01 * sign(vy)); //sometimes YComp can be 0 causing the HeadAngle to be 0 since all arguments are 0. In that case, just make VY a small number with the same sign as vy;
Angle = point_direction(0, 0, vx, VY);
