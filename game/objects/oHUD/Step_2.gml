
HealthCheckSound();

if(HealthLowPulseDir != 0){
	
	HealthLowPulse += (HealthLowPulseDir * 0.075);
	
	if(HealthLowPulse >= 1){
		HealthLowPulse = 1;
		HealthLowPulseDir = -1;
	}
	
	if(HealthLowPulse <= 0){
		HealthLowPulse = 0;
		HealthLowPulseDir = 0;
	}
	
	var _GB = (1 - HealthLowPulse) * 255;
	HealthLowPulseColor = make_color_rgb(255, _GB, _GB);
	
}


//If pendant of secrets, alert if a secret door is in the Room
//This variable gets set at the end of camera room transition and after adding item to inventory
if(CheckPendentSecret){
	
	if(!instance_exists(oDialogueBox)){
		
		if(Pendant_Check(Pendant.Secrets)){
			
			if(global.Level.Rooms[global.CurrentRoomIndex].Secret == -1){ //make sure we're not in a secret Room
				with(oDoor){
					if(RoomIndex == global.CurrentRoomIndex && (Status == DoorStatus.Secret_Closed || SecretType == SecretDoor.Illusion) ){
						var inst = instance_create_layer(oCamera.X + 100, oCamera.Y + 64, "System", oPendantAlert);
						inst.image_index = Pendant.Secrets;
						break;
					}
						
				}					
			}
			
		}
		
		CheckPendentSecret = false;
		
	}
	
}

if(AddHealth > 0){
	
	//if(LinkHealth - AddHealth == global.Inventory.ItemData[ItemClass.HeartPiece].Amount){
		
	//	AddHealth = 0;
	//	AddHealthSoundCounter = 0;
		
	//}else{
	
		if(alarm[1] <= 0){
			
			if(AddHealthSoundCounter == 0) audio_play_sound(Sound_HealthRefill, 1, false);
			AddHealthSoundCounter = (AddHealthSoundCounter + 1) mod 4;
		
			AddHealth -= 0.25;
			
			if(AddHealth <= 0){
				AddHealth = 0;
				AddHealthSoundCounter = 0;
			}else{
				alarm[1] = 2;
			}
		}
		
	//}

}


if(AddMagic > 0){

	if(global.Inventory.ItemData[ItemClass.Magic].Amount - AddMagic == MAGICAMOUNT_MAX){
		AddMagic = 0;
		AddMagicSoundCounter = 0;
	}else{

		if(alarm[2] <= 0){
			
			if(AddMagicSoundCounter == 0){
				audio_stop_sound(Sound_MagicMeter);
				audio_play_sound(Sound_MagicMeter, 1, false);
			}
			AddMagicSoundCounter = (AddMagicSoundCounter + 1) mod 4;
		
			AddMagic -= 1;
			
			if(AddMagic == 0)
				AddMagicSoundCounter = 0;
			else
				alarm[2] = 2;
		}
		
	}

	
}

if(AddRupees != 0){
	
	var Sign = sign(AddRupees);
	var AbsValue = abs(AddRupees);
	var Increment = Sign * (AbsValue >= 500 ? 20 : (AbsValue >= 100 ? 5 : 1 ));
	
	AddRupees -= Increment;

	if(!audio_is_playing(Sound_RupeeGetRegister))
		audio_play_sound(Sound_RupeeGetRegister, 1, false);
	else{
		AddRupeesCount++;
		if(AddRupeesCount >= 10){
			audio_play_sound(Sound_RupeeGetRegister, 1, false);
			AddRupeesCount = 0;
		}

	}

	var _InvRupees = global.Inventory.ItemData[ItemClass.Rupee];
	
	_InvRupees.Amount = max(_InvRupees.Amount + Increment, 0);

	if(_InvRupees.Amount = 0){
		oHUD.AddRupees = 0;
		oHUD.AddRupeesCount = 0;
	}
	
	if(ChallengeMax_Rupees != -1 && _InvRupees.Amount >= ChallengeMax_Rupees){
		_InvRupees.Amount = ChallengeMax_Rupees;
		oHUD.AddRupees = 0;
		oHUD.AddRupeesCount = 0;
	}
	
}


if(ShowLevelName){
	ShowLevelName_Alpha += (0.05 * ShowLevelName_FadeDir);
	if(ShowLevelName_FadeDir == 1 && ShowLevelName_Alpha >= 1){
		ShowLevelName_Alpha = 1;
		if(!ShowLevelName_Pause){
			alarm[0] = 120;
			ShowLevelName_Pause = true;
		}
	}
	if(ShowLevelName_FadeDir == -1 && ShowLevelName_Alpha <= 0){
		ShowLevelName_Alpha = -3;
		ShowLevelName_FadeDir = 1;
		ShowLevelName = false;
	}
	
}
	
MagicW = global.Inventory.ItemData[ItemClass.Magic].Amount - AddMagic;//ceil(((global.Inventory.ItemData[ItemClass.Magic].Amount - AddMagic) / MAGICAMOUNT_MAX) * MAGICAMOUNT_MAX);

RupeesStr = ScoreText(global.Inventory.ItemData[ItemClass.Rupee].Amount, 4);

AttackColor = oLink.AttackPoints == 8 ? #F8C800 : c_white;
DefenseColor = oLink.DefensePoints == 8 ? #F8C800 : c_white;
ArrowsColor = global.Inventory.ItemData[ItemClass.Arrows].Amount[0] == Inventory_MaxAmount(ItemClass.Arrows) ? #C00000 : c_white;
BombsColor = global.Inventory.ItemData[ItemClass.Bombs].Amount[0] == Inventory_MaxAmount(ItemClass.Bombs) ? #C00000 : c_white;

global.MapHidden = Curse_Check(CurseEffects.MapNotVisible) || global.Challenges[Challenges.NoMap];


MapOwned = global.Inventory.ItemData[ItemClass.Map].Owns[0] || oLink.StandingOnMap;
CompassOwned = global.Inventory.ItemData[ItemClass.Compass].Owns[0] || oLink.StandingOnCompass;
DirectionPendant = Map_DirectionPendantActive();

DrawMap = MapOwned|| DirectionPendant;
DrawCompass = CompassOwned || DirectionPendant;