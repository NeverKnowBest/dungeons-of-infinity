event_inherited();

Item_SetIndex(min(global.Inventory.ItemData[Class].Index + 1, image_number - 1));

ShadowSpr = sShadow_Medium;
ShadowOffsetX = -0.5;
x += 0.5;
Get_Sound = Sound_KinstoneConnect;
InWaterSprW = 14;
InWaterSprXOffset = -0.5;