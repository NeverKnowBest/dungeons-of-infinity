event_inherited();

if(Hit_Started){
	instance_destroy(WallInst);
	exit;
}

PauseObj

//in SpawnEnemies(), it checks for walls to place enemies, so the wall can't be created in the create event since it will detect that wall and neber find a good spot
//Any enemies that need walls should do it this way
if(WallInit){
	WallInst = WallObj_Create("Objs_" + FloorLevelStr, x - 8, y - 8, 2, 2);
	WallInst.BlockProjectiles = false;
	WallInst.BlockItems = false;
	WallInst.IsEnemy = true;
	WallInit = false;
}