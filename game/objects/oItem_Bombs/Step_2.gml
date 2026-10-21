if(Setup){
	
	Amount = Bombs_PickAmount(From);
		
	Setup = false;	
}

if(Red){
	image_index = 2;
	ShowAmount = false;
}else if(Amount == 3){
	image_index = 1;
	ShowAmount = false;
}else{
	image_index = 0;
	ShowAmount = Amount > 1;
}
