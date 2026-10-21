PixelRender(true, true, false, noone, 0, true, Colors[ColorFrame]);

draw_sprite_ext(sprite_index, image_index, xTL, yTL, 1, 1, 0, c_white, 1);

draw_sprite_ext(sprite_index, image_index, xTR, yTR, -1, 1, 0, c_white, 1);

draw_sprite_ext(sprite_index, image_index, xBL, yBL, 1, -1, 0, c_white, 1);

draw_sprite_ext(sprite_index, image_index, xBR, yBR, -1, -1, 0, c_white, 1);

shader_reset();

