/// @description Sparkles 0
if(!CVisible[0]) exit;

var _inst = instance_create_layer(Cx[0] + irandom_range(-5, 5), Cy[0] - Cz[0] - irandom(14), "ObjsHighest", oSparkle);
_inst.depth -= 10;
alarm[1] = irandom_range(12, 20);