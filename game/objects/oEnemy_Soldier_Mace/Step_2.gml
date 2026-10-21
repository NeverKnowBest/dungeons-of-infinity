if(instance_exists(WeaponInst)){
	
	switch(Dir){
		case UP:
			WeaponInst.StartX = x - 10;
			WeaponInst.StartY = y - 14;
			break;

		case DOWN:
			WeaponInst.StartX = x + 8;
			WeaponInst.StartY = y - 16;
			break;
	
		case LEFT:
			WeaponInst.StartX = x;
			WeaponInst.StartY = y - 11;
			break;
	
		case RIGHT:
			WeaponInst.StartX = x;
			WeaponInst.StartY = y - 11;
			break;

	}

	WeaponInst.x = WeaponInst.StartX + lengthdir_x(WeaponInst.SpinDist, WeaponInst.SpinAngle);
	WeaponInst.y = WeaponInst.StartY + lengthdir_y(WeaponInst.SpinDist, WeaponInst.SpinAngle);

}