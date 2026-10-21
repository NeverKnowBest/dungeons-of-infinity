event_inherited();

if(oBoss_Lanmola_C.Destroyed[ID]){
	vx = 0; vy = 0; vz = 0;
	exit;
}

if(global.Paused){
	ObjPause();
	exit;
}

Lanmola_Update();

