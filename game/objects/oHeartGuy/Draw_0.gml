if(Disappeared) exit;

PixelRender_Dim(true, true, false, noone, 0, false, []);

draw_sprite(sShadow_Large, 0, x, y);
draw_sprite(sprite_index, image_index, x, y - z);

shader_reset();