event_inherited();


//for pendants, medallions, skills, etc, we have to first set the Index to -1 since PickAvailableItem
//uses Item_Exists(), and since this item is already created, it'll find this item if Index is set to default Index 0.
Index = -1; 
var AvailableRing = Item_PickAvailableIndex(ItemClass.Ring);
if(AvailableRing != -1) Item_SetIndex(AvailableRing);

ShadowOffsetY = -1;