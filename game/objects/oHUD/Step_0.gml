LinkMapX = MapX + (round(oLink.x / 16) * 2);
LinkMapY = round((oLink.y - 4) / 16) * 2;

DungeonLinkY = DungeonY + 11 + (global.DungeonDepth * 9);

if(oLink.Item1Index != -1 && keyboard_check_pressed(vk_pageup)) {
	oLink.Item1Index = (oLink.Item1Index + 1) mod oLink.InventorySize;
}
if(oLink.Item2Index != -1 && keyboard_check_pressed(vk_pagedown)) {
	oLink.Item2Index = (oLink.Item2Index + 1) mod oLink.InventorySize;
}

if(AddHealth > 0 && !instance_exists(oHUD_HeartAnimation)){
	
	if(oLink.Health == oLink.HealthMax){
		
		AddHealth = 0;
		
	}else{
	
		var FullHearts = floor(oLink.Health);
		//var HalfHearts = ceil(oLink.Health - FullHearts);
	
		var HeartAniX = HeartsX[0] + ((FullHearts mod 8) * 8);
		var HeartAniY = HeartsY[0] + ((FullHearts div 8) * 8);
		instance_create_depth(HeartAniX, HeartAniY, depth - 1, oHUD_HeartAnimation);
		AddHealth--;
		
	}
	
}

if(AddRupees != 0){
	
	var Sign = sign(AddRupees);
	var AbsValue = abs(AddRupees);
	var Increment = Sign * (AbsValue >= 500 ? 20 : (AbsValue >= 100 ? 5 : 1 ));
	//var Increment = Sign * (ceil(AbsValue / 50));
	RupeesAdd(Increment);
	
	if(oLink.Rupees >= oLink.RupeesMax){
		oLink.Rupees = oLink.RupeesMax;
		AddRupees = 0;
		AddRupeesCount = 0;
		exit;
	}
	
	if(oLink.Rupees <= 0){
		oLink.Rupees = 0;
		AddRupees = 0;
		AddRupeesCount = 0;
		exit;
	}
	
	AddRupees -= Increment;
	
	if(!audio_is_playing(Sound_RupeeGetRegister))
		audio_play_sound(Sound_RupeeGetRegister, 1, false);
	else{
		AddRupeesCount++;
		if(AddRupeesCount >= 10){
			audio_play_sound(Sound_RupeeGetRegister, 1, false);
			AddRupeesCount = 0;
		}
		//if(abs(AddRupees) >= 10 && abs(AddRupees) mod 10 == 0){
			
		//}
	}
	
}


if(AddMagic > 0){

	MagicAdd(0.5);
	if(oLink.Magic == oLink.MagicMax){
		AddMagic = 0;
		exit;		
	}
	
	AddMagic-=0.5;
	

	if(AddMagic mod 4 == 0){
		audio_stop_sound(Sound_MagicMeter);
		audio_play_sound(Sound_MagicMeter, 1, false);
	}

	
}

	
MagicH = ceil((oLink.Magic / oLink.MagicMax) * 38);
MagicY = MMY + 5 + (38 - MagicH);

	