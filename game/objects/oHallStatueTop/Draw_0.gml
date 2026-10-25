// Feather disable GM2064
if(!instance_exists(Owner)) exit;
PixelRender_Dim(true, true, false, noone, 0, false, []);
Statue_DrawFigurePart(Owner.Index, Owner.x, Owner.y - 12, Owner.y - 24, true);
shader_reset();
