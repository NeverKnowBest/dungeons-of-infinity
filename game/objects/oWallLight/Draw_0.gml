PixelRender(true, true, true, sWallLight_Pal, PaletteIndex, false, []);

draw_sprite(sprite_index, TorchesImgIndex, x, y);

shader_reset();

if(Status) draw_sprite(TorchesSpr, TorchesImgIndex, TorchesSprX, TorchesSprY);
