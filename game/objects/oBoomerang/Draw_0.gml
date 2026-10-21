
PixelRender(true, true, false, noone, 0, false, []);

//image_xscale = Flip ? -1.0 : 1.0;
draw_sprite_ext(sprite_index, image_index, x, y_base, Flip ? -1 : 1, 1, Rot, c_white, 1.0);

shader_reset();