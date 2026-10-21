if(Setup){

	switch(HeadIndex){
		case SoldierHead.Pig:
			Weapon = SoldierWeapon.Fork;
			Enemy_SetEnergy(7);
			Attack = 2.5;
			break;
		case SoldierHead.Pig2:
			Weapon = SoldierWeapon.Spear;
			Enemy_SetEnergy(8);
			Attack = 2.75;
			break;
		case SoldierHead.Demon:
			Weapon = SoldierWeapon.Sword;
			Enemy_SetEnergy(9);
			Attack = 3;
			break;
	}
		
	Soldier_UpdateWeaponSprite();
	
	Setup = false;
}