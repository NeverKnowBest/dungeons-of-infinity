
if(Lit){
	LightFlickerDist += (LightFlickerDir * 0.005);
	
	if(LightFlickerDir == 1 && LightFlickerDist >= LightFlickerLenTarget){
		LightFlickerDist = LightFlickerLenTarget;
		LightFlickerDir *= -1;
		LightFlickerLenTarget = random_range(0.01, LightFlickerLenMax);
	}else if(LightFlickerDir == -1 && LightFlickerDist <= 0){
		LightFlickerDist = 0;
		LightFlickerDir *= -1;
	}

	Lighting_UpdateLight_Radius(RoomIndex, LightIndex, LightStrength + LightFlickerDist);
	
	exit;
	
}

if(Lighting){
	
	if(LightStrength == 0){
		instance_create_layer(x + 8, y + 6, "ObjsHigher_Upper", oLampFlame);
		Lighting_UpdateLight_Visible(RoomIndex, LightIndex, true);
		LightStrength = 0.6
		sprite_index = sTorch_Lit;
		
	}
	
	LightR += 0.075; LightG += 0.075;	LightB += 0.075;
	if(LightR >= LightMaxR){
		LightR = LightMaxR;
		LightG = LightMaxG;
		LightB = LightMaxB;		
	}
	Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [LightR, LightG, LightB]);	
	
	LightStrength += 0.125;
	if(LightStrength >= LightStrengthMax){
		Lit = true;
		Lighting = false;
		
		if(IsSwitch){
			
			var OtherTorchesLit = true;
			with(oTorch){
				if(GroupIndex == other.GroupIndex){
					if(!Lit){
						OtherTorchesLit = false;
						break;
					}
				}
				
			}
			
			if(OtherTorchesLit) Switch_Activate(Action, HiddenObjInst);
		
		}
	}
	Lighting_UpdateLight_Radius(RoomIndex, LightIndex, LightStrength);	
	
}

