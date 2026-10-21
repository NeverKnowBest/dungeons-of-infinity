if(Init){
	Enemy_SetEnergy(global.EnemyData[object_index].EnergyIndex);
	//Enemy_SetEnergy(0);
	Init = false;
}

switch(State){
		
	case EnemyState.Jumping:
		
		Armos_MoveToWaypoint(id);	
		break;

}