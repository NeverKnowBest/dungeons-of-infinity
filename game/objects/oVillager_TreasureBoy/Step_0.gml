event_inherited();

if(DoorInst == noone){
	DoorInst = collision_rectangle(x - 64, y - 48, x, y, oDoor, false, true);
	exit;
}
if(DoorInst.Status == DoorStatus.Locked && Inventory_ItemExists(ItemClass.SpecialKey)) ResponseIndex = 0;
if(DoorInst.Status == DoorStatus.Open) ResponseIndex = 1;