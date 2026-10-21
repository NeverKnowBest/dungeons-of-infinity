event_inherited();

if(vy > 0 && y >= YMax){
	y = YMax;
	vy *= -1;
}else if(vy < 0 && y <= YMin){
	y = YMin;
	vy *= -1;
}

