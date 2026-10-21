var RangeX1 = oCamera.X;
var RangeX2 = oCamera.X + oCamera.W;
var RangeY1 = oCamera.Y;
var RangeY2 = oCamera.Y + oCamera.H;
repeat(irandom_range(2, 4)){
	instance_create_layer(irandom_range(RangeX1, RangeX2), irandom_range(RangeY1, RangeY2), "System", oRainSplash);
}
alarm[3] = irandom_range(1, 5);