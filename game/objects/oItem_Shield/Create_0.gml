event_inherited();

Item_SetIndex(min(global.Inventory.ItemData[Class].Index + 1, image_number - 1));

ShadowSpr = (Index == 0 ? sShadow_Medium : sShadow_Large)
ShadowOffsetY = -1;
if(Index == 3) InWaterSprXOffset = 0.5;
