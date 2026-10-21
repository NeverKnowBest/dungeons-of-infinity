PixelRender(true, false, false, noone, 0, false, []);
draw_sprite_ext(sLeaf_Shadow, 0, x, y_base, FlipX, FlipY, Rot, c_white, 1);
shader_reset();		

PixelRender(true, true, false, noone, 0, false, []);

draw_sprite_ext(sprite_index, 0, x, y, FlipX, FlipY, Rot, c_white, 1);

shader_reset();