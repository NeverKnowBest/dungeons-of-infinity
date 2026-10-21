event_inherited();

if(!AwakeInit && !Revealed){
	if(instance_exists(oMedallion)){
		//global.Paused = true;
		//with(oLink){
		//	UpdateState(LinkState.Idle);
		//}
		AwakeInit = true;
	}
}

if(AwakeInit){
	if(!instance_exists(oMedallion)){
		if(CollideTileBlock(global.TMID_Water_Lower, oLink.x, oLink.y, 44, VillageTilesY + 13, 2, 2)){
			Reveal = true;
			audio_play_sound(Sound_Warp, 1, false);
			global.Paused = true;
			with(oLink){
				UpdateState(LinkState.Idle);
				Facing = UP;
				sprite_index = sLink_Stand_Up;
			}
		}
		AwakeInit = false;
	}
}

if(Reveal){
	Alpha += 0.0075;	
	if(Alpha >= 0.55){
		Alpha = 0.55;
		Reveal = false;
		Revealed = true;
		alarm[0] = 45;
	}
}

if(!Revealed) exit;




HoverFrame = (HoverFrame + 4) mod 360;
HoverY = dsin(HoverFrame) * 3;


if(DB_Init_GrandChild){
	
	if(ResponseIndex == -1){
		ResponseIndex = Revealed ? 0 : -1;
	}
	
	DB_Init_GrandChild = false;
	
	DB_Started_GrandChild = true;
	
	exit;
	
}


if(DB_Started_GrandChild){
	
	if(!instance_exists(global.DB_Inst)){
		
		DB_Started_GrandChild = false;
		
		switch(ResponseIndex){
			case 0:
				with(oLink){					
					var inst = instance_create_layer(x, y, "ObjsHigher_Upper", other.ItemHolding);
					HoldUpItem(inst);
				}
				ItemHolding = noone;
				ResponseIndex = 1;
				break;
			
		}
		
	}
	

}