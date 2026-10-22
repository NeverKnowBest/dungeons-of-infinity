// Feather disable GM2064
switch(State){
	
	case PickupObjState.PickedUp:
		if(!Red){
			alarm[0] = -1;
			alarm[1] = -1;			
			ObjSetImageSpeed(0);
			image_index = 0;
		}
		//image_index = (Red ? 1 : 0);
		break;
		
	case PickupObjState.Destroyed:
		

		
		break;
	
}

if(BlowUp){
	
	var inst = instance_create_layer(ObjCenterX(), ObjCenterY(), "ObjsHigher_" + FloorLevelStr, oBombExplosion, {FloorLevel : FloorLevel});
	if(Red){
		inst.MaxDamage = 4;
	}
		
	if(oLink.ItemHolding == id){
		with(oLink){
			ItemHolding = noone;
			UpdateState(LinkState.Standing);
		}
	}
		
	instance_destroy(id);
		
}