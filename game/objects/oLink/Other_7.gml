switch(State){

	case LinkState.Sword:
			
		UpdateState(LinkState.Standing);
			
		if(input_check("sword") && SwordChargeAllowed){ //still pressing button, engage spin charge
			SwordCharge += SwordChargeSpeed;
			var _FloorLevelStr = GetFloorLevelString(FloorLevel);
			var SwordInst = instance_create_layer(x, y, "Objs_" + _FloorLevelStr, oSword);
			SwordInst.FloorLevel = FloorLevel;	
		}
			
		UpdateSprites();
			

		
		//to test further
		//with(oSword){
		//	if(input_check_pressed("sword") && other.image_index >= 5 && Prob(0.80)){
		//		with(oLink) UpdateState(LinkState.Sword);
		//		break;
		//	}		
		//}
		
		break;
			
	case LinkState.Bow:
		Arrow_Create();
		UpdateState(LinkState.Standing);
		ObjSetImageSpeed(1);
		break;

	case LinkState.Rod:
	case LinkState.Boomerang:
		UpdateState(LinkState.Standing);
		break;
		
	case LinkState.Powder:
		UpdateState(LinkState.Standing);
		with(oVillager_Treeman){
			if(TransformInit){
				global.Paused = true;
				with(oLink){
					UpdateState(LinkState.Idle);
				}
			}
		}
		break;
		
	case LinkState.SwordPoke:
		Invincible = false;
		UpdateState(LinkState.Standing);
		break;

	case LinkState.SwordSpin:
		Invincible = false;
		UpdateState(LinkState.Standing);
		break;

	case LinkState.Falling:

		x = FallSpawnX; 
		y = FallSpawnY;
		FloorLevel = FallSpawnFloorLevel;
		Facing = FallSpawnFacing;
		LampDim = FloorLevel;
		BounceBack = false;
		HealthAdd(-1);			
		if(LinkHealth > 0){
			UpdateState(LinkState.Standing);
			LinkEnableFlashing();
		}
		
		break;
		
}