event_inherited();


RoomIndex = Dungeon_GetRoomIndex(oLink.x, oLink.y);

r_base = 0.3; g_base = 0.3; b_base = 1.3;
R = r_base; G = g_base; B = b_base;
LightIndex = Lighting_CreateLight(RoomIndex, x, y, 0.6, [R, G, B]);

T = 0;

//ShadowSpr = sShadow_Medium;
ShadowOffsetY = -1;
