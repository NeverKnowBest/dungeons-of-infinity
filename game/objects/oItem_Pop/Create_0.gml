event_inherited();

Item_SetIndex(irandom(global.PopFlavors - 1));

ShadowOffsetY = -2;

if(variable_instance_exists(id, "From")){
	
	switch(From){
		case ItemFrom.Treasure:
			Amount = choose(1,1,1,2,2,3);
			break;
		case ItemFrom.Shop:
		case ItemFrom.KinstoneGreen:
			Amount = choose(2,2,3);
			break;

	}
	
}


