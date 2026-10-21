if(instance_exists(WeaponInst)){
	
	switch(Dir){
		case UP:
			WeaponInst.x = x - 9;
			WeaponInst.y = y - 14;
			break;

		case DOWN:
			WeaponInst.x = x + 7;
			WeaponInst.y = y - 14;
			break;
	
		case LEFT:
			WeaponInst.x = x;
			WeaponInst.y = y - 11;
			break;
	
		case RIGHT:
			WeaponInst.x = x;
			WeaponInst.y = y - 11;
			break;

	}
}