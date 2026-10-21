if(instance_exists(WeaponInst)){
	
	switch(Dir){
		case UP:
			switch(floor(image_index)){
				case 0:
					WeaponInst.x = x + 7;
					WeaponInst.y = y - 8;
					break;
				case 1:
					WeaponInst.x = x + 7;
					WeaponInst.y = y - 7;
					break;
				case 2:
					WeaponInst.x = x + 7;
					WeaponInst.y = y - 7;
					break;
				case 3:
					WeaponInst.x = x + 7;
					WeaponInst.y = y - 14;
					break;
			}	
			break;
		case DOWN:
			switch(floor(image_index)){
				case 0:
					WeaponInst.x = x - 8;
					WeaponInst.y = y - 3;
					break;
				case 1:
					WeaponInst.x = x - 9;
					WeaponInst.y = y - 3;
					break;
				case 2:
					WeaponInst.x = x - 9;
					WeaponInst.y = y - 4;
					break;
				case 3:
					WeaponInst.x = x - 9;
					WeaponInst.y = y;
					break;
			}	
			break;		
		case LEFT:
			switch(floor(image_index)){
				case 0:
				case 2:
					WeaponInst.x = x - 4;
					WeaponInst.y = y - 2;
					break;
				case 1:
					WeaponInst.x = x - 4;
					WeaponInst.y = y - 3;
					break;
				case 3:
					WeaponInst.x = x - 7;
					WeaponInst.y = y - 4;
					break;
			}
		
			break;	
		case RIGHT:
			switch(floor(image_index)){
				case 0:
				case 2:
					WeaponInst.x = x + 4;
					WeaponInst.y = y - 2;
					break;
				case 1:
					WeaponInst.x = x + 4;
					WeaponInst.y = y - 3;
					break;
	
				case 3:
					WeaponInst.x = x + 7;
					WeaponInst.y = y - 4;
					break;
			}		
			break;
	}
}