/// @description Put back projectile on effects layer. 
//If the projectile is shooting up from person, we momentarilly place it on the ObjsFloor layer so it doesn't draw on top.
//We don't want to use the Depthdraw since that cause projectiles to seem to pass through objs it can't hit.
layer = layer_get_id("ObjsHigher_" + FloorLevelStr);