if(DB_Init_Child){

	DB_Init_Child = false;	
	
	DB_InitDone = true;
	
	exit;
	
}

var _DistCheck = distance_to_object(oLink) < LookDist;

if(_DistCheck && SprUp > -1 || (_DistCheck && SprUp == -1 && y <= oLink.y + 6)){
	Dir = DirFaceLink();
	LookAtLink = true;
	alarm[1] = -1
}else{
	if(alarm[1] == -1){
		if(LookAtLink){
			alarm[1] = 45;
		}else{
			Dir = MainDir;
		}
	}
}
	
NPC_UpdateDir();

