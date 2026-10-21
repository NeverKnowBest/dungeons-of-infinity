for(var i = 0; i < ItemClasses; i++){

	if(Counts[i] > 0){
		Percents[i] = round((Counts[i] / Total) * 10000);		
	}
	
}

alarm[0] = UpdateDelay;