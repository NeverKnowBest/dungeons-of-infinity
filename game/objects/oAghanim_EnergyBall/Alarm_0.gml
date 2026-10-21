/// @description Create Trail

var _TrailInst = instance_create_layer(x, y, layer, oAghanim_EnergyBall_Trail);
_TrailInst.image_index = 1;
_TrailInst.depth = depth + 5;
alarm[0] = TrailDelay;