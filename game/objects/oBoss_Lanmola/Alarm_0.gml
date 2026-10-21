/// @description Section Spawn
if(SectionCount < 7){
	
	var SectionObj = (SectionCount == 6 ? oBoss_Lanmola_Tail : oBoss_Lanmola_Body);
	
	var VarStruct = {FloorLevel : UPPER, ItemHolding : noone, SectionID: 0, RoomIndex : 0};
	var inst = instance_create_layer(StartX, StartY, "Objs_Upper", SectionObj, VarStruct);
	inst.ID = ID;
	inst.vx = StartVX;
	inst.vy = StartVY;
	inst.Angle = StartAngle;
	inst.Path = Path;
	if(oBoss_Lanmola_C.Destroyed[ID]) inst.Draw = false;
	
	ds_list_add(oBoss_Lanmola_C.SectionInstList[ID], inst);
	
	SectionCount++;
	
	if(SectionObj == oBoss_Lanmola_Tail)
		instance_destroy(oBoss_Lanmola_C.DirtSplashInst[ID]);
	
	alarm[0] = SectionSpawnTime;
}