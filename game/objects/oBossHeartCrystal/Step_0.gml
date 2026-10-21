if(global.Paused) ObjIncAlarms();

if(SpawnedHeart && instance_number(oItem_HeartPiece) == 0 && !SpawnCrystal){
	SpawnCrystal = true;
	alarm[1] = CrystalDelay;
}