for(var i = 0; i < GuruCount; i++){
	if(!instance_exists(GuruInst[i])) continue;
	instance_destroy(GuruInst[i]);
}

instance_destroy(WallInst);