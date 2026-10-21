event_inherited();

if(TransformInit && oLink.State = LinkState.Standing){
	global.Paused = true;
	with(oLink) UpdateState(LinkState.Idle);
	alarm[0] = 40;
	TransformInit = false;
}

if(TransformFlash){
	TransformFlash_Color = (TransformFlash_Color + 1) mod 5;	
}

if(Transform){
	
	if(image_index >= image_number - 1){
		ObjSetImageSpeed(0);
		Transform = false;
		Transformed = true;
		alarm[3] = 45;
	}
	
}

if(DB_Init_GrandChild){
	
	if(ResponseIndex == -1){
		ResponseIndex = Transformed ? 0 : -1;
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