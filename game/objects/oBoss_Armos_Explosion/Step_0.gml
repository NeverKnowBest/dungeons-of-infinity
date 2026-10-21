if(global.Paused){
	ObjPause();
	exit;
}else image_speed = 1;

xTL += vxTL;
yTL += vyTL;

xTR += vxTR;
yTR += vyTR;

xBL += vxBL;
yBL += vyBL;

xBR += vxBR;
yBR += vyBR;

ColorFrame = (ColorFrame + 1) mod array_length(Colors);

