/// @description Sparkles 2
if(!CVisible[2]) exit;

instance_create_layer(Cx[2] + irandom_range(-8, 8), Cy[2] - Cz[2] - irandom(16), "ObjsHigher_Upper", oSparkle);
alarm[3] = irandom_range(12, 20);