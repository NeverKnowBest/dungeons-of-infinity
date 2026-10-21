if(Init){

	EnergyIndex = Enemy_CheckEnergyIndex(11);
	EnergyMax = Enemy_GetMaxEnergy(EnergyIndex);
	
	Energy[0] = EnergyMax;
	Energy[1] = EnergyMax;
	Energy[2] = EnergyMax;
	
	Init = false;
	
}

if(Destroyed[0] && Destroyed[1] && Destroyed[2] && instance_number(oBoss_Lanmola) == 0 && instance_number(oExplosion_Large) == 0){
	instance_create_layer(HeartSpawn_X, HeartSpawn_Y, "System", oBossHeartCrystal);
	instance_destroy(id);
}
