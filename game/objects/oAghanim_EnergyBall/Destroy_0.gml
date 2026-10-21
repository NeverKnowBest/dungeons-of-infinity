event_inherited();

with(oBoss_Aghanim){
	if(GravityBall) exit;
}

if(point_in_rectangle(x, y, oCamera.X, oCamera.Y, oCamera.X2, oCamera.Y2)) instance_create_layer(x, y, "ObjsHigher_" + GetFloorLevelString(FloorLevel), oSwordBeamHit);
