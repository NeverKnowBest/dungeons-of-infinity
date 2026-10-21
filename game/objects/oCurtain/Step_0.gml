if(Revealed && !RevealedDone){
	
	if(DoorInst != noone){
		sprite_index = asset_get_index("sCurtain_" + Location + "_Open_Secret");
		DoorInst.Status = DoorStatus.Open;
		DoorInst.UpdateStatus = true;
	}else{
		sprite_index = asset_get_index("sCurtain_" + Location + "_Open");	
	}
	
	RevealedDone = true;
	
}

