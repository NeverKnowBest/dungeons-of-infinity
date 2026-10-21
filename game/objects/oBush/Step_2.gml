switch(State){

	case PickupObjState.Destroyed:
		
		if(!audio_is_playing(Sound_Curtain)) audio_play_sound(Sound_Curtain, 1, false);

		PickupObj_RevealContents();

		var inst = instance_create_layer(ObjCenterX(), ObjCenterY() - 8, "ObjsHigher_Upper", oBush_Destroy);
		inst.sprite_index = asset_get_index("sBush_Destroy_" + string(Index));
		
		instance_destroy(id);
		
		break;
	
}