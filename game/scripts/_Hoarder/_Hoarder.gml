function Hoarder_UpdateDir(){
	
	if(distance_to_object(oLink) <= 56 && !oLink.Cape){
		ChargeAngle =  point_direction(x, y, oLink.x, oLink.y);
	}else{
		ChargeAngle =  irandom_range(Angle - 90, Angle + 90);
		Speed = NormalSpeed;
	}
	
	ChargeAngle = AngleCheck(ChargeAngle);
	
	alarm[0] = irandom_range(ChangeDirDelayMin, ChangeDirDelayMax);
	
}