
Lighting_UpdateLightPos(oLink.LampLightID, oLink.x, oLink.y - 6);


FlickerDist += (FlickerDir * 0.0025);

if(FlickerDir == 1 && FlickerDist >= MaxFlickerLen){
	FlickerDist = MaxFlickerLen;
	FlickerDir *= -1;
	MaxFlickerLen = random_range(0.01, 0.08);
}else if(FlickerDir == -1 && FlickerDist <= 0){
	FlickerDist = 0;
	FlickerDir *= -1;
}

var LinkLampStrength = oLink.LampStrength[global.ItemData[oItem_Lamp].Index] + FlickerDist + (oLink.z / 250);


var DoorFadeFactor = 1;

if(oLink.InDoorPassage != 0){ 

	var FadeSpeed = 28; //Higer = slower

	switch(oLink.PassageOrientation){		
		
		case TOP_BOTTOM:
			var FadeFactor1 = clamp(1 - ((oLink.DoorPassage[3] - oLink.y + 15) / FadeSpeed), 0, 1);
			var FadeFactor2 = clamp(1 - ((oLink.y - oLink.DoorPassage[1] - 5) / FadeSpeed), 0, 1);
			break;
			
		case LEFT_RIGHT:
			var FadeFactor1 = clamp(1 - ((oLink.DoorPassage[2] + 7 - oLink.x) / FadeSpeed), 0, 1);
			var FadeFactor2 = clamp(1 - ((oLink.x - oLink.DoorPassage[0] + 7) / FadeSpeed), 0, 1);
			
			break;
			
	}
	
	DoorFadeFactor = (FadeFactor1 + FadeFactor2);
	

	//Keep Link's light at the edges of the Door Mask so it shrinks and expands at the entrances without moving with Link as he moves through the passage

	switch(oLink.PassageOrientation){
		case TOP_BOTTOM:
			var DistToBottom = abs(oLink.y - 6 - oLink.DoorPassage[3]);
			var DistToTop = abs(oLink.y - 6 - oLink.DoorPassage[1]);
			if(DistToBottom < DistToTop){
				Lighting_UpdateLightPos(oLink.LampLightID, oLink.x, oLink.DoorPassage[3] + 10);
			}else{
				Lighting_UpdateLightPos(oLink.LampLightID, oLink.x, oLink.DoorPassage[1] - 8)
			}
			break;

		case LEFT_RIGHT:
			var DistToRight = abs(oLink.x - oLink.DoorPassage[2]);
			var DistToLeft = abs(oLink.x - oLink.DoorPassage[0]);
			if(DistToRight < DistToLeft){
				Lighting_UpdateLightPos(oLink.LampLightID, oLink.DoorPassage[2] + 10, oLink.y - 6);
			}else{
				Lighting_UpdateLightPos(oLink.LampLightID, oLink.DoorPassage[0] - 8, oLink.y - 6)
			}
			break;
	}

	
	LinkLampStrength *= DoorFadeFactor;
	
}

	
var MinFade = (oLink.InDoorPassage != 0 ? 0.0 : 0.4 - ((global.ItemData[oItem_Lamp].Index - 1) * 0.075) )
oLink.LampLightR = clamp(oLink.LampLightMaxR * DoorFadeFactor, MinFade, oLink.LampLightMaxR);
oLink.LampLightG = clamp(oLink.LampLightMaxG * DoorFadeFactor, MinFade, oLink.LampLightMaxG);
oLink.LampLightB = clamp(oLink.LampLightMaxB * DoorFadeFactor, MinFade, oLink.LampLightMaxB);


Lighting_UpdateLightStrength(oLink.LampLightID, LinkLampStrength);	
Lighting_UpdateLightCol(oLink.LampLightID, oLink.LampLightR, oLink.LampLightG, oLink.LampLightB);	



with(oWallLight) Lighting_UpdateLightStrength(LightIndex, LightStrength + (other.FlickerDist * 1.75));