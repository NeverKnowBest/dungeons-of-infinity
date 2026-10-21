event_inherited();

Index = -1;
var AvailableRod = Item_PickAvailableIndex(ItemClass.Rod);
if(AvailableRod != -1){
	Item_SetIndex(AvailableRod);
	Amount = global.MaxRodCharge[Index];
}

ShadowSpr = sShadow_Medium;

InWaterSprW = 14;