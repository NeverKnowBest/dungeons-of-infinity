// Feather disable GM2064
RoomIndex = Dungeon_GetRoomIndex(x, y);
FloorLevel = GetFloorLevelID(x, y);

SoundID = audio_play_sound(Sound_Waterfall, 1, true, 0);
SoundPaused = true;
SoundPlaying = false;
SoundFadeIn = false;
LinkLeavingHouse = false;

Color = (LevelDef.Theme == DungeonLevel.Mines ? 1 : 0)

//clear ceiling
for(var i = 0; i < W / 8; i++){
	var _TileX = x + (i * 8);
	tilemap_set_at_pixel(global.TMID_Tiles_Ceiling, 0, _TileX, y);		
	tilemap_set_at_pixel(global.TMID_Tiles_Ceiling, 0, _TileX, y + 8);		
}

H -= sprite_get_height(sWaterfall_Base);

BaseInst = instance_create_layer(x, y + H, "ObjsFloor_Lower", oWaterfall_Base, {W : W, H : H, Color : Color});