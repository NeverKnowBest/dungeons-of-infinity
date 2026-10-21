/// @description Check for holes

if(oLink.State == LinkState.PickUp) exit;
			
if(Item_OverHole()){
	Item_FallInHole();
}
