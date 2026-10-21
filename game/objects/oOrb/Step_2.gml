switch(State){
	
	case PickupObjState.PickedUp:
		break;
	
	case PickupObjState.Travelling:
		break;
		
	case PickupObjState.Destroyed:
		
		switch(Index){
		
			case Orb.Fire:
				instance_create_layer(x, y - 5, "ObjsHighest", oFireIceTower, {TowerObj : oFireTower});
				break;
				
			case Orb.Ice:
				instance_create_layer(x, y - 5, "ObjsHighest", oFireIceTower, {TowerObj : oIceTower});
				break;
				
			case Orb.Fairy:
				
				instance_create_layer(x - 4, y - 5, layer, oItem_Fairy, {From : ItemFrom.Pot});
				
				if(Prob(0.2)){
					instance_create_layer(x - 4, y - 5, layer, oItem_Fairy, {From : ItemFrom.Pot});
				}else if(Prob(0.02)){
					repeat(7){
						instance_create_layer(x + 4, y - 5, layer, oItem_Fairy, {From : ItemFrom.Pot});
					}
				}else if(Prob(0.001)){
					repeat(24){
						instance_create_layer(x + 4, y - 5, layer, oItem_Fairy, {From : ItemFrom.Pot});
					}
				}
				
				break;		
		
		
		}

		instance_create_layer(x, y - 8, "ObjsHighest", oPoof);
		
		instance_destroy(id);
		
		break;

		
}