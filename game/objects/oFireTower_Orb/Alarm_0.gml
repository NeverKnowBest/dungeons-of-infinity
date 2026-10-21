repeat(12){
	instance_create_layer(CenterX + lengthdir_x(Radius, irandom(360)), CenterY + lengthdir_y(Radius, irandom(360)), "ObjsHigher_Upper", oFireTower, {FlameColor : FlameColor});
}
Count--;

if(Count > 0){
	alarm[0] = 6;
	Radius += 16;
}else
	instance_destroy(id);