var RangeX1 = oCamera.X;
var RangeX2 = oCamera.X + (oCamera.W * 1.5);
repeat(irandom_range(3,6)){
	instance_create_layer(irandom_range(RangeX1, RangeX2), oCamera.Y, "ObjsHigher_Upper", oRainDrop);
}
alarm[0] = 2
