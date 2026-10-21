
LightFrame = (LightFrame + 6) mod 360;
LightRadius = BaseLightRadius + (dsin(LightFrame) * 0.075);
Lighting_UpdateLight_Radius(RoomIndex, LightIndex, LightRadius);

if(Inventory_NoItemIsEquiped || oLink.Facing != DOWN){
	RodInserted = false;
	exit;
}
		
if(Inventory_EquipedItem.ItemClass == ItemClass.Rod){
			
	if(instance_place(x, y - 4, oLink) != noone){
				
		if(!RodInserted || RodIndex != Inventory_EquipedItem.ItemIndex){
			audio_play_sound(Sound_Arrow_Shoot, 1, false);
			audio_play_sound(Sound_CrystalHit, 1, false);
			RodIndex = Inventory_EquipedItem.ItemIndex;
			MagicCost = MAGICAMOUNT_MAX / global.MaxRodCharge[RodIndex];
			RodInserted = true;
		}
		
	}else RodInserted = false;
				
}else RodInserted = false;
		
if(global.Paused || oLink.State == LinkState.Hit) exit;
		
if(RodInserted){
			
	if(input_check("action")){
				
		if(CanAddShot){
			
			if(Inventory_EquipedItem.Amount >= global.MaxRodCharge[RodIndex]){
				if(!FillError){
					MsgBox("Maximum charge reached!",,Sound_Error);
					FillError = true;
				}				
			}else if(MagicUse(MagicCost) > 0){
				Inventory_EquipedItem.Amount += 1;
				audio_play_sound(Sound_RodCharger, 1, false);
				CanAddShot = false;
				alarm[0] = ChargeDelay;
			}else{
				if(!FillError){
					MsgBox("Not enough magic to add a charge!",,Sound_Error);
					FillError = true;
				}
						
			}
		}
				
	}else{
		CanAddShot = true;
		FillError = false;
	}
			

}
		
ChargeColor = (ChargeColor + 1) mod 3;


		