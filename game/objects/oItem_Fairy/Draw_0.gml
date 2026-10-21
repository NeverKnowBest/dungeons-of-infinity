PixelRender_Dim(Lighting, Lighting, Palette, PaletteSpr, Index, false, []);

draw_sprite(ShadowSpr, 0, x, y_base);

draw_sprite_ext(sprite_index, image_index, x, floor(y), Dir, 1, 0, c_white, 1);

shader_reset();
