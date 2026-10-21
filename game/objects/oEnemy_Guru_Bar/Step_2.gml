if(DestroyGurus){
	
	for(var i = 0; i < GuruCount; i++){
		var _Guru = GuruInst[i];
		if(!instance_exists(_Guru)) continue;
		var _PoofSound = !instance_exists(oFireIceTower) && !instance_exists(oPoof);
		instance_create_layer(_Guru.x, _Guru.y, "ObjsHigher_Upper", _PoofSound ? oPoof : oPoof_NoSound);
		instance_destroy(_Guru.id);
	}
	GuruInst = [];
	GuruCount = 0;

	DestroyGurus = false;
	GurusDestroyed = true;
	
}