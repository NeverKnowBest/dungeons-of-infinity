
ObjGrid = ds_grid_create(2, 1);

ObjTypeList = ds_list_create();
ds_list_add(ObjTypeList, oLink, oEnemy, oItem, oBomb, oShopKeeper, oHeartGuy, oArcades, oNPC, oEffects, oZora);
ObjTypes = ds_list_size(ObjTypeList);

ObjectCount = 0;

Draw = true;


