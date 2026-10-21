
if(oCamera.RoomTransition != NONE) exit;

ds_list_clear(EnemyList);
var EnemiesInRoom = collision_rectangle_list(x, y, X2, Y2, oEnemy, false, true, EnemyList, false);
var EnemyDestroysInRoom = collision_rectangle(x, y, X2, Y2, oEnemy_Destroy, false, true);
var IceShardsInRoom = collision_rectangle(x, y, X2, Y2, oIceShard, false, true);
var PoofsInRoom = collision_rectangle(x, y, X2, Y2, oPoof, false, true);

//delete enemies from list that don't need to be destroyed
var NoMoreEnemies = true;
for(var i = 0; i < EnemiesInRoom; i++){
	var _Inst = EnemyList[| i];
	if(_Inst != noone){
		var _ObjIndex = _Inst.object_index;
		if(Enemy_GoodForSpecialAttack(_ObjIndex)){
			NoMoreEnemies = false;
			break;
		}
	}
	
}

if(NoMoreEnemies && EnemyDestroysInRoom == noone && IceShardsInRoom == noone && PoofsInRoom == noone){
	with(oDoor){
		if(RoomIndex == global.CurrentRoomIndex && Status == DoorStatus.Closed){
			Open = true;
		}	
	}		

	instance_destroy(id);
}
	
