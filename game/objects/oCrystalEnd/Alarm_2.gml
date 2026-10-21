/// @description Sparkles 1
if(!CVisible[1]) exit;

instance_create_layer(Cx[1] + irandom_range(-8, 8), Cy[1] - Cz[1] - irandom(16), "ObjsHigher_Upper", oSparkle);
alarm[2] = irandom_range(12, 20);