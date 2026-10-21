
function Dungeon_Clear(){
	
	tilemap_clear(global.TMID_Higher, 0);
	tilemap_clear(global.TMID_Ceiling, 0);
	tilemap_clear(global.TMID_Decor_Upper, 0);
	tilemap_clear(global.TMID_Walls_Upper, 0);
	tilemap_clear(global.TMID_Water_Upper, 0);
	tilemap_clear(global.TMID_Floor_Upper, 0);
	tilemap_clear(global.TMID_Decor_Lower, 0);
	tilemap_clear(global.TMID_Walls_Lower, 0);
	tilemap_clear(global.TMID_Water_Lower, 0);
	tilemap_clear(global.TMID_Floor_Lower, 0);
	tilemap_clear(global.TMID_Pit, 0);
	
	
	//destroy items from previous dungeon.
	with(oEnemy) instance_destroy(id);
	with(oItem) instance_destroy(id);
	with(oProjectile) instance_destroy(id);
	with(oPot) instance_destroy(id);
	with(oCrystalSwitch) instance_destroy(id);
	with(oWallLight) instance_destroy(id);
	with(oTorch) instance_destroy(id);
	with(oLampFlame) instance_destroy(id);
	with(oDoor) instance_destroy(id);
	with(oSwitchBlock) instance_destroy(id);
	with(oEffects) instance_destroy(id);
	with(oMovingFloor) instance_destroy(id);
	with(oSpikeBlock) instance_destroy(id);
	with(oWall) instance_destroy(id);
	with(oCurtain) instance_destroy(id);
	with(oShop) instance_destroy(id);
	with(oShopKeeper) instance_destroy(id);
	with(oHeartGuy) instance_destroy(id);
	with(oArcades) instance_destroy(id);
	with(oPoolTable) instance_destroy(id);
	with(oPopMachine) instance_destroy(id);
	with(oBoss_Armos_C) instance_destroy(id);
	with(oBoss_Lanmola_C) instance_destroy(id);
	with(oBoss_Moldorm) instance_destroy(id);
	with(oBoss_Lanmola_Dirt1) instance_destroy(id);
	with(oBoss_Lanmola_Dirt2) instance_destroy(id);
	with(oBoss_Lanmola_DirtSplash) instance_destroy(id);
	with(oFinalBossGate) instance_destroy(id);
	with(oStarfield) instance_destroy(id);
	with(oCrystalEnd) instance_destroy(id);
	with(oMineFire) instance_destroy(id);
	with(oItem_Kinstone_Main) instance_destroy(id);
	with(oFloorSwitch) instance_destroy(id);
	with(oArrowSwitch) instance_destroy(id);
	with(oWarp) instance_destroy(id);
	with(oCursed) instance_destroy(id);
	with(oDeadGuy) instance_destroy(id);
	with(oMap) instance_destroy(id);
	with(oInventory) instance_destroy(id);
	with(oPrisoner) instance_destroy(id);
	with(oTreasureLarge) instance_destroy(id);
	with(oFairy_Health) instance_destroy(id);
	with(oHouseDoor) instance_destroy(id);
	with(oCastleWallDoor) instance_destroy(id);	
	with(oWaterfall) instance_destroy(id);
	with(oNPC) instance_destroy(id);
	with(oNPC_OldLady) instance_destroy(id);
	with(oChessBoard) instance_destroy(id);
	with(oSign) instance_destroy(id);
	with(oBomb) instance_destroy(id);
	with(oEnemy_Zirro_Bomb) instance_destroy(id);
	with(oEnemy_Zirro_BombExplosion) instance_destroy(id);
	with(oEnemy_Guru_Bar) instance_destroy(id);
	with(oEnemy_Guru) instance_destroy(id);
	with(oBush) instance_destroy(id);
	with(oLinkDeath) instance_destroy(id);
	with(oEnemyTrap) instance_destroy(id);
	
	var MapSlot = Inventory_ItemExists(oItem_Map, 0);
	if(MapSlot != -1) Inventory_DeleteSlot(MapSlot);
	var CompassSlot = Inventory_ItemExists(oItem_Compass, 0);
	if(CompassSlot != -1) Inventory_DeleteSlot(CompassSlot);

	ds_grid_resize(global.NonDuplicatableItemsThatExist, 2, 0);
	ds_list_clear(global.ProbList);
	ds_list_clear(global.ProbListExclude);
	
	PixelRender_DataClear();
	
	Map_Clear();
	
	ResetUnusedPrisonerList();
	ResetUnusedShopKeeperList();
	
	global.TorchGroupIndex = 0; //When adding torches to Rooms, set them all to the same group index, and increment this index for each Room. This way when checking to see if all torches are lit in the same Room, we can check only those that have the same group index
	global.HeartPiecesThatExist = 0;
	
	Dungeon_DestroyLevel();

}
