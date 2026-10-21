/// @description increase/decrease tongue length

if(!Hit){
	
	Dist += (Inc * Dir);

	if(Dir == 1){
		if(Dist >= MaxDist){
			Dist = MaxDist;
			Dir *= -1;
		}
	}else{
		if(Dist <= 0){
			Dist = 0;
			alarm[1] = IncDelay * 2;
			exit;
		}	
	
	}
}

alarm[0] = IncDelay;