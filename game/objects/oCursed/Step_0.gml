if(DB_Init){
	
	global.DB_Inst = instance_create_layer(0,0, "System", oDialogueBox);

	global.DB_Inst.Script = DB_Script;
	DB_Init = false;
	DB_Started = true;

}

if(DB_Started && alarm[0] == -1){
	if(!instance_exists(global.DB_Inst)){
		switch(global.CurseEffect){
			case CurseEffects.HealthDrain:
				oLink.alarm[3] = global.CurseHealthDrainDelay;
				break;
			case CurseEffects.AttackReduced:
			case CurseEffects.DefenseReduced:
				Link_UpdateAttackDefence();
				break;
			case CurseEffects.ToughEnemies:
				//increase enemy energies
				with(oEnemy){
					var _Damage = EnergyMax - Energy;
					Enemy_SetEnergy(EnergyIndex); 
					Energy -= _Damage; //after setting the new energy index, remove the same amount of damage as before
				}
				break;
		}
		
		instance_destroy(id);
		
	}
}