var VarStruct = { ID : ID, FloorLevel : UPPER, ItemHolding : noone, SectionID: 0, RoomIndex : 0};
var inst = instance_create_layer(x, y, "Objs_Upper", oBoss_Lanmola, VarStruct);
inst.EnergyIndex = oBoss_Lanmola_C.EnergyIndex;
inst.Energy = oBoss_Lanmola_C.Energy[ID];

ds_list_clear(oBoss_Lanmola_C.SectionInstList[ID]);
ds_list_add(oBoss_Lanmola_C.SectionInstList[ID], inst);

oBoss_Lanmola_C.DirtSplashInst[ID] = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_DirtSplash);

audio_play_sound_stopall(Sound_Sand1);
audio_play_sound_stopall(Sound_Sand2);

var S = 2.25;
var Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = S; Rock.vy = -S;
Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = -S; Rock.vy = -S;
Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = S; Rock.vy = S;
Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = -S; Rock.vy = S;
if(oBoss_Lanmola_C.BossCount == 1){
	Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = S; Rock.vy = 0;
	Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = -S; Rock.vy = 0;
	Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = 0; Rock.vy = S;
	Rock = instance_create_layer(x, y, "ObjsFloor_Upper", oBoss_Lanmola_Rock); Rock.vx = 0; Rock.vy = -S;	
}
instance_destroy(id)