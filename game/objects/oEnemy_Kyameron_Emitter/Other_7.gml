switch(State){

	case EnemyState.Jumping:
		Enemy_UpdateState(EnemyState.Idle);
		var MovingInst = instance_create_layer(x, y, layer, oEnemy_Kyameron_Moving, {RoomIndex : RoomIndex, FloorLevel : FloorLevel, ItemHolding : -1});
		MovingInst.ParentInst = self;
		MovingInst.alarm[0] = MovingTime;
		break;
	
}