var RangeX1 = oCamera.X;
var RangeX2 = oCamera.X + (CAM_W * 1.5);
repeat(irandom_range(1,3)){
	instance_create_layer(irandom_range(RangeX1, RangeX2), oCamera.Y, "ObjsHighest", oLeaf_Outside);
}
alarm[5] = irandom_range(1, 40);
