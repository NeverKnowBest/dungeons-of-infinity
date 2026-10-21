SpawnedHeart = false;
SpawnCrystal = false;
CrystalDelay = 70;


if(Item_Allowed(ItemClass.HeartPiece, 0, ItemFrom.Enemy)){
	alarm[0] = 10;	
}else{
	alarm[1] = CrystalDelay;
}