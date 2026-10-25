// pedestal, and the part of the figure below y - 24 (under Link)
PixelRender_Dim(true, true, false, noone, 0, false, []);
draw_sprite(sHall_Pedestal, global.Statues[Index].Tier, x, y);
Statue_DrawFigurePart(Index, x, y - 12, y - 24, false);
shader_reset();
