var RangeX1 = oCamera.X + 8;
var RangeX2 = oCamera.X + (CAM_W * 1.5);
repeat(irandom_range(3,6)){
	instance_create_layer(irandom_range(RangeX1, RangeX2), irandom_range(oCamera.Y - 64, oCamera.Y), "ObjsHighest", oRainDrop);
}
alarm[0] = 2
