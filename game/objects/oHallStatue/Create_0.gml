// Feather disable GM2064
// A statue of the Hall of Fame (Index into global.Statues is set when it is created, see Hub_CreateStatue).
// It is an oNPC only so Link can talk to it; it replaces all of oNPC's events. Talking opens the gallery on it.
// This instance draws the pedestal and the bottom of the figure under Link; oHallStatueTop draws the rest over him.
visible = true;
image_speed = 0;
FloorLevel = UPPER;
depth = 750;	// above the room picture (ObjsFloor_Upper, 800), below Link (Objs_Upper, 600)
DB_Init = false;
DB_Delay = false;
DB_Script = -1;
WallInst = noone;
mask_index = sHall_Statue_Armos;	// talk area: 40x50 above the pedestal's bottom
