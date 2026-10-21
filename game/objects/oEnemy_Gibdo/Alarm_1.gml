/// @description Change Dir

var _NewDir = (oLink.Cape ? RandomDir() : DirFaceLink());
Gibdo_UpdateDir(_NewDir);
ObjSetImageSpeed(1);
alarm[0] = irandom_range(60, 150);