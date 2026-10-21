visible = false; //all children object should have visible set to false so DepthDrawObjs can sort and draw everything manually
				 //If objects doesn't get sorted by DepthDrawObjs, manually set visible back to true

if(!variable_instance_exists(id, "FloorLevel")) FloorLevel = GetFloorLevelID(x, y);
FloorLevelStr = GetFloorLevelString(FloorLevel);

RoomIndex = Dungeon_GetRoomIndex(x, y);

Name = "";
Info = "No Info Available";
Index = 0;

//From = ItemFrom.Pot;

y_base = y;

vx = 0;
vy = 0;
vz = 0;
z = 0;
z_end = 1000;
g = 0;

Class = ItemClassFromObjIndex(object_index);

Spawning = false;
SpawnAnimationInit = false;
SpawnAnimation = false;
SpawnAnimationFinish = false;

SpawnType = ItemSpawnType.None;
SpawnBounces = 0;
SpawnPause = 0;
SpawnPauseCount = 0;

Alpha = 1;

Amount = 1;
ShowAmount = true;

AmountOffsetX = Item_AmountOffsetX(Class);

Price = 0;
Price_Max = 0;
Price_Modified = Price;
Price_CouponApplied = false;
Price_Color = c_white;
ShowPrice = false;
ShopItem = false;

ShadowSpr = sShadow_Large;
ShadowOffsetX = 0;
ShadowOffsetY = 0;
ShowShadow = true;

Lighting = true;

Palette = false;
PaletteSpr = noone
PaletteIndex = 0;

Get_WhenLinkCollides = true;
Get_Allowed = false;
Get_Sound = Sound_KeyGet;
Get_ShowDialogue = true;

InventorySpr = sprite_index;

CollidedWallList = ds_list_create();
WallCollide_X = false;
WallCollide_Y = false;

CanPickup = false;

InWater = false;
InWaterSprW = 18;
InWaterSprXOffset = 0;
InWaterSprYOffset = -4;

Setup = false;